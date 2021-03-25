@echo off

IF NOT "x%DEBUG%"=="x" @ECHO ON

set DEST=%SystemRoot%\kpCloud\Build\firstboot\src
set APP=nircmd-x64.zip

ECHO Installing %APP% ...

IF NOT EXIST %DEST%\%APP% (
  mkdir %DEST%
  wget -nv -O %DEST%\%APP% http://%ksServer%/ks/helper/src/%APP%

  IF EXIST %DEST%\%APP% (
    cd "%SystemDrive%\Program Files\7-Zip\" & 7z.exe x -y -o%SystemRoot%\System32 %DEST%\%APP%
    %SystemRoot%\System32\nircmd.exe win child class "Shell_TrayWnd" show class "TrayClockWClass" 
    %SystemRoot%\System32\nircmd.exe setdisplay 1280 720 32 -updatereg -allusers
    %SystemRoot%\System32\nircmd.exe screensavertimeout 20
  )

)

exit 0
