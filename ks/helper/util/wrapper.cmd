@ECHO off

IF NOT "x%DEBUG%"=="x" @ECHO ON

IF NOT DEFINED PHASE (
  ECHO.^%PHASE^% undefined. Exiting.
  exit 253
)

IF NOT DEFINED phaseRoot (
  ECHO.^%phaseRoot^% undefined. Exiting.
  exit 252
)

ECHO.
ECHO. +--------------------------------------------+ 
ECHO.
ECHO.      Running %PHASE% Configuration 
ECHO.
ECHO. +--------------------------------------------+ 
ECHO.

NET USE /P:NO 2>&1 >nul

IF EXIST %SystemRoot\System32\WPEUTIL.EXE (
  ECHO.Waiting for removable storage to be on-line ...
  wpeutil.exe WaitForRemovableStorage

  ECHO.
  ECHO.Bringing WinPE's configuration upto date ...
  wpeutil.exe UpdateBootInfo
)

ECHO.Serching for override configuration directory ...
<NUL SET /P "=  Device: "
FOR /F "tokens=1,2,*" %%a in ('reg.exe query "HKLM\SYSTEM\MountedDevices" ^| find /i "DosDevices"') DO (
  FOR /F "tokens=2 delims=\" %%p in ("%%a") DO (
    IF EXIST %%p\kpCloud (
      <NUL SET /P "=%%a* "
      SET ksConfDrive=%%p
    ) ELSE (
      <NUL SET /P "=%%a "
    )
  )
)
ECHO.

IF DEFINED ksConfDrive (
  ECHO.
  ECHO.Found %ksConfDrive%\kpCloud configuration directory. Preserving its contents ...
  XCOPY /E /C /I /F /H /R /Y %ksConfDrive%\kpCloud %buildRoot%
) 

REM  Merging parameters in the configuration parameters file into the enviornment
IF EXIST %buildRoot%\build.conf (
  ECHO.
  ECHO.Injecting key^/value pair from %buildRoot%\build.conf file into the enviornment ...
  FOR /f "delims=" %%x IN (%buildRoot%\build.conf) DO (
    ECHO.  %%x
    SET %%x
  )
) ELSE (
  CMD /K "ECHO.%buildRoot%\build.conf configuration file not found. Exiting to command prompt."
  EXIT 255
)

IF NOT "x%DEBUG%"=="x" @ECHO ON

REM  Derive some of the needed parameters from other enviornment variables that are set
FOR /f "tokens=1-9 delims=/\ " %%a in ("%ks%") DO (
  set ksServer=%%b
  set ksOS=%%d\%%e\%%f
)

ECHO.
ECHO.kpCloud Build OS: %ksOS%
ECHO.    Build Server: %ksServer% 
ECHO.

setlocal enableextensions enabledelayedexpansion

SET scriptRoot=%phaseRoot%\%PHASE%
SET scriptDir=%scriptRoot%.d
IF NOT EXIST %scriptDir% mkdir %scriptDir%

SET scriptLogs=%phaseRoot%\%PHASE%.d.log
IF NOT EXIST %scriptLogs% mkdir %scriptLogs%

SET scriptList=%phaseRoot%\%PHASE%.lst

<NUL SET /P DIS=Waiting on DNS client to be ready
FOR /L %%C IN (1, 1, 60) DO (
  <NUL SET /P DIS=.
  PING -a -n 1 -w 1000 %ksServer% 2>&1 >NUL
  IF ERRORLEVEL 0 GOTO AfterDnsUp
  IF %%C EQU 60 (
    CMD /K "ECHO.DNS Client configurstion via DHCP failed...Exiting to command prompt."
  )
  sleep 1
) 

:AfterDnsUp
ECHO.
IF NOT EXIST %scriptList% (
  IF NOT EXIST z:\ks (
    ECHO.Attaching to Windows share for kpCloud build framework source ...
    IF EXIST z:\* NET USE /d z:
    NET USE z: \\%ksServer%\kpCloud
  ) ELSE (
    ECHO.
  )

  ECHO.Scripts in the framework:
  FOR /F %%I IN ('dir /b /o:n z:\ks\%ksOS%\%PHASE%\??-*') DO (
  COPY /V /Y z:\ks\%ksOS%\%PHASE%\%%I %scriptDir% 2>&1 >nul
    ECHO.  %%I
    ECHO.%%I >>%scriptList%
  )
  COPY /V /Y /A %scriptList% %scriptList%.full >nul
  ECHO.

) ELSE (
  ECHO.
  ECHO.Scripts in the FIFO:
  FOR /F %%I IN (%scriptList%) DO (
    ECHO.  %%I
  )
)

ECHO.

IF NOT EXIST %phaseRoot%\scriptexec.bat (
  wget -O %phaseRoot%\scriptexec.bat http://kpCloud-ks/ks/helper/util/scriptexec.bat
)

START "Running %PHASE% script set." /D %scriptDir% /wait %phaseRoot%\scriptexec.bat %scriptList%

REM  Jump to phase specific tasks
IF /I "%PHASE%"=="pre" CALL :pre
IF /I "%PHASE%"=="post" CALL :post
IF /I "%PHASE%"=="firstboot" CALL :firstboot

ECHO.
ECHO. +++ %PHASE% phase complete.
EXIT 0










REM  pre phase specific tasks
:pre

set ksUnattendFile=%buildRoot%\unattend.xml
ECHO.Getting configuration file for unattended installation ...
wget -O %ksUnattendFile% %ks%

IF EXIST z:\os\src\%ksOS%\setup.exe (
  ECHO.Installing Windows using %ksUnattendFile% file ...
  z:\os\src\%ksOS%\setup.exe /unattend:%ksUnattendFile% /noreboot /m:z:\ks\%ksOS%\$OEM$
)

goto :EOF









REM  post phase specific tasks
:post

ECHO.Preserving kpCloud install logs...

FOR /F "tokens=1,2,*" %%a in ('reg.exe query "HKLM\SYSTEM\MountedDevices" ^| find /i "DosDevices"') DO (
  IF DEFINED DEBUG ECHO.DEBUG: ^%^%a=%%a
  FOR /F "tokens=2 delims=\" %%p in ("%%a") DO IF EXIST %%p\$WINDOWS.~BT (
    IF DEFINED DEBUG ECHO.DEBUG: ^%^%p=%%p
    MKDIR %%p\Windows\kpCloud\build
    SET OSDRIVE=%%p
    XCOPY %SystemRoot%\System32\wpeinit.log %%p\Windows\kpCloud\build\
    XCOPY /E /C /I /F /H /R /Y %TEMP% %%p\Windows
    
  )
)

ECHO. *** REBOOTING ***
type %PhaseLog% >%OSDRIVE%\Windows\kpCloud\build\%PHASE%.log 
start "Reboot..." /min wpeutil reboot

goto :EOF











REM  firstboot phase specific tasks
:firstboot
ECHO. *** REBOOTING ***
shutdown /r /t 1 /c "kpCloud build initiated FINAL reboot." /d p:2:16 

goto :EOF

