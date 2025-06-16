#!/bin/bash
rm durc_config/DURC_relational_model.json 
python manage.py durc_mine --include durc_aaa durc_bbb not_pointless
