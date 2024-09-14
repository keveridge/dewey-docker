# Load Common variables
. lib\common_vars.ps1
# Load the logging library
. lib\log_message.ps1
# Load the pushover library
. lib\pushover.ps1

# Define the source and target directories
$sourceDir = $rootFolder
$targetDir = "$($rootFolder)\data\docker\volumes\export"

# Get the files that match the pattern *.env.*
$filesToCopy = Get-ChildItem -Path $sourceDir -Filter "*.env.*"

# Copy each file to the target directory
try {
    foreach ($file in $filesToCopy) {
        $destination = Join-Path -Path $targetDir -ChildPath $file.Name
        Copy-Item -Path $file.FullName -Destination $destination
    }

    # Calculate total number of files and total file size
    $fileCount = (Get-ChildItem -Path $targetDir -Recurse | Measure-Object).Count
    $totalSize = (Get-ChildItem -Path $targetDir -Recurse | Measure-Object -Property Length -Sum).Sum

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
    Log-Message -Message "Docker Env backup successful. Files: $fileCount, $sizeMessage"
} catch {
    # Log failure
    $errorMessage = "Docker Env backup operation failed. Error: $_"
    Log-Message -Message $errorMessage

    # Send Pushover message
    Send-PushoverMessage -Message $errorMessage -Title "Docker Env Backup Operation Failed"
}