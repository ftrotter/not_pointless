#!/usr/bin/env python3
"""
Standalone script to test database connection using SQLAlchemy.
This script reads database connection details from:
1. AWS Secrets Manager (if available)
2. .env file (as fallback)
3. Default values (as final fallback)

It tests:
1. If the database can be connected to
2. If the endpoint table exists in the specified schema
3. If the table has data in it

No Django dependencies are required.
"""

import os
import sys
import json
import logging
from pathlib import Path
from dotenv import load_dotenv
from sqlalchemy import create_engine, text, inspect
from sqlalchemy.exc import SQLAlchemyError

# Set up logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s [%(levelname)s] - %(message)s',
    handlers=[logging.StreamHandler(sys.stdout)]
)
logger = logging.getLogger(__name__)

# Try to import boto3 for AWS Secrets Manager
try:
    import boto3
    boto3_available = True
    logger.info("boto3 is available, will try AWS Secrets Manager")
except ImportError:
    boto3_available = False
    logger.info("boto3 is not available, skipping AWS Secrets Manager")

class SecretsManager:
    """
    Class to manage secrets retrieval with caching to avoid multiple API calls
    """
    def __init__(self):
        self.cache = {}
        self.region_name = "us-east-1"
        self.boto3_available = boto3_available
        logger.info("Initializing secrets manager with region: %s", self.region_name)
    
    def get_secret(self, *, secret_name, default_if_not_found=None, secret_sub_key=None):
        """
        Generic secret retrieval function with three-step fallback:
        1. Try AWS Secrets Manager
        2. Try .env file / environment variable
        3. Return default_if_not_found
        
        Parameters:
        - secret_name (str): Name of the secret to retrieve (required)
        - default_if_not_found: Value to return if secret is not found (default=None)
        - secret_sub_key (str): If the secret is a dictionary, get this specific key (default=None)
        """
        logger.info("Attempting to get secret: %s (sub_key: %s)", secret_name, secret_sub_key)
        
        # Check if we already have this secret in cache
        if secret_name in self.cache:
            logger.info("Secret '%s' found in cache", secret_name)
            secret_value = self.cache[secret_name]
            # If we need a sub-key and the cached value is a dict, return the sub-key
            if secret_sub_key is not None and isinstance(secret_value, dict):
                logger.info("Returning cached sub_key '%s' from secret '%s'", secret_sub_key, secret_name)
                return secret_value.get(secret_sub_key, default_if_not_found)
            return secret_value
        
        # Step 1: Try AWS Secrets Manager (if boto3 is available)
        if self.boto3_available:
            logger.info("Secret '%s' not in cache, trying AWS Secrets Manager", secret_name)
            try:
                logger.info("Creating boto3 session")
                session = boto3.session.Session()
                logger.info("Creating secretsmanager client in region %s", self.region_name)
                client = session.client(
                    service_name='secretsmanager',
                    region_name=self.region_name
                )
                logger.info("Calling get_secret_value for SecretId: %s", secret_name)
                get_secret_value_response = client.get_secret_value(
                    SecretId=secret_name
                )
                logger.info("Successfully retrieved secret from AWS Secrets Manager: %s", secret_name)
                secret = get_secret_value_response['SecretString']
                try:
                    # Try to parse as JSON (for dictionary secrets)
                    logger.info("Attempting to parse secret as JSON")
                    parsed_secret = json.loads(secret)
                    logger.info("Successfully parsed secret as JSON")
                    # Cache the parsed secret
                    self.cache[secret_name] = parsed_secret
                    # If a sub-key was requested, return that specific value
                    if secret_sub_key is not None:
                        logger.info("Returning sub_key '%s' from parsed JSON secret", secret_sub_key)
                        return parsed_secret.get(secret_sub_key, default_if_not_found)
                    logger.info("For secret '%s', returning JSON value", secret_name)
                    return parsed_secret
                except json.JSONDecodeError:
                    # If not valid JSON, it's a string secret
                    logger.info("Secret is not valid JSON, treating as string")
                    self.cache[secret_name] = secret
                    logger.info("For secret '%s', returning string value", secret_name)
                    return secret
            except Exception as e:
                # AWS Secrets Manager failed, continue to step 2
                logger.warning("Failed to get secret from AWS Secrets Manager: %s - %s", secret_name, str(e))
                logger.info("Falling back to environment variables")
        
        # Step 2: Try environment variable / .env file
        env_value = os.getenv(secret_name)
        if env_value is not None:
            logger.info("Found secret '%s' in environment variables", secret_name)
            # Cache the environment value
            self.cache[secret_name] = env_value
            return env_value
        
        # Step 3: Return default value
        logger.info("Secret '%s' not found in AWS or environment, using default value", secret_name)
        return default_if_not_found

def main():
    # Get the project root directory (assuming this script is in the scripts/ directory)
    project_root = Path(__file__).parent.parent
    
    # Load environment variables from .env file
    env_path = project_root / '.env'
    if env_path.exists():
        logger.info(f"Loading environment variables from {env_path}")
        load_dotenv(env_path)
    else:
        logger.warning(f".env file not found at {env_path}, will rely on environment variables or AWS Secrets")
    
    # Create secrets manager instance
    secrets_manager = SecretsManager()
    
    # Get database connection details with fallback mechanism
    db_user = secrets_manager.get_secret(
        secret_name="NotPointlessPostgresqlPassword", 
        secret_sub_key='username',
        default_if_not_found=os.getenv('DB_USER', 'postgres')
    )
    
    db_password = secrets_manager.get_secret(
        secret_name="NotPointlessPostgresqlPassword", 
        secret_sub_key='password',
        default_if_not_found=os.getenv('DB_PASSWORD', '')
    )
    
    db_name = secrets_manager.get_secret(
        secret_name="NotPointlessPostgresqlPassword", 
        secret_sub_key='dbname',
        default_if_not_found=os.getenv('DB_NAME', 'postgres')
    )
    
    db_host = secrets_manager.get_secret(
        secret_name="NotPointlessPostgresqlPassword", 
        secret_sub_key='host',
        default_if_not_found=os.getenv('DB_HOST', 'localhost')
    )
    
    db_port = secrets_manager.get_secret(
        secret_name="NotPointlessPostgresqlPassword", 
        secret_sub_key='port',
        default_if_not_found=os.getenv('DB_PORT', '5432')
    )
    
    # Get schema and table information
    db_schema = os.getenv('DB_SCHEMA', 'not_pointless')
    db_table = os.getenv('DB_TABLE', 'endpoint')
    
    logger.info(f"Database connection parameters:")
    logger.info(f"  Database: {db_name}")
    logger.info(f"  Schema: {db_schema}")
    logger.info(f"  Host: {db_host}")
    logger.info(f"  Port: {db_port}")
    logger.info(f"  User: {db_user}")
    logger.info(f"  Table: {db_table}")
    
    # Connect to the database
    connection_string = f"postgresql://{db_user}:{db_password}@{db_host}:{db_port}/{db_name}"
    
    logger.info(f"Testing connection to database '{db_name}'...")
    
    try:
        # Create engine and test connection
        engine = create_engine(connection_string)
        
        # Test basic connection by getting database version
        with engine.connect() as connection:
            version_result = connection.execute(text("SELECT version();"))
            version = version_result.fetchone()[0]
            logger.info(f"✓ Database connection successful!")
            logger.info(f"PostgreSQL version: {version}")
            
            # Test if we can access the endpoint table
            logger.info("\nTesting access to endpoint table...")
            
            # Check if the table exists
            inspector = inspect(engine)
            schemas = inspector.get_schema_names()
            
            # Look for the table in the specified schema
            table_found = False
            schema_name = db_schema
            
            if schema_name in schemas:
                tables = inspector.get_table_names(schema=schema_name)
                if db_table in tables:
                    table_found = True
                    logger.info(f"✓ Table '{schema_name}.{db_table}' exists!")
                else:
                    logger.warning(f"✗ Table '{db_table}' not found in schema '{schema_name}'")
                    logger.info(f"Available tables in schema '{schema_name}': {tables}")
            else:
                logger.warning(f"✗ Schema '{schema_name}' not found")
                logger.info(f"Available schemas: {schemas}")
            
            # If table not found in the expected schema, look in other schemas
            if not table_found:
                logger.info("Looking for table in other schemas...")
                for schema in schemas:
                    if schema not in ['information_schema', 'pg_catalog', 'pg_toast']:
                        tables = inspector.get_table_names(schema=schema)
                        if db_table in tables:
                            table_found = True
                            schema_name = schema
                            logger.info(f"✓ Table '{schema_name}.{db_table}' found in different schema!")
                            break
            
            # If table is found, check if it has data
            if table_found:
                # Count records in the table
                count_query = text(f"SELECT COUNT(*) FROM {schema_name}.{db_table}")
                count_result = connection.execute(count_query)
                count = count_result.fetchone()[0]
                
                logger.info(f"✓ Successfully accessed endpoint table!")
                logger.info(f"Number of records in endpoint table: {count}")
                
                # Show sample records if they exist
                if count > 0:
                    sample_query = text(f"""
                        SELECT id, endpoint_url, domain_name, created_at 
                        FROM {schema_name}.{db_table} 
                        ORDER BY created_at DESC 
                        LIMIT 5;
                    """)
                    sample_result = connection.execute(sample_query)
                    records = sample_result.fetchall()
                    
                    logger.info("\nSample records from endpoint table:")
                    logger.info("-" * 80)
                    for record in records:
                        logger.info(f"ID: {record[0]}, URL: {record[1]}, Domain: {record[2]}, Created: {record[3]}")
                else:
                    logger.warning("✗ The table exists but contains no data.")
            
    except SQLAlchemyError as e:
        logger.error(f"✗ Database connection error: {e}")
        logger.error("\nPossible issues:")
        logger.error("1. Check your .env file has the correct DB_PASSWORD")
        logger.error("2. Verify the database host and port are correct")
        logger.error("3. Ensure your IP is whitelisted in AWS RDS security groups")
        logger.error("4. Check if the database server is running")
        
        # List available databases if possible
        try:
            # Try connecting to postgres database to list available databases
            logger.info("Attempting to connect to 'postgres' database to list available databases...")
            postgres_connection_string = f"postgresql://{db_user}:{db_password}@{db_host}:{db_port}/postgres"
            postgres_engine = create_engine(postgres_connection_string)
            
            with postgres_engine.connect() as connection:
                # List available databases
                db_list_query = text("SELECT datname FROM pg_database WHERE datistemplate = false;")
                db_list_result = connection.execute(db_list_query)
                databases = [row[0] for row in db_list_result]
                
                logger.info("\nAvailable databases:")
                for db in databases:
                    logger.info(f"- {db}")
                
                # List available schemas
                inspector = inspect(postgres_engine)
                schemas = inspector.get_schema_names()
                logger.info("\nAvailable schemas in 'postgres' database:")
                for schema in schemas:
                    if schema not in ['information_schema', 'pg_catalog', 'pg_toast']:
                        logger.info(f"- {schema}")
                        
                # If the specified schema exists, check for tables
                if db_schema in schemas:
                    tables = inspector.get_table_names(schema=db_schema)
                    logger.info(f"\nTables in schema '{db_schema}':")
                    for table in tables:
                        logger.info(f"- {table}")
        except Exception as list_error:
            logger.error(f"Could not list available databases and schemas: {list_error}")
        
        sys.exit(1)
    except Exception as e:
        logger.error(f"✗ Unexpected error: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
