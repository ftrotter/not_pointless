#!/bin/bash
python merge_create_sql_files.py --dir sql/create_table_sql
python manage.py durc_mine --include postgres.ndh postgres.nppes_normal
## compile command goes here..
durc-mine-fkeys --input_json_file durc_config/DURC_relational_model.json --output_sql_file ./sql/foreign_key_sql/foreign_keys.sql

