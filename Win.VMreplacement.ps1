### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### 
### --- update the new server OU and Description as the old one. 
$oriVM = "oldVM"
$newVM= "newVM"

### --- get the AD information
$oriDescription = (Get-ADComputer -Identity $oriVM -Properties *).Description
$oriOU = (Get-ADComputer -Identity $oriVM -Properties *).DistinguishedName
### --- host table
$oriHost = get-content \\$oriVM\c$\Windows\system32\drivers\etc\hosts | Select-String -NotMatch "^#|^$"


### --- applied to new VM
$computername |Foreach-object {
get-adcomputer $computername|  Move-ADObject -TargetPath $TargetOU 
Set-ADComputer -Identity $_ -Description $Description
Add-Content \\$_\c$\Windows\system32\drivers\etc\hosts  $oriHost
}








### --- localsec, localgpo
$oriSecpol=secedit /export /cfg $env:tmp\orisecpol.inf
$targetcpol=get-content (secedit /export /cfg $env:tmp\orisecpol.inf)

### --- the certification
(Get-childitem -path cert:\localmachine\My |sort NotBefore |select Subject )[-1]
Get-childitem -path cert:\localmachine\Root  |sort NotBefore 
Get-childitem -path cert:\localmachine\CA |sort NotBefore

$invokeCommand = @{
    ScriptBlock = {
        ### ---  get all the certification , excluded exiry cert.
        $today=Get-date
        Get-ChildItem -Path cert:\localmachine  -Recurse |select * | where-object {$_.NotAfter -gt $today}
    }
}


$oricert=Invoke-Command -Computer $oriVM @invokeCommand
$newcert=Invoke-Command -Computer $newVM @invokeCommand

### ---  compare the cert. find some cert are missing in new server, but excluded the host based cert. 
compare $oricert  -ReferenceObject $newcert  -Property Subject, PSParentPath, Thumbprint |sort |where-object {($_.SideIndicator -eq '=>') -AND ($_.Subject -NotMatch "$oriVM")}  |select PSParentPath, Thumbprint, subject


