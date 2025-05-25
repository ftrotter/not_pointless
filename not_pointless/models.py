from django.db import models

class Endpoint(models.Model):
    id = models.AutoField(primary_key=True)
    endpoint_url = models.TextField(null=True, blank=True)
    domain_name = models.TextField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        db_table = '"not_pointless"."endpoint"'  # Properly quote the schema and table name
        managed = False  # Don't let Django manage this table since it already exists
    
    def __str__(self):
        return f"{self.endpoint_url} ({self.domain_name})"
