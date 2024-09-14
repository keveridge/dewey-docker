# backup_scripts/backup_paperless.ps1

# Load Common variables
. lib\common_vars.ps1
# Load Pushover library
. lib\pushover.ps1
# Load Backup-Service library, includes the $rootFolder and $logFile variables
. lib\backup_service.ps1

# Load environment variables from .env file
$envFilePath = Join-Path -Path $rootFolder -ChildPath ".env.mongodb"
$envFileContent = Get-Content -Path $envFilePath

foreach ($line in $envFileContent) {
    if ($line -match "^\s*([^=]+)\s*=\s*(.+)\s*$") {
        [System.Environment]::SetEnvironmentVariable($matches[1], $matches[2])
    }
}

# Backup Paperless
$mongodbBackupFolder = "$rootFolder\data\mongodb\volumes\export"
$mongodbEnvFile = Join-Path -Path $rootFolder -ChildPath ".env.mongodb"
$mongodbComposeFile = Join-Path -Path $rootFolder -ChildPath "docker-compose-mongodb.yaml"
$mongodbDockerCommand = "docker compose --env-file $mongodbEnvFile -f $mongodbComposeFile exec mongodb mongodump --username $env:MONGO_INITDB_ROOT_USERNAME --password $env:MONGO_INITDB_ROOT_PASSWORD --authenticationDatabase $env:MONGO_AUTH_DB --out /export"
Backup-Service -ServiceName "MongoDB" -DockerCommand $mongodbDockerCommand -BackupFolder $mongodbBackupFolder -LogFile $logFile
