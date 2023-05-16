### --- Citrix policy ---###
# https://developer-docs.citrix.com/projects/citrix-virtual-apps-desktops-sdk/en/latest/group-policy-sdk-usage/
# https://docs.citrix.com/en-us/citrix-virtual-apps-desktops/policies/policies-default-settings.html

Import-Module "C:\Citrix_Supportability_Pack\Tools\Scout\Current\Utilities\Citrix.GroupPolicy.Commands.psm1"
get-command -Module Citrix.GroupPolicy.Commands

New-PsDrive -PsProvider CitrixGroupPolicy -Name GP -Root \ -Controller localhost

###--- Disable all the default policy --- ###

cd GP:\Computer
Set-ItemProperty -Path .\Unfiltered -Name Enabled -Value $false
cd GP:\USer
Set-ItemProperty -Path .\Unfiltered -Name Enabled -Value $false

Set-ItemProperty -Path GP:\$PolicyType\$PolicyName -Name Enabled -Value $true
###--- Create Baseline for User policies --- ###
$Name = "Baseline"
$PolicyType = "User"
$PolicyName = $Name+"_"+$PolicyType

cd GP:\$PolicyType
New-Item $PolicyName
Set-ItemProperty -Path GP:\$PolicyType\$PolicyName -Name Enabled -Value $true

###--- Disable all Redirection setting --- ###
Set-ItemProperty -Path GP:\$PolicyType\$PolicyName\settings\ICA\ClipboardRedirection\ -Name State -Value Disabled
Set-ItemProperty -Path GP:\$PolicyType\$PolicyName\settings\ICA\DesktopLaunchForNonAdmins\ -Name State -Value Disabled
Set-ItemProperty -Path GP:\$PolicyType\$PolicyName\settings\ICA\NonPublishedProgramLaunching\ -Name State -Value Disabled
Set-ItemProperty -Path GP:\$PolicyType\$PolicyName\settings\ICA\ReadonlyClipboard\ -Name State -Value Disabled
Set-ItemProperty -Path GP:\$PolicyType\$PolicyName\settings\ICA\RestrictClientClipboardWrite\ -Name State -Value Disabled
Set-ItemProperty -Path GP:\$PolicyType\$PolicyName\settings\ICA\RestrictSessionClipboardWrite\ -Name State -Value Disabled

###--- Disable all FileRedirection setting --- ###
Set-ItemProperty -Path GP:\$PolicyType\$PolicyName\settings\ICA\FileRedirection\AllowFileDownload  -Name State -Value Prohibited
Set-ItemProperty -Path GP:\$PolicyType\$PolicyName\settings\ICA\FileRedirection\AllowFileTransfer  -Name State -Value Prohibited
Set-ItemProperty -Path GP:\$PolicyType\$PolicyName\settings\ICA\FileRedirection\AllowFileUpload  -Name State -Value Prohibited
Set-ItemProperty -Path GP:\$PolicyType\$PolicyName\settings\ICA\FileRedirection\AsynchronousWrites  -Name State -Value Disabled
Set-ItemProperty -Path GP:\$PolicyType\$PolicyName\settings\ICA\FileRedirection\AutoConnectDrives  -Name State -Value Disabled
Set-ItemProperty -Path GP:\$PolicyType\$PolicyName\settings\ICA\FileRedirection\ClientDriveLetterPreservation  -Name State -Value Prohibited
Set-ItemProperty -Path GP:\$PolicyType\$PolicyName\settings\ICA\FileRedirection\ClientDriveRedirection  -Name State -Value Prohibited
Set-ItemProperty -Path GP:\$PolicyType\$PolicyName\settings\ICA\FileRedirection\ClientFixedDrives  -Name State -Value Prohibited
Set-ItemProperty -Path GP:\$PolicyType\$PolicyName\settings\ICA\FileRedirection\ClientFloppyDrives  -Name State -Value Prohibited
Set-ItemProperty -Path GP:\$PolicyType\$PolicyName\settings\ICA\FileRedirection\ClientNetworkDrives  -Name State -Value Prohibited
Set-ItemProperty -Path GP:\$PolicyType\$PolicyName\settings\ICA\FileRedirection\ClientOpticalDrives  -Name State -Value Prohibited
Set-ItemProperty -Path GP:\$PolicyType\$PolicyName\settings\ICA\FileRedirection\ClientRemoveableDrives  -Name State -Value Prohibited
Set-ItemProperty -Path GP:\$PolicyType\$PolicyName\settings\ICA\FileRedirection\HostToClientRedirection  -Name State -Value Disabled
Set-ItemProperty -Path GP:\$PolicyType\$PolicyName\settings\ICA\FileRedirection\ReadOnlyMappedDrive  -Name State -Value Disabled
Set-ItemProperty -Path GP:\$PolicyType\$PolicyName\settings\ICA\FileRedirection\SpecialFolderRedirection  -Name State -Value Prohibited

Set-ItemProperty -Path GP:\$PolicyType\$PolicyName\settings\ICA\TWAINDevices\TwainRedirection  -Name State -Value Prohibited
Set-ItemProperty -Path GP:\$PolicyType\$PolicyName\settings\ICA\USBDevices\UsbDeviceRedirection  -Name State -Value Disabled
Set-ItemProperty -Path GP:\$PolicyType\$PolicyName\settings\ICA\USBDevices\UsbPlugAndPlayRedirection  -Name State -Value Disabled

###--- Encryption --- ###
Set-ItemProperty -Path GP:\$PolicyType\$PolicyName\settings\ICA\Security\MinimumEncryptionLevel  -Name State -Value enabled
Set-ItemProperty -Path GP:\$PolicyType\$PolicyName\settings\ICA\Security\MinimumEncryptionLevel  -Name Value -Value Bits128
###--- session Limits --- ###
Set-ItemProperty -Path GP:\$PolicyType\$PolicyName\settings\ICA\SessionLimits\SessionDisconnectTimer  -Name State -Value Enabled
Set-ItemProperty -Path GP:\$PolicyType\$PolicyName\settings\ICA\SessionLimits\SessionDisconnectTimerInterval  -Name State -Value Enabled
Set-ItemProperty -Path GP:\$PolicyType\$PolicyName\settings\ICA\SessionLimits\SessionDisconnectTimerInterval  -Name Value -Value 30
Set-ItemProperty -Path GP:\$PolicyType\$PolicyName\settings\ICA\SessionLimits\SessionIdleTimer  -Name State -Value Enabled
Set-ItemProperty -Path GP:\$PolicyType\$PolicyName\settings\ICA\SessionLimits\SessionIdleTimerInterval  -Name State -Value Enabled
Set-ItemProperty -Path GP:\$PolicyType\$PolicyName\settings\ICA\SessionLimits\SessionIdleTimerInterval  -Name Value -Value 120

###--- Printer setting --- ###
Set-ItemProperty -Path GP:\$PolicyType\$PolicyName\settings\ICA\Printing\ClientPrinterRedirection -Name State -Value Disabled
Set-ItemProperty -Path GP:\$PolicyType\$PolicyName\settings\ICA\Printing\SessionPrinters -Name State -Value Disabled
Set-ItemProperty -Path GP:\$PolicyType\$PolicyName\settings\ICA\Printing\ClientPrinters\AutoCreatePDFPrinter -Name State -Value Disabled
Set-ItemProperty -Path GP:\$PolicyType\$PolicyName\settings\ICA\Printing\ClientPrinters\ClientPrinterAutoCreation -Name State -Value Disabled
Set-ItemProperty -Path GP:\$PolicyType\$PolicyName\settings\ICA\Printing\ClientPrinters\ClientPrinterAutoCreation -Name Value -Value DoNotAutoCreate
Set-ItemProperty -Path GP:\$PolicyType\$PolicyName\settings\ICA\Printing\ClientPrinters\GenericUniversalPrinterAutoCreation -Name State -Value Disabled
Set-ItemProperty -Path GP:\$PolicyType\$PolicyName\settings\ICA\Printing\ClientPrinters\RetainedAndRestoredClientPrinters -Name State -Value Disabled

### --- Optimization --- ###
Set-ItemProperty -Path GP:\$PolicyType\$PolicyName\settings\ICA\DesktopUI\DesktopWallpaper -Name State -Value Disabled
Set-ItemProperty -Path GP:\$PolicyType\$PolicyName\settings\ICA\DesktopUI\MenuAnimation -Name State -Value Disabled
Set-ItemProperty -Path GP:\$PolicyType\$PolicyName\settings\ICA\DesktopUI\WindowContentsVisibleWhileDragging -Name State -Value Disabled
Set-ItemProperty -Path GP:\$PolicyType\$PolicyName\settings\ICA\Multimedia\MSTeamsRedirection  -Name State -Value Enabled
