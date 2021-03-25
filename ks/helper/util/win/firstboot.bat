@echo off

IF NOT "x%DEBUG%"=="x" @ECHO ON

color 1F

ECHO.
ECHO.-----------------------------------------------
ECHO.     kpCloud's vCloud build for Windows
ECHO.-----------------------------------------------
ECHO.

SET PHASE=firstboot
SET buildRoot=%SystemRoot%\kpCloud\build
SET phaseRoot=%buildRoot%\%PHASE%
SET phaseLog=%buildRoot%\%PHASE%.log

SET WRAPPER=wrapper.cmd

echo Getting %WRAPPER% ...
busybox wget -O %phaseRoot%\%PHASE%.cmd http://kpCloud-ks/ks/helper/util/%WRAPPER%

echo.
echo Continueing vCloud Windows build. Please wait ...

(
 echo.
 echo.---------------------{ BOOT MARKER }---------------------
 date /t
 time /t
 echo.
) >>%phaseLog%

start "kpCloud Build %PHASE% phase script run console" /D %buildRoot% /WAIT cmd /V:ON /K "color 3f & echo Running %PHASE%.cmd ... & %phaseRoot%\%PHASE%.cmd >>%phaseLog% 2>&1"

