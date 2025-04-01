#############################
# API Credentials
$ClientId = "your-client-id"
$ClientSecret = "your-client-secret"
$CustomerId = "your-customer-id"
$api = "https://{ApiGatewayEndpoint}"
$endpoint = "$api/Applications"

$bearer = "CWSAuth bearer=[token]"
$headers = @{'Citrix-CustomerId'=$customerId;'Authorization'=$bearer}

$results = Invoke-RestMethod $endpoint -Headers $headers -Verbose
Write-Host “Number of items returned in the first call : ”, $results.value.Count

while($results.'@odata.nextLink' -ne $null)
{
    $results = Invoke-RestMethod $results.'@odata.nextLink' -Headers $headers -Verbose
    Write-Host "Number of items returned in next call : ", $results.value.Count
}



# Get Access Token
$body = @{
    client_id     = $ClientId
    client_secret = $ClientSecret
    grant_type    = "client_credentials"
}
$tokenResponse = Invoke-RestMethod -Uri "https://api-us.cloud.com/cctrustoauth2/root/tokens/clients" -Method Post -Body $body
$AccessToken = $tokenResponse.access_token

# Get Session Data
$headers = @{
    "Authorization" = "CWSAuth Bearer $AccessToken"
    "Citrix-CustomerId" = $CustomerId
}
$uri = "https://api-us.cloud.com/monitorodata/v4/Sessions"
$sessions = Invoke-RestMethod -Uri $uri -Headers $headers -Method Get
$token =  "CwsAuth Bearer=" + $AccessToken

$headers = @{
    "Authorization" = $token
    "Citrix-CustomerId" = $CustomerId
}
$uri = "https://api-us.cloud.com/monitorodata/Sessions"
$sessions = Invoke-RestMethod -Uri $uri -Headers $headers -Method Get
($sessions.value).count


#############################

# Process Data
$activeSessions = ($sessions.value | Where-Object { $_.SessionState -eq "Active" }).Count
$disconnectedSessions = ($sessions.value | Where-Object { $_.SessionState -eq "Disconnected" }).Count

# Output for Telegraf (InfluxDB Line Protocol)
Write-Output "citrix_sessions,session_state=active value=$activeSessions"
Write-Output "citrix_sessions,session_state=disconnected value=$disconnectedSessions"
#############################

# Get Historical Session Data (Last 7 Days)
$uri = "https://api-us.cloud.com/monitorodata/v4/Sessions?`$filter=StartDate ge $(Get-Date).AddDays(-7).ToString('yyyy-MM-dd')"
$sessions = Invoke-RestMethod -Uri $uri -Headers $headers -Method Get

# Process Data
foreach ($session in $sessions.value) {
    $username = $session.UserName
    $start_time = $session.StartDate
    $end_time = $session.EndDate
    $state = $session.SessionState
    Write-Output "citrix_session_history,user=$username state=$state start_time=$start_time end_time=$end_time"
}


#############################

$uri = "https://api-us.cloud.com/monitorodata/v4/Sessions"
$sessions = Invoke-RestMethod -Uri $uri -Headers $headers -Method Get
$sessions | Format-Table UserName, StartDate, EndDate, MachineName


$startDate = (Get-Date).AddDays(-30).ToString("yyyy-MM-ddTHH:mm:ssZ")
$endDate = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ssZ")

$uri = "https://api-us.cloud.com/monitorodata/v4/Sessions?`$filter=StartDate ge $startDate and EndDate le $endDate"

$sessions = Invoke-RestMethod -Uri $uri -Headers $headers -Method Get
$sessions | Format-Table UserName, StartDate, EndDate, MachineName


$sessions | Export-Csv -Path "C:\CitrixUserSessions.csv" -NoTypeInformation



6. Additional API Endpoints
Active Sessions: GET https://api-us.cloud.com/monitorodata/v4/Sessions?$filter=SessionState eq 'Active'

Disconnected Sessions: GET https://api-us.cloud.com/monitorodata/v4/Sessions?$filter=SessionState eq 'Disconnected'

User-Specific Sessions: GET https://api-us.cloud.com/monitorodata/v4/Sessions?$filter=UserName eq 'user@example.com'






