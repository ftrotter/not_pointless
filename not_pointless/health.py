from django.http import JsonResponse
from django.db import connection
from django.conf import settings
from not_pointless.settings import logger
import json
import os
import time

def health_check(request):
    """
    Health check endpoint for AWS App Runner
    Returns 200 if the application is healthy, 500 otherwise
    """
    logger.info("Health check endpoint called")
    start_time = time.time()
    
    try:
        # Check database connection
        logger.info("Attempting database connection for health check")
        with connection.cursor() as cursor:
            cursor.execute("SELECT 1")
            cursor.fetchone()
        
        logger.info("Database connection successful")
        
        # Basic application health
        health_data = {
            "status": "healthy",
            "database": "connected",
            "debug": settings.DEBUG,
            "environment": os.getenv('ENVIRONMENT', 'development')
        }
        
        # Log completion time
        elapsed_time = time.time() - start_time
        logger.info(f"Health check completed successfully in {elapsed_time:.3f} seconds")
        
        return JsonResponse(health_data, status=200)
    
    except Exception as e:
        # Log the error
        logger.error(f"Health check failed: {str(e)}")
        
        error_data = {
            "status": "unhealthy",
            "error": str(e),
            "database": "disconnected"
        }
        return JsonResponse(error_data, status=500)
