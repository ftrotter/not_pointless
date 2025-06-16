import os
import json
import re
from django.core.management.base import BaseCommand, CommandError
from django.db import connections, connection
from django.db.models.fields.related import ForeignKey, ManyToManyField
from django.db.models.fields import AutoField, BigAutoField, SmallAutoField
from django.db.utils import OperationalError

class Command(BaseCommand):
    help = 'Mine database schema and generate DURC relational model JSON'

    def add_arguments(self, parser):
        parser.add_argument(
            '--include',
            nargs='+',
            type=str,
            help='Specify databases, schemas, or tables to include in the format: db.schema.table, db.schema, or db'
        )

    def handle(self, *args, **options):
        include_patterns = options.get('include', [])
        
        if not include_patterns:
            raise CommandError("You must specify at least one database, schema, or table to include using --include")
        
        # Parse the include patterns
        db_schema_table_patterns = self._parse_include_patterns(include_patterns)
        
        # Extract the relational model
        relational_model = self._extract_relational_model(db_schema_table_patterns)
        
        # Ensure the durc_config directory exists
        os.makedirs('durc_config', exist_ok=True)
        
        # Write the relational model to JSON file
        output_path = os.path.join('durc_config', 'DURC_relational_model.json')
        with open(output_path, 'w') as f:
            json.dump(relational_model, f, indent=2)
        
        self.stdout.write(self.style.SUCCESS(f"Successfully generated DURC relational model at {output_path}"))

    def _parse_include_patterns(self, patterns):
        """
        Parse the include patterns into a structured format.
        
        Returns a list of dictionaries with keys:
        - db: database name
        - schema: schema name (or None for all schemas)
        - table: table name (or None for all tables)
        """
        result = []
        
        for pattern in patterns:
            parts = pattern.split('.')
            
            if len(parts) == 1:
                # Format: db
                result.append({
                    'db': parts[0],
                    'schema': None,
                    'table': None
                })
            elif len(parts) == 2:
                # Format: db.schema
                result.append({
                    'db': parts[0],
                    'schema': parts[1],
                    'table': None
                })
            elif len(parts) == 3:
                # Format: db.schema.table
                result.append({
                    'db': parts[0],
                    'schema': parts[1],
                    'table': parts[2]
                })
            else:
                raise CommandError(f"Invalid include pattern: {pattern}. Use format: db.schema.table, db.schema, or db")
        
        return result

    def _extract_relational_model(self, db_schema_table_patterns):
        """
        Extract the relational model based on the specified patterns.
        
        Returns a dictionary structured according to the DURC_simplified schema.
        """
        relational_model = {}
        
        # Use the default connection if no specific database is provided
        conn = connection
        
        for pattern in db_schema_table_patterns:
            db_name = pattern['db']
            schema_name = pattern['schema']
            table_name = pattern['table']
            
            # Try to get the connection for the specified database
            try:
                if db_name in connections:
                    conn = connections[db_name]
                else:
                    self.stdout.write(self.style.WARNING(f"Database '{db_name}' not found in settings, using default connection"))
            except Exception as e:
                self.stdout.write(self.style.ERROR(f"Error connecting to database '{db_name}': {e}"))
                continue
            
            # Initialize the database in the relational model if not already present
            if db_name not in relational_model:
                relational_model[db_name] = {}
            
            # Get the introspection API for the connection
            introspection = conn.introspection
            
            # Get all table names in the database
            try:
                with conn.cursor() as cursor:
                    # Get all tables in the database/schema
                    if schema_name:
                        # If schema is specified, get tables from that schema
                        cursor.execute(f"""
                            SELECT table_name 
                            FROM information_schema.tables 
                            WHERE table_schema = %s 
                            AND table_type = 'BASE TABLE'
                            AND table_name NOT LIKE '\\_%%'
                        """, [schema_name])
                    else:
                        # If no schema is specified, use the database name as the schema name
                        # This assumes that the database name is also the schema name
                        schema_name = db_name
                        cursor.execute(f"""
                            SELECT table_name 
                            FROM information_schema.tables 
                            WHERE table_schema = %s
                            AND table_type = 'BASE TABLE'
                            AND table_name NOT LIKE '\\_%%'
                        """, [schema_name])
                    
                    all_tables = [row[0] for row in cursor.fetchall()]
                    
                    # Filter tables based on the pattern
                    tables_to_process = []
                    if table_name:
                        if table_name in all_tables:
                            tables_to_process.append(table_name)
                        else:
                            self.stdout.write(self.style.WARNING(f"Table '{table_name}' not found in schema '{schema_name or 'default'}'"))
                    else:
                        tables_to_process = all_tables
                    
                    # Process each table
                    for table in tables_to_process:
                        # Skip tables that start with underscore
                        if table.startswith('_'):
                            continue
                        
                        # Get table description (columns)
                        cursor.execute(f"""
                            SELECT column_name, data_type, is_nullable, column_default
                            FROM information_schema.columns c
                            WHERE table_name = %s
                            {f"AND table_schema = '{schema_name}'" if schema_name else ""}
                            ORDER BY ordinal_position
                        """, [table])
                        
                        columns_data = cursor.fetchall()
                        
                        # Get primary key information
                        cursor.execute(f"""
                            SELECT ccu.column_name
                            FROM information_schema.table_constraints tc
                            JOIN information_schema.constraint_column_usage ccu 
                            ON tc.constraint_name = ccu.constraint_name
                            WHERE tc.table_name = %s
                            {f"AND tc.table_schema = '{schema_name}'" if schema_name else ""}
                            AND tc.constraint_type = 'PRIMARY KEY'
                        """, [table])
                        
                        primary_keys = set([row[0] for row in cursor.fetchall()])
                        
                        # Get foreign key information
                        cursor.execute(f"""
                            SELECT kcu.column_name
                            FROM information_schema.table_constraints tc
                            JOIN information_schema.key_column_usage kcu
                            ON tc.constraint_name = kcu.constraint_name
                            WHERE tc.table_name = %s
                            {f"AND tc.table_schema = '{schema_name}'" if schema_name else ""}
                            AND tc.constraint_type = 'FOREIGN KEY'
                        """, [table])
                        
                        foreign_key_columns = set([row[0] for row in cursor.fetchall()])
                        
                        # Get foreign key relationships
                        cursor.execute(f"""
                            SELECT kcu.column_name, ccu.table_schema, ccu.table_name, ccu.column_name
                            FROM information_schema.table_constraints AS tc 
                            JOIN information_schema.key_column_usage AS kcu
                            ON tc.constraint_name = kcu.constraint_name
                            JOIN information_schema.constraint_column_usage AS ccu 
                            ON ccu.constraint_name = tc.constraint_name
                            WHERE tc.constraint_type = 'FOREIGN KEY' 
                            AND tc.table_name = %s
                            {f"AND tc.table_schema = '{schema_name}'" if schema_name else ""}
                        """, [table])
                        
                        foreign_keys = {}
                        for fk_col, fk_schema, fk_table, fk_target_col in cursor.fetchall():
                            foreign_keys[fk_col] = {
                                'schema': fk_schema,
                                'table': fk_table,
                                'column': fk_target_col
                            }
                        
                        # Try to get the CREATE TABLE SQL using pg_get_ddl if available
                        try:
                            cursor.execute(f"""
                                SELECT pg_get_ddl('TABLE', '{schema_name + "." if schema_name else ""}{table}')
                            """)
                            create_table_sql = cursor.fetchone()[0]
                        except Exception as e:
                            # If pg_get_ddl is not available, construct a simplified CREATE TABLE statement
                            self.stdout.write(self.style.WARNING(f"Could not get CREATE TABLE SQL using pg_get_ddl: {e}"))
                            self.stdout.write(self.style.WARNING(f"Constructing simplified CREATE TABLE statement for {table}"))
                            
                            # Get column information for constructing CREATE TABLE
                            create_table_parts = [f"CREATE TABLE {schema_name + '.' if schema_name else ''}{table} ("]
                            column_parts = []
                            
                            for col_name, data_type, is_nullable, default_value in columns_data:
                                col_def = f"  {col_name} {data_type}"
                                
                                if not is_nullable == 'YES':
                                    col_def += " NOT NULL"
                                
                                if default_value:
                                    col_def += f" DEFAULT {default_value}"
                                
                                column_parts.append(col_def)
                            
                            # Add primary key constraint if any
                            if primary_keys:
                                column_parts.append(f"  PRIMARY KEY ({', '.join(primary_keys)})")
                            
                            # Add foreign key constraints
                            for fk_col, fk_info in foreign_keys.items():
                                # Use the current schema for references if the foreign key is in the same schema
                                ref_schema = schema_name if fk_info['schema'] == 'public' else fk_info['schema']
                                column_parts.append(
                                    f"  FOREIGN KEY ({fk_col}) REFERENCES {ref_schema}.{fk_info['table']}({fk_info['column']})"
                                )
                            
                            create_table_parts.append(',\n'.join(column_parts))
                            create_table_parts.append(")")
                            
                            create_table_sql = '\n'.join(create_table_parts)
                        
                        # Process columns
                        column_data = []
                        for col_name, data_type, is_nullable, default_value in columns_data:
                            # Determine if this column is a primary key or foreign key
                            is_primary = col_name in primary_keys
                            is_foreign = col_name in foreign_key_columns
                            # Skip columns that start with underscore
                            if col_name.startswith('_'):
                                continue
                            
                            # Determine if this is a linked key (ends with _id)
                            is_linked_key = col_name.endswith('_id')
                            
                            # Get foreign key information
                            foreign_db = None
                            foreign_table = None
                            if col_name in foreign_keys:
                                foreign_db = db_name  # Assume same database
                                foreign_table = foreign_keys[col_name]['table']
                            elif is_linked_key and not is_foreign:
                                # Try to infer the foreign table from the column name
                                inferred_table = col_name[:-3]  # Remove _id suffix
                                # Check if this table exists
                                cursor.execute(f"""
                                    SELECT EXISTS (
                                        SELECT 1 
                                        FROM information_schema.tables 
                                        WHERE table_name = %s
                                        {f"AND table_schema = '{schema_name}'" if schema_name else ""}
                                    )
                                """, [inferred_table])
                                if cursor.fetchone()[0]:
                                    foreign_db = db_name
                                    foreign_table = inferred_table
                            
                            # Determine if auto-increment
                            is_auto_increment = False
                            if default_value and ('nextval' in str(default_value) or 'auto_increment' in str(default_value).lower()):
                                is_auto_increment = True
                            
                            # Map PostgreSQL data types to simplified types
                            simplified_type = self._map_data_type(data_type)
                            
                            column_data.append({
                                'column_name': col_name,
                                'data_type': simplified_type,
                                'is_primary_key': is_primary,
                                'is_foreign_key': is_foreign,
                                'is_linked_key': is_linked_key,
                                'foreign_db': foreign_db,
                                'foreign_table': foreign_table,
                                'is_nullable': is_nullable == 'YES',
                                'default_value': default_value,
                                'is_auto_increment': is_auto_increment
                            })
                        
                        # Process relationships
                        has_many = {}
                        belongs_to = {}
                        
                        # Find "belongs_to" relationships (foreign keys in this table)
                        for col in column_data:
                            if col['is_foreign_key'] or col['is_linked_key']:
                                if col['foreign_table']:
                                    # Determine the prefix (if any)
                                    prefix = None
                                    if col['column_name'].endswith('_id'):
                                        prefix_candidate = col['column_name'][:-3]  # Remove _id
                                        if prefix_candidate != col['foreign_table']:
                                            prefix = prefix_candidate
                                    
                                    # Use the current schema for the foreign table if it's in the public schema
                                    foreign_db = col['foreign_db']
                                    foreign_table = col['foreign_table']
                                    
                                    belongs_to[col['column_name'][:-3] if col['column_name'].endswith('_id') else col['column_name']] = {
                                        'prefix': prefix,
                                        'type': foreign_table,
                                        'to_table': foreign_table,
                                        'to_db': foreign_db,
                                        'local_key': col['column_name']
                                    }
                        
                        # Find "has_many" relationships (foreign keys in other tables pointing to this table)
                        cursor.execute(f"""
                            SELECT tc.table_name, kcu.column_name
                            FROM information_schema.table_constraints AS tc 
                            JOIN information_schema.key_column_usage AS kcu
                            ON tc.constraint_name = kcu.constraint_name
                            JOIN information_schema.constraint_column_usage AS ccu 
                            ON ccu.constraint_name = tc.constraint_name
                            WHERE tc.constraint_type = 'FOREIGN KEY' 
                            AND ccu.table_name = %s
                            {f"AND ccu.table_schema = '{schema_name}'" if schema_name else ""}
                        """, [table])
                        
                        for ref_table, ref_column in cursor.fetchall():
                            # Skip tables that start with underscore
                            if ref_table.startswith('_'):
                                continue
                            
                            # Determine the prefix (if any)
                            prefix = None
                            if ref_column.endswith('_id'):
                                prefix_candidate = ref_column[:-3]  # Remove _id
                                if prefix_candidate != table:
                                    prefix = prefix_candidate
                            
                            relation_name = ref_table
                            if prefix:
                                relation_name = f"{prefix}_{ref_table}"
                            
                            has_many[relation_name] = {
                                'prefix': prefix,
                                'type': ref_table,
                                'from_table': ref_table,
                                'from_db': db_name,
                                'from_column': ref_column
                            }
                        
                        # Add the table to the relational model
                        relational_model[db_name][table] = {
                            'table_name': table,
                            'db': db_name,
                            'column_data': column_data,
                            'create_table_sql': create_table_sql
                        }
                        
                        # Add relationships if they exist
                        if has_many:
                            relational_model[db_name][table]['has_many'] = has_many
                        if belongs_to:
                            relational_model[db_name][table]['belongs_to'] = belongs_to
                        
                        self.stdout.write(f"Processed table: {db_name}.{schema_name + '.' if schema_name else ''}{table}")
                    
            except OperationalError as e:
                self.stdout.write(self.style.ERROR(f"Database operation error: {e}"))
            except Exception as e:
                self.stdout.write(self.style.ERROR(f"Error processing database '{db_name}': {e}"))
        
        return relational_model

    def _map_data_type(self, pg_type):
        """Map PostgreSQL data types to simplified types used in DURC schema"""
        pg_type = pg_type.lower()
        
        # Integer types
        if pg_type in ('integer', 'int', 'int4', 'serial', 'bigint', 'int8', 'bigserial', 'smallint', 'int2', 'smallserial'):
            return 'int'
        
        # String types
        if pg_type.startswith('varchar') or pg_type.startswith('character varying'):
            return 'varchar'
        if pg_type == 'text':
            return 'text'
        if pg_type == 'char' or pg_type.startswith('character'):
            return 'char'
        
        # Text types
        if pg_type == 'mediumtext':
            return 'mediumtext'
        if pg_type == 'longtext':
            return 'longtext'
        
        # Numeric types
        if pg_type == 'real' or pg_type == 'float4' or pg_type == 'float8' or pg_type == 'double precision':
            return 'float'
        if pg_type.startswith('numeric') or pg_type.startswith('decimal'):
            return 'decimal'
        
        # Date/time types
        if pg_type == 'date':
            return 'date'
        if pg_type == 'timestamp' or pg_type.startswith('timestamp'):
            return 'timestamp'
        if pg_type == 'time' or pg_type.startswith('time'):
            return 'time'
        if pg_type == 'datetime':
            return 'datetime'
        
        # Binary types
        if pg_type == 'bytea':
            return 'blob'
        
        # Boolean types
        if pg_type == 'boolean' or pg_type == 'bool':
            return 'tinyint'
        
        # Default fallback
        return pg_type
