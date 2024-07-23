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
        $Result.remote
        if ($Result.TcpTestSucceeded -ne "true"){
            write-host $_.fqdn
            write-host "connection Failure"
            if ($result.remoteaddress.IPaddresstostring -ne $_.IP){
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

    $Today=Get-Date
    if ($($cert2.NotAfter) -lt $Today){
         write-host $cert2.NotAfter
         }
    }
}

######################################################################

