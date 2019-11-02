<#
.SYNOPSIS
    Launch and chain all scripts to clean Google Photos archive, from Google's TakeOut.
    It allows lauching separately each step manually if required.
.PARAMETER takeOutArchivePath
    Path to the root folder containing Google Photos archive.
    By default, ".\test-resources\take-out-archive" in order to perform tests.
.PARAMETER unknownFolderPath
    Path to the folder where to store folders and files for what we do not know what to do.
    By default, ".\test-resources\take-out-archive-unknown" in order to perform tests.
.PARAMETER logFile
    Path of the file where to log all this script's actions.
    By default, ".\takeout-googlephotos-cleaner.log" in root folder, ignored by GIT.
.PARAMETER testProcess
    DO NOT SET TO 1 IF WORKING ON ORIGINAL FILES !!!
    If set to 1 :
        - Cleaning test work folders by definitively removing all $takeOutArchivePath and $unknownFolderPath folders and files.
        - Then copying the test-folder as the Take Out Archive.
#>

param(  [string] $takeOutArchivePath = ".\test-resources\take-out-archive",
        [string] $referenceFolderPath = ".\test-resources\reference-folder",
        [string] $unknownFolderPath = ".\test-resources\take-out-archive-unknown",
        [string] $logFile = ".\takeout-googlephotos-cleaner.log",
        [bool] $testProcess = 0)


Clear-Content $logFile

# if we are launching tests, preparing folders
if ( $testProcess ) {

    # another security to prevent original files to delete
    if ( $takeOutArchivePath -eq ".\test-resources\take-out-archive" ) {

        # erasing, if required, the Take Out Archive folder, and initialize it with the Test Case
        if (Test-Path $takeOutArchivePath) { Remove-Item $takeOutArchivePath -Recurse -Force }
        #New-Item -Path $takeOutArchivePath -ItemType Directory -Force | Out-Null
        Copy-Item -Path ".\test-resources\test-folder" -Destination $takeOutArchivePath -Recurse

        # erasing, if required, Unkown work folders, and initialize it with expected sub-folders
        if (Test-Path $unknownFolderPath) { Remove-Item $unknownFolderPath -Recurse -Force }
        New-Item -Path $unknownFolderPath -ItemType Directory -Force | Out-Null
        New-Item -Path $unknownFolderPath"\not-found" -ItemType Directory -Force | Out-Null
        New-Item -Path $unknownFolderPath"\several-matches" -ItemType Directory -Force | Out-Null
    }
}


# Step 1 : remove all JSON files from target folder
$step1Path = ".\step1-clean-json-files.ps1 -takeOutArchivePath """ + $takeOutArchivePath + """ -logFile """ + $logFile + """"
Invoke-Expression $step1Path


# Step 2 : remove all empty folders from target folder
$step2Path = ".\step2-clean-empty-folders.ps1 -takeOutArchivePath """ + $takeOutArchivePath + """ -logFile """ + $logFile + """"
Invoke-Expression $step2path


# Step 3 : reorganizing folders following the reference folders
$step3Path = ".\step3-reorganize-folders.ps1" `
    + " -takeOutArchivePath """ + $takeOutArchivePath + """" `
    + " -referenceFolderPath """ + $referenceFolderPath + """" `
    + " -unknownFolderPath """ + $unknownFolderPath + """" `
    + " -logFile """ + $logFile + """"
Invoke-Expression $step3Path


# Step 4 : deleting files existing in reference folder
$step4Path = ".\step4-deleting-existing-files.ps1" `
    + " -takeOutArchivePath """ + $takeOutArchivePath + """" `
    + " -referenceFolderPath """ + $referenceFolderPath + """" `
    + " -logFile """ + $logFile + """"
Invoke-Expression $step4Path