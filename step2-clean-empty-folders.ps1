<#
.SYNOPSIS
    Permanently remove all empty folders from targeted folder, and recursed sub-folders
.PARAMETER TargetFolder
    The folder in which deleting all empty folders.
    By default, ".\test-resources\test-folder" in order to perform tests.
.PARAMETER LogFile
    Path to the file where to log all removed folders.
    By default, ".\takeout-googlephotos-cleaner.log" in root folder, ignored by GIT.
#>

param([string]$targetFolder = ".\test-resources\test-folder", [string]$logFile = ".\takeout-googlephotos-cleaner.log")



Add-content $Logfile -value ""
Add-content $Logfile -value ""
Add-content $Logfile -value "####################################"
Add-content $Logfile -value "### start deleting empty folders ###"
Add-content $Logfile -value "####################################"
Add-content $Logfile -value ""


#selecting folders to delete
$allItems = Get-ChildItem $targetFolder -Recurse
$allFolders = $allItems.where({ $_.PsIsContainer -eq $true })
$allEmptyFolders = $allFolders.where({ $_.GetFiles().Count -eq 0 -and $_.GetDirectories().Count -eq 0 })

#logging folders to delete
#$allEmptyFolders | Select-Object -Property FullName | Add-Content $logFile
$allEmptyFolders.Fullname | Add-Content $logFile

#deleting empty folders
$allEmptyFolders | Remove-Item


Add-content $Logfile -value ""
Add-content $Logfile -value "##################################"
Add-Content $logFile -value "### end deleting empty folders ###"
Add-content $Logfile -value "##################################"
Add-content $Logfile -value ""
Add-content $Logfile -value ""
