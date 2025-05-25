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
