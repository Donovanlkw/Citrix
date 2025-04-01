### --- Init.  --- ### 
# API Credentials
$ClientId = "your-client-id"
$ClientSecret = "your-client-secret"
$CustomerId = "your-customer-id"
$api = "https://api-us.cloud.com/monitorodata"

# Get Access Token
$body = @{
    client_id     = $ClientId
    client_secret = $ClientSecret
    grant_type    = "client_credentials"
}

$tokenResponse = Invoke-RestMethod -Uri "https://api-us.cloud.com/cctrustoauth2/root/tokens/clients" -Method Post -Body $body
$AccessToken = $tokenResponse.access_token
$token =  "CwsAuth Bearer=" + $AccessToken
$headers = @{
    "Authorization" = $token
    "Citrix-CustomerId" = $CustomerId
}

#############################
# $table= "Applications" 
# $table= "Sessions"
# $table= "Users"
# $table= "Machine"

$table= "ConnectionFailureLogs"
$filtering= "?$filter=(ModifiedDate ge 2025-04-01T00:00:00Z and ModifiedDate le  2025-04-02T00:00:00Z)"
$URL = "$api/$table$filtering"

$results = Invoke-RestMethod $URL -Headers $headers -Verbose
Write-Host “Number of items returned in the first call : ”, $results.value.Count

#############################

while($results.'@odata.nextLink' -ne $null)
{
    $results = Invoke-RestMethod $results.'@odata.nextLink' -Headers $headers -Verbose
    Write-Host "Number of items returned in next call : ", $results.value.Count
}
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

# https://developer-docs.citrix.com/en-us/monitor-service-odata-api/data-access-protocol
# https://developer-docs.citrix.com/en-us/citrix-cloud/accessing-monitor-service-data-citrix-cloud-external/accessing-monitor-service-data-citrix-cloud-external.html


