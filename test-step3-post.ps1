<#
.SYNOPSIS
    Verify if all folders have well been moved to the wanted location.
.PARAMETER takeOutArchivePath
    Path to the root folder containing Google Photos archive.
.PARAMETER referenceFolderPath
    The folder containing referent files, to compare with. It will not be modified at all.
.PARAMETER unknownFolderPath
    Path to the folder where to store folders and files for what we do not know what to do.
.PARAMETER logFile
    Path of the file where to log all this script's actions.
#>

param(  [Parameter(Mandatory=$true)] [string] $takeOutArchivePath,
        [Parameter(Mandatory=$true)] [string] $referenceFolderPath,
        [Parameter(Mandatory=$true)] [string] $unknownFolderPath,
        [Parameter(Mandatory=$true)] [string] $logFile)


# root folder
if (-Not (Test-Path $takeOutArchivePath)) { exit 1 }
if (-Not (Test-Path $takeOutArchivePath"\file-1-to-ignore.txt")) { exit 1 }

    # folder 1
    if (-Not (Test-Path $takeOutArchivePath"\folder-1")) { exit 1 }
    if (-Not (Test-Path $takeOutArchivePath"\folder-1\file-1.1-to-ignore.txt")) { exit 1 }
    if (-Not (Test-Path $takeOutArchivePath"\folder-1\file-1.4-to-synchronize.txt")) { exit 1 }

        # folder 1.1
        if (-Not (Test-Path $takeOutArchivePath"\folder-1\folder-1.1")) { exit 1 }
        if (-Not (Test-Path $takeOutArchivePath"\folder-1\folder-1.1\file-1.1.1-to-ignore.txt")) { exit 1 }

    # folder 3
    if (-Not (Test-Path $takeOutArchivePath"\folder-3")) { exit 1 }
    if (-Not (Test-Path $takeOutArchivePath"\folder-3\file-3.1-to-ignore.txt")) { exit 1 }
    
        # folder 3.2
        if (-Not (Test-Path $takeOutArchivePath"\folder-3\folder-3.2")) { exit 1 }
        if (-Not (Test-Path $takeOutArchivePath"\folder-3\folder-3.2\file-3.2.1-to-ignore.txt")) { exit 1 }

    # folder 4 - OLD VERSION
    if (Test-Path $takeOutArchivePath"\folder-4-not-found") { exit 1 }
    if (Test-Path $takeOutArchivePath"\folder-4-not-found\file-4.1.txt") { exit 1 }

    # folder 5 - OLD VERSION
    if (Test-Path $takeOutArchivePath"\folder-5-several-matches") { exit 1 }
    if (Test-Path $takeOutArchivePath"\folder-5-several-matches\file-5.1.txt") { exit 1 }

    # folder 6.1.1 - OLD VERSION
    if (Test-Path $takeOutArchivePath"\folder-6.1.1-2-levels-to-create") { exit 1 }
    if (Test-Path $takeOutArchivePath"\folder-6.1.1-2-levels-to-create\file-6.1.1.1-to-ignore.txt") { exit 1 }

    # folder 6
    if (-Not (Test-Path $takeOutArchivePath"\folder-6")) { exit 1 }

        # folder 6.1
        if (-Not (Test-Path $takeOutArchivePath"\folder-6\folder-6.1")) { exit 1 }

            # folder 6.1.1
            if (-Not (Test-Path $takeOutArchivePath"\folder-6\folder-6.1\folder-6.1.1-2-levels-to-create")) { exit 1 }
            if (-Not (Test-Path $takeOutArchivePath"\folder-6\folder-6.1\folder-6.1.1-2-levels-to-create\file-6.1.1.1-to-ignore.txt")) { exit 1 }

        # folder 6.2
        if (-Not (Test-Path $takeOutArchivePath"\folder-6\folder-6.2")) { exit 1 }
        if (-Not (Test-Path $takeOutArchivePath"\folder-6\folder-6.2\file-6.2.1-to-synchronize.txt")) { exit 1 }


# unknown folder
if (-Not (Test-Path $unknownFolderPath)) { exit 1 }
if ((Get-Item $unknownFolderPath).GetFiles().Count -ne 0) { exit 1 }

    # Not Found folder
    if (-Not (Test-Path $unknownFolderPath"\not-found")) { exit 1 }
    if ((Get-Item $unknownFolderPath"\not-found").GetFiles().Count -ne 0) { exit 1 }

        # Folder 4
        if (-Not (Test-Path $unknownFolderPath"\not-found\folder-4-not-found")) { exit 1 }
        if (-Not (Test-Path $unknownFolderPath"\not-found\folder-4-not-found\file-4.1.txt")) { exit 1 }

    # Several Matches folder
    if (-Not (Test-Path $unknownFolderPath"\several-matches")) { exit 1 }
    if ((Get-Item $unknownFolderPath"\several-matches").GetFiles().Count -ne 0) { exit 1 }

        # folder 5
        if (-Not (Test-Path $unknownFolderPath"\several-matches\folder-5-several-matches")) { exit 1 }
        if (-Not (Test-Path $unknownFolderPath"\several-matches\folder-5-several-matches\file-5.1.txt")) { exit 1 }


        
# testing Reference Folder
$testReferenceFolderPath = ".\test-reference-folder.ps1" `
    + " -referenceFolderPath """ + $referenceFolderPath + """" `
    + " -logFile """ + $logFile + """"

Invoke-Expression $testReferenceFolderPath

if ($LastExitCode -ne 0) {
    Write-Host "Reference Folder Tests : `t FAILED" -ForegroundColor Red
    exit $LastExitCode
}



Write-Host "Step 3 Post-Tests : `t`t SUCCESS" -ForegroundColor Green
exit 0