$FQDN=
"www.yahoo.com.hk"

$IP=
"76.223.84.192"


$Result=$FQDN |ForEach-Object {
Test-NetConnection $_ -port 443 
}

$Result | Select ComputerName, tcptestsucceeded, RemoteAddress

Compare-object -ReferenceObject $IP -DifferenceObject $Result.RemoteAddress.IPAddressToString -IncludeEqual


