# TakeOut-GooglePhotos-Cleaner

Clean Google Photos archive got from Google's TakeOut, in order to synchronize it with a Local Backup Folder.  

## My Usage Case: why I developed this script ?

I had numerous photos saved locally on my computer in an original and full size, and synchronized with [Google Photos](https://photos.google.com/), using Google Sync. However, I knew I did not have all pictures uploaded by Google Photos. Because of previous computer synchronization and pictures taken using my smartphone and synchronized with Google Photos but not with my local backup.  

Through [Take Out](https://takeout.google.com/), Google provides a way to download all what you want they own about you, including all photos coming from [Google Photos](https://photos.google.com/). It is a nice way to download all pictures you have not on your local computer, typically photos taken with your phone.  

However, Take Out archive comes with:
- a description JSON file for each photo,
- pictures from your Google Drive,
- pictures in a not-original-size (so you do not want to keep this version if your local one is in a better quality), 
- flat folder structure (if you had pictures folders in pictures folders, forget it in your Take Out Archive: they are all moved up to root level),
- a lot, and a lot, and a lot, and a lot of photos you have taken, making comparison with your local backup very... hum... boring (45.000 files in my case).

I needed a solution to clean and reorganize Take Out Archive, and then compare it and my Local Backup Folder in order to identify only photos stored on Google Photos.

## Script behavior

Script is composed of several steps with a different objective each time:

1. Step 1: deleting all JSON files from Take Out Archive
2. Step 2: deleting empty folders (some folders contained just a JSON file. Do not ask...), from Take Out Archive
3. Step 3: trying to reorganize Take Out Google Photos folder in order to copy your local backup folder (pre-requisite to step 4)
    - Folders which are not found in Local Backup Folder are moved to a `\not-found` directory to be processed manually later
    - Folders for which several possible folders are found in Local Backup Folder are moved to a `\several-matches` directory to be processed manually later
4. Step 4: comparing files in Take Out Archive and your local backup in order to delete those which are on both sides.

All actions are logged in log file, where you can control script behavior. You can also use it to understand where several folder matches have been found.  

## How to use script ?

Script is written in `Power Shell`, so can work only on Windows.  
It is advised to execute it under a `Power Shell console` in order to benefit Progress Bars display (which are welcomed when script processes thousand and thousand of files).  

Before executing script :

    Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope CurrentUser

Do not forget to come back to a lower level of `Power Shell Execution Policy`: by default `Restricted`, to replace `Bypass`.  

Usage :

    C:\dev\repo\TakeOut-GooglePhotos-Cleaner\step0-launcher.ps1
        -takeOutArchivePath "C:\take-out-archive\Google Photos"
        -referenceFolderPath "D:\Nos Photos"
        -unknownFolderPath "C:\take-out-archive\workspace"
        -logFile "C:\take-out-archive\workspace\cleaner.log"