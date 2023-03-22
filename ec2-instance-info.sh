#!/bin/bash

# Este script toma 1 argumento: el ID de instancia
INSTANCE_ID=$1

# Verificar si se ha proporcionado la ID de instancia
if [ -z "$INSTANCE_ID" ]; then
  echo "Debe proporcionar la ID de instancia."
  exit 1
fi

# Obtener la región de la cuenta
REGION=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone | sed 's/.$//')

# Ejecutar el comando de AWS CLI para obtener información de la instancia EC2
aws ec2 describe-instances --instance-ids $INSTANCE_ID --region $REGION \
--query 'Reservations[*].Instances[*].{Instance:InstanceId,Name:Tags[?Key==`Name`]|[0].Value,PublicIpAddress:PublicIpAddress,PrivateIpAddress:PrivateIpAddress,Status:State.Name,VpcId:VpcId,SubnetId:SubnetId,SecurityGroups:SecurityGroups[].GroupName,SSM:join(`, `,NetworkInterfaces[].PrivateIpAddresses[].Association.SsmAssociationStatus)`}' \
--output table
