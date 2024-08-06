# Define the parameters
$TaskName = "EventTriggeredTask"
$EventLogName = "Application"  # Replace with the desired event log name
$EventID = "1000"  # Replace with the desired event ID
$ActionScript = "C:\Path\to\YourScript.ps1"  # Replace with the path to your script
$Trigger = New-ScheduledTaskTrigger -AtStartup  # Change the trigger as needed

# Create the event trigger
$EventTrigger = New-ScheduledTaskTrigger -AtLogon
$EventFilter = New-ScheduledTaskEventTrigger -Subscription "<QueryList><Query><Select Path='Application'>*[System[EventID=$EventID]]</Select></Query></QueryList>"

# Register the scheduled task
Register-ScheduledTask -TaskName $TaskName -Trigger $Trigger -Action (New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-File $ActionScript") -Settings (New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries) -Force

# Attach the event trigger to the task
$Task = Get-ScheduledTask -TaskName $TaskName
$EventTrigger.Id = $Task.Triggers.Count + 1
$Task.Triggers.Add($EventTrigger)
$Task | Set-ScheduledTask
