
###--- Create Baseline for Computer policies --- ###
$Name = "Baseline"
$PolicyType = "Computer"
$PolicyName = $Name+"_"+$PolicyType

cd GP:\$PolicyType
New-Item $PolicyName
Set-ItemProperty -Path GP:\$PolicyType\$PolicyName -Name Enabled -Value $true

####--- Server Load --- ###

Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\LoadManagement\CPUUsage	-Name State -Value	Enabled
Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\LoadManagement\CPUUsage	-Name Value -Value 95
Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\LoadManagement\MemoryUsage	-Name State -Value	Enabled
Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\LoadManagement\MemoryUsage -Name Value -Value 95
Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\LoadManagement\MaximumNumberOfSessions	-Name State -Value	Disabled
Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\LoadManagement\MaximumNumberOfSessions	-Name Value -Value 30

####--- Monitoring --- ###

Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\VirtualDesktopAgent\Monitoring\EnableProcessMonitoring	-Name State -Value	Allowed
Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\VirtualDesktopAgent\Monitoring\EnableResourceMonitoring	-Name State -Value	Allowed
Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\VirtualDesktopAgent\Monitoring\EnableWorkstationVDAFaultMonitoring	-Name State -Value	Prohibited
Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\VirtualDesktopAgent\Monitoring\SelectedFailureLevel	-Name State -Value	Enabled

Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\ICA\EndUserMonitoring\IcaRoundTripCalculation	-Name State -Value	Enabled
Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\ICA\EndUserMonitoring\IcaRoundTripCalculationInterval	-Name State -Value	Enabled
Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\ICA\EndUserMonitoring\IcaRoundTripCalculationWhenIdle	-Name State -Value	Enabled


####--- User experience --- ###

Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\ICA\AutoClientReconnect\AutoClientReconnect	-Name State -Value	Enabled
Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\ICA\AutoClientReconnect\AutoClientReconnectLogging	-Name State -Value	Enabled
Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\ICA\AutoClientReconnect\AutoClientReconnectLogging	-Name Value -Value LogAutoReconnectEvents

Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\ICA\SessionReliability\SessionReliabilityConnections	-Name State -Value	Enabled
Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\ICA\SessionReliability\SessionReliabilityTimeout	-Name State -Value	Enabled
Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\ICA\SessionReliability\SessionReliabilityTimeout	-Name Value -Value 30

Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\ICA\EnhancedDesktopExperience\EnhancedDesktopExperience	-Name State -Value	Enabled

####--- tobe review --- ###

Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\VirtualDesktopAgent\CPUUsageMonitoring\CPUUsageMonitoring_Enable	-Name State -Value	Enabled
Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\VirtualDesktopAgent\CPUUsageMonitoring\CPUUsageMonitoring_Period	-Name State -Value	Enabled
Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\VirtualDesktopAgent\CPUUsageMonitoring\CPUUsageMonitoring_Threshold	-Name State -Value	Enabled
		
Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\ICA\KeepAlive\IcaKeepAlives	-Name State -Value	Disabled
Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\ICA\KeepAlive\IcaKeepAliveTimeout	-Name State -Value	Disabled
Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\ICA\Graphics\Caching	-Name State -Value	Disabled
Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\ICA\Graphics\Framehawk	-Name State -Value	Disabled
Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\ICA\Graphics\DisplayDegradePreference	-Name State -Value	Disabled
Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\ICA\Graphics\DisplayDegradeUserNotification	-Name State -Value	Disabled
Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\ICA\Graphics\DisplayMemoryLimit	-Name State -Value	Disabled
Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\ICA\Graphics\DynamicPreview	-Name State -Value	Disabled
Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\ICA\Graphics\ImageCaching	-Name State -Value	Disabled
Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\ICA\Graphics\LegacyGraphicsMode	-Name State -Value	Disabled
Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\ICA\Graphics\MaximumColorDepth	-Name State -Value	Disabled
Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\ICA\Graphics\QueueingAndTossing	-Name State -Value	Disabled
Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\ICA\Graphics\Framehawk\FramehawkDisplayChannelPortRange	-Name State -Value	Disabled
Set-ItemProperty -Path 	GP:\$PolicyType\$PolicyName\Settings\ICA\Graphics\Caching\PersistentCache	-Name State -Value	Disabled


