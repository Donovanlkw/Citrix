get-winevent  -logname "Microsoft-Windows-WMI-Activity/Operational"


#Command to reload perfmon counters :- 
#Rebuilding the counters:-
cd c:\windows\system32
lodctr /R
cd c:\windows\sysWOW64
lodctr /R
#Resyncing the counters with Windows Management Instrumentation (WMI):-
WINMGMT.EXE /RESYNCPERF



1. Run Wbemtest
2. In Windows Management Instrumentation Tester, click Connect.
3. In the Namespace box, type root\cimv2, and the click Connect.

4Click Enum Classes.

In the Enter superclass name box, type Win32_Perf, click Recursive and then click OK.

In Query Results, you will not see results for the counters that are not transferred to WMI.

For example, the counter object for Remote Process Explorer is Win32_PerfFormattedData_PerfProc_Process. If this counter does not exist, you will not see the following line in Query Results - Win32_PerfFormattedData_PerfProc_Process.

To Manually reset the WMI counters:

Click Start , click Run, type cmd, and then click OK.
Stop the Windows Management Instrumentation service or at the command prompt, type net stop winmgmt, and then press ENTER.
At the command prompt, type winmgmt /resyncperf, and then press ENTER.
At the command prompt, type wmiadap.exe /f, and then press ENTER.
Start the Windows Management Instrumentation service or at the command prompt, type net start winmgmt, and then press ENTER.
Type exit, and then press ENTER to close the command prompt.
After resetting the WMI counters, retest WMI.
You could also try restarting the Windows  Management Instrumentation Service and check if that works.

* Strong recommendation is that you run the antivirus scan for the all systems, sometimes virus attacks may also indicate a WMIPRVSE high CPU utilization.



https://discussions.citrix.com/topic/395518-wmiprvse-high-cpu-utilization/
https://support.citrix.com/article/CTX223754/xd-712-wmiprvseexe-consumes-high-cpu
https://www.optimizationcore.com/system-administration/complete-wmi-query-guide-wmiexplorer-powershell-cmd/
https://appuals.com/wmi-provider-host-wmiprvse-exe-high-cpu-usage-on-windows-10/


