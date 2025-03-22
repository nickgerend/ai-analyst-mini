### Task
Generate a PostgreSQL query to answer [QUESTION]{user_question}[/QUESTION]

### Instructions
- Use date related fields correctly when provided in different formats
- If you cannot answer the question with the available database schema, return 'I do not know'

### Database Schema
The query will run on a database with the following schema:
{table_metadata_string}

### Answer
Given the database schema, here is the PostgreSQL query that answers [QUESTION]{user_question}[/QUESTION]
[SQL]