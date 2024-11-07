@echo off
setlocal enabledelayedexpansion
:: Automated script that runs daily in task scheduler, will move files from one directory to another.
:: It will extract every images' file, and creates date folders in destinationDir to put them in.

:: Set the source and destination directories
set "sourceDir=F:"
set "destinationDir=\\vmware-host\Shared Folders\tempshared"

:: Get the date of today (Assumming in dd-MMM-yy)
for /f "tokens=1-3 delims=-" %%a in ('date /t') do (
    set year=20%%c
    set month=%%b
    set day=%%a
)
set year=%year: =%

:: Create the date folder in the destination directory
set "datePath=%destinationDir%\!year!\!month!\!day!\"

if not exist "!datePath!" (
    mkdir "!datePath!"
)

:: Move all files
for /R "%sourceDir%" %%f in (*.*) do (
    echo Moving file: %%f
)

pause