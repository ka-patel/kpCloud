@echo off

IF NOT "x%DEBUG%"=="x" @ECHO ON

echo Preserving WinPE install logs ...

FOR /F "tokens=1,2,*" %%a in ('reg.exe query "HKLM\SYSTEM\MountedDevices" ^| find /i "DosDevices"') DO (
  IF DEFINED DEBUG ECHO DEBUG: ^%^%a=%%a
  FOR /F "tokens=2 delims=\" %%p in ("%%a") DO IF EXIST %%p\$WINDOWS.~BT (
    IF DEFINED DEBUG ECHO DEBUG: ^%^%p=%%p
    MKDIR %%p\Windows\kpCloud\WinPE
    XCOPY /E /C /I /F /H /R /Y %%p\$WINDOWS.~BT\Sources %%p\Windows\kpCloud\WinPE
  )
)

exit
