#!/bin/bash

# Startup script for AWS App Runner deployment
# This script runs database migrations and collects static files

echo "Starting Django application setup..."

# Wait for database to be ready
echo "Waiting for database connection..."
python manage.py test_db_connection

# Run database migrations
echo "Running database migrations..."
python manage.py migrate --noinput

# Collect static files
echo "Collecting static files..."
python manage.py collectstatic --noinput

# Create superuser if it doesn't exist (optional)
# echo "Creating superuser if needed..."
# python manage.py shell -c "
# from django.contrib.auth import get_user_model
# User = get_user_model()
# if not User.objects.filter(username='admin').exists():
#     User.objects.create_superuser('admin', 'admin@example.com', 'changeme123')
#     print('Superuser created')
# else:
#     print('Superuser already exists')
# "

echo "Django setup complete. Starting application..."

# Start the application
exec "$@"
