# TakeOut-GooglePhotos-Cleaner
Clean Google Photos archive from Google's TakeOut

Before executing script :

    Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope CurrentUser

TODO check if policy modification survives a computer restart

Usage :

    C:\dev\repo\TakeOut-GooglePhotos-Cleaner\step0-launcher.ps1
        -takeOutArchivePath "C:\take-out-archive\Google Photos"
        -referenceFolderPath "D:\Nos Photos"
        -unknownFolderPath "C:\take-out-archive\workspace"
        -logFile "C:\take-out-archive\workspace\cleaner.log"