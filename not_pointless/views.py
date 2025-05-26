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
    Display detailed debugging information about AWS secrets loading
    """
    try:
        # Get Django secret key (first 10 characters)
        django_secret = get_django_secret_key()
        django_secret_preview = django_secret[:10] if django_secret else "Not found"
        
        # Initialize debug info
        db_secret_preview = "None"
        raw_secret_info = "N/A (development mode)"
        secret_type_info = "N/A (development mode)"
        json_loads_error = None
        raw_secret_preview = "N/A (development mode)"
        
        if os.getenv('ENVIRONMENT') == 'production':
            # Import boto3 and json here for debugging
            import boto3
            import json
            
            # Get raw secret response for debugging
            try:
                region_name = "us-east-1"
                session = boto3.session.Session()
                client = session.client(
                    service_name='secretsmanager',
                    region_name=region_name
                )
                
                get_secret_value_response = client.get_secret_value(
                    SecretId="NotPointlessPostgresqlPassword"
                )
                raw_secret = get_secret_value_response['SecretString']
                
                # Show type and first 50 chars of raw secret
                secret_type_info = f"Type: {type(raw_secret).__name__}"
                raw_secret_preview = raw_secret[:50] + "..." if len(raw_secret) > 50 else raw_secret
                
                # Try json.loads and see what happens
                try:
                    parsed_with_json = json.loads(raw_secret)
                    json_loads_success = True
                    json_loads_type = type(parsed_with_json).__name__
                    json_loads_error = None
                except Exception as json_e:
                    parsed_with_json = None
                    json_loads_success = False
                    json_loads_type = "Failed"
                    json_loads_error = str(json_e)
                
                # Try treating raw_secret as already parsed (without json.loads)
                if isinstance(raw_secret, dict):
                    # Already a dict
                    direct_access_success = True
                    direct_access_type = "dict"
                    if 'password' in raw_secret:
                        db_password = raw_secret['password']
                        db_secret_preview = db_password[:5] if db_password else "Empty password"
                    else:
                        db_secret_preview = "No 'password' key found"
                elif isinstance(raw_secret, str):
                    # It's a string, might need parsing
                    direct_access_success = False
                    direct_access_type = "string"
                    if json_loads_success and parsed_with_json and 'password' in parsed_with_json:
                        db_password = parsed_with_json['password']
                        db_secret_preview = db_password[:5] if db_password else "Empty password"
                    else:
                        db_secret_preview = "Failed to parse or no password key"
                else:
                    direct_access_success = False
                    direct_access_type = type(raw_secret).__name__
                    db_secret_preview = "Unexpected secret type"
                
                raw_secret_info = f"Raw secret type: {secret_type_info}, Direct access: {direct_access_success} ({direct_access_type}), JSON loads: {json_loads_success} ({json_loads_type})"
                
            except Exception as aws_e:
                raw_secret_info = f"AWS Error: {str(aws_e)}"
                db_secret_preview = "AWS connection failed"
        else:   
            # In development, show first 5 chars of DB_PASSWORD env var
            db_password = os.getenv('DB_PASSWORD', '')
            db_secret_preview = db_password[:5] if db_password else "None"
        
        context = {
            'django_secret_preview': django_secret_preview,
            'db_secret_preview': db_secret_preview,
            'environment': os.getenv('ENVIRONMENT', 'development'),
            'raw_secret_info': raw_secret_info,
            'raw_secret_preview': raw_secret_preview,
            'json_loads_error': json_loads_error,
        }
        
        return render(request, 'not_pointless/debug_secrets.html', context)
    
    except Exception as e:
        return HttpResponse(f"Error accessing secrets: {str(e)}", status=500)
