param( $cmdListFileName, $maxProcessCount, $startInterval, $checkInterval, $retryCount, $exitWait, $logDir, $enable_log_stdout, $enable_log_stderr )

if (-Not($cmdListFileName)){
    Write-Host "Usage : multiExec_from_PS.ps1 <cmdListFile> <maxProcessCount> <startInterval> <checkInterval> <retryCount> <exitWait>"
    exit
}

if (-Not($maxProcessCount)){
    $maxProcessCount = 4
}

if (-Not($startInterval)){
    $startInterval = 0
}

if (-Not($checkInterval)){
    $checkInterval = 4
}

if (-Not($retryCount)){
    $retryCount = 4
}

if (-Not($exitWait)){
    $exitWait = $FALSE
}

if (-Not($logDir)){
    $logDir = ".\log_multiexec"
}

if (-Not(Test-Path $logDir)) {
    Write-Host "`"$logDir`" is not found."
    return
}

if (-Not ($enable_log_stdout)) {
    $enable_log_stdout = $FALSE
}
else {
    $enable_log_stdout = $TRUE
}

if (-Not ($enable_log_stderr)) {
    $enable_log_stderr = $FALSE
}
else {
    $enable_log_stderr = $TRUE
}

##---------------------------------------------------------------------------##
## Print Arguments.
##---------------------------------------------------------------------------##
function varsWrite([string]$cmdListFileName, [int]$maxProcessCount, [int]$startInterval, [int]$checkInterval, [int]$retryCount, [boolean]$exitWait, [string]$logDir, [boolean]$enable_log_stdout, [boolean]$enable_log_stderr)
{
    Write-Output "`$cmdListFileName = $cmdListFileName"
    Write-Output "`$maxProcessCount = $maxProcessCount"
    Write-Output "`$startInterval = $startInterval"
    Write-Output "`$checkInterval = $checkInterval"
    Write-Output "`$retryCount = $retryCount"
    Write-Output "`$exitWait = $exitWait"
    Write-Output "`$logDir = $logDir"
    Write-Output "`$enable_log_stdout = $enable_log_stdout"
    Write-Output "`$enable_log_stderr = $enable_log_stderr"
} 

##---------------------------------------------------------------------------##
## Get start position of argument of execution command
##---------------------------------------------------------------------------##
function getArgsPostion([string]$cmdLine)
{
    $pos1 = $cmdLine.IndexOf("`"")
    if ($pos1 -ge 0) {
        $pos2 = $pos1 + $cmdLine.Substring($pos1 + 1).IndexOf("`"")
        $posSPC = $pos2 + $cmdLine.Substring($pos2).IndexOf(" ")
    }
    else {
        $posSPC = $pos2 + $cmdLine.IndexOf(" ")
    }
    
    if ($posSPC -gt 0) {
        return $posSPC
    }
    else {
        return -1
    }
}

##---------------------------------------------------------------------------##
## Function to wait until the number of processes falls below the upper limit.
##---------------------------------------------------------------------------##
function waitEnableExec([int]$maxProcessCount, [int]$checkInterval, [int]$retryCount, [array]$PID_LIST)
{
    $loopCount = 0

    while (1) {
        $pCount = 0

        for ($i = 0; $i -lt $PID_LIST.Length; $i++ ) {
            if ((IsExist_targetProcesses $PID_LIST[$i]) -gt 0) {
                $pCount++
            }
            else {
                $PID_LIST[$i] = 0
            }
        }

        if ($pCount -lt $maxProcessCount) {
            return
        }

        $loopCount++

        if ($loopCount -ge $retryCount) {
            Write-Host "Process Count is MAX!!"

            while($true)
            {
                Write-Host "Force Quit(Q) or Wait Continue(C)?" -NoNewline
                $keyInfo = [Console]::ReadKey($true)

                if($keyInfo.Key -eq "Q") {
                    exit
                }
                elseif($keyInfo.Key -eq "C") {
                    Write-Host
                    break
                }
            }

            $loopCount = 0
        }
        else {
            # 指定時間待機する
            Start-Sleep $checkInterval
        }
    }
}

function IsExist_targetProcesses([int]$target_pid) {
    return @(Get-Process -Id $target_pid -ErrorAction 0).Count
}


##---------------------------------------------------------------------------##
## Main
##---------------------------------------------------------------------------##
function Main([string]$cmdListFileName, [int]$maxProcessCount, [int]$startInterval, [int]$checkInterval, [int]$retryCount, [boolean]$exitWait, [string]$logDir, [boolean]$enable_log_stdout, [boolean]$enable_log_stderr)
{
    # Print Arguments.
    varsWrite $cmdListFileName $maxProcessCount $startInterval $checkInterval $retryCount $exitWait $logDir $enable_log_stdout $enable_log_stderr

    $LINES = (Get-Content $cmdListFileName) -as [string[]]
    #Write-Host `$LINES.Length : $LINES.Length

    $PID_LIST = @(0..($MaxProcessCount - 1))

    for ($i = 0; $i -lt $LINES.Length;) {
        # Wait until the number of processes falls below the upper limit.
        waitEnableExec $maxProcessCount $checkInterval $retryCount $PID_LIST

        for ($p = 0; $p -lt $PID_LIST.Length; $p++) {
        
            if ($i -ge $LINES.Length) {
                break
            }

            $currentLine = $LINES[$i]
            $currentLine = $currentLine -replace "#.*$", ""
            $currentLine = $currentLine -replace "//.*$", ""

            if ($currentLine -eq "") {
                $i++
                continue
            }

            if ($enable_log_stdout -eq $TRUE) {
                $STDOUT_FILE = "$logDir\line_$($i + 1)_stdout.txt"
            }

            if ($enable_log_stderr -eq $TRUE) {
                $STDERR_FILE = "$logDir\line_$($i + 1)_stderr.txt"
            }

            if ($PID_LIST[$p] -ne 0) {
                continue
            }

            Write-Host "[$($i + 1)] : $currentLine"

            $posSPC = getArgsPostion $currentLine

            if ($posSPC -gt 0) {
                $CMD  = $currentLine.Substring(0, $posSPC)
                $ARGS = $currentLine.Substring($posSPC + 1).Split(" ")
            }
            else {
                $CMD  = $currentLine
                $ARGS = ""
            }

            if ($CMD.Substring(0,2) -eq ".\") {
                $CMD = $CMD.Substring(2)
            }

            $i++

            if (($enable_log_stdout -eq $TRUE) -And ($enable_log_stderr -eq $TRUE)) {
                if ($ARGS -ne "") {
                    # Command parallel execution.
                    $PROCESS = Start-Process -PassThru $CMD -ArgumentList $ARGS -RedirectStandardOutput $STDOUT_FILE -RedirectStandardError $STDERR_FILE
                }
                else {
                    # Command parallel execution.
                    $PROCESS = Start-Process -PassThru $CMD -RedirectStandardOutput $STDOUT_FILE -RedirectStandardError $STDERR_FILE
                }

                Write-Host $STDOUT_FILE
                Write-Host $STDERR_FILE

            }
            elseif ($enable_log_stdout -eq $TRUE) {
                if ($ARGS -ne "") {
                    # Command parallel execution.
                    $PROCESS = Start-Process -PassThru $CMD -ArgumentList $ARGS -RedirectStandardOutput $STDOUT_FILE
                }
                else {
                    # Command parallel execution.
                    $PROCESS = Start-Process -PassThru $CMD -RedirectStandardOutput $STDOUT_FILE
                }

                Write-Host $STDOUT_FILE

            }
            elseif ($enable_log_stderr -eq $TRUE) {
                if ($ARGS -ne "") {
                    # Command parallel execution.
                    $PROCESS = Start-Process -PassThru $CMD -ArgumentList $ARGS -RedirectStandardError $STDERR_FILE
                }
                else {
                    # Command parallel execution.
                    $PROCESS = Start-Process -PassThru $CMD -RedirectStandardError $STDERR_FILE
                }

                Write-Host $STDERR_FILE

            }
            else {
                if ($ARGS -ne "") {
                    # Command parallel execution.
                    $PROCESS = Start-Process -PassThru $CMD -ArgumentList $ARGS
                }
                else {
                    # Command parallel execution.
                    $PROCESS = Start-Process -PassThru $CMD
                }
            }

            if ($PROCESS) {
                $PID_LIST[$p] = $PROCESS.Id
                Write-Host "PID = "$PROCESS.Id
            }

            if ($exitWait -eq $TRUE) {
                $PROCESS.WaitForExit()
            }

            Start-Sleep $startInterval
        }
    }

    $CommandName = Split-Path -Leaf $PSCommandPath
    Write-Host $CommandName is Done...
}

## Main Call
Main $cmdListFileName $maxProcessCount $startInterval $checkInterval $retryCount $exitWait $logDir $enable_log_stdout $enable_log_stderr
