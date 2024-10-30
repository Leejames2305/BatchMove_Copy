@echo off
:: Automated script that runs daily in task scheduler, will copy files from one directory to another.
:: In the destination directory, it will create new folder with date and copy files into.

:: Set the source and destination directories
set "sourceDir=C:\Documents and Settings\Administrator\Desktop\testA"
set "destinationDir=C:\Documents and Settings\Administrator\Desktop\testB"

:: Get the date of today
for /f "tokens=1-3 delims=-" %%a in ('date /t') do (
    set year=%%a
    set month=%%b
    set day=%%c
)

:: Create the folder with today's date in the destination directory
set "datePath=%destinationDir%\%year%\%month%\%day%"

if not exist  "%datePath%" (
    mkdir "%datePath%"
)

:: Copy files from source to newly created folder in destination, duplicates are not copied
xcopy "%sourceDir%" "%datePath%" /e /d /q

:: Pause the script to see the output
pause