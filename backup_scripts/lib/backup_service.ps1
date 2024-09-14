function Backup-Service {
    param (
        [string]$ServiceName,
        [string]$DockerCommand,
        [string]$BackupFolder,
        [string]$LogFile
    )

    # Run Docker command
    Invoke-Expression $DockerCommand

    # Check if the Docker command was successful
    if ($LASTEXITCODE -eq 0) {
        # Calculate total number of files and total file size
        $fileCount = (Get-ChildItem -Path $BackupFolder -Recurse | Measure-Object).Count
        $totalSize = (Get-ChildItem -Path $BackupFolder -Recurse | Measure-Object -Property Length -Sum).Sum

        # Calculate size in MB
        $totalSizeMB = [math]::Round($totalSize / 1MB, 2)

        if ($totalSizeMB -eq 0) {
            # If size in MB is zero, calculate size in KB
            $totalSizeKB = [math]::Round($totalSize / 1KB, 2)
            $sizeMessage = "Total size: $totalSizeKB KB"
        } else {
            $sizeMessage = "Total size: $totalSizeMB MB"
        }

        # Log success
        $logMessage = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - $ServiceName backup successful. Files: $fileCount, $sizeMessage"
        Add-Content -Path $LogFile -Value $logMessage
    } else {
        # Log failure
        $logMessage = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - $ServiceName backup failed."
        Add-Content -Path $LogFile -Value $logMessage

        # Send Pushover message
        Send-PushoverMessage -Message "$ServiceName backup has failed. Please check the logs for details." -Title "$ServiceName Backup Failed"
    }
}
