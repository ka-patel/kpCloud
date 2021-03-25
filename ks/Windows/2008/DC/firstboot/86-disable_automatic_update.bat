@echo off

IF NOT "x%DEBUG%"=="x" @ECHO ON

Echo Setting automatic update to manual ...

reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v AUOptions /t REG_DWORD /d 2 /f 
