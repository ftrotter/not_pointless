#!/usr/bin/env python
"""
Test script to verify logging configuration.
Run this script to generate test log messages at different levels.
"""
import os
import sys
import logging
import argparse

def setup_logging(log_level='INFO'):
    """Configure logging with a basic configuration"""
    logging.basicConfig(
        level=getattr(logging, log_level.upper()),
        format='%(asctime)s [%(levelname)s] %(name)s - POINTLESS: %(message)s',
        handlers=[
            logging.StreamHandler(sys.stdout)
        ]
    )
    return logging.getLogger()

def generate_test_logs(logger, include_error=True):
    """Generate test log messages at different levels"""
    logger.debug("This is a DEBUG message")
    logger.info("This is an INFO message")
    logger.warning("This is a WARNING message")
    
    if include_error:
        logger.error("This is an ERROR message")
        try:
            # Generate an exception
            1/0
        except Exception as e:
            logger.exception("This is an EXCEPTION message with traceback")

def main():
    """Main function to run the test"""
    parser = argparse.ArgumentParser(description='Test logging configuration')
    parser.add_argument('--level', default='INFO', 
                        choices=['DEBUG', 'INFO', 'WARNING', 'ERROR', 'CRITICAL'],
                        help='Log level to use')
    parser.add_argument('--no-error', action='store_true',
                        help='Skip generating error logs')
    
    args = parser.parse_args()
    
    # Setup logging
    logger = setup_logging(args.level)
    
    # Print environment information
    logger.info("=== Logging Test Started ===")
    logger.info(f"Python version: {sys.version}")
    logger.info(f"Current directory: {os.getcwd()}")
    logger.info(f"Log level: {args.level}")
    
    # Generate test logs
    generate_test_logs(logger, not args.no_error)
    
    logger.info("=== Logging Test Completed ===")

if __name__ == "__main__":
    main()
