@echo off

IF NOT "x%DEBUG%"=="x" @ECHO ON

ECHO Setting bginfo background ...

IF EXIST %SystemDrive%\sysinternals\bginfo.exe (
  %SystemDrive%\sysinternals\bginfo.exe /SILENT /NOLICPROMPT /TIMER:0
)

exit 0

