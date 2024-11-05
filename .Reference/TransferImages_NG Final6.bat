@echo off
:: CopyImages.bat Created by Khairul Khalis on 3Feb2024 V1 specifically for NGTA PC Windows10
:: The file/directory will be deleted after copying and create back the same folder.
:: Source1 "C:\Images\Balloon Inspection"
:: Source2 "C:\Images\Balloon InspectionFail"
:: Destination1 \\gspens3glp00001\NGTA\NGTA\Autotransfer\Line6\NGfinal\BalloonInspection
:: Destination2 \\gspens3glp00001\NGTA\NGTA\Autotransfer\Line6\NGfinal\BalloonInspectionFail
:: [/E] Copy subfolders including empty subfolders
:: [/DCOPY:T] Copy directory timestamp
:: [/MOV] Delete from source after copying
:: [IS] include same file
:: [IT] include Tweaked file
:: The process will be skipped if the folder already exist in the destination location. Means it will not transfer or delete the folder and file.
:: The process for 200mb took less than 2 min to complete transfer and delete


robocopy "C:\Images\Balloon Inspection" \\gspens3glp00001\NGTA\NGTA\Autotransfer\Line6\NGfinal\BalloonInspection /E /V /IS /IT /DCOPY:T /MOVE /ETA /LOG+:"\\gspens3glp00001\NGTA\NGTA\Autotransfer\Line6\NGfinal\LogPass.txt"
robocopy "C:\Images\Balloon InspectionFail" \\gspens3glp00001\NGTA\NGTA\Autotransfer\Line6\NGfinal\BalloonInspectionFail /E /V /IS /IT /DCOPY:T /MOVE /ETA /LOG+:"\\gspens3glp00001\NGTA\NGTA\Autotransfer\Line6\NGfinal\LogFail.txt"
Mkdir "C:\Images\Balloon Inspection"
Mkdir "C:\Images\Balloon InspectionFail"