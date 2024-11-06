@echo off
setlocal enabledelayedexpansion
:: Automated script that runs daily in task scheduler, will move files from one directory to another.
:: In the destination directory, it will split the date into detailed folders, and move files into.
:: (SourceDir\29Dec24\Stuff.xyz) -> (DestinationDir\2024\12\29\Stuff.xyz)

:: Set the source and destination directories
set "sourceDir=F:"
set "destinationDir=\\vmware-host\Shared Folders\tempshared"

:: Get the date from the folders' name
for /d %%d in (%sourceDir%\*) do (
    set folderName=%%~nxd
    set year=20!folderName:~5,2!
    set month=!folderName:~2,3!
    set day=!folderName:~0,2!
    echo Year:!year! Month:!month! Day:!day!
    
    REM Create the folder with today's date in the destination directory
    set "datePath=%destinationDir%\!year!\!month!\!day!"

    if not exist "!datePath!" (
        mkdir "!datePath!"
    )

    REM Move files from source to newly created folder in destination
    xcopy "%%d\*" "!datePath!" /e /d /q /y

    REM Remove the source folder
    if !errorlevel! equ 0 (
        echo Copy success, deleting folder: %%d
        rmdir "%%d" /s /q
    ) else (
        echo Copy failed, not deleting folder: %%d
    )
)
endlocal

:: Pause the script to see the output
pause