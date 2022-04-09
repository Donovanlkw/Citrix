$connectTestResult = Test-NetConnection -ComputerName globomantics456.file.core.windows.net -Port 445
if ($connectTestResult.TcpTestSucceeded) {
    # Save the password so the drive will persist on reboot
    cmd.exe /C "cmdkey /add:`"globomantics456.file.core.windows.net`" /user:`"localhost\globomantics456`" /pass:`"xf/FuUtLURgSL4KwJFiQbPzc6j0W+TW4HEo3pST3Ri6KIAk3rOW2k8m3eIHCbQroyXOKFziyY+Nk+ASt/JRdMA==`""
    # Mount the drive
    New-PSDrive -Name Z -PSProvider FileSystem -Root "\\globomantics456.file.core.windows.net\fs123456" -Persist
} else {
    Write-Error -Message "Unable to reach the Azure storage account via port 445. Check to make sure your organization or ISP is not blocking port 445, or use Azure P2S VPN, Azure S2S VPN, or Express Route to tunnel SMB traffic over a different port."
}
