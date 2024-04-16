$Key = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" 
$ConsentPromptBehaviorAdmin_Name = "ConsentPromptBehaviorAdmin" 
$ConsentPromptBehaviorUser_Name = "ConsentPromptBehaviorUser" 
$PromptOnSecureDesktop_Name = "PromptOnSecureDesktop" 
Set-ItemProperty -Path $key -Name $ConsentPromptBehaviorAdmin_Name -Value 5
Set-ItemProperty -Path $key -Name $ConsentPromptBehaviorUser_Name -Value 3
Set-ItemProperty -Path $key -Name $PromptOnSecureDesktop_Name -Value 0
