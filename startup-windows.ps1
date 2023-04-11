
#.\test.ps1 -Action Start -StartupType Manual -ServiceName "Spooler"
#Import-Module Microsoft.PowerShell.Management

# Define the input parameters for the script
#param(
#    [Parameter(Mandatory=$true, Position=0)]
#    [ValidateSet('Start', 'Stop')]
#    [string]$Action,
#
#    [Parameter(Mandatory=$false)]
#    [ValidateSet('Manual', 'Automatic', 'Disabled')]
#    [string]$StartupType
#)

$Action = "Start"
$StartupType = "Manual"

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
#$services = Get-Content -Path $FilePath

# If no file was specified, use the default array of services
##if (!$services) {
$services = @('EventLog')
##}

foreach ($service in $services) {
    $status = Get-Service -Name $service -ErrorAction SilentlyContinue

    if ($status) {
      if ($status.Status -eq "Running" -and ${Action} -eq "Running") {
#        if ($status.Status -eq "Running" -and ${Action} -eq [Microsoft.PowerShell.Commands.ServiceControllerStatus]::Running) {
            Write-Host "$service is already running on $machineName"
        }
        elseif ($status.Status -eq "Stopped" -and ${Action} -eq "Stopped") {
#        elseif ($status.Status -eq "Stopped" -and ${Action} -eq [Microsoft.PowerShell.Commands.ServiceControllerStatus]::Stopped) {
            Write-Host "$service is already stopped on $machineName"
        }
        else {
            Write-Host "${Action}-ing $service on $machineName..."

            try {
                # Set the startup type if specified
                if ($StartupType) {
                    Set-Service -Name $service -StartupType $StartupType -ErrorAction Stop
                }

                # Start or stop the service
                if (${Action} -eq "Running") {
#                if (${Action} -eq [Microsoft.PowerShell.Commands.ServiceControllerStatus]::Running) {
                    Start-Service -Name $service -ErrorAction Stop
                }
                else {
                    Stop-Service -Name $service -ErrorAction Stop
                }

                Write-Host "$service has been ${Action}-ed on $machineName"

            }
            catch {
                Write-Host "Error ${Action}-ing $service on $machineName : $_" -ForegroundColor Red
            }
        }
    }
    else {
        Write-Host "Could not get status for $service on $machineName" -ForegroundColor Red
    }
}
