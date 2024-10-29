@echo off
setlocal enabledelayedexpansion
:: Automated script that runs daily in task scheduler, will copy files from one directory's folders to another.
:: In the destination directory's folder, it will create new folder with date (yesterday) inside each subfolder and copy files into.

:: Set the source and destination directories
set sourceDir="C:\Documents and Settings\Administrator\Desktop\testA"
set destinationDir="C:\Documents and Settings\Administrator\Desktop\testB"

:: Get the date of today
for /f "tokens=1-3 delims=-" %%a in ('date /t') do (
    set year=%%a
    set month=%%b
    set day=%%c
)

:: Create the date folder name
set folderName=%year%-%month%-%day%
set folderName=%folderName: =%

:: Iterate over each subfolder in the source directory
for /d %%d in (%sourceDir%\*) do (
    set subfolder=%%~nxd
    :: Don't comment out next line, somehow syntax breaks without it
    echo Processing subfolder: !subfolder!

    :: Create the corresponding subfolder in the destination directory if it doesn't exist
    if not exist %destinationDir%\"!subfolder!" (
        mkdir %destinationDir%\"!subfolder!"
    )

    :: Create the date folder inside the subfolder in the destination directory
    if not exist %destinationDir%\"!subfolder!"\%folderName% (
        mkdir %destinationDir%\"!subfolder!"\%folderName%
    )

    :: Copy files from the source subfolder to the newly created date folder in the destination subfolder, Duplicates are not copied
    xcopy %sourceDir%\"!subfolder!"\* %destinationDir%\"!subfolder!"\%folderName% /s /e /d /q
)
endlocal

:: Pause the script to see the output
pause