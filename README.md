# Not Pointless

A Django web application for managing API endpoints.

## Database Connection Testing

To test if the database connection is working:

```bash
python manage.py test_db_connection
```

This command:

- Tests PostgreSQL connection
- Checks access to the `not_pointless.endpoint` table
- Shows record count and sample data
- Provides troubleshooting info if connection fails

## Checkpoint

- working without VPC and the database credentials are loading from the AWS secret system correctly
