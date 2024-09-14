# backup_scripts/backup_paperless.ps1

# Load Common variables
. lib\common_vars.ps1
# Load Pushover library
. lib\pushover.ps1
# Load Backup-Service library, includes the $rootFolder and $logFile variables
. lib\backup_service.ps1

# Backup Paperless
$postgresBackupFolder = "$rootFolder\data\postgres\volumes\export"
$postgresEnvFile = Join-Path -Path $rootFolder -ChildPath ".env.postgres"
$postgresComposeFile = Join-Path -Path $rootFolder -ChildPath "docker-compose-postgres.yaml"
$postgresDockerCommand = "docker compose --env-file $postgresEnvFile -f $postgresComposeFile exec postgres pg_dumpall --file=/export/postgres_backup.sql"
Backup-Service -ServiceName "Postgres" -DockerCommand $postgresDockerCommand -BackupFolder $postgresBackupFolder -LogFile $logFile
