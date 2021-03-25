@echo off

IF NOT "x%DEBUG%"=="x" @ECHO ON

Echo Rebuilding WMI... Please wait.
net stop sharedaccess
net stop winmgmt /y
cd %SystemRoot%\system32\wbem
del /Q Repository

%SystemDrive%
cd %SystemRoot%\system32\wbem
rd /S /Q repository
regsvr32 /s %systemroot%\system32\scecli.dll
regsvr32 /s %systemroot%\system32\userenv.dll
mofcomp cimwin32.mof
mofcomp cimwin32.mfl
mofcomp rsop.mof
mofcomp rsop.mfl
for /f %%s in ('dir /b /s *.dll') do regsvr32 /s %%s
for /f %%s in ('dir /b *.mof') do mofcomp %%s 
for /f %%s in ('dir /b *.mfl') do mofcomp %%s 
mofcomp exwmi.mof
mofcomp -n:root\cimv2\applications\exchange wbemcons.mof
mofcomp -n:root\cimv2\applications\exchange smtpcons.mof
mofcomp exmgmt.mof
net stop winmgmt
net start winmgmt
gpupdate /force

Echo Check winmgmt is started, there were problems with it not starting on win7
net start winmgmt
