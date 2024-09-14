# PowerShell Script: terminal.ps1

param (
    [switch]$help,
    [string]$container,
    [string]$service
)

# Function to display help information
function Show-Help {
    Write-Host "Usage: .\terminal.ps1 [-help] <container> [service]"
    Write-Host "Options:"
    Write-Host "  <container>          Specify the Docker Compose file (without 'docker-compose-' prefix)"
    Write-Host "  [service]            Specify the service (container) to start an interactive session with"
    Write-Host "  -help                Display this help message"
    exit
}

# Display help if -help is provided
if ($help) {
    Show-Help
}

# Ensure the container parameter is provided
if (-not $container) {
    Write-Host "You must provide a container name."
    exit 1
}

# Define directory where files are located
$directory = ".\"

# Get the docker-compose YAML file matching the container
$composeFile = Get-ChildItem -Path $directory -Filter "docker-compose-$container.yaml" | Sort-Object Name | Select-Object -First 1

# Ensure the compose file exists
if (-not $composeFile) {
    Write-Host "No Docker Compose file found for container '$container'."
    exit 1
}

# Assign the compose file name to a variable
$fileName = $composeFile.Name

# If no service is provided, assume the container name is the same as the service name
if (-not $service) {
    $service = $container
}

# Define the corresponding .env file for the container
$envFile = ".env.$container"

# Ensure the .env file exists
if (-not (Test-Path "$directory$envFile")) {
    $command = "docker compose -f $directory$fileName exec $service /bin/bash"
} else {
    $command = "docker compose --env-file $directory$envFile -f $directory$fileName exec $service /bin/bash"
}

# Construct and execute the docker compose exec command with the .env file
Write-Host "Running command: $command"
Invoke-Expression $command
