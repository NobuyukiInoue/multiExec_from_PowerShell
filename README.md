multiExec_from_PowerShell
==

multiExec_from_PS.ps1 is a script that executes commands in parallel in multiple processes from PowerShell.

## System requirements

* Windows 7/8/10 or Windows Server 2008/2012/2016
* PowerShell 2.0 or later


## Execution method

1. List the command strings you want to execute in any text file (cmdList.txt). Please fill in one command per line.

2. Start PowerShell and execute multiExec_from_PS.ps1 in the following format.

```
> ./multiExec_from_PS.ps1 <cmdListFile> <maxProcessCount> <startInterval> <checkInterval> <retryCount> <noWait>
```
  
## Execution command example

```
> ./multiExec_from_PS.ps1 ./cmdList.txt
```


## LICENSE

[MIT](https://github.com/NobuyukiInoue/multiExec_from_PowerShell/blob/master/LICENSE)
