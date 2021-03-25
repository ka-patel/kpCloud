@echo off

IF NOT "x%DEBUG%"=="x" @ECHO ON

@powershell -NoProfile -ExecutionPolicy unrestricted -Command "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))" && SET PATH=%PATH%;%systemdrive%\chocolatey\bin

%ComSpec% /c "C:\Chocolatey\Bin\cinst.bat DotNet3.5"
%ComSpec% /c "C:\Chocolatey\Bin\cinst.bat Dogtail.DotNet3.5SP1"
%ComSpec% /c "C:\Chocolatey\Bin\cinst.bat DotNet4.0"
%ComSpec% /c "C:\Chocolatey\Bin\cinst.bat DotNet4.5"
%ComSpec% /c "C:\Chocolatey\Bin\cinst.bat DotNet4.5.1"
%ComSpec% /c "C:\Chocolatey\Bin\cinst.bat PowerShell"
%ComSpec% /c "C:\Chocolatey\Bin\cinst.bat powershell4"
%ComSpec% /c "C:\Chocolatey\Bin\cinst.bat git"
%ComSpec% /c "C:\Chocolatey\Bin\cinst.bat notepadplusplus"
%ComSpec% /c "C:\Chocolatey\Bin\cinst.bat 7zip"
%ComSpec% /c "C:\Chocolatey\Bin\cinst.bat javaruntime"
%ComSpec% /c "C:\Chocolatey\Bin\cinst.bat ruby"
%ComSpec% /c "C:\Chocolatey\Bin\cinst.bat flashplayeractivex"
%ComSpec% /c "C:\Chocolatey\Bin\cinst.bat 7zip.commandline"
%ComSpec% /c "C:\Chocolatey\Bin\cinst.bat python"
%ComSpec% /c "C:\Chocolatey\Bin\cinst.bat flashplayerplugin"
%ComSpec% /c "C:\Chocolatey\Bin\cinst.bat adobereader"
%ComSpec% /c "C:\Chocolatey\Bin\cinst.bat sysinternals"
%ComSpec% /c "C:\Chocolatey\Bin\cinst.bat putty"
%ComSpec% /c "C:\Chocolatey\Bin\cinst.bat msysgit"
%ComSpec% /c "C:\Chocolatey\Bin\cinst.bat git.commandline"
%ComSpec% /c "C:\Chocolatey\Bin\cinst.bat vim"
%ComSpec% /c "C:\Chocolatey\Bin\cinst.bat windirstat"
%ComSpec% /c "C:\Chocolatey\Bin\cinst.bat hg"
%ComSpec% /c "C:\Chocolatey\Bin\cinst.bat Wget"
%ComSpec% /c "C:\Chocolatey\Bin\cinst.bat curl"
%ComSpec% /c "C:\Chocolatey\Bin\cinst.bat winmerge"
%ComSpec% /c "C:\Chocolatey\Bin\cinst.bat PDFCreator"
%ComSpec% /c "C:\Chocolatey\Bin\cinst.bat winscp"
%ComSpec% /c "C:\Chocolatey\Bin\cinst.bat SourceCodePro"
%ComSpec% /c "C:\Chocolatey\Bin\cinst.bat notepad2"
%ComSpec% /c "C:\Chocolatey\Bin\cinst.bat SourceTree"
%ComSpec% /c "C:\Chocolatey\Bin\cinst.bat MicrosoftSecurityEssentials"
%ComSpec% /c "C:\Chocolatey\Bin\cinst.bat php"
%ComSpec% /c "C:\Chocolatey\Bin\cinst.bat rdcman"

exit 0
