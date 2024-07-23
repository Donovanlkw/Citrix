$pshost = get-host
$pswindow = $pshost.ui.rawui
$newsize = $pswindow.buffersize
$newsize.height = 3000
$newsize.width = 300
$pswindow.buffersize = $newsize
$newsize = $pswindow.windowsize
$newsize.height = 50
$newsize.width = 300
$pswindow.windowsize = $newsize

$Today=Get-Date -f "yyyyMMdd"

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
Get-Module Citrix.* -ListAvailable | Select-Object Name -Unique
Get-Command -Module Citrix.Broker.Commands


### --- PS Profile --- ###

$PROFILE | Select-Object *
notepad $PROFILE
Test-Path -Path $PROFILE.AllUsersAllHosts

if (!(Test-Path -Path <profile-name>)) {
  New-Item -ItemType File -Path <profile-name> -Force
}

Invoke-Command -Session $s -FilePath $PROFILE

### --- PS Profile --- ###

<#

https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_profiles?view=powershell-7.4
https://learn.microsoft.com/en-us/powershell/scripting/learn/ps101/05-formatting-aliases-providers-comparison?view=powershell-7.4
https://learn.microsoft.com/en-us/powershell/scripting/samples/creating-get-winevent-queries-with-filterhashtable?view=powershell-7.4



###--- https://learn.microsoft.com/en-us/powershell/scripting/learn/shell/using-aliases?view=powershell-7.4
 Get-Alias
  Get-PSProvider
 Get-PSDrive
 Get-ChildItem -Path Cert:\LocalMachine\CA

  Import-Module -Name ActiveDirectory
 
 ###--- retrieve the system information:
 
$CIMDesktop=Get-CimInstance -ClassName Win32_Desktop
$CIMQF=get-CimInstance -ClassName Win32_QuickFixEngineering
$CIMOS=Get-CimInstance -ClassName Win32_OperatingSystem 
$CIMComputer= Get-computerinfo

#>
