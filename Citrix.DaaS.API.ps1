$ClientId = "your-client-id"
$ClientSecret = "your-client-secret"

$body = @{
    client_id     = $ClientId
    client_secret = $ClientSecret
    grant_type    = "client_credentials"
}

$tokenResponse = Invoke-RestMethod -Uri "https://api-us.cloud.com/cctrustoauth2/root/tokens/clients" -Method Post -Body $body
$AccessToken = $tokenResponse.access_token
Write-Host "Access Token: $AccessToken"


$headers = @{
    "Authorization" = "CWSAuth Bearer $AccessToken"
    "Citrix-CustomerId" = "your-customer-id"
}

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





