from django.test import TestCase
from django.core.management.base import CommandError
from durc_is_crud.management.commands.durc_utils.include_pattern_parser import DURC_IncludePatternParser

class TestIncludePatternParser(TestCase):
    """Test cases for the DURC_IncludePatternParser utility."""
    
    def test_parse_db_only_pattern(self):
        """Test parsing of a pattern with only a database name."""
        patterns = ['test_db']
        result = DURC_IncludePatternParser.parse_include_patterns(patterns)
        
        self.assertEqual(len(result), 1)
        self.assertEqual(result[0]['db'], 'test_db')
        self.assertIsNone(result[0]['schema'])
        self.assertIsNone(result[0]['table'])
    
    def test_parse_db_schema_pattern(self):
        """Test parsing of a pattern with database and schema names."""
        patterns = ['test_db.test_schema']
        result = DURC_IncludePatternParser.parse_include_patterns(patterns)
        
        self.assertEqual(len(result), 1)
        self.assertEqual(result[0]['db'], 'test_db')
        self.assertEqual(result[0]['schema'], 'test_schema')
        self.assertIsNone(result[0]['table'])
    
    def test_parse_db_schema_table_pattern(self):
        """Test parsing of a pattern with database, schema, and table names."""
        patterns = ['test_db.test_schema.test_table']
        result = DURC_IncludePatternParser.parse_include_patterns(patterns)
        
        self.assertEqual(len(result), 1)
        self.assertEqual(result[0]['db'], 'test_db')
        self.assertEqual(result[0]['schema'], 'test_schema')
        self.assertEqual(result[0]['table'], 'test_table')
    
    def test_parse_multiple_patterns(self):
        """Test parsing of multiple patterns."""
        patterns = ['db1', 'db2.schema2', 'db3.schema3.table3']
        result = DURC_IncludePatternParser.parse_include_patterns(patterns)
        
        self.assertEqual(len(result), 3)
        
        self.assertEqual(result[0]['db'], 'db1')
        self.assertIsNone(result[0]['schema'])
        self.assertIsNone(result[0]['table'])
        
        self.assertEqual(result[1]['db'], 'db2')
        self.assertEqual(result[1]['schema'], 'schema2')
        self.assertIsNone(result[1]['table'])
        
        self.assertEqual(result[2]['db'], 'db3')
        self.assertEqual(result[2]['schema'], 'schema3')
        self.assertEqual(result[2]['table'], 'table3')
    
    def test_invalid_pattern(self):
        """Test that an invalid pattern raises a CommandError."""
        patterns = ['test_db.test_schema.test_table.invalid']
        
        with self.assertRaises(CommandError):
            DURC_IncludePatternParser.parse_include_patterns(patterns)
