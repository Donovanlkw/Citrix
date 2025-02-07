##### Definition #####
Invoke-WebRequest -Uri "https://go.microsoft.com/fwlink/?linkid=2088631" -OutFile "C:\dotnet48.exe"

Install-WindowsFeature -name  web-server
Invoke-WebRequest -Uri "https://go.microsoft.com/fwlink/?linkid=2088631" -OutFile "C:\dotnet48.exe"

Start-Process -FilePath "C:\dotnet48.exe" -ArgumentList "/quiet /norestart" -Wait


Start-Process -FilePath "C:\dotnet48.exe" -ArgumentList "/quiet /norestart" -Wait

Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full" -Name Release
Restart-Computer -Force



https://support.citrix.com/article/CTX206009

https://developer-docs.citrix.com/projects/storefront-powershell-sdk/en/latest/Get-STFStoreService/

https://dennisspan.com/translating-the-citrix-storefront-console-to-powershell/

https://github.com/citrix/storefront-powershell-sdk-old/blob/master/docs/storefront-services-authentication-sdk.md

https://www.mycugc.org/blogs/chris-jeucken/2021/03/02/unattended-storefront-install-and-config
