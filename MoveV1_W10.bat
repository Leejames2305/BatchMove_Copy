@echo off
setlocal enabledelayedexpansion
:: Automated script that runs daily in task scheduler, will move files from one directory to another.
:: In the destination directory, it create folders with current date, and move files into.

:: Set the source and destination directories
:: "sourceDir=F:" OR "sourceDir=C:\SomeFolder"
:: "destinationDir = \\network\shared\folder"
:: "defaultFolder = Line 1\Distal Allignment Machine"
set "sourceDir=F:"
set "destinationDir=\\vmware-host\Shared Folders\tempshared"
set "defaultFolder=Line 3\Distal Allignment Machine"

:: Check both directories are valid
if not exist "%sourceDir%" (
    echo Source directory does not exist: %sourceDir%
    pause
    exit /b 1
)

if not exist "%destinationDir%" (
    echo Destination directory does not exist: %destinationDir%
    pause
    exit /b 1
)

:: Check if the source directory is empty
dir /b "%sourceDir%" | findstr . >nul
if errorlevel 1 (
    echo Source is empty
    pause
    exit /b 1
) else (
    echo Source is not empty
)

:: Get the current date
for /f "tokens=1-3 delims=-" %%a in ('powershell -command "Get-Date -Format yyyy-MMM-dd"') do (
    set year=%%a
    set month=%%b
    set day=%%c
)

:: Create the date folder in the destination directory
set "datePath=%destinationDir%\%year%\%month%\%day%\%defaultFolder%"

if not exist "%datePath%" (
    mkdir "%datePath%"
)

:: Move files from subdirectories in source to destination
for /D %%i in ("%sourceDir%\*") do (
    robocopy "%%i" "%datePath%\%%~ni" /MOVE /E /IT
)
mkdir "%sourceDir%\Balloon Inspection"
mkdir "%sourceDir%\Balloon InspectionFail"

:: Pause the script to see the output
pause