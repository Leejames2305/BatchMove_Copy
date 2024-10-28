@echo off
setlocal enabledelayedexpansion
:: Automated script that runs daily in task scheduler, will copy files from one directory to another.
:: In the destination directory, it will create new folder with date (yesterday) inside each subfolder and copy files into.

:: Set the source and destination directories
set sourceDir="C:\Users\leex17\OneDrive - Boston Scientific\Desktop\testA"
set destinationDir="C:\Users\leex17\OneDrive - Boston Scientific\Desktop\testB"

:: Get the date of yesterday
for /f "tokens=1-3 delims=-" %%a in ('powershell -command "Get-Date ((Get-Date).AddDays(-1)) -Format yyyy-MM-dd"') do (
    set year=%%a
    set month=%%b
    set day=%%c
)

:: Create the date folder name
set folderName=%year%-%month%-%day%

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
    mkdir %destinationDir%\"!subfolder!"\%folderName%

    @REM :: Copy files from the source subfolder to the newly created date folder in the destination subfolder
    @REM :: Duplicates are not copied
    @REM xcopy %%d\* %destinationDir%\!subfolder!\%folderName% /s /e /d
)
endlocal

:: Pause the script to see the output
pause