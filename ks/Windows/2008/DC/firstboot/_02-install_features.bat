@echo off

IF NOT "x%DEBUG%"=="x" @ECHO ON

:: Use 'dism /Online /Get-Features' command to display available features to enable
:: See http://technet.microsoft.com/en-us/library/ff715741.aspx for list of all packages

dism /Online /NoRestart /enable-feature:CoreFileServer

dism /Online /NoRestart /enable-feature:NetFx3

dism /Online /NoRestart /enable-feature:MicrosoftWindowsPowerShellISE
dism /Online /NoRestart /enable-feature:ActiveDirectory-PowerShell

dism /Online /NoRestart /enable-feature:RemoteAssistance

dism /Online /NoRestart /enable-feature:SNMP
dism /Online /NoRestart /enable-feature:WMISnmpProvider

dism /Online /NoRestart /enable-feature:SUA

dism /Online /NoRestart /enable-feature:TelnetClient

dism /Online /NoRestart /enable-feature:NetworkLoadBalancingFullServer

dism /Online /NoRestart /enable-feature:InkSupport
dism /Online /NoRestart /enable-feature:DesktopExperience

dism /Online /NoRestart /enable-feature:StorageManagerForSANs

dism /Online /NoRestart /enable-feature:TFTP

dism /Online /NoRestart /enable-feature:MultipathIo

dism /Online /NoRestart /enable-feature:TIFFIFilter

dism /Online /NoRestart /enable-feature:WindowsRecoveryDisc

dism /Online /NoRestart /enable-feature:WindowsServerBackup
dism /Online /NoRestart /enable-feature:WindowsServerBackupCommandlet

dism /Online /NoRestart /enable-feature:WSRM

dism /Online /NoRestart /enable-feature:XPS-Viewer

exit 0
