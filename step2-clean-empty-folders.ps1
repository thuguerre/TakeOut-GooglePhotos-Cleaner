<#
.SYNOPSIS
    Permanently remove all empty folders from targeted folder, and recursed sub-folders
.PARAMETER TargetFolder
    The folder in which deleting all empty folders
.PARAMETER LogFile
    Path to the file where to log all removed folders.
    By default, C:/takeout-googlephotos-cleaner.log
#>

param([string]$targetFolder = "C:\take-out-archive\test-folder", [string]$logFile = "C:\temp\takeout-googlephotos-cleaner.log")



Add-content $Logfile -value ""
Add-content $Logfile -value ""
Add-content $Logfile -value "####################################"
Add-content $Logfile -value "### start deleting empty folders ###"
Add-content $Logfile -value "####################################"
Add-content $Logfile -value ""


#Get-ChildItem $targetFolder -recurse -include *.json | Tee-Object -var filesToDelete | Remove-Item 
#$filesToDelete | Add-Content $logFile

Get-ChildItem $targetFolder -Recurse `
    | Where-Object { $_.PsIsContainer -eq $true } `
    | Where-Object { $_.GetFiles().Count -eq 0 -and $_.GetDirectories().Count -eq 0 } `
    | Tee-Object -var folderToDelete `
    | Remove-Item

$folderToDelete | Add-Content $logFile


Add-content $Logfile -value ""
Add-content $Logfile -value "##################################"
Add-Content $logFile -value "### end deleting empty folders ###"
Add-content $Logfile -value "##################################"
Add-content $Logfile -value ""
Add-content $Logfile -value ""
