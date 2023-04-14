# Import the required PowerShell module
Import-Module Microsoft.PowerShell.Management

# Define the input parameters for the script
param(
    [Parameter(Mandatory=$true, Position=0)]
    [ValidateSet('Start', 'Stop')]
    [string]$Action,

    [Parameter(Mandatory=$true)]
    [string[]]$ApprovedServices,

    [Parameter(Mandatory=$false)]
    [ValidateSet('Manual', 'Automatic', 'Disabled')]
    [string]$StartupType,

    [Parameter(Mandatory=$false)]
    [switch]$Force
)

# Get the name of the local machine
$machineName = $env:COMPUTERNAME

# Use the ForEach-Object method to process the services
$ApprovedServices | ForEach-Object {
    $service = $_
    # Get the status of the service
    $status = Get-Service -Name $service -ErrorAction SilentlyContinue

    if ($status) {
        if ($status.Status -eq "Running" -and ${Action} -eq "Start") {
            # If the service is already running and we're not forcing it, skip it
            if (!$Force) {
                Write-Host "$service is already running on $machineName" -ForegroundColor Yellow
                exit 3
            }
            # If the service is already running and we're forcing it, stop it first
            else {
                Write-Host "Stopping $service on $machineName to restart it..."
                Stop-Service -Name $service -ErrorAction Stop -Force
            }
        }
        elseif ($status.Status -eq "Stopped" -and ${Action} -eq "Stop") {
            # If the service is already stopped and we're not forcing it, skip it
            if (!$Force) {
                Write-Host "$service is already stopped on $machineName" -ForegroundColor Yellow
                exit 4
            }
            # If the service is already stopped and we're forcing it, start it first
            else {
                Write-Host "Starting $service on $machineName to stop it..."
                Start-Service -Name $service -ErrorAction Stop -Force
            }
        }
        else {
            # If we're forcing the service to start or stop, set the startup type first
            if ($Force -and $StartupType) {
                Set-Service -Name $service -StartupType $StartupType -ErrorAction Stop
            }

            # Start or stop the service
            Write-Host "${Action}-ing $service on $machineName..."
            try {
                if (${Action} -eq "Start") {
                    Start-Service -Name $service -ErrorAction Stop -Force
                }
                else {
                    Stop-Service -Name $service -ErrorAction Stop -Force
                }

                Write-Host "$service has been ${Action}-ed on $machineName"
                exit 0
            }
            catch {
                Write-Host "Error ${Action}-ing $service on $machineName: $_" -ForegroundColor Red
                exit 5
            }
        }
    }
    else {
        Write-Host "$service does not exist on $machineName" -ForegroundColor Red
        exit 2
    }
}
