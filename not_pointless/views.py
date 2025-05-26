from django.shortcuts import render
from django.http import HttpResponse
from .models import Endpoint
from .settings import get_secret, get_django_secret_key
import os

def homepage(request):
    """
    Display a simple homepage that doesn't connect to the database
    """
    return render(request, 'not_pointless/homepage.html')

def endpoint_print(request):
    """
    Display distinct URLs from the endpoint table (requires database connection)
    """
    try:
        # Get distinct endpoint URLs from the database
        distinct_urls = Endpoint.objects.values_list('endpoint_url', flat=True).distinct().order_by('endpoint_url')
        
        context = {
            'urls': distinct_urls,
            'total_count': distinct_urls.count()
        }
        
        return render(request, 'not_pointless/endpoint_list.html', context)
    
    except Exception as e:
        # If there's a database connection issue, show the error
        return HttpResponse(f"Database connection error: {str(e)}", status=500)

def debug_secrets(request):
    """
    Display the first 5 characters of the two secrets to verify AWS secrets loading
    """
    try:
        # Get Django secret key (first 5 characters)
        django_secret = get_django_secret_key()
        django_secret_preview = django_secret[:5] if django_secret else "Not found"
        
        # Get database secret (first 5 characters of password)
        db_secret_preview = "None"
        if os.getenv('ENVIRONMENT') == 'production':
            db_secrets = get_secret("NotPointlessPostgresqlPassword")
            if db_secrets and 'password' in db_secrets:
                db_password = db_secrets['password']
                db_secret_preview = db_password[:5] if db_password else "Not found"
            else:
                db_password = 'failed'
                db_secret_preview = 'failed'
        else:   
            # In development, show first 5 chars of DB_PASSWORD env var
            db_password = os.getenv('DB_PASSWORD', '')
            db_secret_preview = db_password[:5] if db_password else "None"
        
        context = {
            'django_secret_preview': django_secret_preview,
            'db_secret_preview': db_secret_preview,
            'environment': os.getenv('ENVIRONMENT', 'development')
        }
        
        return render(request, 'not_pointless/debug_secrets.html', context)
    
    except Exception as e:
        return HttpResponse(f"Error accessing secrets: {str(e)}", status=500)
