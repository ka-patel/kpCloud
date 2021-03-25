@echo off

IF NOT "x%DEBUG%"=="x" @ECHO ON

ECHO Copying and creating Windows BusyBox utility links ...

IF EXIST %SystemRoot%\System32\busybox.exe (
  ECHO Busybox found ...
  for /f %%a in ('%SystemRoot%\System32\busybox.exe --list') do (
    echo linking: %SystemRoot%\System32\%%a
    mklink %SystemRoot%\System32\%%a.exe %SystemRoot%\System32\busybox.exe
  )
) ELSE (
  ECHO Busybox not found. Skipping symlinks creations.
)

exit 0
