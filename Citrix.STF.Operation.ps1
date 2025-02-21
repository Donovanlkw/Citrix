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

Get-STFDeployment 
Get-STFDomainService
Get-STFFeatureState
Get-STFFeatureStateNames
Get-STFHmacKey
Get-STFInstalledFeatures
Get-STFPackage
Get-STFPeerResolutionService
Get-STFServerGroup
Get-STFServerGroupJoinState
Get-STFServiceMonitor
Get-STFVersion


$storeservice = Get-STFStoreService
Get-STFStoreFarm -StoreService $storeservice
Get-STFStoreEnumerationOptions -StoreService $storeservice
Get-STFStoreFarm -StoreService $storeservice
Get-STFStoreFarmConfiguration -StoreService $storeservice
Get-STFStoreGatewayService  -StoreService $storeservice
Get-STFStoreLaunchOptions -StoreService $storeservice
Get-STFStorePna -StoreService $storeservice
Get-STFStorePnaSmartAccess -StoreService $storeservice
Get-STFStoreRegisteredGateway -StoreService $storeservice
Get-STFStoreRegisteredOptimalLaunchGateway -StoreService $storeservice
Get-STFStoreService -StoreService $storeservice
Get-STFStoreSubscriptionsDatabase -StoreService $storeservice


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


### operation.
get-stfservergroupjoinstate
Publish-STFServerGroupConfiguration
#Clear-STFDeployment -Confirm $False


#https://docs.citrix.com/en-us/storefront/2203-ltsr/sdk-overview.html
#https://docs.citrix.com/en-us/storefront/current-release/install-standard/create-new-deployment.html
#https://docs.citrix.com/en-us/storefront/current-release/install-standard/create-new-deployment.html
https://support.citrix.com/article/CTX206009
https://developer-docs.citrix.com/projects/storefront-powershell-sdk/en/latest/Get-STFStoreService/
https://dennisspan.com/translating-the-citrix-storefront-console-to-powershell/
https://github.com/citrix/storefront-powershell-sdk-old/blob/master/docs/storefront-services-authentication-sdk.md
https://www.mycugc.org/blogs/chris-jeucken/2021/03/02/unattended-storefront-install-and-config
