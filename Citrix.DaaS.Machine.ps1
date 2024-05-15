

Get-BrokerDesktop -Filter { DesktopGroupName -eq 'Delivery Group Name'} | Select-Object -Property MachineName | Export-csv c:\MachineName.csv


$y=$Get-BrokerDesktop -Filter { sessionsupport -eq 'Multisession'} | Select-Object -Property MachineName


$MMServer=Get-BrokerDesktop -Filter {DeliveryType -eq "DesktopsAndApps"}
$MMServer |select DNSname,  OSType, Desktopgroupname



### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### 
### --- Export all VDI mapping.  --- ###
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

### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### 
