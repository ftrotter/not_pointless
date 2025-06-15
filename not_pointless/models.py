import os
from django.db import models

# Get schema and table names from environment variables with fallbacks
DB_SCHEMA = os.getenv('DB_SCHEMA', 'not_pointless')
DB_TABLE = os.getenv('DB_TABLE', 'endpoint')

class Endpoint(models.Model):
    id = models.AutoField(primary_key=True)
    endpoint_url = models.TextField(null=True, blank=True)
    domain_name = models.TextField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        db_table = f'"{DB_SCHEMA}"."{DB_TABLE}"'  # Properly quote the schema and table name
        managed = False  # Don't let Django manage this table since it already exists
    
    def __str__(self):
        return f"{self.endpoint_url} ({self.domain_name})"
