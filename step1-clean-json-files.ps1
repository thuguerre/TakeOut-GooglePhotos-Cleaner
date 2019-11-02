<#
.SYNOPSIS
    Permanently remove all *.json files from targeted folder, and recursed sub-folders
.PARAMETER takeOutArchivePath
    The folder in which deleting all JSON files
    By default, ".\test-resources\take-out-archive" in order to perform tests.
.PARAMETER logFile
    Path to the file where to log all removed files.
    By default, ".\takeout-googlephotos-cleaner.log" in root folder, ignored by GIT.
#>

param(  [string] $takeOutArchivePath = ".\test-resources\take-out-archive",
        [string] $logFile = ".\takeout-googlephotos-cleaner.log")


Add-content $Logfile -value ""
Add-content $Logfile -value ""
Add-content $Logfile -value "#################################"
Add-content $Logfile -value "### start deleting JSON files ###"
Add-content $Logfile -value "#################################"
Add-content $Logfile -value ""


Get-ChildItem $takeOutArchivePath -recurse -include *.json | Tee-Object -var filesToDelete | Remove-Item 
$filesToDelete | Add-Content $logFile


Add-content $Logfile -value ""
Add-content $Logfile -value "###############################"
Add-Content $logFile -value "### end deleting JSON files ###"
Add-content $Logfile -value "###############################"
Add-content $Logfile -value ""
Add-content $Logfile -value ""
