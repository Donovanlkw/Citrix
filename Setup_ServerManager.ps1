#----- Creat a deault template for ServerManager -----# 

Get-process ServerManager | stop-process -force 
del "$env:USERPROFILE\AppData\Roaming\Microsoft\Windows\ServerManager\ServerList.xml" 
start-process -filepath $env:SystemRoot\System32\ServerManager.exe -WindowStyle Maximized 
timeout 10 
Get-process ServerManager | % { $_.CloseMainWindow() } 

#----- list out all RDS Server and add to server manager via For loop -----# 
Import-Module ServerManager 
$RDServer = Get-rdserver |select-object server 
$RDServer |ForEach-Object { 
$file = get-item "$env:USERPROFILE\AppData\Roaming\Microsoft\Windows\ServerManager\ServerList.xml" 

copy-item -path $file -destination $file-backup -force 
$xml = [xml] (get-content $file ) 
$newserver = @($xml.ServerList.ServerInfo)[0].clone() 
$newserver.name = $_.server 

$newserver.lastUpdateTime = "0001-01-01T00:00:00" 
$newserver.status = "2" 
$xml.ServerList.AppendChild($newserver) 
$xml.Save($file.FullName) 
} 

start-process -filepath $env:SystemRoot\System32\ServerManager.exe -WindowStyle Maximized 

#----- Add server in Server Manager 
Get-process ServerManager | stop-process -force 
del "$env:USERPROFILE\AppData\Roaming\Microsoft\Windows\ServerManager\ServerList.xml" 
start-process -filepath $env:SystemRoot\System32\ServerManager.exe -WindowStyle Maximized 
timeout 10 

Get-process ServerManager | % { $_.CloseMainWindow() }  

Import-Module ServerManager 
$RDServer = Get-rdserver |select-object server 
$RDServer |ForEach-Object { 
$file = get-item "$env:USERPROFILE\AppData\Roaming\Microsoft\Windows\ServerManager\ServerList.xml" 
copy-item -path $file -destination $file-backup -force 
$xml = [xml] (get-content $file )
$newserver = @($xml.ServerList.ServerInfo)[0].clone() 
$newserver.name = $_.server 
$newserver.lastUpdateTime = "0001-01-01T00:00:00" 
$newserver.status = "2" 
$xml.ServerList.AppendChild($newserver) 
$xml.Save($file.FullName) 
} 

start-process -filepath $env:SystemRoot\System32\ServerManager.exe -WindowStyle Maximized
