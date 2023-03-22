#!/bin/bash

# Listar todas las instancias EC2 en una región
aws ec2 describe-instances --region <REGION>

# Listar todos los buckets de S3
aws s3 ls

# Listar todos los recursos de RDS
aws rds describe-db-instances

# Listar todos los recursos de Elastic Beanstalk
aws elasticbeanstalk describe-environments

# Listar todos los recursos de Lambda
aws lambda list-functions

# Crear un bucket de S3
aws s3api create-bucket --bucket <BUCKET_NAME> --region <REGION>

# Copiar un archivo al bucket de S3
aws s3 cp <FILE_PATH> s3://<BUCKET_NAME>/<OBJECT_KEY>

# Crear una instancia EC2
aws ec2 run-instances --image-id <AMI_ID> --count 1 --instance-type <INSTANCE_TYPE> --key-name <KEY_NAME>

# Detener una instancia EC2
aws ec2 stop-instances --instance-ids <INSTANCE_ID>

# Eliminar un bucket de S3
aws s3api delete-bucket --bucket <BUCKET_NAME>
