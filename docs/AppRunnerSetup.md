# AWS App Runner Deployment Guide for Not Pointless

This guide provides step-by-step instructions for deploying the Not Pointless Django application to AWS App Runner with GitHub integration, custom domain configuration, and AWS Secrets Manager for secure credential management.

## Prerequisites

- AWS Account with appropriate permissions
- GitHub repository with your Django application
- Domain name (notpointless.ft1.us) with DNS management access
- AWS CLI installed and configured (optional but recommended)

## Step 1: AWS Console Login and Initial Setup

1. **Login to AWS Console**
   - Navigate to [AWS Console](https://console.aws.amazon.com/)
   - Sign in with your AWS credentials
   - Ensure you're in the correct region (us-east-1 recommended for this setup)

2. **Verify Required Services**
   - Ensure you have access to:
     - AWS App Runner
     - AWS Secrets Manager
     - AWS Certificate Manager (for SSL)
     - Route 53 (if using AWS for DNS)

## Step 2: Set Up AWS Secrets Manager



### Create Application Secrets

1. **Verify Existing Database Secret**
   - The PostgreSQL password secret already exists: `NotPointlessPostgresqlPassword`
   - This secret contains the database credentials and is correctly configured in the application

2. **Create Django Secret Key**
   - Create secret named: `notpointless-django-secret`
   - Use plaintext format:
   ```json
   {
     "SECRET_KEY": "your-super-secure-django-secret-key-here-make-it-long-and-random"
   }
   ```
   - Generate a secure secret key using the provided script:
   ```bash
   python scripts/make_secret_key.py
   ```

## Step 3: Create AWS App Runner Service

### Initial Service Creation

1. **Navigate to AWS App Runner**
   - Go to AWS Console → Services → App Runner
   - Click "Create service"

2. **Configure Source**
   - **Source type**: Source code repository
   - **Repository type**: GitHub
   - Click "Add new" to connect your GitHub account
   - Authorize AWS App Runner to access your GitHub repositories
   - Select your repository: `your-username/not_pointless`
   - **Branch**: main
   - **Deployment trigger**: Automatic
   - Click "Next"

3. **Configure Build**
   - **Configuration file**: Use configuration file
   - App Runner will automatically detect the `apprunner.yaml` file
   - Click "Next"

4. **Configure Service**
   - **Service name**: `notpointless-app`
   - **Virtual CPU**: 1 vCPU (can be adjusted based on needs)
   - **Memory**: 2 GB (can be adjusted based on needs)
   
   **Note**: Environment variables are automatically configured via the `apprunner.yaml` file in your repository. No manual environment variable configuration is needed during service creation.

5. **Configure Auto Scaling**
   - **Auto scaling**: Enabled
   - **Minimum instances**: 1
   - **Maximum instances**: 10
   - **Concurrency**: 100 (requests per instance)

6. **Configure Health Check**
   - **Health check path**: `/` (or your health check endpoint)
   - **Health check interval**: 10 seconds
   - **Health check timeout**: 5 seconds
   - **Healthy threshold**: 3
   - **Unhealthy threshold**: 3

### Service Permissions

1. **Create IAM Role for App Runner**
   - Go to IAM → Roles → Create role
   - **Trusted entity**: AWS service
   - **Service**: App Runner
   - **Permissions**: Add the following policies:
     - `SecretsManagerReadWrite` (or create a custom policy with read access to your secrets)
     - `AmazonEC2ContainerRegistryReadOnly`

2. **Custom Policy for Secrets Manager** (Recommended)
   Create a custom policy with minimal permissions:
   ```json
   {
     "Version": "2012-10-17",
     "Statement": [
       {
         "Effect": "Allow",
         "Action": [
           "secretsmanager:GetSecretValue"
         ],
         "Resource": [
           "arn:aws:secretsmanager:us-east-1:YOUR-ACCOUNT-ID:secret:NotPointlessPostgresqlPassword-*",
           "arn:aws:secretsmanager:us-east-1:YOUR-ACCOUNT-ID:secret:notpointless-django-secret-*"
         ]
       }
     ]
   }
   ```

3. **Attach Role to App Runner Service**
   - In the App Runner service configuration
   - **Instance role**: Select the IAM role created above
   - Click "Next"

4. **Review and Create**
   - Review all configurations
   - Click "Create & deploy"

## Step 5: Configure Custom Domain

### SSL Certificate Setup

1. **Request SSL Certificate**
   - Go to AWS Certificate Manager
   - Click "Request a certificate"
   - **Certificate type**: Request a public certificate
   - **Domain name**: `notpointless.ft1.us`
   - **Validation method**: DNS validation (recommended)
   - Click "Request"

2. **Validate Certificate**
   - Follow the DNS validation instructions
   - Add the CNAME record to your DNS provider
   - Wait for validation (can take a few minutes to hours)

### Domain Configuration in App Runner

1. **Add Custom Domain**
   - Go to your App Runner service
   - Click on "Custom domains" tab
   - Click "Link domain"
   - **Domain name**: `notpointless.ft1.us`
   - **Certificate**: Select the certificate created above
   - Click "Link domain"

2. **Configure DNS**
   - App Runner will provide a CNAME target
   - Add a CNAME record in your DNS provider:
     ```
     Type: CNAME
     Name: notpointless
     Value: [App Runner provided CNAME target]
     TTL: 300 (or your preferred value)
     ```

## Step 6: Database Migration and Initial Setup

### Run Database Migrations

1. **Access App Runner Logs**
   - Go to your App Runner service
   - Click "Logs" tab to monitor deployment

2. **Manual Migration** (if needed)
   - If automatic migrations don't run, you may need to:
   - Use AWS Systems Manager Session Manager to access the container
   - Or create a management command to run migrations on startup

3. **Create Superuser** (if needed)
   - You may need to create a Django superuser
   - This can be done through a management command or Django shell

## Step 7: Testing and Verification

### Verify Deployment

1. **Check Service Status**
   - Ensure App Runner service shows "Running" status
   - Check logs for any errors

2. **Test Application**
   - Visit `https://notpointless.ft1.us`
   - Verify the application loads correctly
   - Test database connectivity
   - Check admin interface (if applicable)

3. **Monitor Performance**
   - Use App Runner metrics to monitor performance
   - Set up CloudWatch alarms if needed

## Step 8: Ongoing Maintenance

### Automatic Deployments

- App Runner will automatically deploy when you push to the main branch
- Monitor deployments in the App Runner console
- Check logs for any deployment issues

### Scaling

- App Runner will automatically scale based on traffic
- Monitor scaling metrics and adjust settings as needed

### Security Updates

- Regularly update dependencies in requirements.txt
- Keep Docker base image updated
- Rotate secrets periodically

## Troubleshooting

### Common Issues

1. **Build Failures**
   - Check Dockerfile syntax
   - Verify all dependencies in requirements.txt
   - Check build logs in App Runner console

2. **Database Connection Issues**
   - Verify Secrets Manager configuration
   - Check security group settings for RDS
   - Ensure IAM permissions are correct

3. **Domain Issues**
   - Verify DNS configuration
   - Check SSL certificate status
   - Ensure CNAME record is correct

4. **Static Files Issues**
   - Verify WhiteNoise configuration
   - Check STATIC_ROOT setting
   - Ensure collectstatic runs during build

### Useful Commands

```bash
# Test locally with production settings
ENVIRONMENT=production python manage.py runserver

# Collect static files
python manage.py collectstatic --noinput

# Test database connection
python manage.py test_db_connection

# Check Django configuration
python manage.py check --deploy
```

## Security Considerations

1. **Secrets Management**
   - Never commit secrets to version control
   - Use AWS Secrets Manager for all sensitive data
   - Rotate secrets regularly

2. **Network Security**
   - Use HTTPS only
   - Configure proper security groups
   - Consider using AWS WAF for additional protection

3. **Application Security**
   - Keep Django and dependencies updated
   - Use Django security middleware
   - Configure proper CORS settings if needed

## Cost Optimization

1. **Right-sizing**
   - Monitor resource usage and adjust instance size
   - Use auto-scaling effectively

2. **Monitoring**
   - Set up billing alerts
   - Monitor App Runner costs in AWS Cost Explorer

3. **Development vs Production**
   - Use smaller instances for development/staging
   - Consider using spot instances for non-critical workloads

## Support and Resources

- [AWS App Runner Documentation](https://docs.aws.amazon.com/apprunner/)
- [AWS Secrets Manager Documentation](https://docs.aws.amazon.com/secretsmanager/)
- [Django Deployment Checklist](https://docs.djangoproject.com/en/stable/howto/deployment/checklist/)

---

This guide provides a comprehensive setup for deploying your Django application to AWS App Runner. Follow each step carefully and refer to the troubleshooting section if you encounter any issues.
