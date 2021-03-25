@echo off

IF NOT "x%DEBUG%"=="x" @ECHO ON

echo Getting WinPE detected networking adapters ...
netcfg -v -s a

echo Getting WinPE detected networking stack components...
netcfg -v -s n

exit
