###--- get Installed software ---###

$File="VM_NonProd"
$ComputerName = Get-Content "$file.txt"
Get-CimInstance -ComputerName $ComputerName -Class Win32_Product |select PSComputerName, Name, version|format-table -AutoSize| out-file "$file.sw.csv" -Append
