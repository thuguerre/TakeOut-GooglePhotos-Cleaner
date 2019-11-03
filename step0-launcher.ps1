<#
.SYNOPSIS
    Launch and chain all scripts to clean Google Photos archive, from Google's TakeOut.
    It allows lauching separately each step manually if required.
.PARAMETER takeOutArchivePath
    Path to the root folder containing Google Photos archive.
    By default, ".\test-resources\take-out-archive" in order to perform tests.
.PARAMETER referenceFolderPath
    The folder containing referent files, to compare with. It will not be modified at all.
    By default, ".\test-resources\reference-folder" in order to perform tests.
.PARAMETER unknownFolderPath
    Path to the folder where to store folders and files for what we do not know what to do.
    By default, ".\test-resources\take-out-archive-unknown" in order to perform tests.
.PARAMETER logFile
    Path of the file where to log all this script's actions.
    By default, ".\takeout-googlephotos-cleaner.log" in root folder, ignored by GIT.
.PARAMETER testing
    DO NOT SET TO 'YES' IF WORKING ON ORIGINAL FILES !!!
    If set to 'YES' :
        - Cleaning test work folders by definitively removing all $takeOutArchivePath and $unknownFolderPath folders and files.
        - Then copying the test-folder as the Take Out Archive.
        - Performing auto-tests at each steps. If one test fails, script stops.
#>

param(  [string] $takeOutArchivePath = ".\test-resources\take-out-archive",
        [string] $referenceFolderPath = ".\test-resources\reference-folder",
        [string] $unknownFolderPath = ".\test-resources\take-out-archive-unknown",
        [string] $logFile = ".\takeout-googlephotos-cleaner.log",
        [string] $testing = "NO")


Clear-Content $logFile

# if we are launching tests, preparing folders
if ( $testing -eq "YES" ) {

    # another security to prevent original files to delete
    if ( $takeOutArchivePath -eq ".\test-resources\take-out-archive" ) {

        # erasing, if required, the Take Out Archive folder, and initialize it with the Test Case
        if (Test-Path $takeOutArchivePath) { Remove-Item $takeOutArchivePath -Recurse -Force }
        Copy-Item -Path ".\test-resources\test-folder" -Destination $takeOutArchivePath -Recurse

        # erasing, if required, Unkown work folders, and initialize it with expected sub-folders
        if (Test-Path $unknownFolderPath) { Remove-Item $unknownFolderPath -Recurse -Force }
        New-Item -Path $unknownFolderPath -ItemType Directory -Force | Out-Null
        New-Item -Path $unknownFolderPath"\not-found" -ItemType Directory -Force | Out-Null
        New-Item -Path $unknownFolderPath"\several-matches" -ItemType Directory -Force | Out-Null

        # performing auto-verification
        $test0Path = ".\test-step0-post.ps1" `
            + " -takeOutArchivePath """ + $takeOutArchivePath + """" `
            + " -referenceFolderPath """ + $referenceFolderPath + """" `
            + " -unknownFolderPath """ + $unknownFolderPath + """" `
            + " -logFile """ + $logFile + """"
        
        Invoke-Expression $test0Path
        
        if ($LastExitCode -ne 0) {
            Write-Host "Step 0 post tests fails" -ForegroundColor Red
            exit $LastExitCode
        }
    }
}


# Step 1 : remove all JSON files from target folder
$step1Path = ".\step1-clean-json-files.ps1" `
    + " -takeOutArchivePath """ + $takeOutArchivePath + """" `
    + " -logFile """ + $logFile + """" `
    + " -testing """ + $testing + """"

Invoke-Expression $step1Path

if ($LastExitCode -ne 0) {
    Write-Host "Step 1 has failed" -ForegroundColor Red
    exit $LastExitCode
}


# Step 2 : remove all empty folders from target folder
$step2Path = ".\step2-clean-empty-folders.ps1" `
    + " -takeOutArchivePath """ + $takeOutArchivePath + """" `
    + " -logFile """ + $logFile + """" `
    + " -testing """ + $testing + """"

Invoke-Expression $step2path

if ($LastExitCode -ne 0) {
    Write-Host "Step 2 has failed" -ForegroundColor Red
    exit $LastExitCode
}


# Step 3 : reorganizing folders following the reference folders
$step3Path = ".\step3-reorganize-folders.ps1" `
    + " -takeOutArchivePath """ + $takeOutArchivePath + """" `
    + " -referenceFolderPath """ + $referenceFolderPath + """" `
    + " -unknownFolderPath """ + $unknownFolderPath + """" `
    + " -logFile """ + $logFile + """" `
    + "-testing """ + $testing + """"

Invoke-Expression $step3Path

if ($LastExitCode -ne 0) {
    Write-Host "Step 3 has failed" -ForegroundColor Red
    exit $LastExitCode
}


# Step 4 : deleting files existing in reference folder
$step4Path = ".\step4-deleting-existing-files.ps1" `
    + " -takeOutArchivePath """ + $takeOutArchivePath + """" `
    + " -referenceFolderPath """ + $referenceFolderPath + """" `
    + " -unknownFolderPath """ + $unknownFolderPath + """" `
    + " -logFile """ + $logFile + """" `
    + "-testing """ + $testing + """"

Invoke-Expression $step4Path

if ($LastExitCode -ne 0) {
    Write-Host "Step 4 has failed" -ForegroundColor Red
    exit $LastExitCode
}

Write-Host "Cleaning done." -ForegroundColor Green