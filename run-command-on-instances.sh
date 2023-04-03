#!/bin/bash

# Define the command to be executed on each instance
COMMAND="echo 'Hello, world!'"

# Define an array of instances
INSTANCES=("192.168.0.1" "192.168.0.2" "192.168.0.3")

# Define the file where the output of the execution will be saved
OUTPUT_FILE="output.txt"

# Loop through the array of instances and execute the command on each one
for INSTANCE in "${INSTANCES[@]}"
do
  # Check if the instance is available
  if ping -c 1 $INSTANCE &> /dev/null
  then
    # The instance is available, so execute the command
    echo "Executing command on instance $INSTANCE..."
    ssh user@$INSTANCE "$COMMAND" >> $OUTPUT_FILE
  else
    # The instance is not available, so display an error message
    echo "Error: instance $INSTANCE is not available."
  fi
done

echo "Done! The output of the execution was saved in the file $OUTPUT_FILE."
