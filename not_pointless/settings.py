"""
Django settings for not_pointless project.

Generated by 'django-admin startproject' using Django 5.2.1.

For more information on this file, see
https://docs.djangoproject.com/en/5.2/topics/settings/

For the full list of settings and their values, see
https://docs.djangoproject.com/en/5.2/ref/settings/
"""
import os
import json
import boto3
import dj_database_url
import logging
import sys
from pathlib import Path
from dotenv import load_dotenv

# Configure logging
LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'formatters': {
        'verbose': {
            'format': '%(asctime)s [%(levelname)s] %(name)s - POINTLESS: %(message)s'
        },
        'simple': {
            'format': '%(levelname)s POINTLESS: %(message)s'
        },
    },
    'handlers': {
        'console': {
            'class': 'logging.StreamHandler',
            'stream': sys.stdout,
            'formatter': 'verbose',
        },
    },
    'root': {
        'handlers': ['console'],
        'level': 'INFO',
    },
    'loggers': {
        'django': {
            'handlers': ['console'],
            'level': 'INFO',
            'propagate': True,
        },
        'not_pointless': {
            'handlers': ['console'],
            'level': 'INFO',
            'propagate': True,
        },
        'gunicorn': {
            'handlers': ['console'],
            'level': 'INFO',
            'propagate': True,
        },
    },
}

# Set up the root logger for backward compatibility
logger = logging.getLogger()
logger.info("Starting application initialization")

# Load .env file only in development
if os.getenv('ENVIRONMENT') != 'production':
    logger.info("Loading .env file (development mode)")
    load_dotenv()
else:
    logger.info("Running in production mode, skipping .env file")

class mySecrets:
    """
    Class to manage secrets retrieval with caching to avoid multiple API calls
    """
    def __init__(self):
        self.cache = {}
        self.region_name = "us-east-1"
        logger.info("Initializing secrets manager with region: %s", self.region_name)
    
    def get_secret(self, *, secret_name, default_if_not_found=None, secret_sub_key=None):
        """
        Generic secret retrieval function with three-step fallback:
        1. Try AWS Secrets Manager
        2. Try .env file / environment variable
        3. Return default_if_not_found
        
        Parameters:
        - secret_name (str): Name of the secret to retrieve (required)
        - default_if_not_found: Value to return if secret is not found (default=None)
        - secret_sub_key (str): If the secret is a dictionary, get this specific key (default=None)
        """
        logger.info("Attempting to get secret: %s (sub_key: %s)", secret_name, secret_sub_key)
        
        # Check if we already have this secret in cache
        if secret_name in self.cache:
            logger.info("Secret '%s' found in cache", secret_name)
            secret_value = self.cache[secret_name]
            # If we need a sub-key and the cached value is a dict, return the sub-key
            if secret_sub_key is not None and isinstance(secret_value, dict):
                logger.info("Returning cached sub_key '%s' from secret '%s'", secret_sub_key, secret_name)
                return secret_value.get(secret_sub_key, default_if_not_found)
            return secret_value
        
        # Step 1: Try AWS Secrets Manager
        logger.info("Secret '%s' not in cache, trying AWS Secrets Manager", secret_name)
        try:
            logger.info("Creating boto3 session")
            session = boto3.session.Session()
            logger.info("Creating secretsmanager client in region %s", self.region_name)
            client = session.client(
                service_name='secretsmanager',
                region_name=self.region_name
            )
            logger.info("Calling get_secret_value for SecretId: %s", secret_name)
            get_secret_value_response = client.get_secret_value(
                SecretId=secret_name
            )
            logger.info("Successfully retrieved secret from AWS Secrets Manager: %s", secret_name)
            secret = get_secret_value_response['SecretString']
            try:
                # Try to parse as JSON (for dictionary secrets)
                logger.info("Attempting to parse secret as JSON")
                parsed_secret = json.loads(secret)
                logger.info("Successfully parsed secret as JSON")
                # Cache the parsed secret
                self.cache[secret_name] = parsed_secret
                # If a sub-key was requested, return that specific value
                if secret_sub_key is not None:
                    logger.info("Returning sub_key '%s' from parsed JSON secret", secret_sub_key)
                    return parsed_secret.get(secret_sub_key, default_if_not_found)
                logger.info(f"For secret '{secret_name}', returning JSON value of '{parsed_secret}")
                return parsed_secret
            except json.JSONDecodeError:
                # If not valid JSON, it's a string secret
                logger.info("Secret is not valid JSON, treating as string")
                self.cache[secret_name] = secret
                logger.info(f"For secret '{secret_name}', returning JSON value of '{secret}")
                return secret
        except Exception as e:
            # AWS Secrets Manager failed, continue to step 2
            logger.warning("Failed to get secret from AWS Secrets Manager: %s - %s", secret_name, str(e))
            logger.info("Falling back to environment variables")
        
        # Step 2: Try environment variable / .env file
        env_value = os.getenv(secret_name)
        if env_value is not None:
            logger.info("Found secret '%s' in environment variables", secret_name)
            # Cache the environment value
            self.cache[secret_name] = env_value
            return env_value
        
        # Step 3: Return default value
        logger.info("Secret '%s' not found in AWS or environment, using default value", secret_name)
        return default_if_not_found

# Create a singleton instance of mySecrets
logger.info("Creating secrets_manager instance")
secrets_manager = mySecrets()

# Build paths inside the project like this: BASE_DIR / 'subdir'.
BASE_DIR = Path(__file__).resolve().parent.parent


# Quick-start development settings - unsuitable for production
# See https://docs.djangoproject.com/en/5.2/howto/deployment/checklist/

# SECURITY WARNING: keep the secret key used in production secret!
#SECRET_KEY = 'django-insecure-53q+)n(fti3@35hxb3dstzqpw94&x_tp899f-ig9%d$#ldktzk'
logger.info("Getting notpointless-django-secret")
SECRET_KEY = secrets_manager.get_secret(
    secret_name='notpointless-django-secret', 
    default_if_not_found='insecure-dev-key-change-me'
)
logger.info("notpointless-django-secret retrieved successfully")

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = os.getenv("DEBUG", "False") == "True"
DEBUG = "True"

# Production settings
ALLOWED_HOSTS = [
    'notpointless.ft1.us',
    '.amazonaws.com',
    ".awsapprunner.com",
    'localhost',
    '127.0.0.1',
    os.getenv("ALLOWED_HOST", "*")
]

# Application definition

INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'not_pointless.apps.NotPointlessConfig',
    'durc_is_crud',
]

MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'whitenoise.middleware.WhiteNoiseMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]

ROOT_URLCONF = 'not_pointless.urls'

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]

WSGI_APPLICATION = 'not_pointless.wsgi.application'


# Database
# https://docs.djangoproject.com/en/5.2/ref/settings/#databases

# Database configuration using lazy loading to avoid accessing AWS Secrets Manager during build
logger.info("Setting up lazy database configuration")

def get_database_config():
    """
    Lazy loading function for database configuration.
    This is only called when the database configuration is actually needed,
    not during module import or build time.
    """
    logger.info("Lazy loading database configuration")
    
    # Get database name and schema from secrets or environment variables
    db_name = secrets_manager.get_secret(
        secret_name="NotPointlessPostgresqlPassword", 
        secret_sub_key='dbname',
        default_if_not_found=os.getenv('DB_NAME', 'postgres')
    )
    
    # Get schema separately - this is not part of Django's database configuration
    # but we log it for reference
    db_schema = os.getenv('DB_SCHEMA', 'ndh')
    logger.info(f"Using database schema: {db_schema}")
    
    return {
        'default': {
            'ENGINE': 'django.db.backends.postgresql',
            'NAME': db_name,
            'USER': secrets_manager.get_secret(
                secret_name="NotPointlessPostgresqlPassword", 
                secret_sub_key='username',
                default_if_not_found=os.getenv('DB_USER', 'insecure_user')
            ),
            'PASSWORD': secrets_manager.get_secret(
                secret_name="NotPointlessPostgresqlPassword", 
                secret_sub_key='password',
                default_if_not_found=os.getenv('DB_PASSWORD', 'insecure_password')
            ),
            'HOST': secrets_manager.get_secret(
                secret_name="NotPointlessPostgresqlPassword", 
                secret_sub_key='host',
                default_if_not_found=os.getenv('DB_HOST', 'endpoing-rds.cybcmwkoc02f.us-east-1.rds.amazonaws.com')
            ),
            'PORT': secrets_manager.get_secret(
                secret_name="NotPointlessPostgresqlPassword", 
                secret_sub_key='port',
                default_if_not_found=os.getenv('DB_PORT', '5432')
            ),
            'OPTIONS': {
                # Set the default schema for PostgreSQL
                'options': f'-c search_path={db_schema},public'
            }
        }
    }

# For commands that don't need database access (like collectstatic),
# use a simple SQLite configuration during build time
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': os.path.join(BASE_DIR, 'db.sqlite3'),
    }
}

# Only configure real database for runtime operations, not during build
# For local development, always use the real database configuration if .env file exists
if (os.getenv('ENVIRONMENT') == 'production' and 'collectstatic' not in sys.argv) or \
   'test_db_connection' in sys.argv or \
   'runserver' in sys.argv or \
   os.path.exists(os.path.join(BASE_DIR, '.env')):
    logger.info("Runtime, test_db_connection, or local development detected, loading real database configuration")
    DATABASES = get_database_config()
    logger.info("Database configuration complete")
else:
    logger.info("Build or collectstatic detected, using SQLite configuration")



# Password validation
# https://docs.djangoproject.com/en/5.2/ref/settings/#auth-password-validators

AUTH_PASSWORD_VALIDATORS = [
    {
        'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator',
    },
]


# Internationalization
# https://docs.djangoproject.com/en/5.2/topics/i18n/

LANGUAGE_CODE = 'en-us'

TIME_ZONE = 'UTC'

USE_I18N = True

USE_TZ = True


# Static files (CSS, JavaScript, Images)
# https://docs.djangoproject.com/en/5.2/howto/static-files/

STATIC_URL = '/static/'
STATIC_ROOT = os.path.join(BASE_DIR, 'staticfiles')

# WhiteNoise configuration
STATICFILES_STORAGE = 'whitenoise.storage.CompressedManifestStaticFilesStorage'

# Default primary key field type
# https://docs.djangoproject.com/en/5.2/ref/settings/#default-auto-field

DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'
