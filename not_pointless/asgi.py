"""
ASGI config for not_pointless project.

It exposes the ASGI callable as a module-level variable named ``application``.

For more information on this file, see
https://docs.djangoproject.com/en/5.2/howto/deployment/asgi/
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
logger.info("ASGI application initialization starting")

from django.core.asgi import get_asgi_application

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'not_pointless.settings')

logger.info("Loading Django ASGI application")
application = get_asgi_application()
logger.info("Django ASGI application loaded successfully")
