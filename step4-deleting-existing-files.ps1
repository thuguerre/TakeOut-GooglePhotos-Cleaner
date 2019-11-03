<#
.SYNOPSIS
    Crawl Take Out Archive in order to delete files existing in Reference Folder.
    It will let only the files to later manually synchronize into Reference Folder.
.PARAMETER takeOutArchivePath
    The folder in which deleting existing files.
    By default, ".\test-resources\take-out-archive" in order to perform tests.
.PARAMETER referenceFolderPath
    The folder containing referent files, to compare with. It will not be modified at all.
    By default, ".\test-resources\reference-folder" in order to perform tests.
.PARAMETER logFile
    Path to the file where to log all files deletion.
    By default, ".\takeout-googlephotos-cleaner.log" in root folder, ignored by GIT.
#>

param(  [string] $takeOutArchivePath = ".\test-resources\take-out-archive",
        [string] $referenceFolderPath = ".\test-resources\reference-folder",
        [string] $logFile = ".\takeout-googlephotos-cleaner.log")


Add-content $Logfile -value ""
Add-content $Logfile -value ""
Add-content $Logfile -value "#####################################"
Add-content $Logfile -value "### start deleting existing files ###"
Add-content $Logfile -value "#####################################"
Add-content $Logfile -value ""


$takeOutFolder = Get-ChildItem -Recurse -Path $takeOutArchivePath
$referenceFolder = Get-ChildItem -Recurse -Path $referenceFolderPath

Compare-Object -ReferenceObject $referenceFolder -DifferenceObject $takeOutFolder -IncludeEqual -ExcludeDifferent -Passthru `
    | % {$_.FullName}


Add-content $Logfile -value ""
Add-content $Logfile -value ""
Add-content $Logfile -value "###################################"
Add-content $Logfile -value "### end deleting existing files ###"
Add-content $Logfile -value "###################################"
Add-content $Logfile -value ""

