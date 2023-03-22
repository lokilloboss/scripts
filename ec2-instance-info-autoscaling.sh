#!/bin/bash

# Pedir la instancia ID como argumento de entrada
if [ $# -ne 1 ]; then
    echo "Por favor, proporcione una instancia ID como argumento"
    exit 1
fi

INSTANCE_ID=$1

# Definir la lista de cuentas y regiones a verificar
accounts=("account-1" "account-2" "account-3")
regions=("us-east-1" "us-west-2" "eu-west-1")

# Iterar sobre cada cuenta y región para verificar si la instancia pertenece a algún grupo de Auto Scaling
for account in "${accounts[@]}"; do
  for region in "${regions[@]}"; do
    echo "Verificando en la cuenta $account y la región $region..."
    export AWS_DEFAULT_REGION="$region"
    export AWS_PROFILE="$account"

    # Verificar si la instancia pertenece a un grupo de Auto Scaling
    asg=$(aws autoscaling describe-auto-scaling-instances --instance-ids $INSTANCE_ID --query 'AutoScalingInstances[0].AutoScalingGroupName' --output text)

    if [ -z "$asg" ]; then
        echo "La instancia no pertenece a ningún grupo de Auto Scaling"
    else
        echo "La instancia pertenece al grupo de Auto Scaling: $asg"
    fi
  done
done
