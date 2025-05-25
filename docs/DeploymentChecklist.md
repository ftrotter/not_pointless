# AWS App Runner Deployment Checklist

Use this checklist to ensure all steps are completed for a successful deployment.

## Pre-Deployment Checklist

### 1. Code Preparation
- [ ] All code changes committed and pushed to GitHub
- [ ] Dockerfile is present and properly configured
- [ ] apprunner.yaml configuration file is present
- [ ] requirements.txt includes all necessary dependencies
- [ ] Django settings are configured for production
- [ ] Health check endpoint is implemented and accessible

### 2. AWS Secrets Manager Setup
- [ ] Database credentials secret verified: `NotPointlessPostgresqlPassword` (already exists)
- [ ] Django secret key created: `notpointless-django-secret`
- [ ] IAM permissions configured for App Runner to access secrets
- [ ] Secret ARNs documented for reference

### 3. Domain and SSL
- [ ] SSL certificate requested in AWS Certificate Manager
- [ ] Certificate validated (DNS validation completed)
- [ ] Domain DNS management access confirmed

## Deployment Steps

### 1. Create App Runner Service
- [ ] AWS App Runner service created
- [ ] GitHub repository connected
- [ ] Build configuration set to use apprunner.yaml
- [ ] Environment variables configured:
  - [ ] ENVIRONMENT = production
  - [ ] DEBUG = False
  - [ ] ALLOWED_HOST = notpointless.ft1.us
  - [ ] AWS_DEFAULT_REGION = us-east-1
- [ ] IAM role attached with Secrets Manager permissions
- [ ] Auto-scaling configured (1-10 instances)
- [ ] Health check configured (/health/ endpoint)

### 2. Domain Configuration
- [ ] Custom domain linked in App Runner
- [ ] SSL certificate attached
- [ ] CNAME record added to DNS provider
- [ ] Domain propagation verified

### 3. Database Setup
- [ ] Database migrations run successfully
- [ ] Database connectivity verified through health check
- [ ] Admin user created (if needed)

## Post-Deployment Verification

### 1. Application Health
- [ ] App Runner service shows "Running" status
- [ ] Health check endpoint returns 200 status
- [ ] Application accessible at https://notpointless.ft1.us
- [ ] Database connectivity confirmed
- [ ] Static files loading correctly

### 2. Functionality Testing
- [ ] Homepage loads without errors
- [ ] Admin interface accessible (if applicable)
- [ ] All application features working as expected
- [ ] No errors in App Runner logs

### 3. Performance and Monitoring
- [ ] App Runner metrics reviewed
- [ ] CloudWatch logs configured (if needed)
- [ ] Performance baseline established
- [ ] Auto-scaling behavior verified

## Security Verification

### 1. Secrets Management
- [ ] No secrets in version control (apprunner.yaml, code, or documentation)
- [ ] No secrets in environment variables (using Secrets Manager instead)
- [ ] SECRET_KEY properly configured in AWS Secrets Manager for production
- [ ] IAM permissions follow least privilege principle
- [ ] Database credentials properly secured in AWS Secrets Manager

### 2. Network Security
- [ ] HTTPS enforced (no HTTP access)
- [ ] Proper ALLOWED_HOSTS configuration
- [ ] Security headers configured

### 3. Application Security
- [ ] DEBUG = False in production
- [ ] Django security middleware enabled
- [ ] Static files served securely

## Troubleshooting Common Issues

### Build Failures
- [ ] Check Dockerfile syntax and dependencies
- [ ] Verify requirements.txt completeness
- [ ] Review build logs in App Runner console

### Database Connection Issues
- [ ] Verify Secrets Manager configuration
- [ ] Check RDS security group settings
- [ ] Confirm IAM permissions for secrets access

### Domain/SSL Issues
- [ ] Verify DNS CNAME record
- [ ] Check SSL certificate status
- [ ] Confirm domain validation

### Application Errors
- [ ] Review App Runner application logs
- [ ] Check Django error logs
- [ ] Verify environment variable configuration

## Maintenance Tasks

### Regular Maintenance
- [ ] Monitor App Runner costs and usage
- [ ] Update dependencies regularly
- [ ] Rotate secrets periodically
- [ ] Review and update scaling settings

### Security Updates
- [ ] Keep Django and dependencies updated
- [ ] Monitor security advisories
- [ ] Regular security audits

## Emergency Procedures

### Rollback Process
- [ ] Document current deployment version
- [ ] Identify last known good deployment
- [ ] Process for quick rollback via GitHub
- [ ] Database backup and restore procedures

### Incident Response
- [ ] App Runner service restart procedure
- [ ] Log access and analysis process
- [ ] Escalation contacts and procedures
- [ ] Communication plan for outages

---

## Useful Commands for Local Testing

```bash
# Test with production settings locally
ENVIRONMENT=production DEBUG=False python manage.py runserver

# Check Django deployment readiness
python manage.py check --deploy

# Test database connection
python manage.py test_db_connection

# Collect static files
python manage.py collectstatic --noinput

# Run migrations
python manage.py migrate

# Test health endpoint
curl http://localhost:8000/health/
```

## Important URLs and Resources

- **Application URL**: https://notpointless.ft1.us
- **Health Check**: https://notpointless.ft1.us/health/
- **Admin Interface**: https://notpointless.ft1.us/admin/
- **AWS App Runner Console**: [Link to your service]
- **AWS Secrets Manager**: [Link to your secrets]
- **GitHub Repository**: [Link to your repo]

---

**Note**: Keep this checklist updated as your deployment process evolves. Document any custom procedures or configurations specific to your environment.
