from django.core.management.base import BaseCommand
from django.db import connection
from django.db.utils import OperationalError
import os
import sys


class Command(BaseCommand):
    help = 'Test database connection and query the endpoint table'

    def handle(self, *args, **options):
        # Get schema name from environment variable with fallback to "not_pointless"
        db_schema = os.getenv('DB_SCHEMA', 'not_pointless')
        db_table = os.getenv('DB_TABLE', 'endpoint')
        
        self.stdout.write("Testing database connection...")
        self.stdout.write(f"Using schema: {db_schema}")
        self.stdout.write(f"Using table: {db_table}")
        
        try:
            # Test basic connection
            with connection.cursor() as cursor:
                cursor.execute("SELECT version();")
                version = cursor.fetchone()
                self.stdout.write(
                    self.style.SUCCESS(f"✓ Database connection successful!")
                )
                self.stdout.write(f"PostgreSQL version: {version[0]}")
                
                # Test if we can access the endpoint table in the specified schema
                self.stdout.write(f"\nTesting access to {db_schema}.{db_table} table...")
                
                try:
                    cursor.execute(f"SELECT COUNT(*) FROM {db_schema}.{db_table};")
                    count = cursor.fetchone()[0]
                    self.stdout.write(
                        self.style.SUCCESS(f"✓ Successfully accessed endpoint table!")
                    )
                    self.stdout.write(f"Number of records in endpoint table: {count}")
                    
                    # Show a few sample records if they exist
                    if count > 0:
                        cursor.execute(f"""
                            SELECT id, endpoint_url, domain_name, created_at 
                            FROM {db_schema}.{db_table} 
                            ORDER BY created_at DESC 
                            LIMIT 5;
                        """)
                        records = cursor.fetchall()
                        
                        self.stdout.write("\nSample records from endpoint table:")
                        self.stdout.write("-" * 80)
                        for record in records:
                            self.stdout.write(f"ID: {record[0]}, URL: {record[1]}, Domain: {record[2]}, Created: {record[3]}")
                    
                except Exception as e:
                    self.stdout.write(
                        self.style.ERROR(f"✗ Error accessing endpoint table: {e}")
                    )
                    self.stdout.write("This might be because:")
                    self.stdout.write(f"1. The table '{db_table}' doesn't exist in the '{db_schema}' schema")
                    self.stdout.write("2. The schema doesn't exist")
                    self.stdout.write("3. Permission issues")
                    
                    # Try to list available schemas
                    try:
                        cursor.execute("""
                            SELECT schema_name 
                            FROM information_schema.schemata 
                            WHERE schema_name NOT IN ('information_schema', 'pg_catalog', 'pg_toast');
                        """)
                        schemas = cursor.fetchall()
                        self.stdout.write(f"\nAvailable schemas: {[s[0] for s in schemas]}")
                    except Exception as schema_error:
                        self.stdout.write(f"Could not list schemas: {schema_error}")
                
        except OperationalError as e:
            self.stdout.write(
                self.style.ERROR(f"✗ Database connection failed: {e}")
            )
            self.stdout.write("\nPossible issues:")
            self.stdout.write("1. Check your .env file has the correct DB_PASSWORD")
            self.stdout.write("2. Verify the database host and port are correct")
            self.stdout.write("3. Ensure your IP is whitelisted in AWS RDS security groups")
            self.stdout.write("4. Check if the database server is running")
            sys.exit(1)
            
        except Exception as e:
            self.stdout.write(
                self.style.ERROR(f"✗ Unexpected error: {e}")
            )
            sys.exit(1)
