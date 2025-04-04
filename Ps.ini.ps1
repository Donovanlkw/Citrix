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
