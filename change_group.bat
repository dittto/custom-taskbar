@echo off
IF "%1"=="" (
    echo Group name not set
    exit
)

set LOCAL_FILE=%~dp0
set LOCAL_PATH=%LOCAL_FILE:~0,-1%

set GROUP_NAME=%1%
set GROUP_PATH=%LOCAL_PATH%\group-%GROUP_NAME%

set REG_FILE=%GROUP_PATH%\taskbar_registry.reg
regedit.exe /s %REG_FILE%
echo Imported registry from "%REG_FILE%"

rmdir /s /q "%AppData%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar"
echo Removed old taskbar icons

robocopy "%GROUP_PATH%" "%AppData%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar" /e >nul
echo Copied taskbar links from "%GROUP_PATH%"

echo Restarting explorer
taskkill /f /im explorer.exe
start explorer.exe
echo Restarted explorer
