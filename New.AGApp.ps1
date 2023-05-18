$Name= "NI-EAS-GA-S-STG"
$DG="DG-"+ $Name
$MC="MC-"+ $Name
$AG="AG-"+ $Name
$AGuser = "Domain\ACL"
$Description = "General VDA"

### --- New Application Group ---###
New-BrokerApplicationGroup -name $AG -Description $Description
Add-BrokerApplicationGroup $AG -DesktopGroup $DG
Set-BrokerApplicationGroup $AG -UserFilterEnabled $true
Add-BrokerUser $AGuser -ApplicationGroup $AG

### --- New System  Application  ---###
$app="notepad","mstsc","explorer","cmd"
$app|foreach{
$commandline ="%SystemRoot%\"+$_+".exe"
$workingdirectory="%SystemDrive%\Windows"
New-BrokerApplication -ApplicationType HostedOnDesktop -Name $_ -CommandLineExecutable $commandline -ApplicationGroup $AG  -WorkingDirectory $workingdirectory
}

### --- New Office  Application  ---###
$app="WINWORD","EXCEL","POWERPNT","MSACCESS"

C:\Program Files (x86)\Microsoft Office\Office16\.EXE
$app|foreach{
$commandline ="C:\Program Files (x86)\Microsoft Office\Office16\"+$_+".exe"
$workingdirectory="C:\Program Files (x86)\Microsoft Office\Office16"
New-BrokerApplication -ApplicationType HostedOnDesktop -Name $_ -CommandLineExecutable $commandline -ApplicationGroup $AG  -WorkingDirectory $workingdirectory
}



### --- New   Application  ---###
$app="notepad","mstsc","explorer","cmd"
$app|foreach{
$commandline ="%SystemRoot%\"+$_+".exe"
$workingdirectory="%SystemDrive%\Windows"
New-BrokerApplication -ApplicationType HostedOnDesktop -Name $_ -CommandLineExecutable $commandline -ApplicationGroup $AG  -WorkingDirectory $workingdirectory
}


