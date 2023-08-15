[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Add-AzureRmAccount
Save-AzureRmContext -Path c:\logon.json –Force
