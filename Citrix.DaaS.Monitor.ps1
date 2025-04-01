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
### --- machine --- ###
$URL = "$api/Machines?null=null&$filter=FailureDate ne null and FailureDate ge 2024-07-30T00:00:00Z"
$URL = "$api/Machines?$filter=FailureDate ne null and FailureDate ge 2024-07-30T00:00:00Z&$select=Id&$expand=MachineFailures($filter=FailureStartDate ge 2024-07-30T00:00:00Z)"
$URL = "$api/Machines?$select=Name,IsInMaintenanceMode,CurrentRegistrationState,CurrentSessionCount,IsPreparing,FaultState&$expand=DesktopGroup($select=Id,Name),Sessions($select=SessionKey,ConnectionState;$filter=EndDate+eq+null)&$filter=Name+ne+null+and+DesktopGroup+ne+null"
$URL = "$api/Machines?$filter=LifecycleState eq 0 and Name ne null and DnsName ne '' and CatalogId ne null and MachineRole eq 0&$expand=CurrentLoadIndex,Catalog,Hypervisor"

### --- CPU and memory usage at hourly level --- ###
$URL = "$api/ResourceUtilizationSummary?$filter=Granularity eq 60 and SummaryDate eq 2024-07-30T08:00:00Z and UptimeInMinutes gt 0"

### --- CPU and memory usage at day  level --- ###
$URL = "$api/ResourceUtilizationSummary?$filter=Granularity eq 1440 and SummaryDate eq 2024-07-30T00:00:00Z and UptimeInMinutes gt 0"

### --- session --- ###
$URL = "$api/Sessions?$expand=ApplicationInstances&$filter=(ConnectionState eq 5) and (ModifiedDate gt 2024-08-06T07:00:00Z and ModifiedDate le 2024-08-06T07:10:00Z )"
$URL = "$api/Sessions?$select=StartDate,LogOnDuration,EndDate&$expand=Machine($select=DesktopGroupId),Connections($select=LogOnStartDate,LogOnEndDate,BrokeringDuration,VMStartStartDate,VMStartEndDate,HdxStartDate,HdxEndDate,AuthenticationDuration,GpoStartDate,GpoEndDate,LogOnScriptsStartDate,LogOnScriptsEndDate,ProfileLoadStartDate,ProfileLoadEndDate,InteractiveStartDate,InteractiveEndDate;$filter=IsReconnect+eq+false)&$filter=LogOnDuration+ne+null+and+StartDate+gt+cast(2024-07-31T02:56:57.996Z,+Edm.DateTimeOffset)&$orderby=StartDate+desc"
$URL = "$api/Sessions?$filter=EndDate eq null &$select=StartDate,ConnectionState,SessionIdleTime&$expand=SessionMetrics($select=IcaRttMS),Machine($expand=DesktopGroup($select=Name)),Machine($select=Name),User($select=UserName),CurrentConnection($select=ClientName,ClientVersion,ClientAddress,ConnectedViaIPAddress,BrokeringDuration)"
$URL = "$api/Sessions?$expand=Machine($expand=DesktopGroup)&$filter=(Machine/DesktopGroup/Id eq ad9e2d3d-44ac-49b0-a34b-7affb5ce3596) and (EndDate eq null)"
$URL = "$api/Sessions?$filter=ConnectionState ne 3 or FailureDate gt 2020-12-04T15:08:25.000Z"

### --- application --- ###
$URL = "$api/Applications?$filter=LifecycleState eq 0&$expand=DesktopGroups($select=Id)"
$URL = "$api/Applications?$apply=groupby((ApplicationType), aggregate(NAme with countdistinct as NumberofApplications))"
$URL = "$api/Applications?$filter=LifecycleState eq 0&$count=true"

### --- application instance --- ###
$URL = "$api/ApplicationInstances?$filter=EndDate eq null and Session/ConnectionState ne 3"
$URL = "$api/ApplicationInstances?$apply=filter(ApplicationId eq 6b07220e-b7d2-4f8d-9e43-49bd85222553 and EndDate eq null)&$expand=Session($expand=Machine,User)"

### --- connection --- ###
$URL = "$api/Connections?$filter=Session/FailureDate ge 2024-07-24T00:00:00.000Z and Session/FailureDate le 2024-07-25T00:00:00.000Z &$select=*,&$expand=Session($select=*;$expand=User($select=UPN,UserName),Failure($select=ConnectionFailureEnumValue,Category),Machine($select=DnsName,DesktopGroupId,IsInMaintenanceMode))"

### --- connection failure  --- ###
$URL = "$api/ConnectionFailureLogs?$filter=(FailureDate ge 2024-07-30T00:00:00Z and FailureDate le 2024-07-31T00:00:00Z)"
$URL = "$api/ConnectionFailureLogs?$filter=(FailureDate ge 2024-07-31T00:00:00Z)&$expand=Machine($select=Name,CurrentRegistrationState,IsInMaintenanceMode),User($select=Sid,Upn,UserName,Domain),Session"
$URL = "$api/ConnectionFailureLogs?$apply=filter(CreatedDate gt 2024-07-01T00:00:00.00Z )/groupby((ConnectionFailureEnumValue), aggregate(id with countdistinct as FailureCount))"

### --- user --- ###
$URL = "$api/Users?$filter=Domain eq 'CITRITE'"
$URL = "$api/Sessions?$filter=StartDate gt 2020-03-01 and LogonDuration gt 20000 &$expand=Machine($select=Name;$expand=DesktopGroup($select=Name)),User($select=FullName)&$select=StartDate,LogonDuration&orderby=LogOnDuration desc"


# https://developer-docs.citrix.com/en-us/monitor-service-odata-api/how-to-get-connectionfailurelogs
# https://developer-docs.citrix.com/en-us/monitor-service-odata-api/data-access-protocol
# https://developer-docs.citrix.com/en-us/citrix-cloud/accessing-monitor-service-data-citrix-cloud-external/accessing-monitor-service-data-citrix-cloud-external.html

