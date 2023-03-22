#!/bin/bash

# Listar todas las instancias EC2 en una región
aws ec2 describe-instances --region <REGION>

# Listar todos los buckets de S3
aws s3api list-buckets

# Listar todos los recursos de RDS
aws rds describe-db-instances

# Listar todos los recursos de Elastic Beanstalk
aws elasticbeanstalk describe-environments

# Listar todos los recursos de Lambda
aws lambda list-functions

