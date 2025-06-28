# Not Pointless

This is a scratch pad for work related to endpoint data etc.

## Using durc-is-crud

### Installation

To use the durc-is-crud package in this project:

1. Install the package via pip:
   ```bash
   pip install durc-is-crud
   ```

2. Add 'durc_is_crud' to the INSTALLED_APPS in your settings.py file:
   ```python
   INSTALLED_APPS = [
       # ... other apps
       'durc_is_crud',
   ]
   ```

3. After installation and configuration, you can use the durc commands:
   ```bash
   # To mine database schema and generate DURC relational model JSON
   python manage.py durc_mine --include <database_name>.<schema_name>.<table_name>
   
   # To compile the DURC relational model into code
   python manage.py durc_compile
   ```

The durc commands will appear under the [durc_is_crud] section when you run `python manage.py`.

