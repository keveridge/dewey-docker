# backup_scripts/backup_paperless.ps1

# Load Common variables
. lib\common_vars.ps1
# Load Pushover library
. lib\pushover.ps1
# Load Backup-Service library, includes the $rootFolder and $logFile variables
. lib\backup_service.ps1

# Backup Paperless
$paperlessBackupFolder = "$rootFolder\data\paperless\webserver\volumes\export"
$paperlessEnvFile = Join-Path -Path $rootFolder -ChildPath ".env.paperless"
$paperlessComposeFile = Join-Path -Path $rootFolder -ChildPath "docker-compose-paperless.yaml"
$paperlessDockerCommand = "docker compose --env-file $paperlessEnvFile -f $paperlessComposeFile exec webserver document_exporter ../export"
Backup-Service -ServiceName "Paperless" -DockerCommand $paperlessDockerCommand -BackupFolder $paperlessBackupFolder -LogFile $logFile
