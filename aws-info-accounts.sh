#!/bin/bash

# Obtiene la lista de cuentas en la organización
accounts=$(aws organizations list-accounts | jq -r '.Accounts[] | .Id')

# Itera sobre cada cuenta
for account in $accounts
do
  # Obtiene la región predeterminada de la cuenta
  region=$(aws ec2 describe-account-attributes --attribute-names defaultRegion --query 'AccountAttributes[0].AttributeValues[0]' --output text --profile $account)

  # Muestra el nombre de la cuenta y su región predeterminada
  echo "La región predeterminada de la cuenta $account es $region"
done
