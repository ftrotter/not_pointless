import os
import json
from unittest import mock
from django.test import TestCase
from django.core.management import call_command
from django.core.management.base import CommandError

class TestDurcCompileCommand(TestCase):
    """Test cases for the durc_compile management command."""
    
    def setUp(self):
        """Set up test environment."""
        # Create test directories if they don't exist
        os.makedirs('durc_config', exist_ok=True)
        os.makedirs('durc_generated', exist_ok=True)
        
        # Create a sample relational model file for testing
        self.sample_model = {
            'test_db': {
                'test_table': {
                    'table_name': 'test_table',
                    'db': 'test_db',
                    'column_data': [
                        {
                            'column_name': 'id',
                            'data_type': 'int',
                            'is_primary_key': True,
                            'is_foreign_key': False,
                            'is_linked_key': False,
                            'is_nullable': False,
                            'is_auto_increment': True
                        },
                        {
                            'column_name': 'name',
                            'data_type': 'varchar',
                            'is_primary_key': False,
                            'is_foreign_key': False,
                            'is_linked_key': False,
                            'is_nullable': False,
                            'is_auto_increment': False
                        }
                    ]
                }
            }
        }
        
        with open('durc_config/DURC_relational_model.json', 'w') as f:
            json.dump(self.sample_model, f, indent=2)
    
    def tearDown(self):
        """Clean up after tests."""
        # Remove test files if they exist
        if os.path.exists('durc_config/DURC_relational_model.json'):
            os.remove('durc_config/DURC_relational_model.json')
        
        if os.path.exists('durc_generated/durc_compile_placeholder.txt'):
            os.remove('durc_generated/durc_compile_placeholder.txt')
        
        # Remove test directories if they exist and are empty
        for dir_path in ['durc_generated', 'durc_config']:
            if os.path.exists(dir_path) and not os.listdir(dir_path):
                os.rmdir(dir_path)
    
    def test_command_requires_input_file(self):
        """Test that the command requires the input file to exist."""
        # Remove the input file
        os.remove('durc_config/DURC_relational_model.json')
        
        # Call the command and expect an error
        with self.assertRaises(CommandError):
            call_command('durc_compile')
    
    def test_command_creates_output_file(self):
        """Test that the command creates the output file."""
        # Call the command
        call_command('durc_compile')
        
        # Assert that the output file was created
        self.assertTrue(os.path.exists('durc_generated/durc_compile_placeholder.txt'))
    
    def test_command_with_custom_paths(self):
        """Test that the command respects custom input and output paths."""
        # Create a custom input file
        custom_input_dir = 'custom_input'
        custom_output_dir = 'custom_output'
        
        os.makedirs(custom_input_dir, exist_ok=True)
        os.makedirs(custom_output_dir, exist_ok=True)
        
        custom_input_file = os.path.join(custom_input_dir, 'custom_model.json')
        
        with open(custom_input_file, 'w') as f:
            json.dump(self.sample_model, f, indent=2)
        
        try:
            # Call the command with custom paths
            call_command('durc_compile', input_json_file=custom_input_file, output_dir=custom_output_dir)
            
            # Assert that the output file was created at the custom path
            self.assertTrue(os.path.exists(os.path.join(custom_output_dir, 'durc_compile_placeholder.txt')))
        finally:
            # Clean up
            if os.path.exists(custom_input_file):
                os.remove(custom_input_file)
            
            if os.path.exists(os.path.join(custom_output_dir, 'durc_compile_placeholder.txt')):
                os.remove(os.path.join(custom_output_dir, 'durc_compile_placeholder.txt'))
            
            for dir_path in [custom_input_dir, custom_output_dir]:
                if os.path.exists(dir_path) and not os.listdir(dir_path):
                    os.rmdir(dir_path)
