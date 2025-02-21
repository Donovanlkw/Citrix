### --- Perform basic Certification installation.
$computername|Foreach-object {
    Invoke-Command -Computer $_ -ScriptBlock {
        
        ### --- Group policy update
        GPupdate /force

        ### --- set the encryption standard
        [Net.ServicePointManager]::Securityprotocol = [Net.ServicePointManager]::Securityprotocol::Ssl3 -bor  [Net.ServicePointManager]::Securityprotocol::Tls -bor   [Net.ServicePointManager]::Securityprotocol::Tls12

        ### --- Install certification.
        ### --- https://support.citrix.com/s/article/CTX549325-how-to-install-digicert-g4-root-and-intermediate-certificates-in-cloud-connector?language=en_US 
        Invoke-WebRequest -Uri "https://cacerts.digicert.com/DigiCertTrustedRootG4.crt" -OutFile "C:\Temp\DigiCertTrustedRootG4.crt"
        Invoke-WebRequest -Uri "https://cacerts.digicert.com/DigiCertTrustedG4CodeSigningRSA4096SHA3842021CA1.crt"  -OutFile  "C:\Temp\DigiCertTrustedG4CodeSigningRSA4096SHA3842021CA1.crt"

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
