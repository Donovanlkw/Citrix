# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
### --- https://docs.citrix.com/en-us/storefront/2203-ltsr/sdk-overview.html

# # # # # # # # # # # 
### --- Create a server Group
### at Primary server 
Start-STFServerGroupJoin -IsAuthorizingServer -Confirm:$false
Write-Host 'Use the Passcode to join to this server'
$Passcode = (Start-STFServerGroupJoin -IsAuthorizingServer -Confirm:$false).Passcode

### at secondary servers
#Clear-STFDeployment -Confirm $False
Start-STFServerGroupJoin -AuthorizerHostName serverA -Passcode $Passcode -Confirm:$false
get-stfservergroupjoinstate


### operation.
get-stfservergroupjoinstate
Publish-STFServerGroupConfiguration
