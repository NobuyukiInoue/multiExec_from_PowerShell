multiExec_from_PowerShell
==

multiExec_from_PS.ps1 is a script that executes commands in parallel in multiple processes from PowerShell.

## System requirements

* Windows 7/8/10 or Windows Server 2008/2012/2016
* PowerShell 5.0 or later


## Execution method

1. List the command strings you want to execute in any text file (cmdList.txt). Please fill in one command per line.

2. Start PowerShell and execute multiExec_from_PS.ps1 in the following format.

```
> ./multiExec_from_PS.ps1 <cmdListFile> <maxProcessCount> <startInterval> <checkInterval> <retryCount> <noWait> <logDir> <enable_log_stdout> <enable_log_stderr>
```
  
## Execution command example

```
S> .\multiExec_from_PS.ps1 .\cmdList.txt 4 -enable_log_stdout true -enable_log_stderr true
$cmdListFileName = .\cmdList.txt
$maxProcessCount = 4
$startInterval = 0
$checkInterval = 4
$retryCount = 4
$exitWait = False
$logDir = .\log_multiexec
$enable_log_stdout = True
$enable_log_stderr = True
[1] : ping www.google.com
.\log_multiexec\line_1_stdout.txt
.\log_multiexec\line_1_stderr.txt
PID =  11840
[2] : ping www.yahoo.co.jp
.\log_multiexec\line_2_stdout.txt
.\log_multiexec\line_2_stderr.txt
PID =  10164
[3] : ping www.amazon.com
.\log_multiexec\line_3_stdout.txt
.\log_multiexec\line_3_stderr.txt
PID =  13756
[4] : ping www.nikkei.co.jp
.\log_multiexec\line_4_stdout.txt
.\log_multiexec\line_4_stderr.txt
PID =  8740
[5] : snmpwalk -v 1 -c public 10.15.10.254 .1.3.6.1.2.1.2
.\log_multiexec\line_5_stdout.txt
.\log_multiexec\line_5_stderr.txt
PID =  14248
[6] : snmpwalk -v 1 -c public 10.15.10.254 .1.3.6.1.2.1.2.2.1.7
.\log_multiexec\line_6_stdout.txt
.\log_multiexec\line_6_stderr.txt
PID =  5840
[7] : snmpwalk -v 1 -c public 10.15.10.254 .1.3.6.1.2.1.2.2.1.8
.\log_multiexec\line_7_stdout.txt
.\log_multiexec\line_7_stderr.txt
PID =  3716
[8] : snmpwalk -v 1 -c public 10.15.10.254 .1.3.6.1.2.1.2.2.1.9
.\log_multiexec\line_8_stdout.txt
.\log_multiexec\line_8_stderr.txt
PID =  12936
multiExec_from_PS.ps1 is Done...
PS D:\n1.inoue\OneDrive\Develop-Works\LANGS\PowerShell\PS_Work\multiExec_from_PS>
```

## LICENSE

[MIT](https://github.com/NobuyukiInoue/multiExec_from_PowerShell/blob/master/LICENSE)
