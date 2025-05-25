from django.http import JsonResponse
from django.db import connection
from django.conf import settings
import json
import os

def health_check(request):
    """
    Health check endpoint for AWS App Runner
    Returns 200 if the application is healthy, 500 otherwise
    """
    try:
        # Check database connection
        with connection.cursor() as cursor:
            cursor.execute("SELECT 1")
            cursor.fetchone()
        
        # Basic application health
        health_data = {
            "status": "healthy",
            "database": "connected",
            "debug": settings.DEBUG,
            "environment": os.getenv('ENVIRONMENT', 'development')
        }
        
        return JsonResponse(health_data, status=200)
    
    except Exception as e:
        error_data = {
            "status": "unhealthy",
            "error": str(e),
            "database": "disconnected"
        }
        return JsonResponse(error_data, status=500)
