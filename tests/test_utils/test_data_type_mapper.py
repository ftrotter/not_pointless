from django.test import TestCase
from durc_is_crud.management.commands.durc_utils.data_type_mapper import DURC_DataTypeMapper

class TestDataTypeMapper(TestCase):
    """Test cases for the DURC_DataTypeMapper utility."""
    
    def test_integer_types(self):
        """Test mapping of integer data types."""
        integer_types = ['integer', 'int', 'int4', 'serial', 'bigint', 'int8', 'bigserial', 'smallint', 'int2', 'smallserial']
        
        for pg_type in integer_types:
            self.assertEqual(DURC_DataTypeMapper.map_data_type(pg_type), 'int')
            # Test case insensitivity
            self.assertEqual(DURC_DataTypeMapper.map_data_type(pg_type.upper()), 'int')
    
    def test_string_types(self):
        """Test mapping of string data types."""
        # Test varchar types
        varchar_types = ['varchar', 'varchar(255)', 'character varying', 'character varying(255)']
        for pg_type in varchar_types:
            self.assertEqual(DURC_DataTypeMapper.map_data_type(pg_type), 'varchar')
        
        # Test text type
        self.assertEqual(DURC_DataTypeMapper.map_data_type('text'), 'text')
        
        # Test char types
        char_types = ['char', 'character', 'character(10)']
        for pg_type in char_types:
            self.assertEqual(DURC_DataTypeMapper.map_data_type(pg_type), 'char')
    
    def test_text_types(self):
        """Test mapping of text data types."""
        self.assertEqual(DURC_DataTypeMapper.map_data_type('mediumtext'), 'mediumtext')
        self.assertEqual(DURC_DataTypeMapper.map_data_type('longtext'), 'longtext')
    
    def test_numeric_types(self):
        """Test mapping of numeric data types."""
        # Test float types
        float_types = ['real', 'float4', 'float8', 'double precision']
        for pg_type in float_types:
            self.assertEqual(DURC_DataTypeMapper.map_data_type(pg_type), 'float')
        
        # Test decimal types
        decimal_types = ['numeric', 'numeric(10,2)', 'decimal', 'decimal(10,2)']
        for pg_type in decimal_types:
            self.assertEqual(DURC_DataTypeMapper.map_data_type(pg_type), 'decimal')
    
    def test_date_time_types(self):
        """Test mapping of date/time data types."""
        self.assertEqual(DURC_DataTypeMapper.map_data_type('date'), 'date')
        
        timestamp_types = ['timestamp', 'timestamp without time zone', 'timestamp with time zone']
        for pg_type in timestamp_types:
            self.assertEqual(DURC_DataTypeMapper.map_data_type(pg_type), 'timestamp')
        
        time_types = ['time', 'time without time zone', 'time with time zone']
        for pg_type in time_types:
            self.assertEqual(DURC_DataTypeMapper.map_data_type(pg_type), 'time')
        
        self.assertEqual(DURC_DataTypeMapper.map_data_type('datetime'), 'datetime')
    
    def test_binary_types(self):
        """Test mapping of binary data types."""
        self.assertEqual(DURC_DataTypeMapper.map_data_type('bytea'), 'blob')
    
    def test_boolean_types(self):
        """Test mapping of boolean data types."""
        boolean_types = ['boolean', 'bool']
        for pg_type in boolean_types:
            self.assertEqual(DURC_DataTypeMapper.map_data_type(pg_type), 'tinyint')
    
    def test_unknown_type(self):
        """Test mapping of an unknown data type."""
        self.assertEqual(DURC_DataTypeMapper.map_data_type('unknown_type'), 'unknown_type')
        self.assertEqual(DURC_DataTypeMapper.map_data_type('json'), 'json')
        self.assertEqual(DURC_DataTypeMapper.map_data_type('jsonb'), 'jsonb')
