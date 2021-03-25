@ECHO off

IF NOT "x%DEBUG%"=="x" @ECHO ON

setlocal enableextensions enabledelayedexpansion

IF "x%1"=="x" (
  ECHO.FIFO file not specified as the first argument to the script.
  EXIT 255
)

SET FIFO=%1
SET FIFONEW=%FIFO%.new
SET REGSAVE=Winlogin.hiv

IF NOT EXIST %REGSAVE% (
  ECHO.Saving auto login registry enteries...
  reg save "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" %REGSAVE% 
)

FOR /F %%A IN (%FIFO%) DO (
  ECHO.Running: %%A

  IF NOT "x%%A"=="x" (
    (ECHO.-------------------------------------------
     ECHO.SCRIPT: %%A
     ECHO. START: !DATE! !TIME!
     ECHO.-------------------------------------------
     ECHO.
    ) 

    IF %%~xA==.bat (
      CALL CMD /C %%A 2>&1
    ) ELSE IF %%~xA==.cmd (
      CALL CMD /C %%A 2>&1
    ) ELSE IF %%~xA==.reg (
      CALL CMD /C REG import %%A 2>&1
    ) ELSE IF %%~xA==.vbs (
      CALL CMD /C cscript %%A 2>&1
    ) ELSE IF %%~xA==.ps1 (
      CALL CMD /C powershell -NoProfile -ExecutionPolicy bypass -File %%A 2>&1
    ) ELSE (
      ECHO.Unsupported extension type of '%%~xA' for %%A script. Skipped!
    )

    IF ERRORLEVEL 255 ECHO. & ECHO. +++ REBOOTING: !DATE! !TIME! & ECHO. & GOTO REBOOT
    IF /I "%REBOOT%"=="yes" ECHO. & ECHO. +++ REBOOTING: !DATE! !TIME! & ECHO. & GOTO REBOOT

    (ECHO.
     ECHO.-------------------------------------------
     ECHO.  END: !DATE! !TIME!
     ECHO.-------------------------------------------
    ) 
  ) >> %scriptLogs%\%%A.log

  <nul (set /p z=) >%FIFONEW%
  FOR /F "skip=1" %%N IN (%FIFO%) DO ECHO.%%N >>%FIFONEW%
  COPY /V /Y /A %FIFONEW% %FIFO% >nul
)

del /f %REGSAVE%
EXIT 0

:REBOOT
reg restore "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" %REGSAVE% 
SHUTDOWN /R /F /T 2 /C "kpCloud build initiated intrim reboot ..." /D P:2:4 
CMD /C "ECHO. *** REBOOTING ***"
