# Not Pointless

A Django web application for managing API endpoints.

## Database Connection Testing

To test if the database connection is working:

```bash
python manage.py test_db_connection
```

This command:

- Tests PostgreSQL connection
- Checks access to the `not_pointless.endpoint` table
- Shows record count and sample data
- Provides troubleshooting info if connection fails

## Checkpoint

- working without VPC and the database credentials are loading from the AWS secret system correctly

## Setting up the AWS environment

Will move to a terraform script shortly.

* First create the VPC, with two subnets.
* Create an internet gateway and attach it to the VPC
* Then create the RDS, which requires a VPC with two subnets
* Create a new Security Group and allow IP access from your IP to the RDS server
* You should have an Internet Gateway within your VPC configure a new route that goes to 0.0.0.0 that has the destination of the Internet Gateway for your VPC
* then add the app runner instance and make sure you choose all subnets when you setup the VPC connection
  