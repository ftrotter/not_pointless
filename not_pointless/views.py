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
    Display raw debugging information about AWS secrets API responses
    """
    try:
        # Get Django secret key (first 10 characters)
        django_secret = get_django_secret_key()
        django_secret_preview = django_secret[:10] if django_secret else "Not found"
        
        # Initialize debug info
        db_secret_preview = "None"
        raw_secret_info = "N/A (development mode)"
        json_loads_error = None
        raw_secret_preview = "N/A (development mode)"
        aws_raw_response = "N/A (development mode)"
        boto3_session_info = "N/A (development mode)"
        credentials_info = "N/A (development mode)"
        
        if os.getenv('ENVIRONMENT') == 'production':
            # Import boto3 and json here for debugging
            import boto3
            import json
            
            # First, let's see what boto3 session gives us
            try:
                session = boto3.session.Session()
                credentials = session.get_credentials()
                
                if credentials:
                    credentials_info = f"Access Key ID: {credentials.access_key[:10]}..., Secret Key: {'*' * 20}, Token: {'Present' if credentials.token else 'None'}"
                else:
                    credentials_info = "No credentials found in session"
                    
                boto3_session_info = f"Region: {session.region_name}, Profile: {session.profile_name}"
                
            except Exception as session_e:
                boto3_session_info = f"Session Error: {str(session_e)}"
                credentials_info = f"Credentials Error: {str(session_e)}"
            
            # Now try to get the actual secret
            try:
                region_name = "us-east-1"
                session = boto3.session.Session()
                client = session.client(
                    service_name='secretsmanager',
                    region_name=region_name
                )
                
                # Get the full response object
                get_secret_value_response = client.get_secret_value(
                    SecretId="NotPointlessPostgresqlPassword"
                )
                
                # Show the complete raw response structure
                response_keys = list(get_secret_value_response.keys())
                aws_raw_response = f"Response keys: {response_keys}"
                
                # Get the actual secret string
                raw_secret = get_secret_value_response['SecretString']
                raw_secret_preview = f"Type: {type(raw_secret).__name__}, Length: {len(raw_secret)}, Content: {repr(raw_secret)}"
                
                # Try to parse as JSON
                try:
                    parsed_secret = json.loads(raw_secret)
                    parsed_keys = list(parsed_secret.keys()) if isinstance(parsed_secret, dict) else "Not a dict"
                    raw_secret_info = f"JSON Parse Success. Type: {type(parsed_secret).__name__}, Keys: {parsed_keys}"
                    
                    if isinstance(parsed_secret, dict) and 'password' in parsed_secret:
                        db_password = parsed_secret['password']
                        db_secret_preview = f"Found password, length: {len(db_password)}, first 5: {db_password[:5]}"
                    else:
                        db_secret_preview = "No password key found in parsed JSON"
                        
                except json.JSONDecodeError as json_e:
                    json_loads_error = f"JSON Decode Error: {str(json_e)}"
                    raw_secret_info = f"JSON Parse Failed: {str(json_e)}"
                    db_secret_preview = "Could not parse secret as JSON"
                
            except Exception as aws_e:
                aws_raw_response = f"AWS API Error: {type(aws_e).__name__}: {str(aws_e)}"
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
            'aws_raw_response': aws_raw_response,
            'boto3_session_info': boto3_session_info,
            'credentials_info': credentials_info,
        }
        
        return render(request, 'not_pointless/debug_secrets.html', context)
    
    except Exception as e:
        return HttpResponse(f"Error accessing secrets: {str(e)}", status=500)
