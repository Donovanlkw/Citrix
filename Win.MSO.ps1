:: rearm Microsoft Office 
%ProgramFiles%\Microsoft Office\%Office%\OSPPREARM.EXE								

:: Validate Office License	
cscript ospp.vbs  /dstatus

:: Validate Office Client Machine ID (CMID)	
cscript ospp.vbs  /dcmid								

:: Configur and point to KMS server
cscript ospp.vbs /sethst:waplic02.hk.intraxa								

:: activate Office License	
cscript ospp.vbs /act								

::	Command in KMS host for Office license checking	
cscript slmgr.vbs /dlv 2E28138A-847F-42BC-9752-61B03FFF33CD
