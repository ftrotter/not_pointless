from django.shortcuts import render
from django.http import HttpResponse
from django.conf import settings
from .models import Endpoint
from .settings import secrets_manager, logger
import os
import time

def homepage(request):
    """
    Display a simple homepage that doesn't connect to the database
    """
    logger.info("Homepage view called")
    start_time = time.time()
    
    # Render the template
    logger.info("Rendering homepage template")
    response = render(request, 'not_pointless/homepage.html')
    
    # Log completion time
    elapsed_time = time.time() - start_time
    logger.info(f"Homepage rendered successfully in {elapsed_time:.3f} seconds")
    
    return response

def endpoint_print(request):
    """
    Display distinct URLs from the endpoint table (requires database connection)
    """
    is_debug_credentials = True
    logger.info("Endpoint print view called (requires database)")
    start_time = time.time()
    
    if is_debug_credentials:
        # Log database credentials that have already been loaded
        db_config = settings.DATABASES.get('default', {})
        logger.info(f"DEBUG DB CREDENTIALS: {db_config}")
    
    try:
        # Get distinct endpoint URLs from the database
        logger.info("Attempting to query database for endpoints")
        distinct_urls = Endpoint.objects.values_list('endpoint_url', flat=True).distinct().order_by('endpoint_url')
        
        logger.info(f"Successfully retrieved {distinct_urls.count()} distinct endpoints")
        context = {
            'urls': distinct_urls,
            'total_count': distinct_urls.count()
        }
        
        # Log completion time
        elapsed_time = time.time() - start_time
        logger.info(f"Endpoint list rendered successfully in {elapsed_time:.3f} seconds")
        
        return render(request, 'not_pointless/endpoint_list.html', context)
    
    except Exception as e:
        # If there's a database connection issue, show the error
        logger.error(f"Database connection error: {str(e)}")
        return HttpResponse(f"Database connection error: {str(e)}", status=500)

def debug_secrets(request):
    """
    Display raw debugging information about AWS secrets API responses
    """
    logger.info("Debug secrets view called")
    start_time = time.time()
    
    try:
        logger.info("Attempting to retrieve SECRET_KEY for debug display")
        # Define how many characters to show (0 means show all)
        chars_to_show = 0
        
        # Get Django secret key
        django_secret = secrets_manager.get_secret(
            secret_name='SECRET_KEY', 
            default_if_not_found='insecure-dev-key-change-me'
        )
        
        # If chars_to_show is 0, show the entire key, otherwise show the specified number of characters
        django_secret_preview = django_secret if chars_to_show == 0 else django_secret[:chars_to_show]
        django_secret_preview = django_secret_preview if django_secret else "Not found"
        logger.info("SECRET_KEY retrieved for debug display")
        
        # Initialize debug info
        db_secret_preview = "None"
        raw_secret_info = "N/A (development mode)"
        json_loads_error = None
        raw_secret_preview = "N/A (development mode)"
        aws_raw_response = "N/A (development mode)"
        boto3_session_info = "N/A (development mode)"
        credentials_info = "N/A (development mode)"
        
        if os.getenv('ENVIRONMENT') == 'production':
            logger.info("Running in production mode, attempting to access AWS resources")
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
                    # Check all possible credential sources
                    credential_sources = []
                    
                    # Environment variables
                    aws_access_key = os.getenv('AWS_ACCESS_KEY_ID')
                    aws_secret_key = os.getenv('AWS_SECRET_ACCESS_KEY')
                    aws_session_token = os.getenv('AWS_SESSION_TOKEN')
                    credential_sources.append(f"ENV AWS_ACCESS_KEY_ID: {'Present' if aws_access_key else 'Missing'}")
                    credential_sources.append(f"ENV AWS_SECRET_ACCESS_KEY: {'Present' if aws_secret_key else 'Missing'}")
                    credential_sources.append(f"ENV AWS_SESSION_TOKEN: {'Present' if aws_session_token else 'Missing'}")
                    
                    # AWS Profile
                    aws_profile = os.getenv('AWS_PROFILE')
                    credential_sources.append(f"ENV AWS_PROFILE: {aws_profile if aws_profile else 'Not set'}")
                    
                    # Default region
                    aws_region = os.getenv('AWS_DEFAULT_REGION')
                    credential_sources.append(f"ENV AWS_DEFAULT_REGION: {aws_region if aws_region else 'Not set'}")
                    
                    # Instance metadata (for EC2/ECS/Lambda)
                    try:
                        import requests
                        # Try to access instance metadata (this will timeout quickly if not on AWS)
                        metadata_response = requests.get('http://169.254.169.254/latest/meta-data/iam/security-credentials/', timeout=2)
                        if metadata_response.status_code == 200:
                            credential_sources.append("Instance Metadata: Available")
                        else:
                            credential_sources.append(f"Instance Metadata: HTTP {metadata_response.status_code}")
                    except:
                        credential_sources.append("Instance Metadata: Not accessible")
                    
                    credentials_info = f"No credentials found. Sources checked: {'; '.join(credential_sources)}"
                    
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
                
                # Define the secret name we're retrieving
                aws_secret_name = "NotPointlessPostgresqlPassword"
                
                # Get the full response object
                get_secret_value_response = client.get_secret_value(
                    SecretId=aws_secret_name
                )
                
                # Show the complete raw response structure
                response_keys = list(get_secret_value_response.keys())
                aws_raw_response = f"Response keys: {response_keys}"
                
                # Get the actual secret string
                raw_secret = get_secret_value_response['SecretString']
                raw_secret_preview = f"Secret Name: {aws_secret_name}, Type: {type(raw_secret).__name__}, Length: {len(raw_secret)}, Content: {repr(raw_secret)}"
                
                # Try to parse as JSON
                try:
                    parsed_secret = json.loads(raw_secret)
                    parsed_keys = list(parsed_secret.keys()) if isinstance(parsed_secret, dict) else "Not a dict"
                    raw_secret_info = f"JSON Parse Success. Type: {type(parsed_secret).__name__}, Keys: {parsed_keys}"
                    
                    if isinstance(parsed_secret, dict) and 'password' in parsed_secret:
                        # Example of using secret_sub_key parameter
                        db_password = secrets_manager.get_secret(
                            secret_name=aws_secret_name,
                            secret_sub_key='password',
                            default_if_not_found=''
                        )
                        # Use the same chars_to_show logic for consistency in production
                        password_preview = db_password if chars_to_show == 0 else db_password[:chars_to_show]
                        db_secret_preview = f"Found password, length: {len(db_password)}, value: {password_preview}"
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
            # In development, show DB_PASSWORD env var based on chars_to_show
            db_password = secrets_manager.get_secret(
                secret_name='DB_PASSWORD',
                default_if_not_found=''
            )
            # Use the same chars_to_show logic for consistency
            db_secret_preview = db_password if chars_to_show == 0 else db_password[:chars_to_show]
            db_secret_preview = db_secret_preview if db_password else "None"
        
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
            'aws_secret_name': aws_secret_name if os.getenv('ENVIRONMENT') == 'production' else 'N/A (development mode)',
        }
        
        # Log completion time
        elapsed_time = time.time() - start_time
        logger.info(f"Debug secrets page rendered successfully in {elapsed_time:.3f} seconds")
        
        return render(request, 'not_pointless/debug_secrets.html', context)
    
    except Exception as e:
        logger.error(f"Error accessing secrets: {str(e)}")
        return HttpResponse(f"Error accessing secrets: {str(e)}", status=500)
