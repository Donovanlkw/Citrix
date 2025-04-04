## Run cloud connector test to ensure firewall rules and proxy bypass are in place
$computername|Foreach-object {
    Invoke-Command -Computer $_ -ScriptBlock {
        # Get-NetIPAddress -InterfaceAlias Ethernet* |select  IPaddress, ValidLifetime, AddressState
        # Get-LocalGroupMember administrators |select name

        $CCCCURL= "citrix.cloud.com",
        "ap-s.cloud.com",
        "us.cloud.com",
        "eu.cloud.com",
        "accounts.cloud.com/",
        "cloud.com",
        "wem.cloud.com",
        "www.microsoft.com",
        "www.google.com",
        "$customerID.sharefile.com",
        "dl.cacerts.digicert.com/DigiCertAssuredIDRootCA.crt",
        "dl.cacerts.digicert.com/DigiCertSHA2AssuredIDCodeSigningCA.crt"

        $CCCCURL |Foreach-object {
        $result=Invoke-WebRequest -Uri $_ 
        write-host $_
        write-host $result.StatusCode
        $result =""
        }
        $CCCCURL |Foreach-object {
        } 
    }
}

<#
$request = [System.Net.WebRequest]::Create("https://accounts.cloud.com")
$request.Proxy = [System.Net.WebProxy]::new() #blank proxy
$response = $request.GetResponse()
$response
#>


### --- Perform basic Certification installation.
$computername|Foreach-object {
    Invoke-Command -Computer $_ -ScriptBlock {
        
        ### --- Group policy update
        GPupdate /force

        ### --- set the encryption standard
        [Net.ServicePointManager]::Securityprotocol = [Net.ServicePointManager]::Securityprotocol::Ssl3 -bor  [Net.ServicePointManager]::Securityprotocol::Tls -bor   [Net.ServicePointManager]::Securityprotocol::Tls12

        ### --- Install certification.
        ### --- https://support.citrix.com/s/article/CTX549325-how-to-install-digicert-g4-root-and-intermediate-certificates-in-cloud-connector?language=en_US 
        Invoke-WebRequest -Uri "https://cacerts.digicert.com/DigiCertTrustedRootG4.crt" -OutFile "$env:tmp\DigiCertTrustedRootG4.crt"
        Invoke-WebRequest -Uri "https://cacerts.digicert.com/DigiCertTrustedG4CodeSigningRSA4096SHA3842021CA1.crt"  -OutFile  "$env:tmp\DigiCertTrustedG4CodeSigningRSA4096SHA3842021CA1.crt"     

        $paramsRoot = @{
            FilePath = 'C:\Temp\DigiCertTrustedRootG4.crt'
            CertStoreLocation = 'Cert:\LocalMachine\Root'
        }

        $paramsInterRoot = @{
            FilePath = 'C:\Temp\DigiCertTrustedG4CodeSigningRSA4096SHA3842021CA1.crt'
            CertStoreLocation = 'Cert:\LocalMachine\CA'
        }
        Import-Certificate @paramsRoot
        Import-Certificate @paramsInterRoot        
    }      
}

########################################
### --- Download and commandline --- ###  
Invoke-RestMethod -Uri "https://downloads.cloud.com/trowepriceas/connector/cwcconnector.exe" -Headers $headers -Method Get -OutFile  "$env:tmp\cwcconnector.exe"
#Invoke-WebRequest -Uri "https://downloads.cloud.com/$CustomerId/connector/cwcconnector.exe"  -OutFile  "$env:tmp\cwcconnector.exe"

# API Credentials
$ClientId = "your-client-id"
$ClientSecret = "your-client-secret"
$CustomerId = "your-customer-id"
$api = "https://api-us.cloud.com/monitorodata"
$ResourceLocationId = 

### create a Json file
$file = "$env:tmp\cwcconnector_install_params.json"
New-Item $file -force
Add-content $file '{'
Add-content $file '"customerName":"' -nonewline
Add-content $file "$CustomerID"  -nonewline
Add-content $file '",'
Add-content $file '"clientId":' -nonewline
Add-content $file "$ClientId" -nonewline
Add-content $file '",'
Add-content $file '"clientSecret":' -nonewline
Add-content $file "$clientSecret"  -nonewline
Add-content $file '",'
Add-content $file '"resourceLocationId":' -nonewline
Add-content $file "$ResourceLocationId"  -nonewline
Add-content $file '",'
Add-content $file '"acceptTermsOfService":' -nonewline
Add-content $file "true" -nonewline
Add-content $file '",'
Add-Content $file '}'
type $file

$env:tmp/CWCConnector.exe /q /ParametersFilePath:$env:tmp\cwcconnector_install_params.json



# https://gist.github.com/ravager-dk/9b7af54e3311fbac3583fcad8e6d300e
