variable ctxHostExt* | Foreach-object {
$name=$_.Name
$name
$_.value  |ft
#|out-file $name"_"$today.txt
}


### ---  verified if tcp port accessibled form public internet? --- ###

Variable CTXHostExt* |foreach-object{
$name=$_.Name
$name
$_.value  |ft
    $_.value|foreach-object{
        $result=test-netconnection $_.fqdn -port 443
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


######################################################################


### ---  verified if tcp port accessibled form internet network --- ###

Variable CTXHostInt* |foreach-object{
$name=$_.Name
$name
$_.value  |ft
    $_.value|foreach-object{
        $result=test-netconnection $_.fqdn -port 443
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


### ---  verified if tcp port accessibled form internet network --- ###
$CTXHostIntAP="www.google.com"


Variable CTXHostIntAP |foreach-object{
$name=$_.Name
$name
$_.value  |ft
    $_.value|foreach-object{
      #  $result=test-netconnection $_.fqdn -port 443
      #  $Result.TcpTestSucceeded 
        if ($Result.TcpTestSucceeded -ne "true"){
            write-host $_.fqdn
            write-host "connection Failure"
            if ($Result.remote -ne $_.IP){
                write-host "resolved False"
            }
        }
    
    #Perform a web request to get the certificate
    $url = "https://"+$_.fqdn
    
    #Perform a web request to get the certificate
    $request = [System.Net.HttpWebRequest]::Create($url)
    $request.AllowAutoRedirect = $false
    $request.Method = "HEAD"
    $response = $request.GetResponse()

    #Get the SSL certificate
    $cert = $request.ServicePoint.Certificate
    $cert2 = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2 $cert
    <#$cert2
    #Display certificate details
    "Subject: $($cert2.Subject)"
    "Issuer: $($cert2.Issuer)"
    "Effective Date: $($cert2.NotBefore)"
    "Expiry Date: $($cert2.NotAfter)"
    "Thumbprint: $($cert2.Thumbprint)"
    #>
    $Today=Get-Date
    if ($($cert2.NotAfter) -lt $Today){
         write-host $cert2.NotAfter}
    
    }
}

