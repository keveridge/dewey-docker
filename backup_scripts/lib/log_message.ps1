# Define variables
$rootFolder = "C:\Users\kevth\Documents\Repos\dewey-docker"
$logFile = "$rootFolder\logs\backup_log.txt"

# Function to log messages
function Log-Message {
    param (
        [string]$Message
    )
    Add-Content -Path $logFile -Value "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - $Message"
}