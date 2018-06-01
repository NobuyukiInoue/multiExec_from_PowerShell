コマンド並列実行マクロ『multiExec_from_PowerShell』
==

PowerShellからコマンドをマルチプロセスで並列実行するサンプルプログラムです。  
  

## システム要件
*Windows 7/8/10 or Windows Server 2008/2012/2016  
*PowerShell 2.0以降


## ダウンロードおよび実行方法

コマンド プロンプト（またはPowerShell）を開き、git でダウンロードします。  
```
>git clone https://github.com/gx3n-inue/multiExec_from_PowerShell
```

## 実行方法
  
1.任意のテキストファイル(cmdList.txt)に実行したいコマンド列を列挙しておきます。１行１コマンドで記入してください。

2.PowerShellを起動し、下記の書式でps1ファイルを実行します。
```
>multiExec_from_PS.ps1 <cmdListFile> <maxProcessCount> <interval> <retryCount> <noWait>
```
  
実行例  
```
> .\multiExec_from_PS.ps1 .\cmdList.txt
```


## ライセンス
  
コマンド並列実行マクロ『multiExec_from_PowerShell』 ver1.00  
This project is licensed under the terms of the MIT license, see LICENSE.  
