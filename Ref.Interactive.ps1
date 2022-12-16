################ Input  ################ 
param ( 
    [Parameter(Mandatory=$false)] 
    [String] $vmName = "vwts19bk-easd00", 
    [Parameter(Mandatory=$false)] 
    [String] $VMSize = "Standard D2s v2" 
) 

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

 
