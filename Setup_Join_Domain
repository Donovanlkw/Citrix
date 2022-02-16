#----- Declare variables -----# 

$Domain = "lab.local" 

$OU = "OU=Computer,DC=lab,DC=local" 

$username = "$domain\Administrator"  

$password = "Password1" | ConvertTo-SecureString -asPlainText -Force 

 

 

#----- Join Domain ------# 

$credential = New-Object System.Management.Automation.PSCredential($username,$password) 

Add-LocalGroupMember -Group "Administrators" -Member $user 

Add-Computer -DomainName $domain -Credential $credential -Restart 

#Add-Computer -DomainName $domain -OUPath $OU -Credential $credential  
