# lib/pushover.ps1

function Send-PushoverMessage {
    param (
        [string]$Message,
        [string]$Title = "Backup Notification"
    )

    $url = "https://api.pushover.net/1/messages.json"
    $body = @{
        token = "aktqu3jqadimnr75snt1rrv36ijz39"
        user = "q1BVydV4c579CRf6LcYNWtTsbPbDS9"
        message = $Message
        title = $Title
    }

    try {
        $response = Invoke-RestMethod -Uri $url -Method Post -Body $body
        if ($response.status -ne 1) {
            Write-Error "Pushover message failed: $($response.error)"
        }
    } catch {
        Write-Error "Error sending Pushover message: $_"
    }
}
