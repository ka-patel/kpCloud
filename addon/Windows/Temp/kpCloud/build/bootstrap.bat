@ECHO off

color F1

REM
REM See http://technet.microsoft.com/en-us/library/dd744245%28WS.10%29.aspx for how-to on injecting a script into WinPE and the man pages
REM for Ubuntu utility called mkwinpeimg.
REM

ECHO.
ECHO.      -----------------------------------------------
ECHO.          Kalpesh Patel kpCloud build for Windows
ECHO.      -----------------------------------------------
ECHO.

ECHO.Loading WinPE network stack.
netcfg -winpe

ECHO.Waiting on network to be up.
ECHO.
wpeinit

color 1F
SET WRAPPER=wrapper.cmd
SET buildRoot=%TEMP%\kpCloud\build

call :runPhase pre 2F
call :runPhase post 3F

ECHO.Dropping to command prompt ...
cmd.exe /x /f:on /q

color
goto :EOF




:runPhase

SET PHASE=%1
SET phaseRoot=%buildRoot%\%PHASE%
SET phaseLog=%buildRoot%\%PHASE%.log

mkdir %phaseRoot%

ECHO.Getting %WRAPPER% ...
wget -O %phaseRoot%\%PHASE%.cmd http://kpCloud-ks/ks/helper/util/%WRAPPER%

ECHO.Executing %PHASE% phase ... please be patient!
start "kpCloud Build %PHASE% phase script run console" /D %buildRoot% /WAIT cmd /V:ON /K "cd %phaseRoot% & color %2 & %PHASE%.cmd 2>&1 >%phaseLog%" 

ECHO.%PHASE% phase complete ...

EXIT /b 0



