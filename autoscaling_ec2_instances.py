import boto3

# Configurar la sesión de AWS
session = boto3.Session()

# Crear cliente de AWS Organizations
org_client = session.client('organizations')

# Obtener lista de cuentas en la organización
accounts = org_client.list_accounts()

# Crear cliente de EC2
ec2_client = session.client('ec2')

# Recorrer las cuentas y buscar instancias EC2
for account in accounts['Accounts']:
    # Obtener ID de la cuenta
    account_id = account['Id']

    # Configurar la sesión para la cuenta actual
    current_session = boto3.Session(
        profile_name=f'account_{account_id}',
        region_name='us-east-1'
    )

    # Crear cliente de EC2 para la cuenta actual
    current_ec2_client = current_session.client('ec2')

    # Obtener las instancias EC2 de la cuenta actual
    instances = current_ec2_client.describe_instances()

    # Recorrer las instancias EC2 y verificar si pertenecen a un grupo de Auto Scaling
    for reservation in instances['Reservations']:
        for instance in reservation['Instances']:
            if 'AutoScalingGroupName' in instance:
                print(f'La instancia {instance["InstanceId"]} pertenece al grupo de Auto Scaling {instance["AutoScalingGroupName"]}')
