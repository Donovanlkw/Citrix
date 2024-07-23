$pshost = get-host
$pswindow = $pshost.ui.rawui
$newsize = $pswindow.buffersize
$newsize.height = 3000
$newsize.width = 300
$pswindow.buffersize = $newsize
$newsize = $pswindow.windowsize
$newsize.height = 50
$newsize.width = 300
$pswindow.windowsize = $newsize

$Today=Get-Date -f "yyyyMMdd"

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
Get-Module Citrix.* -ListAvailable | Select-Object Name -Unique
Get-Command -Module Citrix.Broker.Commands


### --- PS Profile --- ###

$PROFILE | Select-Object *
notepad $PROFILE
Test-Path -Path $PROFILE.AllUsersAllHosts

if (!(Test-Path -Path <profile-name>)) {
  New-Item -ItemType File -Path <profile-name> -Force
}

Invoke-Command -Session $s -FilePath $PROFILE

### --- PS Profile --- ###

<#

https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_profiles?view=powershell-7.4
https://learn.microsoft.com/en-us/powershell/scripting/learn/ps101/05-formatting-aliases-providers-comparison?view=powershell-7.4
https://learn.microsoft.com/en-us/powershell/scripting/samples/creating-get-winevent-queries-with-filterhashtable?view=powershell-7.4



###--- https://learn.microsoft.com/en-us/powershell/scripting/learn/shell/using-aliases?view=powershell-7.4
 Get-Alias
  Get-PSProvider
 Get-PSDrive
 Get-ChildItem -Path Cert:\LocalMachine\CA

  Import-Module -Name ActiveDirectory
 
 ###--- retrieve the system information:
 
$CIMDesktop=Get-CimInstance -ClassName Win32_Desktop
$CIMQF=get-CimInstance -ClassName Win32_QuickFixEngineering
$CIMOS=Get-CimInstance -ClassName Win32_OperatingSystem 
$CIMComputer= Get-computerinfo

#>






### https://developer-docs.citrix.com/en-us/citrix-cloud/citrix-cloud-api-overview/citrix-cloud-api-walkthrough.html
###--- Citrix DaaS API ---###
$CLIENT_ID=' '
$CLIENT_SECRET=' '
$customerId = ''

$resourceLocUrl = "https://registry.citrixworkspacesapi.net/$customerId/resourcelocations"
$tokenUrl = 'https://api-us.cloud.com/cctrustoauth2/root/tokens/clients'

### OAuth 2.0 Authentication
$response = Invoke-WebRequest $tokenUrl -Method POST -Body @{
  grant_type = "client_credentials"
  client_id = $CLIENT_ID
  client_secret = $CLIENT_SECRET
}

$response
$token = $response.Content | ConvertFrom-Json
$token | Format-List

### --- ### --- ### --- ### --- ###
### Calling Citrix Cloud Services Platform
### CwsAuth Authentication
$headers = @{
  Authorization = "CwsAuth Bearer=$($token.access_token)"
}

$response = Invoke-WebRequest $resourceLocUrl -Headers $headers
$response | ConvertFrom-Json | ConvertTo-Json -Depth 10


### --- list of services and the customer’s entitlement to use each one.
$response = Invoke-WebRequest "https://core.citrixworkspacesapi.net/$customerId/serviceStates" -Headers $headers
$serviceStates = $response | ConvertFrom-Json
$serviceStates | ConvertTo-Json -Depth 10

 
