@echo off

IF NOT "x%DEBUG%"=="x" @ECHO ON

set DEST=%SystemRoot%\kpCloud\Build\firstboot\src
set APP=Git-1.8.5.2-preview20131230.exe

ECHO Installing %APP% ...

IF NOT EXIST %DEST%\%APP% (
  mkdir %DEST%
  wget -nv -O %DEST%\%APP% http://%ksServer%/ks/helper/src/%APP%

  IF EXIST %DEST%\%APP% (
    %ComSpec% /c %DEST%\%APP% /silent /log=%DEST%\%APP%.log /nocancel /norestart /closeapplications /sp
  )
)

exit 0
