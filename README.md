# DURC Is CRUD

DURC (Database to CRUD) is a Django package that helps you generate CRUD (Create, Read, Update, Delete) operations from your database schema.

## Features

- **durc_mine**: Extract relational model information from your database
- **durc_compile**: Generate code artifacts from the relational model (coming soon)

## Installation

```bash
pip install durc_is_crud
```

## Usage

Add `durc_is_crud` to your `INSTALLED_APPS` in your Django settings:

```python
INSTALLED_APPS = [
    # ...
    'durc_is_crud',
    # ...
]
```

### Mining your database

To extract the relational model from your database:

```bash
python manage.py durc_mine --include your_db.your_schema.your_table
```

This will generate a JSON file at `durc_config/DURC_relational_model.json` containing the relational model information.

You can specify a custom output path:

```bash
python manage.py durc_mine --include your_db.your_schema.your_table --output_json_file path/to/output.json
```

### Compiling code artifacts (Coming Soon)

Once you have generated the relational model, you can compile it into code artifacts:

```bash
python manage.py durc_compile
```

This will generate code artifacts in the `durc_generated` directory.

You can specify custom input and output paths:

```bash
python manage.py durc_compile --input_json_file path/to/input.json --output_dir path/to/output
```

## License

MIT
