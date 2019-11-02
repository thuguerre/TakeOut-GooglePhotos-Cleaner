<#
.SYNOPSIS
    Permanently remove all *.json files from targeted folder, and recursed sub-folders
.PARAMETER TargetFolder
    The folder in which deleting all JSON files
.PARAMETER LogFile
    Path to the file where to log all removed files.
    By default, C:/takeout-googlephotos-cleaner.log
#>

param([string]$targetFolder = "C:\take-out-archive\test-folder", [string]$logFile = "C:\temp\takeout-googlephotos-cleaner.log")


Add-content $Logfile -value ""
Add-content $Logfile -value ""
Add-content $Logfile -value "#################################"
Add-content $Logfile -value "### start deleting JSON files ###"
Add-content $Logfile -value "#################################"
Add-content $Logfile -value ""


Get-ChildItem $targetFolder -recurse -include *.json | Tee-Object -var filesToDelete | Remove-Item 
$filesToDelete | Add-Content $logFile


Add-content $Logfile -value ""
Add-content $Logfile -value "###############################"
Add-Content $logFile -value "### end deleting JSON files ###"
Add-content $Logfile -value "###############################"
Add-content $Logfile -value ""
Add-content $Logfile -value ""
