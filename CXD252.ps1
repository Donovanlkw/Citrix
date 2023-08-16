[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Add-AzureRmAccount
Save-AzureRmContext -Path c:\logon.json –Force


$path = “C:\CXD-251\logon.json”
Import-AzureRmContext -Path $path

$VMName = "AUE-W10-001"
$rgname = "Student52341Lab"

Set-AzureRmVMCustomScriptExtension -ResourceGroupName $rgname -VMName $VMName -Name JoinDomainExtension -FileUri "https://cxd251impdata.blob.core.windows.net/vda/joindomain.ps1" -Run 'joindomain.ps1' -Argument 'azr.workspacelab.com AZR\ctxadmin Citrix@Pass!' -Location "East US 2"


Remove-AzureRmVMExtension -ResourceGroupName $rgname -VMName $VMName -Name "JoinDomainExtension" -Force
