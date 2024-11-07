@echo off
setlocal enabledelayedexpansion
:: Automated script that runs daily in task scheduler, will move files from one directory to another.
:: It will search for date-formatted folder in sourceDir, and creates date folders based on it in destinationDir.
:: (SourceDir\Line\Mac\29Dec24\Stuff.xyz) -> (DestinationDir\2024\Dec\29\Line\Mac\Stuff.xyz)
:: (SourceDir\Line\Mac\Pass\29Dec24\Stuff.xyz) -> (DestinationDir\2024\Dec\29\Line\Mac\Pass\Stuff.xyz)

:: Set the source and destination directories
set "sourceDir=F:"
set "destinationDir=\\vmware-host\Shared Folders\tempshared"

:: Loop through all files in the source directory
for /r "%sourceDir%" %%A in (*) do (
    REM Get the full path of the file
    set "file=%%A"

    REM Get the directory path of the file
    set "fileDir=%%~dpA"

    REM Remove the source directory from the file directory to get the relative path
    set "relativePath=!fileDir:%sourceDir%=!"

    REM Remove leading backslash
    if "!relativePath:~0,1!"=="\" set "relativePath=!relativePath:~1!"

    REM Split the relative path into tokens using backslash as delimiter
    set "dateFolder="
    set "subFolders="

    for %%I in ("!relativePath:\=" "!") do (
        REM Check if the folder name matches the date format (e.g., '29Dec24')
        if not defined dateFolder (
            set "folderName=%%~I"
            set "checkDay=!folderName:~0,2!"
            if !checkDay! GEQ 1 if !checkDay! LEQ 31 (
                set "dateFolder=!folderName!"
            ) else (
                if defined subFolders (
                    set "subFolders=!subFolders!\%%~I"
                ) else (
                    set "subFolders=%%~I"
                )
            )
        ) else (
            if defined subFolders (
                set "subFolders=!subFolders!\%%~I"
            ) else (
                set "subFolders=%%~I"
            )
        )
    )

    REM Extract day, month, and year from dateFolder
    set "day=!dateFolder:~0,2!"
    set "month=!dateFolder:~2,3!"
    set "year=20!dateFolder:~5,2!"

    REM Construct the destination path
    if defined subFolders (
        set "destPath=%destinationDir%\!year!\!month!\!day!\!subFolders!"
    ) else (
        set "destPath=%destinationDir%\!year!\!month!\!day!"
    )

    echo Processing file: !file!
    echo File directory: !fileDir!
    echo Relative path: !relativePath!
    echo Date folder: !dateFolder!
    echo Subfolders: !subFolders!

    REM Create the destination directory if it doesn't exist
    REM if not exist "!destPath!" mkdir "!destPath!"

    REM Move the file
    REM move "!file!" "!destPath!"
)
endlocal

pause