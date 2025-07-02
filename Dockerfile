FROM python:3.11-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set work directory
WORKDIR /app

# Install system dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        postgresql-client \
        build-essential \
        libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# Copy project
COPY . /app/

# Make startup script executable
RUN chmod +x /app/scripts/startup.sh

# Expose port
EXPOSE 8000

# Use startup script as entrypoint
ENTRYPOINT ["/app/scripts/startup.sh"]

# Run the application
CMD ["gunicorn", "--config", "scripts/gunicorn_config.py", "not_pointless.wsgi:application"]
