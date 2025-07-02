import boto3
import botocore
import json
import sys

# Update with your values or load from ENV
APP_RUNNER_SERVICE_NAME = 'notpointless-app'
SECRET_NAME = 'NotPointlessPostgresqlPassword'
RDS_INSTANCE_IDENTIFIER = 'dev-notpointless'
REGION = 'us-east-1f'

# Boto3 clients
apprunner = boto3.client('apprunner', region_name=REGION)
secretsmanager = boto3.client('secretsmanager', region_name=REGION)
rds = boto3.client('rds', region_name=REGION)
iam = boto3.client('iam')

def check_apprunner_service():
    print("🔍 Checking App Runner service...")
    services = apprunner.list_services()['ServiceSummaryList']
    match = [s for s in services if s['ServiceName'] == APP_RUNNER_SERVICE_NAME]
    if not match:
        print(f"❌ App Runner service '{APP_RUNNER_SERVICE_NAME}' not found.")
        return False
    service = apprunner.describe_service(ServiceArn=match[0]['ServiceArn'])['Service']
    print(f"✅ App Runner service found: status = {service['Status']}")
    instance_role = service.get('InstanceConfiguration', {}).get('InstanceRoleArn')
    print(f"   IAM Role attached: {instance_role or '❌ None'}")
    return True

def check_secret_exists():
    print("🔍 Checking Secrets Manager...")
    try:
        secret = secretsmanager.describe_secret(SecretId=SECRET_NAME)
        print(f"✅ Secret '{SECRET_NAME}' exists.")
        if 'Tags' in secret:
            print("   Tags:", secret['Tags'])
        return True
    except botocore.exceptions.ClientError as e:
        print(f"❌ Secret '{SECRET_NAME}' not found or access denied: {e}")
        return False

def check_rds_instance():
    print("🔍 Checking RDS instance...")
    try:
        db = rds.describe_db_instances(DBInstanceIdentifier=RDS_INSTANCE_IDENTIFIER)['DBInstances'][0]
        print(f"✅ RDS instance '{RDS_INSTANCE_IDENTIFIER}' found: status = {db['DBInstanceStatus']}")
        print(f"   Endpoint: {db['Endpoint']['Address']}:{db['Endpoint']['Port']}")
        print(f"   VPC: {db['DBSubnetGroup']['VpcId']}")
        return True
    except botocore.exceptions.ClientError as e:
        print(f"❌ RDS instance '{RDS_INSTANCE_IDENTIFIER}' not found: {e}")
        return False

def check_iam_role_permissions(role_arn):
    print("🔍 Checking IAM role permissions...")
    role_name = role_arn.split('/')[-1]
    try:
        attached = iam.list_attached_role_policies(RoleName=role_name)['AttachedPolicies']
        print(f"✅ IAM role '{role_name}' has {len(attached)} attached policies.")
        for policy in attached:
            print(f"   • {policy['PolicyName']} ({policy['PolicyArn']})")
        return True
    except Exception as e:
        print(f"❌ Could not verify IAM role permissions: {e}")
        return False

def main():
    print("🧪 Verifying Django App Runner + RDS Stack...\n")
    if check_apprunner_service():
        role_arn = apprunner.describe_service(ServiceArn=
            apprunner.list_services()['ServiceSummaryList'][0]['ServiceArn']
        )['Service']['InstanceConfiguration'].get('InstanceRoleArn')
        if role_arn:
            check_iam_role_permissions(role_arn)

    print()
    check_secret_exists()
    print()
    check_rds_instance()
    print("\n✅ Done.")

if __name__ == "__main__":
    main()
