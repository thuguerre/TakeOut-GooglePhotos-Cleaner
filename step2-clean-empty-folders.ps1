<#
.SYNOPSIS
    Permanently remove all empty folders from targeted folder, and recursed sub-folders
.PARAMETER takeOutArchivePath
    The folder in which deleting all empty folders.
.PARAMETER logFile
    Path to the file where to log all removed folders.
.PARAMETER testing
    If set to "YES", launch post auto-tests
#>

param(  [Parameter(Mandatory=$true)] [string] $takeOutArchivePath,
        [Parameter(Mandatory=$true)] [string] $logFile,
        [Parameter(Mandatory=$true)] [string] $testing)



Add-content $Logfile -value ""
Add-content $Logfile -value "# start deleting empty folders"
Add-content $Logfile -value ""

Write-Host "Deleting empty folders"

Do {

    #selecting folders to delete
    $allEmptyFolders = (Get-ChildItem $takeOutArchivePath -Recurse `
        | Where-Object { $_.PsIsContainer -eq $true } `
        | Where-Object { $_.GetFiles().Count -eq 0 -and $_.GetDirectories().Count -eq 0 } ).Fullname

    $foldersCount = $allEmptyFolders.Count
    Write-Host "`t $foldersCount folders to delete."

    #logging folders to delete
    $allEmptyFolders | Add-Content $logFile

    #deleting empty folders
    if ( $allEmptyFolders.Count -gt 0 ) {
        $allEmptyFolders | Remove-Item
    }

} While ( $allEmptyFolders.Count -gt 0 )


Add-content $Logfile -value ""
Add-content $Logfile -value "#################################################################"


Write-Host "Empty folders deleted" -ForegroundColor Green

if ( $testing -eq "YES" ) {

    # performing auto-verification
    $test2Path = ".\test-step2-post.ps1" `
        + " -takeOutArchivePath """ + $takeOutArchivePath + """" `
        + " -referenceFolderPath """ + $referenceFolderPath + """" `
        + " -unknownFolderPath """ + $unknownFolderPath + """" `
        + " -logFile """ + $logFile + """"
        
    Invoke-Expression $test2Path

    if ($LastExitCode -ne 0) {
        Write-Host "Step 2 Post-Tests : `t`t FAILED" -ForegroundColor Red
        exit $LastExitCode
    }
}