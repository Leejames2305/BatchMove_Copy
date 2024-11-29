@echo off
setlocal EnableDelayedExpansion

set "sourceDir=C:\Users\leex17\Downloads\copyA"
set "destDir=C:\Users\leex17\Downloads\dest"

:: Get user inputs
set /p "searchPattern=Enter search pattern: "

:: Create array to store matches
set count=0

echo.
echo Searching for files matching pattern: %searchPattern%
echo.

:: Find and list matching files
for /r "%sourceDir%" %%F in (*%searchPattern%*) do (
    set /a count+=1
    set "file[!count!]=%%F"
    echo !count!. %%F
)

if %count%==0 (
    echo No files found matching the pattern.
    pause
    goto :eof
)

:: Get user confirmation
set /p "confirm=Proceed with copying these files? (y/n): "
if /i "%confirm%" neq "y" (
    echo Operation cancelled.
    goto :eof
)

:: Create destination directory
mkdir "%destDir%"

:: Copy files
echo.
echo Copying files...
for /l %%i in (1,1,%count%) do (
    copy "!file[%%i]!" "%destDir%"
)

echo.
echo Files copied to: %destDir%
pause