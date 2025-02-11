### --- verify the DDC/FAS connections 
$CTXHostCCC
$CTXHostFAS

### --- Define CTXHostCCC, CTXHostFAS  
Variable CTXHost* |foreach-object{
#$name=$_.Name
#$name
$_.value  |ft
    $_.value|foreach-object{
        $result=test-netconnection $_.fqdn -port 80
        $Result.TcpTestSucceeded 
        if ($Result.TcpTestSucceeded -ne "true"){
            write-host $_.fqdn
            write-host "connection Failure"
         if ($Result.remote -ne $_.IP){
             write-host "resolved False"
         }
        }
    }
}

### --- Run SF requriement 
$computername|Foreach-object {
    Invoke-Command -Computer $_ -ScriptBlock {
        Install-WindowsFeature -name  web-server
        
        #Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP' -recurse |Get-ItemProperty -name Version,Release -EA 0 | Where { $_.PSChildName -match '^(?!S)\p{L}'} | Select PSChildName, Version, Release
        $release = Get-ItemPropertyValue -LiteralPath 'HKLM:SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full' -Name Release
        switch ($release) {
        { $_ -ge 533320 } { $version = '4.8.1 or later'; break }
        { $_ -ge 528040 } { $version = '4.8'; break }
        { $_ -ge 461808 } { $version = '4.7.2'; break }
        { $_ -ge 461308 } { $version = '4.7.1'; break }
        { $_ -ge 460798 } { $version = '4.7'; break }
        { $_ -ge 394802 } { $version = '4.6.2'; break }
        { $_ -ge 394254 } { $version = '4.6.1'; break }
        { $_ -ge 393295 } { $version = '4.6'; break }
        { $_ -ge 379893 } { $version = '4.5.2'; break }
        { $_ -ge 378675 } { $version = '4.5.1'; break }
        { $_ -ge 378389 } { $version = '4.5'; break }
        default { $version = $null; break }
        }

        if ($version) {
        Write-Host -Object ".NET Framework Version: $version"
        } else {
        Write-Host -Object '.NET Framework Version 4.5 or later is not detected.'
        Invoke-WebRequest -Uri "https://go.microsoft.com/fwlink/?linkid=2088631" -OutFile "$env:TMP\dotnet48.exe"
        Start-Process -FilePath "$env:TMP\dotnet48.exe" -ArgumentList "/quiet /norestart" -Wait
        #Restart-Computer -Force              
        }     
        # some technical issue of second Hop in poWershell REmoting.
        # https://learn.microsoft.com/en-us/powershell/scripting/security/remoting/ps-remoting-second-hop?view=powershell-5.1

        $path="\\tc4202\metaframe\Citrix Virtual Apps and Desktops LTSR 2203 CU1"
        copy  $path\*.* $env:TMP\
        Start-Process "$env:TMP\CitrixStoreFront-x64.exe" "-silent"
    }
}


### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- 
### --- collect existing SF information. and Export configuration
$STFDeployment=Get-STFDeployment
$STFDomainService=Get-STFDomainService
$STFFeatureState=Get-STFFeatureState
$STFFeatureStateNames=Get-STFFeatureStateNames
$STFHmacKey=Get-STFHmacKey
$STFInstalledFeatures=Get-STFInstalledFeatures
$STFPackage=Get-STFPackage
$STFPeerResolutionService=Get-STFPeerResolutionService
$STFServerGroup=Get-STFServerGroup
$STFServerGroupConfiguration=Get-STFServerGroupConfiguration
$STFServerGroupJoinState=Get-STFServerGroupJoinState
$STFServiceMonitor=Get-STFServiceMonitor
$STFVersion=Get-STFVersion


### --- Create a new site
Add-STFDeployment -SiteID 1 -HostBaseURL "https://apps.example.com"
Add-STFAuthenticationService

Enable-STFAuthenticationServiceProtocol -Name (Get-STFAuthenticationProtocolsAvailable) -AuthenticationService (Get-STFAuthenticationService)
 

### --- Create a new site






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
