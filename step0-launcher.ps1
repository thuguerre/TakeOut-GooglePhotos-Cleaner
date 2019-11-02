<#
.SYNOPSIS
    Launch and chain all scripts to clean Google Photos archive, from Google's TakeOut.
    It allows lauching separately each step manually if required.
.PARAMETER takeOutFolderPath
    Path to the root folder containing Google Photos archive.
    By default, ".\test-resources\test-folder" in order to perform tests.
.PARAMETER logFile
    Path of the file where to log all this script's actions.
    By default, ".\takeout-googlephotos-cleaner.log" in root folder, ignored by GIT.
#>

param([string]$takeOutFolderPath = ".\test-resources\test-folder", [string]$logFile = ".\takeout-googlephotos-cleaner.log")

Clear-Content $logFile

# Step 1 : remove all JSON files from target folder
$step1Path = ".\step1-clean-json-files.ps1 -targetFolder """ + $takeOutFolderPath + """ -logFile """ + $logFile + """"
Invoke-Expression $step1Path


# Step 2 : remove all empty folders from target folder
$step1Path = ".\step2-clean-empty-folders.ps1 -targetFolder """ + $takeOutFolderPath + """ -logFile """ + $logFile + """"
Invoke-Expression $step1Path