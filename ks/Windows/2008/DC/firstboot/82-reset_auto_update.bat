@echo off

IF NOT "x%DEBUG%"=="x" @ECHO ON

echo Resetting Automatic Updates

net stop "Windows Update"

del /f /s /q %windir%\SoftwareDistribution
echo.
net start "Windows Update"

echo Forcing AU detection and resetting authorization tokens...

wuauclt.exe /resetauthorization /detectnow 
