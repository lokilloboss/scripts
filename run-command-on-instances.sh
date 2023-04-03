#!/bin/bash

# Define el comando que se ejecutará en cada instancia
COMMAND="echo 'Hola, mundo!'"

# Define un arreglo con las instancias
INSTANCES=("192.168.0.1" "192.168.0.2" "192.168.0.3")

# Define el archivo donde se guardará la salida de la ejecución
OUTPUT_FILE="output.txt"

# Recorre el arreglo de instancias y ejecuta el comando en cada una de ellas
for INSTANCE in "${INSTANCES[@]}"
do
  # Verifica si la instancia está disponible
  if ping -c 1 $INSTANCE &> /dev/null
  then
    # La instancia está disponible, así que ejecuta el comando
    echo "Ejecutando comando en la instancia $INSTANCE..."
    ssh user@$INSTANCE "$COMMAND" >> $OUTPUT_FILE
  else
    # La instancia no está disponible, así que muestra un mensaje de error
    echo "Error: la instancia $INSTANCE no está disponible."
  fi
done

echo "¡Listo! La salida de la ejecución se guardó en el archivo $OUTPUT_FILE."
