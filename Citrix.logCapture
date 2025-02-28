CWA
1. [HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced] "ShowSecondsInSystemClock"=dword:00000001 
[HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Citrix\ICA Client\Engine\Configuration\Advanced\Modules\GfxRender] "VisualInst"=dword:00000001
CWA Log in verberal.
CDF Trace

•	Please capture the export of the following registry keys on the endpoint:
•	Computer\HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Citrix\ICA Client
•	Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Citrix\ICA Client
•	Computer\HKEY_CURRENT_USER\SOFTWARE\Citrix\ICA Client
•	Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Policies
•	Computer\HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Policies
 
VDA
1. [HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced] "ShowSecondsInSystemClock"=dword:00000001 
Disable Telemetry Service on VDA. If it is a Server VDA, log off all sessions to reduce trace noise.
2. CDF Trace
3. Please capture the export of the following registry keys on the VDA:
•	Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Citrix\Graphics
•	Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Policies

  
•	Start a video recording of the issue.
•	To avoid CDF trace event loss in CDFControl, I would recommend increasing the trace buffer size to maximum value in CDFControl options for all running instances of CDFControl.
•	Please make sure multiple sequential CDF trace mode is enabled in all instances o
f CDF Control.
•	Using latest CDFControl, start remote CDF trace on the target VDA
•	Using latest CDFControl, Start the CDF trace on endpoint.
•	Initiate the ICA session to the target VDA.
•	Inside the ICA session on the target VDA, open the system clock with seconds showing for a few moments, to check and demonstrate the clock synchronization between VDA and endpoint.
•	Repro the issue.
•	Please make sure it is clear in the video when exactly the issue occurs.
•	If it is not clearly seen, please provide visual clues in the video such as typing text "issue just occurred"
•	Stop the traces after repro is achieved.
•	Please make sure NO traces are lost (will be shown in RED under "Events Lost" in CDFControl "Controller Stats"). If the event loss does occur, please increase trace buffer size to maximum value and recapture teh Data set from scratch.
•	If the trace event loss still occurs with the max values, please consider using logman instead:  https://citrixwiki.citrite.net/How_to_ensure_no_CDF_trace_event_loss_occurs_on_heavily_loaded_servers [citrixwiki.citrite.net]
•	Collect Thinwire WMI data by running the following command in session and save the output in a text file, e.g. wmi_gfx.txt: 
wmic /namespace:\\root\citrix\hdx path citrix_virtualchannel_thinwire_enum get /value > wmi_gfx.txt & type wmi_gfx.txt



•	Stop recording
•	Re-enable Telemetry Service.
•	Provide display information, collected with dxdiag.exe
•	Send video and traces to Citrix for analysis
