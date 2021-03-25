@echo off

IF NOT "x%DEBUG%"=="x" @ECHO ON

ECHO Customizing desktop settings for "default" user ...

FOR /F "tokens=1,2,*" %%a in ('reg.exe query "HKLM\SYSTEM\MountedDevices" ^| find /i "DosDevices"') DO (
  IF DEFINED DEBUG ECHO DEBUG: ^%^%a=%%a
  FOR /F "tokens=2 delims=\" %%p in ("%%a") DO IF EXIST %%p\$WINDOWS.~BT (
    SET OSDRIVE=%%p
  )
)

SET WALLPAPER=%OSDRIVE%\Windows\Web\Wallpaper\Windows\img0.jpg

IF EXIST %WALLPAPER% (
  reg load HKU\kpBuild %OSDRIVE%\Users\Default\ntuser.dat
  FOR /F %%A IN ('reg query "HKU"') DO (
    reg add "%%A\Control Panel\Desktop" /v Wallpaper            /f /t REG_SZ    /d "%WALLPAPER%"
    reg add "%%A\Control Panel\Desktop" /v WallpaperStyle       /f /t REG_SZ    /d "2"
    reg add "%%A\Control Panel\Desktop" /v TileWallpaper        /f /t REG_SZ    /d "0"
    reg add "%%A\Control Panel\Desktop" /v PaintDesktopVersion  /f /t REG_DWORD /d "1"
  )
  reg unload HKU\kpBuild
)

exit

