"""
Gunicorn configuration file for not_pointless project.
This file configures Gunicorn to properly log to stdout/stderr
which is then captured by AWS App Runner.
"""
import os
import sys
import logging
import multiprocessing

# Bind to 0.0.0.0:8000
bind = "0.0.0.0:8000"

# Number of worker processes
workers = multiprocessing.cpu_count() * 2 + 1

# Timeout in seconds
timeout = 120

# Access log - writes to stdout by default
accesslog = "-"

# Error log - writes to stderr by default
errorlog = "-"

# Log level
loglevel = os.getenv("LOG_LEVEL", "info").lower()

# Capture application stdout/stderr output and redirect to errorlog
capture_output = True

# Configure logging
logconfig_dict = {
    'version': 1,
    'disable_existing_loggers': False,
    'formatters': {
        'verbose': {
            'format': '%(asctime)s [%(process)d] [%(levelname)s] %(name)s - POINTLESS: %(message)s',
            'datefmt': '%Y-%m-%d %H:%M:%S',
        },
        'simple': {
            'format': '%(levelname)s POINTLESS: %(message)s',
        },
    },
    'handlers': {
        'console': {
            'class': 'logging.StreamHandler',
            'stream': sys.stdout,
            'formatter': 'verbose',
        },
        'error_console': {
            'class': 'logging.StreamHandler',
            'stream': sys.stderr,
            'formatter': 'verbose',
        },
    },
    'loggers': {
        'gunicorn.error': {
            'handlers': ['error_console'],
            'level': loglevel.upper(),
            'propagate': True,
        },
        'gunicorn.access': {
            'handlers': ['console'],
            'level': loglevel.upper(),
            'propagate': True,
        },
    },
    'root': {
        'handlers': ['console'],
        'level': loglevel.upper(),
    },
}

# Called just before the application is executed
def post_fork(server, worker):
    server.log.info("Worker spawned (pid: %s)", worker.pid)

# Called just after a worker has been exited
def worker_exit(server, worker):
    server.log.info("Worker exited (pid: %s)", worker.pid)

# Called just after a worker has been terminated
def worker_abort(worker):
    worker.log.info("Worker was terminated (pid: %s)", worker.pid)

# Called just after the master process is initialized
def on_starting(server):
    server.log.info("Gunicorn master starting")

# Called just after the server is started
def on_started(server):
    server.log.info("Gunicorn server started")

# Called just before the server is stopped
def on_exit(server):
    server.log.info("Gunicorn server stopped")
