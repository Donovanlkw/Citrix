### Definition ###
Invoke-WebRequest -Uri "https://go.microsoft.com/fwlink/?linkid=2088631" -OutFile "C:\dotnet48.exe"

Install-WindowsFeature -name  web-server
Invoke-WebRequest -Uri "https://go.microsoft.com/fwlink/?linkid=2088631" -OutFile "C:\dotnet48.exe"

Start-Process -FilePath "C:\dotnet48.exe" -ArgumentList "/quiet /norestart" -Wait


Start-Process -FilePath "C:\dotnet48.exe" -ArgumentList "/quiet /norestart" -Wait

Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full" -Name Release
Restart-Computer -Force


#https://docs.citrix.com/en-us/storefront/2203-ltsr/sdk-overview.html
#https://docs.citrix.com/en-us/storefront/current-release/install-standard/create-new-deployment.html
### Configure site ###
# Add-STFDeployment -SiteID 1 -HostBaseURL "https://apps.example.com"


Import-Module Citrix.StoreFront
Import-Module Citrix.StoreFront.Stores
Import-Module Citrix.StoreFront.Authentication
Import-Module Citrix.StoreFront.WebReceiver
  

 Param(
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
     \# Import StoreFront modules. Required for versions of PowerShell earlier than 3.0 that do not support autoloading
     Import-Module Citrix.StoreFront
     Import-Module Citrix.StoreFront.Stores
     Import-Module Citrix.StoreFront.Authentication
     Import-Module Citrix.StoreFront.WebReceiver
  
















#https://docs.citrix.com/en-us/storefront/current-release/install-standard/create-new-deployment.html


https://support.citrix.com/article/CTX206009

https://developer-docs.citrix.com/projects/storefront-powershell-sdk/en/latest/Get-STFStoreService/

https://dennisspan.com/translating-the-citrix-storefront-console-to-powershell/

https://github.com/citrix/storefront-powershell-sdk-old/blob/master/docs/storefront-services-authentication-sdk.md

https://www.mycugc.org/blogs/chris-jeucken/2021/03/02/unattended-storefront-install-and-config
