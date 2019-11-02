<#
.SYNOPSIS
    Launch and chain all scripts to clean Google Photos archive, from Google's TakeOut.
    It allows lauching separately each step manually if required.
.PARAMETER takeOutFolderPath
    Path to the root folder containing Google Photos archive.
.PARAMETER logFile
    Path of the file where to log all this script's actions.
    By default, C:\take-out-archive\script.log
#>

param([string]$takeOutFolderPath = "C:\take-out-archive\test-folder", [string]$logFile = "C:\take-out-archive\script.log")

Clear-Content $logFile

# Step 1 : remove all JSON files from target folder
$step1Path = ".\step1-clean-json-files.ps1 -targetFolder """ + $takeOutFolderPath + """ -logFile """ + $logFile + """"
Invoke-Expression $step1Path


# Step 2 : remove all empty folders from target folder
$step1Path = ".\step2-clean-empty-folders.ps1 -targetFolder """ + $takeOutFolderPath + """ -logFile """ + $logFile + """"
Invoke-Expression $step1Path