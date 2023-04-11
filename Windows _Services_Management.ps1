# Lista de servicios a verificar
$services = @("servicio1", "servicio2", "servicio3")

# Verificar el estado actual de los servicios y tomar la acción deseada
foreach ($service in $services) {
    $status = Get-Service -Name $service -ErrorAction SilentlyContinue
    if ($status.Status -eq "Running") {
        Write-Host "$service ya se encuentra en ejecución"
    }
    elseif ($status.Status -eq "Stopped") {
        Write-Host "Iniciando $service ..."
        Start-Service -Name $service
        Write-Host "$service se ha iniciado correctamente"
    }
    else {
        Write-Host "No se pudo verificar el estado de $service"
    }
}

# Verificar el estado actual de los servicios y tomar la acción deseada
foreach ($service in $services) {
    $status = Get-Service -Name $service -ErrorAction SilentlyContinue
    if ($status.Status -eq "Running") {
        Write-Host "Deteniendo $service ..."
        Stop-Service -Name $service
        Write-Host "$service se ha detenido correctamente"
    }
    elseif ($status.Status -eq "Stopped") {
        Write-Host "$service ya se encuentra detenido"
    }
    else {
        Write-Host "No se pudo verificar el estado de $service"
    }
}

===
# Iniciar los servicios que no estén en ejecución
foreach ($service in $services) {
    $status = Get-Service -Name $service -ErrorAction SilentlyContinue
    if ($status.Status -eq "Running") {
        Write-Host "$service ya se encuentra en ejecución"
    }
    elseif ($status.Status -eq "Stopped") {
        Write-Host "Iniciando $service ..."
        Start-Service -Name $service
        Write-Host "$service se ha iniciado correctamente"
    }
    else {
        Write-Host "No se pudo verificar el estado de $service"
    }
}

===

# List of services to check
$services = @("service1", "service2", "service3")

# Check current status of services and take desired action
foreach ($service in $services) {
    $status = Get-Service -Name $service -ErrorAction SilentlyContinue
    if ($status.Status -eq "Running") {
        Write-Host "Stopping $service ..."
        Stop-Service -Name $service
        Write-Host "$service has stopped successfully"
    }
    elseif ($status.Status -eq "Stopped") {
        Write-Host "$service is already stopped"
    }
    else {
        Write-Host "Could not verify status of $service"
    }
}

# Check current status of services and take desired action
foreach ($service in $services) {
    $status = Get-Service -Name $service -ErrorAction SilentlyContinue
    if ($status.Status -eq "Running") {
        Write-Host "$service is already running"
    }
    elseif ($status.Status -eq "Stopped") {
        Write-Host "Starting $service ..."
        Start-Service -Name $service
        Write-Host "$service has started successfully"
    }
    else {
        Write-Host "Could not verify status of $service"
    }
}


===

# Parámetro para indicar si se deben iniciar o detener los servicios
param(
    [Parameter(Mandatory=$true,Position=0)]
    [ValidateSet('Start','Stop')]
    [string]$Action,
    [Parameter(Mandatory=$true,Position=1)]
    [string]$FilePath
)

# Obtener la lista de servicios desde el archivo especificado
$services = Get-Content $FilePath

# List of services to check
$services = @("service1", "service2", "service3")

# Validar y tomar acción sobre cada servicio de la lista
foreach ($service in $services) {
    $status = Get-Service -Name $service -ErrorAction SilentlyContinue
    if ($status) {
        if ($status.Status -eq "Running" -and $Action -eq "Start") {
            Write-Host "$service ya se encuentra en ejecución"
        }
        elseif ($status.Status -eq "Stopped" -and $Action -eq "Stop") {
            Write-Host "$service ya se encuentra detenido"
        }
        else {
            Write-Host "$Action-ndo $service ..."
            if ($Action -eq "Start") {
                Start-Service -Name $service
            }
            else {
                Stop-Service -Name $service
            }
            Write-Host "$service se ha $Action correctamente"
        }
    }
    else {
        Write-Host "No se pudo verificar el estado de $service"
    }
}


======

param(
    [Parameter(Mandatory=$true, Position=0)]
    [ValidateSet('Start', 'Stop')]
    [string]$Action,

    [Parameter(Mandatory=$true, Position=1)]
    [ValidateScript({ Test-Path $_ -PathType Leaf -ErrorAction Ignore })]
    [string]$FilePath,

    [Parameter(Mandatory=$false, Position=2)]
    [string]$ComputerName = $env:COMPUTERNAME
)

# Obtener la lista de servicios desde el archivo especificado
$services = Get-Content -Path $FilePath

foreach ($service in $services) {
    $status = Get-Service -Name $service -ComputerName $ComputerName -ErrorAction SilentlyContinue

    if ($status) {
        if ($status.Status -eq "Running" -and $Action -eq [Microsoft.PowerShell.Commands.ServiceControllerStatus]::Running) {
            Write-Host "$service is already running on $ComputerName"
        }
        elseif ($status.Status -eq "Stopped" -and $Action -eq [Microsoft.PowerShell.Commands.ServiceControllerStatus]::Stopped) {
            Write-Host "$service is already stopped on $ComputerName"
        }
        else {
            Write-Host "$Action-ning $service on $ComputerName ..."

            try {
                if ($Action -eq [Microsoft.PowerShell.Commands.ServiceControllerStatus]::Running) {
                    Start-Service -Name $service -ComputerName $ComputerName -ErrorAction Stop
                }
                else {
                    Stop-Service -Name $service -ComputerName $ComputerName -ErrorAction Stop
                }

                Write-Host "$service has been $Action-ed on $ComputerName"
            }
            catch {
                Write-Host "Error $Action-ing $service on $ComputerName: $_" -ForegroundColor Red
            }
        }
    }
    else {
        Write-Host "Could not get status for $service on $ComputerName" -ForegroundColor Red
    }
}


====

[CmdletBinding()]
param(
    [Parameter(Mandatory=$true, Position=0)]
    [ValidateSet('Start', 'Stop')]
    [string]$Action,

    [Parameter(Mandatory=$true, Position=1)]
    [ValidateScript({ Test-Path $_ -PathType Leaf -ErrorAction Ignore })]
    [string]$FilePath,

    [Parameter(Mandatory=$false, Position=2)]
    [string]$ComputerName = $env:COMPUTERNAME,

    [Parameter(Mandatory=$false)]
    [ValidateSet('Manual', 'Automatic', 'Disabled')]
    [string]$StartupType
)

# If a startup type was specified, validate it
if ($StartupType) {
    if ($StartupType -ne 'Manual' -and $StartupType -ne 'Automatic' -and $StartupType -ne 'Disabled') {
        Write-Host "Invalid startup type specified: $StartupType" -ForegroundColor Red
        return
    }
}

# Obtener la lista de servicios desde el archivo especificado
$services = Get-Content -Path $FilePath

# Si no se especificó un archivo, usar el arreglo predeterminado
if (!$services) {
    $services = @('Service1', 'Service2', 'Service3')
}

foreach ($service in $services) {
    $status = Get-Service -Name $service -ComputerName $ComputerName -ErrorAction SilentlyContinue

    if ($status) {
        if ($status.Status -eq "Running" -and ${Action} -eq [Microsoft.PowerShell.Commands.ServiceControllerStatus]::Running) {
            Write-Host "$service is already running on $ComputerName"
        }
        elseif ($status.Status -eq "Stopped" -and ${Action} -eq [Microsoft.PowerShell.Commands.ServiceControllerStatus]::Stopped) {
            Write-Host "$service is already stopped on $ComputerName"
        }
        else {
            Write-Host "$Action-ning $service on $ComputerName ..."

            try {
                # Set the startup type if specified
                if ($StartupType) {
                    Set-Service -Name $service -StartupType $StartupType -ComputerName $ComputerName -ErrorAction Stop
                }

                # Start or stop the service
                if (${Action} -eq [Microsoft.PowerShell.Commands.ServiceControllerStatus]::Running) {
                    Start-Service -Name $service -ComputerName $ComputerName -ErrorAction Stop
                }
                else {
                    Stop-Service -Name $service -ComputerName $ComputerName -ErrorAction Stop
                }

                Write-Host "$service has been $Action-ed on $ComputerName"

            }
            catch {
                Write-Host "Error $Action-ing $service on $ComputerName : $_" -ForegroundColor Red
            }
        }
    }
    else {
        Write-Host "Could not get status for $service on $ComputerName" -ForegroundColor Red
    }
}


===

# Define the input parameters for the script
[CmdletBinding()]
param(
    [Parameter(Mandatory=$true, Position=0)]
    [ValidateSet('Start', 'Stop')]
    [string]$Action,

    [Parameter(Mandatory=$true, Position=1)]
    [ValidateScript({ Test-Path $_ -PathType Leaf -ErrorAction Ignore })]
    [string]$FilePath,

    [Parameter(Mandatory=$false)]
    [ValidateSet('Manual', 'Automatic', 'Disabled')]
    [string]$StartupType
)

# Get the name of the local machine
$machineName = $env:COMPUTERNAME

# If a startup type was specified, validate it
if ($StartupType) {
    if ($StartupType -ne 'Manual' -and $StartupType -ne 'Automatic' -and $StartupType -ne 'Disabled') {
        Write-Host "Invalid startup type specified: $StartupType" -ForegroundColor Red
        return
    }
}

# Get the list of services from the specified file
$services = Get-Content -Path $FilePath

# If no file was specified, use the default array of services
if (!$services) {
    $services = @('Service1', 'Service2', 'Service3')
}

foreach ($service in $services) {
    $status = Get-Service -Name $service -ErrorAction SilentlyContinue

    if ($status) {
        if ($status.Status -eq "Running" -and ${Action} -eq [Microsoft.PowerShell.Commands.ServiceControllerStatus]::Running) {
            Write-Host "$service is already running on $machineName"
        }
        elseif ($status.Status -eq "Stopped" -and ${Action} -eq [Microsoft.PowerShell.Commands.ServiceControllerStatus]::Stopped) {
            Write-Host "$service is already stopped on $machineName"
        }
        else {
            Write-Host "$Action-ning $service on $machineName..."

            try {
                # Set the startup type if specified
                if ($StartupType) {
                    Set-Service -Name $service -StartupType $StartupType -ErrorAction Stop
                }

                # Start or stop the service
                if (${Action} -eq [Microsoft.PowerShell.Commands.ServiceControllerStatus]::Running) {
                    Start-Service -Name $service -ErrorAction Stop
                }
                else {
                    Stop-Service -Name $service -ErrorAction Stop
                }

                Write-Host "$service has been $Action-ed on $machineName"

            }
            catch {
                Write-Host "Error $Action-ing $service on $machineName : $_" -ForegroundColor Red
            }
        }
    }
    else {
        Write-Host "Could not get status for $service on $machineName" -ForegroundColor Red
    }
}
