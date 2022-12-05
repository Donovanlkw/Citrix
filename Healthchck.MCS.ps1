<### --- Healthcheck v2  --- ###>
$DDC |ForEach{
$result=Get-ProvScheme -AdminAddress $_ |where {$_.machinecount -gt 0} 
$Snapshot=split-path -path $result.MasterImageVM -leaf
$MC=$result.IdentityPoolName

  $report =@()
  $report= for($i= 0; $i -lt $Result.count; $i++) {  
    [PSCustomObject]@{
    MC= $MC[$i]
    Snapshot= $snapshot[$i]
    }
  }
$report
}


<### --- Health check v1  --- ###>

$ComputerName=""
$computerName |out-file serverlistDDC.txt

$parameters = @{
  ComputerName = Get-Content serverlistDDC.txt
  ScriptBlock = {Get-ProvScheme |where {$_.machinecount -gt 0} }
}

Invoke-Command @parameters |select IdentityPoolName, MasterImageVM | export-csv MCSimage.csv





