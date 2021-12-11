@echo off

IF NOT "x%DEBUG%"=="x" @ECHO ON

ECHO Setting up for auto admin login and script to bootstrap during first log-on ...

FOR /F "tokens=1,2,*" %%a in ('reg.exe query "HKLM\SYSTEM\MountedDevices" ^| find /i "DosDevices"') DO (
  IF DEFINED DEBUG ECHO DEBUG: ^%^%a=%%a
  FOR /F "tokens=2 delims=\" %%p in ("%%a") DO IF EXIST %%p\$WINDOWS.~BT (
    SET OSDRIVE=%%p
  )
)

SET nextPHASE=firstboot
SET scriptRoot=%OSDRIVE%\Windows\kpCloud\Build\%nextPhase%
SET scriptDir=%scriptRoot%\%nextPhase%.d

mkdir %scriptDir%
wget -O %scriptRoot%\firstboot.bat http://%ksServer%/ks/helper/util/win/firstboot.bat

SET scriptList=%scriptRoot%\firstboot.lst

IF NOT EXIST %scriptList% (
  IF NOT EXIST z:\ks (
    ECHO Attaching to Windows share for build process ...
    IF EXIST z:\* NET USE /d z:
    NET USE z: \\%ksServer%\kpCloud
  )

  ECHO Scripts order to run:
  FOR /F %%I IN ('dir /b /o:n z:\ks\%ksOS%\%nextPHASE%\??-*') DO (
    COPY /V /Y z:\ks\%ksOS%\%nextPHASE%\%%I %scriptDir% 2>&1 >nul
    ECHO.  %%I
    ECHO %%I >>%scriptList%
  )
  COPY /V /Y /A %scriptList% %scriptList%.full >nul
  ECHO.
)

for %%A in (wtee.exe busybox.exe curl.exe wget.exe) do (
  ECHO Downloading %%A
  wget -O %OSDRIVE%\Windows\System32\%%A http://%ksServer%/ks/helper/util/win/%%A
)

IF EXIST %scriptRoot%\firstboot.bat (

  ECHO Adding registry enteries ...
  reg load HKLM\kpBuild %OSDRIVE%\Windows\System32\config\SOFTWARE
  reg add  "HKLM\kpBuild\Microsoft\Windows\CurrentVersion\Run" /v kpCloudInstall /t REG_SZ /d %scriptRoot%\firstboot.bat /f

  reg add  "HKLM\kpBuild\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultDomainName /t REG_SZ    /d "." /f
  reg add  "HKLM\kpBuild\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultUserName   /t REG_SZ    /d "Administrator" /f
  reg add  "HKLM\kpBuild\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultPassword   /t REG_SZ    /d "rootroot" /f
  reg add  "HKLM\kpBuild\Microsoft\Windows NT\CurrentVersion\Winlogon" /v AutoAdminLogon    /t REG_SZ    /d "1" /f
  reg add  "HKLM\kpBuild\Microsoft\Windows NT\CurrentVersion\Winlogon" /v AutoLogonCount    /t REG_DWORD /d "20" /f
  reg unload HKLM\kpBuild
)

exit
