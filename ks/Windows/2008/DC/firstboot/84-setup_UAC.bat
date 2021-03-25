@echo off

IF NOT "x%DEBUG%"=="x" @ECHO ON

Echo Windows7 / Vista Stuff... Please ignore if you are not using.

Echo Disable UAC
%windir%\System32\reg.exe ADD HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v EnableLUA /t REG_DWORD /d 0 /f

