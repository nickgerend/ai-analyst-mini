
#%%
import psycopg2
from psycopg2.extras import RealDictCursor
import pandas as pd

#%%
class PostgresConnector:

    def __init__(self, dbname, user, password, host='localhost', port=5432):
        try:
            self.conn = psycopg2.connect(
                dbname=dbname,
                user=user,
                password=password,
                host=host,
                port=port
            )
            # Using RealDictCursor to return rows as dictionaries
            self.cursor = self.conn.cursor(cursor_factory=RealDictCursor)
            print("Connection established.")
        except Exception as e:
            print("Unable to connect to the database:", e)
            raise

    def execute_query(self, query, params=None):
        """
        Executes a SQL query. If the query returns data (e.g., a SELECT),
        it fetches and returns all the results.
        """
        try:
            self.cursor.execute(query, params)
            if self.cursor.description is not None:
                result = self.cursor.fetchall()
                return result
            else:
                self.conn.commit()
                return None
        except Exception as e:
            print("Error executing query:", e)
            self.conn.rollback()
            raise

    def query_to_dataframe(self, query, params=None):
        """
        Executes a SQL query and returns the result as a pandas DataFrame.
        """
        result = self.execute_query(query, params)
        if result is not None:
            df = pd.DataFrame(result)
            return df
        else:
            return pd.DataFrame()

    def close(self):
        if self.cursor:
            self.cursor.close()
        if self.conn:
            self.conn.close()
        print("Connection closed.")
