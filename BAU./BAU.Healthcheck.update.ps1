### --- check all Patch level ---###
$ComputerName = Get-Content 'Serverlistall.txt'
$AllResult = @()

$StartTime=(Get-date).AddDays(-30)

$ComputerName| Foreach-object {
$System = Get-CimInstance -ComputerName $_ -Class win32_operatingsystem
$Hotfix = Get-hotfix  -computername $_  |where-object {$_.installedOn -gt $starttime}
$CitrixService = Get-Service  -computername $_ -DisplayName Citrix* |where-object {$_.status -ne "Running"}

$parameters = @{
    ComputerName = $_
    ScriptBlock = {
    $Reg1=get-ItemProperty  -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Component Based Servicing" -Name RebootPending  -ErrorAction Ignore 
    $Reg2=get-ItemProperty  -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Component Based Servicing" -Name PackagesPending -ErrorAction Ignore
    $Reg3=get-ItemProperty  -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Component Based Servicing" -Name RebootInProgress -ErrorAction Ignore
    $Reg4=get-ItemProperty  -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" -Name RebootRequired -ErrorAction Ignore
    $Reg5=get-ItemProperty  -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" -Name PostRebootReporting -ErrorAction Ignore
    $Reg6=get-ItemProperty  -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Services " -Name Pending -ErrorAction Ignore
    }
}
Invoke-Command @parameters

$PendingReboot=0
if ($reg1 -or $reg2 -or $reg3 -or $Reg4 -or $Reg5 -or $Reg6){
$PendingReboot=1
}


$VMInfo = [pscustomobject]@{
Name = $System.csname
PendingReboot=$PendingReboot
ServiceNotRunning = $CitrixService.Count
Lastbootuptime =$System.lastbootuptime
hotfixID =$Hotfix.HotfixID
}
# $VMInfo |Format-Table -autosize
$AllResult += $VMInfo
}

$AllResult|Format-Table -autosize
