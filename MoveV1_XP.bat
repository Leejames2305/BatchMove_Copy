@echo off
setlocal enabledelayedexpansion
:: Automated script that runs daily in task scheduler, will move files from one directory to another.
:: In the destination directory, it will split the date into detailed folders, and move files into.
:: (sourceDir\29Dec24\Stuff.xyz) -> (destinationDir\2024\Dec\29\Stuff.xyz)
:: If the folders in SrcDir is not ddMMMyy, it will move all files to a default folder.

:: Set the source and destination directories
:: "sourceDir=F:" OR "sourceDir=C:\SomeFolder"
:: "destinationDir = \\network\shared\folder"
:: "defaultFolder = Line 1\Distal Allignment Machine"
set "sourceDir=F:\"
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
for /F %%i in ('dir /b /a "%sourceDir%"') do (
    echo Source Folder is NOT empty
    goto :continue
)
echo Source Folder is empty
pause
exit /b 1

:continue
:: Make an empty folder to trigger the script 
mkdir "%sourceDir%\emptyTrigger"

:: Get the date from the folders' name, ONLY if it is in ddMMMyy format, else fallback to today's date
for /d %%d in ("%sourceDir%\*") do (
    set folderName=%%~nxd

    REM Is the folder name null?
    if "!folderName!" neq "" (
        REM Check if the date is valid
        if "!folderName:~0,2!" GEQ "01" if "!folderName:~0,2!" LEQ "31" (
            set year=20!folderName:~5,2!
            set month=!folderName:~2,3!
            set day=!folderName:~0,2!
            echo Processing folder: %%d
            echo Year:!year! Month:!month! Day:!day!
            
            REM Create the date folder in the destination directory
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
        ) else (
            REM Get the date of today (Assumming in dd-MMM-yy)
            for /f "tokens=1-3 delims=-" %%a in ('date /t') do (
                set year=20%%c
                set month=%%b
                set day=%%a
            )
            set year=!year: =!

            REM Create the date folder in the destination directory
            set "datePath=%destinationDir%\!year!\!month!\!day!\!defaultFolder!"

            if not exist "!datePath!" (
                mkdir "!datePath!"
            )

            REM Move all files
            set "moveFailed=0"
            for /R "%sourceDir%" %%f in (*.*) do (
                echo Moving file: %%f
                move "%%f" "!datePath!"
                if !errorlevel! neq 0 set "moveFailed=1"
            )

            if !moveFailed! equ 0 (
                for /d %%d in ("%sourceDir%\*") do (
                    echo Deleting folder: %%d
                    rmdir "%%d" /s /q
                )
            )
        )
    )
)
endlocal

:: Pause the script to see the output
pause