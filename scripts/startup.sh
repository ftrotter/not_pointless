#!/bin/bash
set -e

# Run collectstatic
echo "Collecting static files..."
python manage.py collectstatic --noinput

# Start the application
echo "Starting application..."
exec "$@"
