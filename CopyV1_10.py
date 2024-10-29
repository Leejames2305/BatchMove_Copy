## Automated script that runs daily in task scheduler, will copy files from one directory to another.
## In the destination directory, it will create new folder with date (yesterday) and copy files into.

import sys
import os
import shutil
import datetime

# --------------------------- Variables ---------------------------
sourceDir = 'C:/Users/leex17/OneDrive - Boston Scientific/Desktop/testA'
destinationDir = 'C:/Users/leex17/OneDrive - Boston Scientific/Desktop/testB'
# -----------------------------------------------------------------

yesterday = datetime.datetime.now() - datetime.timedelta(days=1)
yesterday = yesterday.strftime('%Y-%m-%d')
destinationDir = destinationDir + '/' + yesterday       # ./Desktop/testB/2024-10-27

# today = datetime.datetime.now().strftime('%Y-%m-%d')
# destinationDir = destinationDir + '/' + today             # ./Desktop/testB/2024-10-28

def copying_files(sourceDir, destinationDir):
    if not os.path.exists(destinationDir):
        os.makedirs(destinationDir)

    for item in os.listdir(sourceDir):
        source_item = os.path.join(sourceDir, item)
        destination_item = os.path.join(destinationDir, item)

        if os.path.isdir(source_item):
            shutil.copytree(source_item, destination_item)
        else:
            shutil.copy2(source_item, destination_item)

copying_files(sourceDir, destinationDir)