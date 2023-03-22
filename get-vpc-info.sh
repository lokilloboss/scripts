#!/bin/bash

# Comprobar que se haya especificado un ID de VPC como argumento
if [ $# -eq 0 ]; then
    echo "Por favor, especifique el ID de la VPC"
    exit 1
fi

# Obtener la información de la VPC
VPC_ID=$1
REGION=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone | sed 's/[a-z]$//')
VPC_INFO=$(aws ec2 describe-vpcs --vpc-ids $VPC_ID --region $REGION)

# Comprobar si la VPC especificada existe
if [ $(echo $VPC_INFO | jq -r '.Vpcs | length') -eq 0 ]; then
    echo "VPC no encontrada"
    exit 1
fi

# Imprimir la información de la VPC
echo "Información de la VPC:"
echo "ID: $(echo $VPC_INFO | jq -r '.Vpcs[].VpcId')"
echo "CIDR: $(echo $VPC_INFO | jq -r '.Vpcs[].CidrBlock')"
echo "Estado: $(echo $VPC_INFO | jq -r '.Vpcs[].State')"
echo "Región: $REGION"
echo ""

# Comprobar la conectividad a la VPC
echo "Comprobando conectividad a la VPC..."
if nc -z -v -w5 $(echo $VPC_INFO | jq -r '.Vpcs[].CidrBlock' | cut -d/ -f1) 22; then
    echo "Conexión a la VPC exitosa"
else
    echo "No se pudo establecer conexión a la VPC"
fi
