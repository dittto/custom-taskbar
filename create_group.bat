@echo off
IF "%1"=="" (
    echo Group name not set
    exit
)

set LOCAL_FILE=%~dp0
set LOCAL_PATH=%LOCAL_FILE:~0,-1%
set CHANGE_GROUP_FILE=%LOCAL_PATH%\change_group.bat

set GROUP_NAME=%1%
set GROUP_PATH=%LOCAL_PATH%\group-%GROUP_NAME%
echo Group set to "%1%"

if not exist "%GROUP_PATH%" (
    mkdir "%GROUP_PATH%" >nul
    echo Created group folder for "%GROUP_PATH%"
)

set SHORTCUTS_PATH=%LOCAL_PATH%\shortcuts
if not exist "%SHORTCUTS_PATH%" (
    mkdir "%SHORTCUTS_PATH%" >nul
    echo Created shortcuts folder for "%SHORTCUTS_PATH%"
)

robocopy "%AppData%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar" "%GROUP_PATH%" /e >nul
echo Copied taskbar links to "%GROUP_PATH%"

set REG_FILE=%GROUP_PATH%\taskbar_registry.reg
regedit /E "%REG_FILE%" "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband"
echo Exported registry to "%REG_FILE%"

set SHORTCUT_FILE=%SHORTCUTS_PATH%\%GROUP_NAME%.lnk
echo Set oWS = WScript.CreateObject("WScript.Shell") > temp_create_shortcut.vbs
echo sLinkFile = "%SHORTCUT_FILE%" >> temp_create_shortcut.vbs
echo Set oLink = oWS.CreateShortcut(sLinkFile) >> temp_create_shortcut.vbs
echo oLink.TargetPath = "%CHANGE_GROUP_FILE%" >> temp_create_shortcut.vbs
echo oLink.Arguments = "%GROUP_NAME%" >> temp_create_shortcut.vbs
echo oLink.Description = "%GROUP_NAME% taskbar group" >> temp_create_shortcut.vbs
echo oLink.Save >> temp_create_shortcut.vbs
cscript temp_create_shortcut.vbs >nul
del temp_create_shortcut.vbs >nul
echo Created shortcut for %SHORTCUT_FILE%
