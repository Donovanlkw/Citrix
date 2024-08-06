################ Input  ################ 
function testing{
    param ( 
        [String] $vmName = "", 
        [String] $computerName = "" 
        #[Parameter(Mandatory=$false)]
    )
        
    Write-host $vmName
    Write-host $computerName
     
}





$CtxSFE|Foreach {
Get-WinEvent -ComputerName $_ -FilterHashTable @{LogName=$LogName;Id=$eventid;ProviderName=$ProviderName;level=$level;StartTime=$StartTime;EndTime=$EndTime}
}




catch { 

    if (!$servicePrincipalConnection) 
    { 
        $ErrorMessage = "Connection $connectionName not found." 
        throw $ErrorMessage 
    } else{ 
        Write-Error -Message $_.Exception 
        throw $_.Exception 
    } 
} 

 
