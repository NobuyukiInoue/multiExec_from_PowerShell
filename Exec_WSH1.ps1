$WshShell = New-Object -ComObject WScript.Shell
$ex = $WshShell.Exec("notepad.exe")

$ProcessID = $ex.ProcessID
Write-Host "ProcessID = $ProcessID is started."

while ( $ex.status -eq 0) {
	Start-Sleep 0.1
}
