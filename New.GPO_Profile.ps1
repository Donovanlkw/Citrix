### --- Citrix policy ---###
# https://developer-docs.citrix.com/projects/citrix-virtual-apps-desktops-sdk/en/latest/group-policy-sdk-usage/
# https://docs.citrix.com/en-us/citrix-virtual-apps-desktops/policies/policies-default-settings.html

Import-Module "C:\Citrix_Supportability_Pack\Tools\Scout\Current\Utilities\Citrix.GroupPolicy.Commands.psm1"
get-command -Module Citrix.GroupPolicy.Commands

New-PsDrive -PsProvider CitrixGroupPolicy -Name GP -Root \ -Controller localhost

###--- Create Baseline for User policies --- ###
$Name = "Profile"
$PolicyType = "Computer"
$PolicyName = $Name+"_"+$PolicyType

$Profilepath="\\AZWFSNCTXSDFS01\azwapnctxdfs\CTXProfiles"
$TemplateProfilePath="\\AZWFSNCTXSDFS01\azwapnctxdfs\CTXProfiles"

cd GP:\$PolicyType
New-Item $PolicyName
Set-ItemProperty -Path GP:\$PolicyType\$PolicyName -Name Enabled -Value $true

Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\UserProfileManager\AdvancedSettings\CEIPEnabled	-Name State -Value Disabled
Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\UserProfileManager\AdvancedSettings\LogoffRatherThanTempProfile	-Name State -Value Enabled
Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\UserProfileManager\AdvancedSettings\ProcessCookieFiles	-Name State -Value Enabled

Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\UserProfileManager\BasicSettings\ProcessAdmins	-Name State -Value Enabled
Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\UserProfileManager\BasicSettings\ServiceActive	-Name State -Value Enabled
Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\UserProfileManager\BasicSettings\DATPath_Part	-Name State -Value Enabled
Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\UserProfileManager\BasicSettings\DATPath_Part	-Name Value -Value $profilepath

Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\UserProfileManager\ProfileHandling\DeleteCachedProfilesOnLogoff	-Name State -Value Enabled
Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\UserProfileManager\ProfileHandling\LocalProfileConflictHandling_Part	-Name State -Value Enabled
Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\UserProfileManager\ProfileHandling\TemplateProfileOverridesLocalProfile	-Name State -Value Enabled
Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\UserProfileManager\ProfileHandling\TemplateProfileOverridesRoamingProfile	-Name State -Value Enabled
Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\UserProfileManager\ProfileHandling\TemplateProfilePath	-Name State -Value Enabled
Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\UserProfileManager\ProfileHandling\TemplateProfilePath -Name Value -Value $TemplateProfilePath


Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\UserProfileManager\LogSettings\DebugMode	-Name State -Value Enabled
Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\UserProfileManager\LogSettings\LogLevel_ActiveDirectoryActions	-Name State -Value Enabled
Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\UserProfileManager\LogSettings\LogLevel_FileSystemActions	-Name State -Value Enabled
Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\UserProfileManager\LogSettings\LogLevel_FileSystemNotification	-Name State -Value Enabled
Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\UserProfileManager\LogSettings\LogLevel_Information	-Name State -Value Enabled
Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\UserProfileManager\LogSettings\LogLevel_Logoff	-Name State -Value Enabled
Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\UserProfileManager\LogSettings\LogLevel_Logon	-Name State -Value Enabled
Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\UserProfileManager\LogSettings\LogLevel_PolicyUserLogon	-Name State -Value Enabled
Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\UserProfileManager\LogSettings\LogLevel_RegistryActions	-Name State -Value Enabled
Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\UserProfileManager\LogSettings\LogLevel_RegistryDifference	-Name State -Value Enabled
Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\UserProfileManager\LogSettings\LogLevel_UserName	-Name State -Value Enabled
Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\UserProfileManager\LogSettings\LogLevel_Warnings	-Name State -Value Enabled
Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\UserProfileManager\LogSettings\MaxLogSize_Part	-Name State -Value Enabled





#Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\UserProfileManager\XenAppOptimizationSettings	-Name State -Value Disabled
#Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\UserProfileManager\XenAppOptimizationSettings\XenAppOptimizationDefinitionPathData	-Name State -Value Disabled
#Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\UserProfileManager\XenAppOptimizationSettings\XenAppOptimizationEnabled	-Name State -Value Disabled

#Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\UserProfileManager\PSSettings\PSAlwaysCache	-Name State -Value Disabled
#Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\UserProfileManager\PSSettings\PSAlwaysCache_Part	-Name State -Value Disabled
#Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\UserProfileManager\PSSettings\PSEnabled	-Name State -Value Disabled
#Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\UserProfileManager\PSSettings\PSPendingLockTimeout	-Name State -Value Disabled
#Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\UserProfileManager\PSSettings\PSUserGroups_Part	-Name State -Value Disabled
#Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\UserProfileManager\PSSettings\StreamingExclusionList_Part	-Name State -Value Disabled
#Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\UserProfileManager\PSSettings\StreamingExclusionList_Part\Values	-Name State -Value Disabled
#Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\UserProfileManager\PSSettings\PSUserGroups_Part\Values	-Name State -Value Disabled

#Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\UserProfileManager\CPSettings\CPEnable	-Name State -Value Disabled
#Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\UserProfileManager\CPSettings\CPMigrationFromBaseProfileToCPStore	-Name State -Value Disabled
#Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\UserProfileManager\CPSettings\CPPathData	-Name State -Value Disabled
#Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\UserProfileManager\CPSettings\CPSchemaPathData	-Name State -Value Disabled
#Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\UserProfileManager\CPSettings\CPUserGroups_Part	-Name State -Value Disabled
#Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\UserProfileManager\CPSettings\CPUserGroups_Part\Values	-Name State -Value Disabled




$ExclusionListSyncDir_Part="
!ctx_localappdata!\Microsoft\Windows\Notifications
!ctx_localappdata!\Citrix\DriveMapper3
!ctx_localappdata!\Microsoft\Office\15.0\Licensing
!ctx_localappdata!\Microsoft\Office\16.0\Licensing
$Recycle.Bin
AppData\Local\Microsoft\Windows\Burn
AppData\Local\Microsoft\Windows Live
AppData\Local\Microsoft\Windows Live Contacts
AppData\Local\Microsoft\Terminal Server Client
AppData\Local\Microsoft\Messenger
AppData\Local\Sun
AppData\Local\Microsoft\OneNote
AppData\Local\Google\Chrome\User Data\Default\Cache
AppData\Local\Microsoft\Windows\Temporary Internet Files
AppData\Local\Temp
AppData\LocalLow
AppData\Roaming\Sun\Java\Deployment\cache
AppData\Roaming\Sun\Java\Deployment\log
AppData\Roaming\Sun\Java\Deployment\tmp
AppData\Roaming\Sun\Java\Deployment
AppData\Roaming\Citrix\PNAgent\AppCache
AppData\Roaming\Citrix\PNAgent\Icon Cache
AppData\Roaming\Citrix\PNAgent\ResourceCache
AppData\Roaming\ICAClient\Cache
AppData\Roaming\Macromedia\Flash Player\macromedia.com\support\flashplayer\sys
AppData\Roaming\Macromedia\Flash Player\#SharedObjects
AppData\Roaming\Microsoft\Excel
AppData\Local\Microsoft\Internet Explorer\Recovery
AppData\Roaming\Microsoft\Word
AppData\Roaming\Microsoft\Powerpoint
AppData\Local\Microsoft\Windows Mail
AppData\Local\Microsoft\Office\15.0\OfficeFileCache
AppData\Roaming\Dropbox
AppData\Local\Dropbox
Dropbox
AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Dropbox
ShareFile
AppData\Roaming\Microsoft\Templates\LiveContent
AppData\Local\Downloaded Installations
AppData\Local\Microsoft\Windows\Themes
AppData\Local\Microsoft\Windows\WER
AppData\Local\Microsoft\Windows\WebCache.old
AppData\Local\ATT Connect
AppData\Roaming\Sharefile\Outlook
AppData\Roaming\com.adobe.formscentral.FormsCentralForAcrobat
AppData\Local\Skype
AppData\Local\Assembly\dl3
AppData\Roaming\Microsoft\Internet Explorer\UserData
AppData\Local\Microsoft\Windows\PriCache
AppData\Local\Packages
AppData\Local\Microsoft\Windows\Application Shortcuts
OneDrive
AppData\Local\Microsoft\CLR-v4.0_32
AppData\Local\Microsoft\GameDVR
AppData\Local\Microsoft\Group Policy
AppData\Local\Microsoft\Media Player
AppData\Local\Microsoft\OneDrive
AppData\Local\Microsoft\PlayReady
AppData\Local\Microsoft\Windows\1033
AppData\Local\Microsoft\Windows\Caches
AppData\Local\Microsoft\Windows\Explorer
AppData\Local\Microsoft\Windows\GameExplorer
AppData\Local\Microsoft\Windows\Notifications
AppData\Local\Microsoft\Windows\Ringtones
AppData\Local\Microsoft\Windows\RoamingTiles
AppData\Local\Comms
WINDOWS\Downloaded Installations
AppData\Local\Microsoft\Windows\WebCache
AppData\Local\Microsoft\Windows\INetCache
AppData\Local\Microsoft\Windows\AppCache
AppData\Local\Google\Chrome\User Data\Default\Code Cache
AppData\Local\Google\Chrome\User Data\Default\Service Worker\CacheStorage
AppData\Local\Microsoft\Office\16.0\Lync\Tracing
AppData\Roaming\Microsoft\Teams*.txt
AppData\Roaming\Microsoft\Teams\media-stack
AppData\Roaming\Microsoft\Teams\Service Worker\CacheStorage
AppData\Roaming\Microsoft\Teams\Logs
AppData\Roaming\Microsoft\Teams\Application Cache
AppData\Roaming\Microsoft\Teams\Cache
AppData\Roaming\Microsoft\Teams\GPUCache
AppData\Roaming\Microsoft\Teams\meeting-addin\Cache
"

$ExclusionListSyncFiles_Part="
!ctx_localappdata!\Microsoft\Windows\UsrClass.dat*
*thumb*.db
*icon*.db
"

$SyncDirList_Part="
AppData\Roaming\Microsoft\Credentials
AppData\Roaming\Microsoft\Crypto
AppData\Roaming\Microsoft\Protect
AppData\Roaming\Microsoft\SystemCertificates
AppData\Local\Microsoft\Credentials
AppData\Roaming\Microsoft\Excel\XLSTART
AppData\Roaming\Microsoft\Word\STARTUP
AppData\LocalLow\Sun\Java\Deployment\ext
AppData\LocalLow\Sun\Java\Deployment\security
"

$SyncFileList_Part="
AppData\Local\Microsoft\Office\*.qat
AppData\Local\Microsoft\Office\*.officeUI
AppData\LocalLow\Google\GoogleEarth\*.kml
AppData\Roaming\Microsoft\Excel\Excel*.xlb
AppData\LocalLow\Sun\Java\Deployment\deployment.properties
AppData\Roaming\ShareFile\Outlook\config.cfg
AppData\Roaming\ShareFile\Outlook\log.txt
AppData\LocalLow\Sun\Java\Deployment\security\exception.sites
AppData\LocalLow\Sun\Java\Deployment\security\trusted.certs
AppData\LocalLow\Sun\Java\Deployment\deployment.properties
"

$ExclusionList_Part="
Software\Microsoft\Office\15.0\Excel\Resiliency
Software\Microsoft\Office\15.0\PowerPoint\Resiliency
Software\Microsoft\Office\15.0\Word\Resiliency
Software\Microsoft\Office\15.0\OneNote\Resiliency
Software\Microsoft\Office\15.0\Outlook\Resiliency
Software\Microsoft\Internet Explorer\Recovery
"


Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\UserProfileManager\FileSystemSettings\DefaultFSExclusions\DefaultExclusionListSyncDir	-Name State -Value Enabled

Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\UserProfileManager\FileSystemSettings\FSExclusions\ExclusionListSyncDir_Part -Name State -Value Enabled
Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\UserProfileManager\FileSystemSettings\FSExclusions\ExclusionListSyncDir_Part -Name Values -Value $ExclusionListSyncDir_Part
Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\UserProfileManager\FileSystemSettings\FSExclusions\ExclusionListSyncFiles_Part -Name State -Value Enabled
Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\UserProfileManager\FileSystemSettings\FSExclusions\ExclusionListSyncFiles_Part -Name Values -Value $ExclusionListSyncFiles_Part

Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\UserProfileManager\FileSystemSettings\FSSynchronization\SyncDirList_Part -Name State -Value Enabled
Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\UserProfileManager\FileSystemSettings\FSSynchronization\SyncDirList_Part -Name Values -Value $SyncDirList_Part
Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\UserProfileManager\FileSystemSettings\FSSynchronization\SyncFileList_Part -Name State -Value Enabled
Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\UserProfileManager\FileSystemSettings\FSSynchronization\SyncFileList_Part -Name Values -Value $SyncFileList_Part


Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\UserProfileManager\RegistrySettings\LastKnownGoodRegistry	-Name State -Value Enabled
Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\UserProfileManager\RegistrySettings\ExclusionList_Part	-Name State -Value Enabled
Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\UserProfileManager\RegistrySettings\ExclusionList_Part	-Name Values  -Value $ExclusionList_Part
Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\UserProfileManager\RegistrySettings\DefaultREGExclusions\DefaultExclusionList	-Name State -Value Enabled

