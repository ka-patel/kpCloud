@echo off

IF NOT "x%DEBUG%"=="x" @ECHO ON

set DEST=%SystemRoot%\kpCloud\Build\firstboot\src
set APP=IE9-Windows7-x64-enu.exe

ECHO Installing %APP% ...

FOR /F "tokens=3" %%t in ('reg query "HKLM\SOFTWARE\Microsoft\Internet Explorer" /v Version') do (
  ECHO IE VERSION DETECTED = %%t
  for /F "delims=. tokens=1" %%s in ('echo %%t') do SET IEVER=%%s
)

IF %IEVER% LSS 9  (

  mkdir %DEST%
  DEL /F /S /Q %DEST%\%APP%

  wget -nv -O %DEST%\%APP% http://%ksServer%/ks/helper/src/%APP%

  IF EXIST %DEST%\%APP% (
    CMD /c %DEST%\%APP% /passive /norestart
  )

  EXIT 255

)

EXIT 0
