#!/bin/bash

# Verificar si se proporcionó un ID de instancia como argumento
if [ -z "$1" ]; then
  echo "Debe proporcionar el ID de instancia como argumento"
  exit 1
fi

# Obtener el ID de instancia del primer argumento
INSTANCE_ID="$1"

# Obtener el nombre de archivo de registro
LOG_FILE="${INSTANCE_ID}_log.txt"

# Obtener la dirección IP de la instancia
IP_ADDRESS=$(aws ec2 describe-instances \
  --instance-ids "$INSTANCE_ID" \
  --query "Reservations[0].Instances[0].PublicIpAddress" \
  --output text)

# Comprobar si se pudo obtener la dirección IP
if [ -z "$IP_ADDRESS" ]; then
  echo "No se pudo obtener la dirección IP de la instancia"
  exit 1
fi

# Conectarse a la instancia y obtener los logs
ssh -i /path/to/key.pem ec2-user@"$IP_ADDRESS" "sudo cat /var/log/messages" > "$LOG_FILE"

# Imprimir mensaje de éxito
echo "Se han obtenido los logs de la instancia en el archivo $LOG_FILE"
