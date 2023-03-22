import boto3
import datetime

# Configurar el cliente EC2
ec2 = boto3.client('ec2')

# ID de la instancia EC2 a encender y apagar
INSTANCE_ID = 'i-0123456789abcdef0'

def lambda_handler(event, context):
    # Obtener la hora actual
    now = datetime.datetime.now().time()
    
    # Verificar si es hora de encender la instancia EC2
    if now >= datetime.time(8, 0) and now < datetime.time(22, 0):
        # Verificar el estado actual de la instancia
        instance = ec2.describe_instances(InstanceIds=[INSTANCE_ID])
        state = instance['Reservations'][0]['Instances'][0]['State']['Name']
        
        # Si la instancia está detenida, encenderla
        if state == 'stopped':
            ec2.start_instances(InstanceIds=[INSTANCE_ID])
            print('Instancia EC2 encendida')
        else:
            print('La instancia EC2 ya está encendida')
            
    # Verificar si es hora de apagar la instancia EC2
    elif now >= datetime.time(22, 0) or now < datetime.time(8, 0):
        # Verificar el estado actual de la instancia
        instance = ec2.describe_instances(InstanceIds=[INSTANCE_ID])
        state = instance['Reservations'][0]['Instances'][0]['State']['Name']
        
        # Si la instancia está encendida, apagarla
        if state == 'running':
            ec2.stop_instances(InstanceIds=[INSTANCE_ID])
            print('Instancia EC2 apagada')
        else:
            print('La instancia EC2 ya está apagada')
