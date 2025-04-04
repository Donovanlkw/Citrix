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
# API Credentials
$ClientId = "your-client-id"
$ClientSecret = "your-client-secret"
$CustomerId = "your-customer-id"
$api = "https://api-us.cloud.com/monitorodata"
$ResourceLocationId = ""

# Define the file path  
$jsonFilePath = "$env:tmp\cwcconnector_install_params.json"

# Define the JSON content  
$jsonContent = @"
{
    "customerName": "$ClientId",
    "clientId": "$CustomerId",
    "clientSecret": "$ClientSecret",
    "resourceLocationId": "$ResourceLocationId",
    "acceptTermsOfService": "true"
}
"@  
# Create the file and write content  
$jsonContent | Out-File -FilePath $jsonFilePath -Encoding utf8  

### --- Download and Installation--- ###  
Invoke-RestMethod -Uri "https://downloads.cloud.com/$CustomerId/connector/cwcconnector.exe" -Headers $headers -Method Get -OutFile  "$env:tmp\cwcconnector.exe"
#Invoke-WebRequest -Uri "https://downloads.cloud.com/$CustomerId/connector/cwcconnector.exe"  -OutFile  "$env:tmp\cwcconnector.exe"

$env:tmp/CWCConnector.exe /q /ParametersFilePath:$env:tmp\cwcconnector_install_params.json

# CWCConnector.exe /customerName:$CustomerId /clientId:$ClientId  /clientSecret:$ClientSecret /resourceLocationId:$ResourceLocationId /q
# https://gist.github.com/ravager-dk/9b7af54e3311fbac3583fcad8e6d300e
