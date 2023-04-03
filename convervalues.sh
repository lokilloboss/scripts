#!/bin/bash

# Pide al usuario que ingrese el nombre del archivo de entrada
echo "Ingresa el nombre del archivo de entrada:"
read INPUT_FILE

# Pide al usuario que ingrese el nombre del archivo de salida
echo "Ingresa el nombre del archivo de salida:"
read OUTPUT_FILE

# Verifica si el archivo de entrada existe
if [ ! -f "$INPUT_FILE" ]; then
  echo "El archivo de entrada no existe."
  exit 1
fi

# Crea el archivo de salida o lo sobrescribe si ya existe
> "$OUTPUT_FILE"

# Lee el archivo de entrada línea por línea y escribe en el archivo de salida
while IFS= read -r LINE; do
  # Elimina los espacios en blanco al inicio y al final de la línea
  LINE=$(echo $LINE | xargs)

  # Verifica si la línea está vacía
  if [ -z "$LINE" ]; then
    continue
  fi

  # Encierra la línea entre comillas dobles y la escribe en el archivo de salida
  echo "\"$LINE\"" >> "$OUTPUT_FILE"
done < "$INPUT_FILE"

# Convierte las líneas en el archivo de salida en una sola línea separada por espacios
OUTPUT=$(cat "$OUTPUT_FILE" | tr '\n' ' ')

# Escribe el resultado en el archivo de salida
echo "$OUTPUT" > "$OUTPUT_FILE"

echo "¡Listo! El archivo de salida \"$OUTPUT_FILE\" fue creado exitosamente."
