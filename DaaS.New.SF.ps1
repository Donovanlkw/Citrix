### Definition ###
Install-WindowsFeature -name  web-server

Invoke-WebRequest -Uri "https://go.microsoft.com/fwlink/?linkid=2088631" -OutFile "C:\dotnet48.exe"
Start-Process -FilePath "C:\dotnet48.exe" -ArgumentList "/quiet /norestart" -Wait
Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full" -Name Release
Restart-Computer -Force

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

### Configure site ###
Import-Module Citrix.StoreFront
Import-Module Citrix.StoreFront.Stores
Import-Module Citrix.StoreFront.Authentication
Import-Module Citrix.StoreFront.WebReceiver
  
$HostbaseUrl=""
$SiteId = 1,
$Farmtype = "XenDesktop",
#[ValidateSet("XenDesktop","XenApp","AppController","VDIinaBox")]
$FarmServers = 
$StoreVirtualPath = "/Citrix/Store",
$LoadbalanceServers = $false,
$Port = 80,
$SSLRelayPort = 443,
     #[ValidateSet("HTTP","HTTPS","SSL")]
$TransportType = "HTTP"



<#Param(
     [Parameter(Mandatory=$true)]
     [Uri]$HostbaseUrl,
     [long]$SiteId = 1,
     [ValidateSet("XenDesktop","XenApp","AppController","VDIinaBox")]
     [string]$Farmtype = "XenDesktop",
     [Parameter(Mandatory=$true)]
     [string[]]$FarmServers,
     [string]$StoreVirtualPath = "/Citrix/Store",
     [bool]$LoadbalanceServers = $false,
     [int]$Port = 80,
     [int]$SSLRelayPort = 443,
     [ValidateSet("HTTP","HTTPS","SSL")]
     [string]$TransportType = "HTTP"
)
#>


# Determine the Authentication and Receiver virtual path to use based of the Store
$authenticationVirtualPath = "$($StoreIISPath.TrimEnd('/'))Auth"
$receiverVirtualPath = "$($StoreVirtualPath.TrimEnd('/'))Web"

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

# Determine if the deployment already exists
$existingDeployment = Get-STFDeployment
if(-not $existingDeployment){
     # Install the required StoreFront components
     Add-STFDeployment -HostBaseUrl $HostbaseUrl -SiteId $SiteId -Confirm:$false
}
elseif($existingDeployment.HostbaseUrl -eq $HostbaseUrl){
    # The deployment exists but it is configured to the desired hostbase url
     Write-Output "A deployment has already been created with the specified hostbase url on this server and will be used."
 }
else{
     Write-Error "A deployment has already been created on this server with a different host base url."
 }
  
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# Determine if the authentication service at the specified virtual path exists
$authentication = Get-STFAuthenticationService -VirtualPath $authenticationVirtualPath
if(-not $authentication){
     \# Add an Authentication service using the IIS path of the Store appended with Auth
     $authentication = Add-STFAuthenticationService $authenticationVirtualPath
}
else{
     Write-Output "An Authentication service already exists at the specified virtual path and will be used."
}
  

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

\# Determine if the store service at the specified virtual path exists
 $store = Get-STFStoreService -VirtualPath $StoreVirtualPath
 if(-not $store)
 {
 \# Add a Store that uses the new Authentication service configured to publish resources from the supplied servers
 $store = Add-STFStoreService -VirtualPath $StoreVirtualPath -AuthenticationService $authentication -FarmName $Farmtype -FarmType $Farmtype -Servers $FarmServers -LoadBalance $LoadbalanceServers \`
         -Port $Port -SSLRelayPort $SSLRelayPort -TransportType $TransportType
 }
 else
 {
     Write-Output "A Store service already exists at the specified virtual path and will be used. Farm and servers will be appended to this store."
     \# Get the number of farms configured in the store
     $farmCount = (Get-STFStoreFarmConfiguration $store).Farms.Count
     \# Append the farm to the store with a unique name
     Add-STFStoreFarm -StoreService $store -FarmName "Controller$($farmCount + 1)" -FarmType $Farmtype -Servers $FarmServers -LoadBalance $LoadbalanceServers -Port $Port \`
         -SSLRelayPort $SSLRelayPort -TransportType $TransportType
 }

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
 # Determine if the receiver service at the specified virtual path exists
 $receiver = Get-STFWebReceiverService -VirtualPath $receiverVirtualPath
 if(-not $receiver)
 {
     \# Add a Receiver for Web site so users can access the applications and desktops in the published in the Store
     $receiver = Add-STFWebReceiverService -VirtualPath $receiverVirtualPath -StoreService $store
 }
 else
 {
     Write-Output "A Web Receiver service already exists at the specified virtual path and will be used."
 }
  

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

 # Determine if PNA is configured for the Store service
 $storePnaSettings = Get-STFStorePna -StoreService $store
 if(-not $storePnaSettings.PnaEnabled)
 {
 \# Enable XenApp services on the store and make it the default for this server
 Enable-STFStorePna -StoreService $store -AllowUserPasswordChange -DefaultPnaService
 }
  
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 




#https://docs.citrix.com/en-us/storefront/2203-ltsr/sdk-overview.html
#https://docs.citrix.com/en-us/storefront/current-release/install-standard/create-new-deployment.html
#https://docs.citrix.com/en-us/storefront/current-release/install-standard/create-new-deployment.html
https://support.citrix.com/article/CTX206009
https://developer-docs.citrix.com/projects/storefront-powershell-sdk/en/latest/Get-STFStoreService/
https://dennisspan.com/translating-the-citrix-storefront-console-to-powershell/
https://github.com/citrix/storefront-powershell-sdk-old/blob/master/docs/storefront-services-authentication-sdk.md
https://www.mycugc.org/blogs/chris-jeucken/2021/03/02/unattended-storefront-install-and-config
