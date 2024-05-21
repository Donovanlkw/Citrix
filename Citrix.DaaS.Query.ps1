### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### 
### --- Collect Data --- ###
$XA=Get-brokermachine -Sessionsupport  MultiSession
$XD=Get-brokermachine -MaxRecordCount 99999 -Sessionsupport  SingleSession
$ICA=Get-BrokerSession -MaxRecordCount 99999 
$CC=Get-ConfigEdgeServer 
$DG=get-brokerdesktopgroup
$VDI=$ICA |where{ ($_.MachineSummaryState -eq "Inuse") -and ($_.Protocol -eq "HDX") -and ($_.OSType -eq "Windows 10") } 

### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### 
### --- Analysis Data --- ###
$XD |where {`
($_.RegistrationState -eq "Unregistered") -and `
($_.PowerState -eq "On") -and `
($_.IsAssigned -eq "True") -and `
($_.SessionState -notlike "Active") -and `
($_.Desktopgroupname -notlike "GTS VDI Staging") } `
|select RegistrationState,  PowerState, DNSname, DesktopGroupName, InMaintenanceMode,IsAssigned, LastDeregistrationReason, LastDeregistrationTime |ft

$XA |select LastDeregistrationReason, LastDeregistrationTime, dnsname, ostype, RegistrationState,DesktopGroupName,LoadIndex |sort LastDeregistrationTime | ft
$CC |select ZoneName, MachineAddress , LastStateChangeTimeInUtc, IsHealthy

### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### 
###--- check the Xenapp status ---###

$parameters = @{
  ComputerName = Get-Content "VM_DDC_XA.txt"
  ScriptBlock = {Get-Brokermachine -SessionSupport MultiSession -ProvisioningType MCS}
}

$result = Invoke-Command @parameters
$result |select CatalogName, DNSName, ImageOutOfDate, InMaintenanceMode, LoadIndex, SessionCount, RegistrationState |Sort-Object sessionCount, LoadIndex |Format-table -AutoSize 


### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### 
### --- Get the DG Name and number of VMs --- ###
$DG |where {`
($_.SessionSupport -eq "SingleSession") -and `
($_.Enabled -eq "True")
} `
|select Name,  DesktopsAvailable


### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### 
### --- list out all the VMs of Name and number of VMs --- ###
$DGName=$DG |where {`
($_.SessionSupport -eq "SingleSession") -and `
($_.Enabled -eq "True")
} |select Name

$DGName | Foreach-object {
$currentDG=$_.name
Write-output $currentDG
($XD |where {($_.IsAssigned -eq "True") -and ($_.Desktopgroupname -eq $currentDG) }).dnsname |out-file ./$CurrentDG.txt
}


### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### 
### --- Export all VDI mapping. 
$AllMapping=@()

$XD| Foreach-object {

    $computername=$_.DNSName
    $_.AssociatedUserUPNs | Foreach-object {
    $mapping = [PsCustomObject]@{
        Name = $computername
        UPN = $_
        }
    $AllMapping +=$mapping
    }
}
$AllMapping |out-file UsermappingAll.txt
