@echo off

IF NOT "x%DEBUG%"=="x" @ECHO ON

echo Copying over Virtual platform drivers for offline install

FOR /F "skip=1 tokens=1,2,*" %%a in ('reg.exe query "HKLM\SYSTEM\CurrentControlSet\Control\SystemInformation" ^| find /i "System"') DO (
  echo Setting: %%a=%%c
  SET %%a=%%c
)

FOR /F "tokens=1,2,*" %%a in ('reg.exe query "HKLM\SYSTEM\MountedDevices" ^| find /i "DosDevices"') DO (
  IF DEFINED DEBUG ECHO DEBUG: ^%^%a=%%a
  FOR /F "tokens=2 delims=\" %%p in ("%%a") DO IF EXIST %%p\$WINDOWS.~BT (
    IF DEFINED DEBUG ECHO DEBUG: ^%^%p=%%p
    MKDIR %%p\Drivers
    XCOPY /E /C /I /F /H /R /Y z:\ks\%ksOS%\Drivers %%p\Drivers
  )
)

IF "%SystemProductName%"=="Parallels Virtual Platform" GOTO parallels

GOTO end





:VirtualBox
GOTO end

:VMware
GOTO end

:Parallels
ECHO Parallel virtual system detected.
GOTO end







:end
exit
