# backup_scripts/backup_paperless.ps1

# Load Common variables
. lib\common_vars.ps1
# Load Pushover library
. lib\pushover.ps1
# Load Backup-Service library, includes the $rootFolder and $logFile variables
. lib\backup_service.ps1

# Backup Pihole
$piholeBackupFolder = "$rootFolder\data\pihole\volumes\export"
$piholeEnvFile = Join-Path -Path $rootFolder -ChildPath ".env.pihole"
$piholeComposeFile = Join-Path -Path $rootFolder -ChildPath "docker-compose-pihole.yaml"
$piholeDockerCommand = "docker compose --env-file $piholeEnvFile -f $piholeComposeFile exec pihole pihole -a -t /export/pihole_backup.tar.gz"
Backup-Service -ServiceName "Pihole" -DockerCommand $piholeDockerCommand -BackupFolder $piholeBackupFolder -LogFile $logFile
