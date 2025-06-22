import os
import json
from unittest import mock
from django.test import TestCase
from django.core.management import call_command
from django.core.management.base import CommandError

class TestDurcMineCommand(TestCase):
    """Test cases for the durc_mine management command."""
    
    def setUp(self):
        """Set up test environment."""
        # Create test directory if it doesn't exist
        os.makedirs('durc_config', exist_ok=True)
    
    def tearDown(self):
        """Clean up after tests."""
        # Remove test output file if it exists
        if os.path.exists('durc_config/DURC_relational_model.json'):
            os.remove('durc_config/DURC_relational_model.json')
        
        # Remove test directory if it exists and is empty
        if os.path.exists('durc_config') and not os.listdir('durc_config'):
            os.rmdir('durc_config')
    
    def test_command_requires_include_argument(self):
        """Test that the command requires the --include argument."""
        with self.assertRaises(CommandError):
            call_command('durc_mine')
    
    @mock.patch('durc_is_crud.management.commands.durc_utils.include_pattern_parser.DURC_IncludePatternParser.parse_include_patterns')
    @mock.patch('durc_is_crud.management.commands.durc_utils.relational_model_extractor.DURC_RelationalModelExtractor.extract_relational_model')
    def test_command_calls_correct_methods(self, mock_extract, mock_parse):
        """Test that the command calls the correct methods with the correct arguments."""
        # Set up mocks
        mock_parse.return_value = [{'db': 'test_db', 'schema': 'test_schema', 'table': 'test_table'}]
        mock_extract.return_value = {'test_db': {'test_table': {'table_name': 'test_table'}}}
        
        # Call the command
        call_command('durc_mine', include=['test_db.test_schema.test_table'])
        
        # Assert that the parse method was called with the correct arguments
        mock_parse.assert_called_once_with(['test_db.test_schema.test_table'])
        
        # Assert that the extract method was called
        mock_extract.assert_called_once()
        
        # Assert that the output file was created
        self.assertTrue(os.path.exists('durc_config/DURC_relational_model.json'))
        
        # Assert that the output file contains the expected data
        with open('durc_config/DURC_relational_model.json', 'r') as f:
            data = json.load(f)
            self.assertEqual(data, {'test_db': {'test_table': {'table_name': 'test_table'}}})
    
    @mock.patch('durc_is_crud.management.commands.durc_utils.include_pattern_parser.DURC_IncludePatternParser.parse_include_patterns')
    @mock.patch('durc_is_crud.management.commands.durc_utils.relational_model_extractor.DURC_RelationalModelExtractor.extract_relational_model')
    def test_command_with_custom_output_path(self, mock_extract, mock_parse):
        """Test that the command respects the --output_json_file argument."""
        # Set up mocks
        mock_parse.return_value = [{'db': 'test_db', 'schema': 'test_schema', 'table': 'test_table'}]
        mock_extract.return_value = {'test_db': {'test_table': {'table_name': 'test_table'}}}
        
        # Create a temporary directory for the test
        os.makedirs('test_output', exist_ok=True)
        
        try:
            # Call the command with a custom output path
            call_command('durc_mine', include=['test_db.test_schema.test_table'], output_json_file='test_output/custom.json')
            
            # Assert that the output file was created at the custom path
            self.assertTrue(os.path.exists('test_output/custom.json'))
            
            # Assert that the output file contains the expected data
            with open('test_output/custom.json', 'r') as f:
                data = json.load(f)
                self.assertEqual(data, {'test_db': {'test_table': {'table_name': 'test_table'}}})
        finally:
            # Clean up
            if os.path.exists('test_output/custom.json'):
                os.remove('test_output/custom.json')
            
            if os.path.exists('test_output') and not os.listdir('test_output'):
                os.rmdir('test_output')
