@echo off

IF NOT "x%DEBUG%"=="x" @ECHO ON

set DEST=%SystemRoot%\kpCloud\Build\firstboot\src
set APP=7z920-x64.msi

ECHO Installing %APP% ...

IF NOT EXIST %DEST%\%APP% (
  mkdir %DEST%
  wget -nv -O %DEST%\%APP% http://%ksServer%/ks/helper/src/%APP%
  
  :: Uses msiexec so below switches are nice to install msi package ...
  cd %DEST% & msiexec /i %APP% /passive /norestart /log %DEST%\%APP%.log 
  setx PATH "%PATH%;%SystemRoot%\Program Files\7-Zip\"

)

exit 0
