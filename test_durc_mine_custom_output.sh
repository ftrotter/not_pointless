#!/bin/bash
# Test the durc_mine command with custom output file
mkdir -p test_output
python manage.py durc_mine --include durc_aaa durc_bbb not_pointless --output_json_file test_output/custom_model.json
echo "Check if the file was created at test_output/custom_model.json"
