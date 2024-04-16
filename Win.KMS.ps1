$computer = gc env:computername

$key = "W269N-WFGWX-YVC9B-4J6C9-T83GX"

$service = get-wmiObject -query "select * from SoftwareLicensingService" -computername $computer

$service.InstallProductKey($key)

$service.RefreshLicenseStatus()

