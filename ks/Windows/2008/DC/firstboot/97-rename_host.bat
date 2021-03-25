@echo off

IF NOT "x%DEBUG%"=="x" @ECHO ON

Echo Renaming host to %localbuild% ...

:: Inject parameters defined in the configuration parameters file into the enviornment
IF EXIST %SystemRoot%\kpCloud\Build\build.conf (
  FOR /f "delims=" %%x IN (%SystemRoot%\kpCloud\Build\build.conf) DO (
    echo Setting: %%x
    SET %%x
  )
)

IF DEFINED localbuild (
  FOR /F %%A IN ('hostname') DO (
    IF /I %%A NEQ %localbuild% (
      netdom renamecomputer %COMPUTERNAME% /Newname:%localbuild% /Force 
      EXIT 255
    )
  )
)
