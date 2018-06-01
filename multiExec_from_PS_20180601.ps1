param( $cmdListFileName, $maxProcessCount, $interval, $retryCount, $noWait )

function varsWrite([string]$cmdListFileName, [int]$maxProcessCount, [int]$interval, [int]$retryCount, [int]$noWait)
{
    Write-Host "`$cmdListFileName = $cmdListFileName"
    Write-Host "`$maxProcessCount = $maxProcessCount"
    Write-Host "`$interval = $interval"
    Write-Host "`$retryCount = $retryCount"
    Write-Host "`$noWait = $noWait"
} 

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

function wait_enableExec([int]$maxProcessCount, [int]$interval, [int]$retryCount, [array]$pid_list)
{
    $loopCount = 0

    while (1) {
        $pCount = 0

        for ($i = 0; $i -lt $pid_list.Length; $i++ ) {
            if ((IsExist_targetProcesses $pid_list[$i]) -gt 0) {
                $pCount++
            }
            else {
                $pid_list[$i] = 0
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
                $input = Read-Host "Force Quit(Q) or Wait Continue(C)?"

                if(($input -eq "Q") -or ($input -eq "q"))
                {
                    # 終了する
                    exit
                } 

                if(($input -eq "C") -or ($input -eq "c"))
                {
                    # ループを抜ける
                    break
                } 
            }

            $loopCount = 0
        }
        else {
            # 0.1[s]待つ
            Start-Sleep $interval
        }
    }
}

function IsExist_targetProcesses([int]$target_pid)
{
    return (Get-Process -Id $target_pid -ErrorAction 0).Count
}


##---------------------------------------------------------------------------##
## Main
##---------------------------------------------------------------------------##

if (-Not($cmdListFileName)){
    Write-Host "Usage : multiExec_from_PS.ps1 <cmdListFile> <maxProcessCount> <interval> <retryCount> <noWait>"
    exit
}

if (-Not($maxProcessCount)){
    $maxProcessCount = 4
}

if (-Not($interval)){
    $interval = 4
}

if (-Not($retryCount)){
    $retryCount = 4
}

if (-Not($noWait)){
    $noWait = 1
}

# 変数読み込みチェック
#varsWrite $cmdListFileName $maxProcessCount $interval $retryCount $noWait

$f = (Get-Content $cmdListFileName) -as [string[]]
#Write-Host `$f.Length : $f.Length

$lines = @(0..($f.Length - 1))
#Write-Host `$lines.Length : $lines.Length

$i = 0
foreach ($currentLine in $f) {
    if ($currentLine.Substring(0,2) -eq ".\"){
        $currentLine = $currentLine.Substring(2)
    }
    $lines[$i]=$currentLine

    $i++
}

$pid_list = @(0..($MaxProcessCount - 1))

$i = 0
while ($i -lt $lines.Length) {
    
    # wait処理
    wait_enableExec $maxProcessCount $interval $retryCount $pid_list

    for ($p = 0; $p -lt $pid_list.Length; $p++) {
        Write-Host `$lines[$i] : $lines[$i]
        
        if (-Not($i -lt $lines.Length)) {
            break
        }

        if (($lines[$i].substring(0,1) -ne "#") -And ($pid_list[$p] -eq 0)) {

            $posSPC = getArgsPostion $lines[$i]

            if ($posSPC -gt 0) {
                #引数の分解チェック
                #Write-Host $lines[$i].Substring(0,$posSPC)
                #Write-Host $lines[$i].Substring($posSPC + 1)
                $proc = Start-Process -PassThru $lines[$i].Substring(0,$posSPC) -ArgumentList $lines[$i].Substring($posSPC + 1)
            }
            else {
                $proc = Start-Process -PassThru $lines[$i]
            }
            
            if ($proc) {
                $pid_list[$p] = $proc.Id
                #Write-Host "`$proc.Id = "$proc.Id
            }
        }

        $i++
    }
}
