$VM_SF = Get-Content "VM_SF_all.txt"

$VM_SF|foreach{
$all_SFWebConfig = get-childitem -recurse -path \\$_\f$\StoreFront\Citrix |where {$_.name -eq "web.config"}

  $all_SFWebConfig.fullname|foreach{
  write-output $_
  Get-Content $_ |select-string "clients/Windows/CitrixWorkspaceApp.exe" 
}

}
