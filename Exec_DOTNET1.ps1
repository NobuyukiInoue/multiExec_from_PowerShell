$proc = Start-Process -PassThru "notepad.exe"
Write-Host "`$proc.Id = "$proc.Id
$proc.WaitForExit()
