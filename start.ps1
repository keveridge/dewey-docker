# PowerShell Script: start.ps1

param (
    [switch]$help,
    [string]$container
)

# Function to display help information
function Show-Help {
    Write-Host "Usage: .\start.ps1 [-help] [container]"
    Write-Host "Options:"
    Write-Host "  ALL                 Run all Docker Compose files"
    Write-Host "  <container>          Run the specified Docker Compose file"
    Write-Host "  -help                Display this help message"
    exit
}

# Display help if -help is provided
if ($help) {
    Show-Help
}

# Define directory where files are located
$directory = ".\"

# Get all docker-compose YAML files
$composeFiles = Get-ChildItem -Path $directory -Filter "docker-compose-*.yaml" | Sort-Object Name

# Display options to the user if no container name is provided
if (-not $container) {
    Write-Host "Select an option:"
    Write-Host "0: ALL"
    for ($i = 0; $i -lt $composeFiles.Count; $i++) {
        $fileName = $composeFiles[$i].Name
        $containerName = $fileName -replace '^docker-compose-', '' -replace '\.yaml$', ''
        Write-Host "$($i + 1): $containerName"
    }

    # Read user input
    $selection = Read-Host "Enter the number of your choice"

    # Handle invalid input
    if ($selection -lt 0 -or $selection -gt $composeFiles.Count) {
        Write-Host "Invalid selection."
        exit 1
    }

    # Get the selected file name
    if ($selection -eq 0) {
        $selectedFiles = $composeFiles
    } else {
        $selectedFiles = @($composeFiles[$selection - 1])
    }
} else {
    # Handle specific container request
    $selectedFiles = $composeFiles | Where-Object { $_.Name -like "docker-compose-$container.yaml" }

    if ($selectedFiles.Count -eq 0) {
        Write-Host "No Docker Compose file found for container '$container'."
        exit 1
    }
}

# Define function to run docker-compose
function Run-DockerCompose {
    param (
        [string]$fileName
    )

    # Determine .env file
    $envFile = $fileName -replace 'docker-compose-', '.env.' -replace '\.yaml$', ''

    if (Test-Path "$directory$envFile") {
        $envOption = "--env-file $directory$envFile"
    } else {
        $envOption = ""
    }

    # Construct and execute the docker-compose command
    $command = "docker-compose -f $directory$fileName $envOption up -d"
    Write-Host "Running command: $command"
    Invoke-Expression $command
}

# Run selected Docker Compose files
foreach ($file in $selectedFiles) {
    Run-DockerCompose -fileName $file.Name
}
