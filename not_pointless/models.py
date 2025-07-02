import os
from django.db import models

# Get schema and table names from environment variables with fallbacks
DB_SCHEMA = os.getenv('DB_SCHEMA', 'ndh')
DB_TABLE = os.getenv('DB_TABLE', 'Endpoint')

class Endpoint(models.Model):
    id = models.AutoField(primary_key=True)
    endpoint_url = models.TextField(null=False, blank=True)
    endpoint_name = models.TextField(null=False, blank=True)
    endpoint_desc = models.TextField(null=False, blank=True)
    EndpointAddress_id = models.IntegerField(null=True)
    EndpointType_id = models.IntegerField(null=True)

    
    class Meta:
        db_table = f'"{DB_SCHEMA}"."{DB_TABLE}"'  # Properly quote the schema and table name
        managed = False  # Don't let Django manage this table since it already exists
    
    def __str__(self):
        return f"{self.endpoint_url} ({self.endpoint_name})"
