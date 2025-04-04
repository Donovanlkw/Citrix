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


### --- https://learn.microsoft.com/en-us/powershell/scripting/learn/ps101/03-discovering-objects?view=powershell-7.4
### --- Powershell 101

Get-ExecutionPolicy -List
Get-Service -Name w32time | Get-Member
Get-Service -Name w32time | Get-Member -MemberType Method
Get-Service -Name w32time | Select-Object -Property *
Get-Service |    Where-Object CanPauseAndContinue -EQ $true |    Select-Object -Property *

Get-Alias
Get-PSProvider
Get-PSDrive

### --- working with WMI
Get-Command -Noun WMI*
Get-Command -Module CimCmdlets







### --- https://learn.microsoft.com/en-us/powershell/scripting/learn/ps101/03-discovering-objects?view=powershell-7.4
### --- Powershell 101





# https://learn.microsoft.com/en-us/powershell/scripting/learn/shell/using-predictors?view=powershell-7.4
Install-Module -Name PSReadLine
Install-PSResource -Name PSReadLine

Set-PSReadLineOption -Colors @{ InlinePrediction = $PSStyle.Background.Blue }

Set-PSReadLineOption -Colors @{ InlinePrediction = "`e[38;5;238m" }




#https://learn.microsoft.com/en-us/powershell/scripting/learn/ps101/10-script-modules?view=powershell-7.4


New-Module -Name MyModule -ScriptBlock {

    function Return-MrOsVersion {
        Get-CimInstance -ClassName Win32_OperatingSystem |
        Select-Object -Property @{label='OperatingSystem';expression={$_.Caption}}
    }

    Export-ModuleMember -Function Return-MrOsVersion

} | Import-Module




