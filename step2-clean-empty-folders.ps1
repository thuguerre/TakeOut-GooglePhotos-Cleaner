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


Do {

    #selecting folders to delete
    $allEmptyFolders = (Get-ChildItem $targetFolder -Recurse `
        | Where-Object { $_.PsIsContainer -eq $true } `
        | Where-Object { $_.GetFiles().Count -eq 0 -and $_.GetDirectories().Count -eq 0 } ).Fullname

    #logging folders to delete
    $allEmptyFolders | Add-Content $logFile

    #deleting empty folders
    if ( $allEmptyFolders.Count -gt 0 ) {
        $allEmptyFolders | Remove-Item
    }

} While ( $allEmptyFolders.Count -gt 0 )


Add-content $Logfile -value ""
Add-content $Logfile -value "##################################"
Add-Content $logFile -value "### end deleting empty folders ###"
Add-content $Logfile -value "##################################"
Add-content $Logfile -value ""
Add-content $Logfile -value ""
