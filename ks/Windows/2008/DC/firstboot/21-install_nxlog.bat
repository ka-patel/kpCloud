@echo off

IF NOT "x%DEBUG%"=="x" @ECHO ON
setlocal enableextensions enabledelayedexpansion

set DEST=%SystemRoot%\kpCloud\Build\firstboot\src
set APP=nxlog-ce-2.7.1191.msi

ECHO Installing %APP% ...

IF NOT EXIST %DEST%\%APP% (
  mkdir %DEST%
  wget -nv -O %DEST%\%APP% http://%ksServer%/ks/helper/src/%APP%
  
  :: Uses msiexec so below switches are nice to install msi package ...
  cd %DEST% & msiexec /i %APP% /passive /norestart /log %DEST%\%APP%.log 

  for /f "delims=," %%z in ("%ProgramFiles(x86)%,%ProgramFiles%") do (
    if exist "%%z\nxlog\conf\nxlog.conf" (
      cd "%%z\nxlog\conf\"
      for /f "delims=" %%a in (nxlog.conf) do (
        SET "s=%%a"
        SET "s=!s:192.168.1.1=10.104.13.224!"
        ECHO.!s! >>nxlog.conf.new
      )
      move /y nxlog.conf.new nxlog.conf
    )
  )

  echo starting nxlog service
  net stop  nxlog
  net start nxlog

)

exit 0
