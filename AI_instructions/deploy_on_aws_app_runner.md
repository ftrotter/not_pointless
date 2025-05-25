Deploy on AWS App Runner
=========================

I would like to ensure that this project works when deployed against AWS App Runner.
This project should already be designed as a docker container, that is compatible with AWS App Runner.

AWS App Runner should be simple to deploy, and it will likely need for me to handle some manual steps.

Create a new file called AppRunnerSetup.md under the docs/ directory.

There detail how to login to AWS console, configure AWS App Runner as needed.
Be sure to detail how to use AWS Secrets Manager to deploy the root database password (that is currently in the .env file)
to the production instance of this app on AWS App Runner.

Eventually, this app will live on the domain name:

https://notpointless.ft1.us/

Please instruct as needed how to configure this. Assume that I understand how to point a domain name at a given IP address.

If the structure of the project needs to change, or more resources added to the project to facilitate deployment via push-from-github to AWS App Runner, lets make those changes now.

Note that there is an existing secret in AWS Secret Manager called 'NotPointlessPostgresqlPassword' that is already correctly hard-coded in settings.py

Please ensure that the code, and the contents of AppRunnerSetup.md make sense and are compatible.

