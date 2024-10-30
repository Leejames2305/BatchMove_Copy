@echo off
:: Automated script that runs daily in task scheduler, will copy files from one directory to another.
:: In the destination directory, it will create new folder with date and copy files into.

:: Set the source and destination directories
set sourceDir="C:\Users\leex17\OneDrive - Boston Scientific\Desktop\testA"
set destinationDir="C:\Users\leex17\OneDrive - Boston Scientific\Desktop\testB"

:: Get the date of today
for /f "tokens=1-3 delims=-" %%a in ('powershell -command "Get-Date -Format yyyy-MM-dd"') do (
    set year=%%a
    set month=%%b
    set day=%%c
)

:: Create the folder with yesterday's date in the destination directory
set folderName=%year%-%month%-%day%
mkdir %destinationDir%\%folderName%

:: Copy files from source directory to the newly created folder in destination directory
:: Duplicates are not copied
xcopy %sourceDir% %destinationDir%\%folderName% /e /d /q

:: Pause the script to see the output
pause