param( $cmd, $exitWait )

if (-Not($cmd)) {
	Write-Host "Usage : Exec_DOTNET2.ps1 <Execute-Command> <exitWait>"
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

$proc = Start-Process -PassThru $cmd

$ProcessID = $proc.Id
Write-Host "ProcessID = $ProcessID is started."

if ($exitWait) {
	$proc.WaitForExit()
	Write-Host "$ProcessID is done."
}
