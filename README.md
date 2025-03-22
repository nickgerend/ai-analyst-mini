# ai-analyst-mini

Check out the demo notebook for a walkthrough on Text to SQL/Python execution using a only a local RTX-4080 and small language models that act as a mini analyst for IMDB!

SLMs Models in the demo:
- defog/sqlcoder-7b-2 for text to PostgreSQL
- ise-uiuc/Magicoder-S-DS-6.7B for text to Python

(both models are loaded as 4-bit quantized for fast execution)

The IMDB database is loaded into PostgreSQL and the ETL is provided under the imdb folder.

pip installs for the project:
- pip install transformers accelerate bitsandbytes psycopg2 pandas ipykernel ipywidgets sqlparse matplotlib
- pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu124

Ways to extend ai-analyst-mini to an AI Analyst Agent:
- add support for more database types
- add RAG to enhance prompts with details needed for better SQL and Python generation
- add SQL and Python retry LLM calls for resolving execution errors (up to X retries)
- add multi-turn conversation for follow-up questions
- add a chat UI to render chats nicely
- decouple Python execution environment
- include SOTA models via APIs and more complex prompts for more accurate and fast generation
- add other LLM agents for taking on more analyst functions