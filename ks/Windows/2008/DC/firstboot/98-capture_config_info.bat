@echo off

IF NOT "x%DEBUG%"=="x" @ECHO ON

ECHO Gathering and preserving network indformation ...

systeminfo

SET MYLOG=%scriptLogs%\%~n0.d
mkdir %MYLOG%
START "Gatehring network info ..." /d %MYLOG% /wait cmd /C "ECHO Gatehring network info ... & cscript %SystemRoot%\System32\gatherNetworkInfo.vbs "

exit 0
