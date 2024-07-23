### --- Sample Host Table --- ### 
$CTXHOSTEXTOGR=@()
$FQDN=
"Citrix.cloud.com",
"Citrix.cloud.com"
$IP=
"40.114.186.222",
"40.114.186.222"

$CTXHOSTEXTOGR= for($i= 0; $i -lt $FQDN.count; $i++){
[PSCustomObject]@{
  FQDN=$FQDN[$i]
  IP=$IP[$i]
  }
}

variable ctxHostExt* | Foreach-object {
$name=$_.Name
$name
$_.value  |ft
#|out-file $name"_"$today.txt
}

### ---  verified if tcp port accessibled form public internet? --- ###
$output=Variable CTXHostExtOGR |foreach-object{
$name=$_.Name
$name
$_.value  |ft
    $_.value|foreach-object{
        $Performance=Measure-Command { $result=test-netconnection $_.fqdn -port 443}
        Write-output $Result| select "TcpTestSucceeded" |fl
        Write-output $Performance | select "TotalSeconds" |fl
              
        if ($Result.TcpTestSucceeded -ne "true"){
            write-host $_.fqdn
            if ($result.remoteaddress.IPaddresstostring -ne $_.IP){
                write-host "resolved Different"
            }
        }
    #Perform a web request to get the certificate
    $url = "https://"+$_.fqdn
    
    #Perform a web request to get the certificate
    $request = [System.Net.HttpWebRequest]::Create($url)
    $request.AllowAutoRedirect = $false
    $request.Method = "HEAD"
 #   $response = $request.GetResponse()

    #Get the SSL certificate
    $cert = $request.ServicePoint.Certificate
    $cert2 = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2 $cert
    #Write-output  $cert2 |select "NotAfter" |fl
    $Today=Get-Date
    if ($($cert2.NotAfter) -lt $Today){
         $cert2 |select "NotAfter"
         }
    }
}

######################################################################
