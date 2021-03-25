@echo off

IF NOT "x%DEBUG%"=="x" @ECHO ON

set DEST=%SystemRoot%\kpCloud\Build\firstboot\src
set APP=SysinternalsSuite.zip

ECHO Installing %APP% ...

IF NOT EXIST %DEST%\%APP% (
  mkdir %DEST%
  wget -nv -O %DEST%\%APP% http://%ksServer%/ks/helper/src/%APP%

  IF EXIST %DEST%\%APP% (
    cd "%SystemDrive%\Program Files\7-Zip\" & 7z.exe x -y -o%SystemDrive%\sysinternals\ %DEST%\%APP%
  )

)

exit 0

