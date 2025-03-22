#%%
import os
import gzip
import shutil

def extract_gz_files(directory):
    """
    Extracts all .gz files in the specified directory.

    Parameters:
    directory (str): The path to the directory containing .gz files.

    Returns:
    None
    """
    # Ensure the provided directory exists
    if not os.path.isdir(directory):
        print(f"The directory {directory} does not exist.")
        return

    # Iterate over all files in the directory
    for filename in os.listdir(directory):
        if filename.endswith('.gz'):
            gz_path = os.path.join(directory, filename)
            output_path = os.path.join(directory, filename[:-3])  # Remove the .gz extension

            # Extract the .gz file
            with gzip.open(gz_path, 'rb') as f_in:
                with open(output_path, 'wb') as f_out:
                    shutil.copyfileobj(f_in, f_out)

            print(f"Extracted {gz_path} to {output_path}")

# Example usage:
# Replace '/path/to/your/directory' with the path to your directory containing .gz files
extract_gz_files('C:/Users/user/code/llm-analyst/imdb')

