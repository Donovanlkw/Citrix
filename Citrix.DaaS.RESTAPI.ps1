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






# https://developer-docs.citrix.com/en-us/monitor-service-odata-api/how-to-get-connectionfailurelogs
# https://developer-docs.citrix.com/en-us/monitor-service-odata-api/data-access-protocol
# https://developer-docs.citrix.com/en-us/citrix-cloud/accessing-monitor-service-data-citrix-cloud-external/accessing-monitor-service-data-citrix-cloud-external.html



#####   https://www.powershellgallery.com/packages/CTXCloudApi/0.0.9/Content/Public%5CGet-CTXAPI_MonitorData.ps1
