import json
from utils.postgresql import PostgresConnector
from transformers import AutoTokenizer, AutoModelForCausalLM, pipeline, BitsAndBytesConfig
import pandas as pd
import sqlparse
import matplotlib.pyplot as plt # for dynamic python execution
import gc

def construct_sql_prompt(question, prompt_file="prompt/sql_template.md", metadata_file="prompt/metadata.sql") -> str:
    
    with open(prompt_file, "r") as f:
        prompt = f.read()
    
    with open(metadata_file, "r") as f:
        table_metadata_string = f.read()

    prompt = prompt.format(
        user_question=question, table_metadata_string=table_metadata_string
    )
    return prompt

def construct_python_prompt(df: pd.DataFrame, question: str, sql:str, prompt_file="prompt/python_template.md", avoid_cols=[]) -> str:
    
    with open(prompt_file, "r") as f:
        prompt = f.read()

    shape = df.shape
    column_details = []
    
    for col in df.columns:
        if col in avoid_cols:
            continue
        col_type = str(df[col].dtype)
        if pd.api.types.is_numeric_dtype(df[col]):
            #min_val = df[col].min()
            #max_val = df[col].max()
            detail = f"- {col} (numeric)" #: min = {min_val}, max = {max_val}"
        elif isinstance(df[col].dtype, pd.CategoricalDtype) or df[col].dtype == object:
            #unique_count = df[col].nunique()
            detail = f"- {col} (categorical)" #: unique values = {unique_count}"
        else:
            detail = f"- {col} (type: {col_type})"
        column_details.append(detail)
    
    details_str = "\n".join(column_details)

    prompt = prompt.format(
        shape=shape, details_str=details_str, question=question, sql=sql
    )
    return prompt

def create_db_connection():
    with open("utils/postgresql_cred.json", "r") as f:
        config = json.load(f)
    dbname = config['dbname']
    user = config['user']
    password = config['password']
    host = config['host']
    port = config['port']
    db = PostgresConnector(dbname, user, password, host, port)
    return db

def get_model_pipeline(model_name, max_new_tokens=500):
    
    # gc.collect()
    # torch.cuda.empty_cache()
    # torch.cuda.ipc_collect()
    tokenizer = AutoTokenizer.from_pretrained(model_name)
    
    q_4bit_config = BitsAndBytesConfig(
        load_in_4bit=True,
        bnb_4bit_quant_type="nf4",        # Choose quantization type (nf4 or gptq)
        bnb_4bit_use_double_quant=True,   # Use double quantization if desired
        bnb_4bit_compute_dtype="float16"  # Compute dtype for inference
    )
    
    model = AutoModelForCausalLM.from_pretrained(
        model_name,
        quantization_config=q_4bit_config
    )
    model.to('cuda:0') # for my local GPU

    # Use the model's EOS token as the stop token.
    eos_token_id = tokenizer.eos_token_id
    
    # Create a text-generation pipeline.
    pipe = pipeline(
        "text-generation",
        model=model,
        tokenizer=tokenizer,
        max_new_tokens=max_new_tokens,
        do_sample=False,          # Deterministic output; set to True for sampling.
        return_full_text=False,
        # num_beams=5,            # Uncomment for beam search if higher quality is desired.
    )
    
    return {"pipe": pipe, "eos_token_id": eos_token_id}

def extract_function(code: str) -> str:
    """
    Extracts the first Python function definition from a code string.
    The function is assumed to start with a line that begins with 'def'
    (ignoring any leading whitespace) and continues until a line is encountered
    that is not indented relative to the 'def' line.
    """
    lines = code.splitlines()
    function_lines = []
    in_function = False
    base_indent = None

    for line in lines:
        # Look for the beginning of a function definition
        if not in_function:
            if line.lstrip().startswith("def "):
                in_function = True
                base_indent = len(line) - len(line.lstrip())
                function_lines.append(line)
        else:
            # Once inside a function, include blank lines as they might be part of the function
            if line.strip() == "":
                function_lines.append(line)
            else:
                current_indent = len(line) - len(line.lstrip())
                # Include line if it's indented more than the function header
                if current_indent > base_indent:
                    function_lines.append(line)
                else:
                    # We've reached a line that isn't part of the function
                    break

    return "\n".join(function_lines).strip()

def run_inference(pipeline, prompt, task_type="sql"):
    """
    Inference function for both SQL and Python code generation.
    
    Args:
        pipeline: Model pipeline dictionary with pip object and eos_token_id.
        prompt (str): The prompt for text/code generation.
        task_type (str): "sql" or "python". Determines how the generated text is processed.
        max_new_tokens (int): Maximum number of tokens to generate.
    
    Returns:
        str: The processed generated output.
    """

    pipe = pipeline['pipe']
    eos_token_id = pipeline['eos_token_id']
    
    # Generate the output.
    generated_text = pipe(
        prompt,
        num_return_sequences=1,
        eos_token_id=eos_token_id,
        pad_token_id=eos_token_id,
    )[0]["generated_text"]
    
    # Post-process based on task type.
    if task_type.lower() == "sql":
        # For SQL, stop at the first semicolon or code fence, then append a semicolon.
        processed = generated_text.split(";")[0].split("```")[0].strip() + ";"
        try:
            processed = sqlparse.format(processed, reindent=True, keyword_case='upper')
        except:
            print("sql could not be parsed to multiline sql")
    elif task_type.lower() == "python":
        # First, try to extract code from a code fence if present.
        if "```" in generated_text:
            code = generated_text.split("```")[1].strip()
        else:
            code = generated_text.strip()
        # Remove any import statements.
        filtered_lines = []
        for line in code.splitlines():
            stripped = line.strip()
            if not (stripped.startswith("import ") or stripped.startswith("from ")):
                filtered_lines.append(line)
        code_without_imports = "\n".join(filtered_lines).strip()
        # Extract the function definition starting at "def"
        processed = extract_function(code_without_imports)
    else:
        # For unknown task types, return the raw generated text.
        processed = generated_text.strip()
    
    return processed

def execute_python_code(generated_code: str, df: pd.DataFrame):
    """
    Executes the generated Python code which is expected to define a plotting function (e.g. plot_dataframe).
    The function is then called with the provided DataFrame and matplotlib is used to display the plot.
    
    Args:
        generated_code (str): The Python code as a string (without import statements).
        df (pd.DataFrame): The DataFrame to pass to the plotting function.
    """
    plt = None # the generated function is expected to redefine this

    # Create a namespace for executing the code.
    exec_namespace = {}
    try:
        exec(generated_code, globals(), exec_namespace)
    except Exception as e:
        print("Error executing generated code:", e)
        return
    
    # Look for the first callable in the namespace.
    plot_func = None
    for name, obj in exec_namespace.items():
        if callable(obj):
            plot_func = obj
            break

    if plot_func is None:
        print("No callable plotting function was found in the generated code.")
        return
    
    try:
        # Execute the plotting function with the provided DataFrame.
        plot_func(df)
        # Check if the generated code already calls plt.show()
        if "plt.show" not in generated_code:
            plt.show()
    except Exception as e:
        print("Error executing the plotting function:", e)
