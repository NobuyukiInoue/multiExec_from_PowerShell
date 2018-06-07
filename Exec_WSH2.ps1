param( $cmd, $exitWait )

if (-Not($cmd)) {
	Write-Host "Usage : Exec_WSH2.ps1 ExecCommand <exitWait>"
	exit
}

if (-Not($exitWait)) {
	$exitWait = $FALSE
}
else {
	if ( $exitWait -gt 0 ) {
		$exitWait = $TRUE
	}
	else {
		$exitWait = $FALSE
	}
}

$WshShell = New-Object -ComObject WScript.Shell
#$WshShell | Get-Member

$ex = $WshShell.Exec($cmd)

if ($ex) {
	$processId = $ex.ProcessID
	
	if ( $exitWait -eq $TRUE ) {
		while ( $ex.status -eq 0) {
			Start-Sleep 0.1
		}
	}
}

Write-Host "ProcessID = $processId is done."
