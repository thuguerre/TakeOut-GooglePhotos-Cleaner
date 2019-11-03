<#
.SYNOPSIS
    Permanently remove all *.json files from targeted folder, and recursed sub-folders
.PARAMETER takeOutArchivePath
    The folder in which deleting all JSON files
.PARAMETER logFile
    Path to the file where to log all removed files.
.PARAMETER testing
    If set to "YES", launch post auto-tests
#>

param(  [Parameter(Mandatory=$true)] [string] $takeOutArchivePath,
        [Parameter(Mandatory=$true)] [string] $logFile,
        [Parameter(Mandatory=$true)] [string] $testing)


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

if ( $testing -eq "YES" ) {

    # performing auto-verification
    $test1Path = ".\test-step1-post.ps1" `
        + " -takeOutArchivePath """ + $takeOutArchivePath + """" `
        + " -referenceFolderPath """ + $referenceFolderPath + """" `
        + " -unknownFolderPath """ + $unknownFolderPath + """" `
        + " -logFile """ + $logFile + """"
    Invoke-Expression $test1Path
    if ($LastExitCode -ne 0) {
        Write-Host "Step 1 post tests fail" -ForegroundColor Red
        exit $LastExitCode
    }
}