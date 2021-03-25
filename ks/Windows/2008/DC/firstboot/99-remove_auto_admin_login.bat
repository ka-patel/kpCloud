@echo off

IF NOT "x%DEBUG%"=="x" @ECHO ON

ECHO Removing auto boot registry enteries ...

reg delete  "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v kpCloudInstall /f

reg delete  "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultDomainName /f
reg delete  "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultUserName   /f
reg delete  "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultPassword   /f
reg add     "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v AutoAdminLogon    /f /t REG_SZ    /d "0"
reg add     "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v AutoLogonCount    /f /t REG_DWORD /d "0"

exit 0
