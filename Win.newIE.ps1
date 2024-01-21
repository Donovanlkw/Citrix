
$edge = Start-Process -FilePath ($Env:WinDir + "\explorer.exe")  -ArgumentList "shell:Appsfolder\Microsoft.MicrosoftEdge_8wekyb3d8bbwe!MicrosoftEdge"
$edge.visible = $true
$edge.FullScreen = $true


start microsoft-edge:http://google.com
$wshell = New-Object -ComObject wscript.shell;
$wshell.AppActivate('Google - Microsoft Edge')
Sleep 2



#https://devblogs.microsoft.com/scripting/use-powershell-to-check-in-for-flight/
