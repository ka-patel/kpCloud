@echo off

IF NOT "x%DEBUG%"=="x" @ECHO ON

IF NOT EXIST "%SystemDrive%\Program Files\7-Zip\7z.exe" (
  ECHO 7z unzipping program not found ... exiting.
  EXIT 1
)

set DEST=%SystemRoot%\kpCloud\Build\firstboot\src

echo Detecting type of System ...
FOR /F "skip=1 tokens=1,2,*" %%a in ('reg.exe query "HKLM\SYSTEM\CurrentControlSet\Control\SystemInformation" ^| find /i "System"') DO (
  echo Setting: %%a=%%c
  SET %%a=%%c
)

IF "%SystemProductName%"=="VMware Virtual Platform" GOTO VMware
IF "%SystemProductName%"=="Parallels Virtual Platform" GOTO parallels

GOTO end











:VirtualBox

ECHO VirtualBox virtual system ...

set APP=VBoxWindowsAdditions-amd64.exe

IF NOT EXIST "%DEST%\%APP%" (

  wget -nv -O %DEST%\%APP% http://%ksServer%/ks/helper/src/GuestAdditions/%APP% 

  ECHO Installing guest tools ...
  %ComSpec% /c %DEST%\%APP% /S 
)

GOTO end







:VMware

ECHO VMware virtual system ...

set APP=VMware-tools-windows-9.4.5-1598834.iso

IF NOT EXIST "%DEST%\%APP%" (
  wget -nv -O %DEST%\%APP% http://%ksServer%/ks/helper/src/GuestAdditions/%APP%

  %SystemDrive% & cd "\Program Files\7-Zip\" & 7z.exe x -y -o%DEST%\%APP%.d %DEST%\%APP%

  ECHO Installing guest tools ...
  cd %DEST%\%APP%.d & setup /s /v "/qb- /l*v %DEST%\%APP%.log REBOOT=ReallySuppress ADDLOCAL=ALL"
  REM :: pnputil -i -a "%CommonProgramFiles%\VMWare\Drivers\video_wddm\vm3d.inf"

  exit 255
)

GOTO end






:Parallels

ECHO Parallel virtual system ...

set APP=prl-tools-win.tar
wget -nv -O %DEST%\%APP% http://%ksServer%/ks/helper/src/GuestAdditions/%APP%
cd "%SystemDrive%\Program Files\7-Zip\" & 7z.exe x -y -o%DEST%\%APP%.d %DEST%\%APP%
ECHO Installing guest tools ...
cd %DEST%\%APP%.d & PTAgent.exe /install_silent
GOTO end







:end
exit 0

