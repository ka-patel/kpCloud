@ECHO off

IF NOT "x%DEBUG%"=="x" @ECHO ON

echo Installing updates ...

set DEST=%SystemRoot%\kpCloud\Build\firstboot\src
set APP=WUInstallAMD64.exe

IF NOT EXIST %DEST%\%APP% (
  mkdir %DEST%
  wget -nv -O %DEST%\%APP% http://%ksServer%/ks/helper/src/%APP%
)

IF EXIST %DEST%\%APP% (
  %ComSpec% /c %DEST%\%APP% /install /autoaccepteula /show_progress /criteria "IsInstalled=0"

  IF ERRORLEVEL 2 (
    EXIT 0
  ) ELSE (
    EXIT 255
  )
)

