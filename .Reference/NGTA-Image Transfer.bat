@echo off

Rem Define the specific location
xcopy E:\ "\\penfileswp00001\EquipmentSoftwareSupport\test" /E
Rem Delete entire folder and files if no error occured
	Rem if %errorlevel% EQU 0 RD E:\ /S /Q