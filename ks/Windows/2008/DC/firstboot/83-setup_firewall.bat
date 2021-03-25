@echo off

IF NOT "x%DEBUG%"=="x" @ECHO ON

Echo Configuring firewall...
netsh firewall set service remoteadmin enable

Echo Enable Ping test ...
netsh firewall set icmpsetting 8 

Echo Win7 Firewall setup ...
netsh advfirewall set currentprofile settings remotemanagement enable 
netsh advfirewall firewall set rule group="windows management instrumentation (WMI)" new enable=Yes
netsh advfirewall firewall set rule group="remote administration" new enable=yes

