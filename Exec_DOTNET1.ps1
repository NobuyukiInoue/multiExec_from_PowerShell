$proc = Start-Process -PassThru "notepad.exe"

$ProcessID = $proc.Id
Write-Host "ProcessID = $ProcessID is started."

$proc.WaitForExit()
