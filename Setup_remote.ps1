#on Target computer 
Set-Service winrm -Status Running -StartupType Automatic 
Enable-PSRemoting –Force 

#on Source Computer 
Set-Service winrm -Status Running -StartupType Automatic 
Set-Item -Path WSMan:\localhost\Client\TrustedHosts -Value * 

Restart-Service WinRM 
Test-WsMan $ComputerName 

# Execute a Single Remote Command 

Invoke-Command -ComputerName COMPUTER -ScriptBlock { COMMAND } -credential USERNAME 

#Start a Remote Session 
Enter-PSsession  -Credential $username -ComputerName $ComputerName 


# https://devblogs.microsoft.com/scripting/remoting-week-non-domain-remoting/ 

# https://docs.microsoft.com/en-us/powershell/scripting/learn/remoting/running-remote-commands?view=powershell-7.1 

# https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/invoke-command?view=powershell-7.1 
