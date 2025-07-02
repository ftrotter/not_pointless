"""
WSGI config for not_pointless project.

It exposes the WSGI callable as a module-level variable named ``application``.

For more information on this file, see
https://docs.djangoproject.com/en/5.2/howto/deployment/wsgi/
"""

import os
import sys
import logging

# Configure basic logging before loading Django
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s [%(levelname)s] %(name)s - POINTLESS: %(message)s',
    handlers=[
        logging.StreamHandler(sys.stdout)
    ]
)
logger = logging.getLogger()
logger.info("WSGI application initialization starting")

from django.core.wsgi import get_wsgi_application

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'not_pointless.settings')

logger.info("Loading Django WSGI application")
application = get_wsgi_application()
logger.info("Django WSGI application loaded successfully")
