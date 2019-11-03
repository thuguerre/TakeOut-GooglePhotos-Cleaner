<#
.SYNOPSIS
    Verify if all JSON files have well been deleted.
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
if (Test-Path $takeOutArchivePath"\file-2-to-delete.json") { exit 1 }
if (Test-Path $takeOutArchivePath"\file-3-to-delete.json") { exit 1 }

    # folder 1
    if (-Not (Test-Path $takeOutArchivePath"\folder-1")) { exit 1 }
    if (-Not (Test-Path $takeOutArchivePath"\folder-1\file-1.1-to-ignore.txt")) { exit 1 }
    if (Test-Path $takeOutArchivePath"\folder-1\file-1.2-to-delete.json") { exit 1 } 
    if (Test-Path $takeOutArchivePath"\folder-1\file-1.3-to-delete.json") { exit 1 } 
    if (-Not (Test-Path $takeOutArchivePath"\folder-1\file-1.4-to-synchronize.txt")) { exit 1 }

        # folder 1.1
        if (-Not (Test-Path $takeOutArchivePath"\folder-1\folder-1.1")) { exit 1 }
        if (-Not (Test-Path $takeOutArchivePath"\folder-1\folder-1.1\file-1.1.1-to-ignore.txt")) { exit 1 }

    # folder 2
    if (-Not (Test-Path $takeOutArchivePath"\folder-2-to-delete")) { exit 1 }
    if (Test-Path $takeOutArchivePath"\folder-2-to-delete\file-2.1-to-delete.json") { exit 1 }
    if (Test-Path $takeOutArchivePath"\folder-2-to-delete\file-2.2-to-delete.json") { exit 1 } 

        # folder 2.1
        if (-Not (Test-Path $takeOutArchivePath"\folder-2-to-delete\folder-2.1-to-delete")) { exit 1 }
        if (Test-Path $takeOutArchivePath"\folder-2-to-delete\folder-2.1-to-delete\file-2.1.1-to-delete.json") { exit 1 }

    # folder 3
    if (-Not (Test-Path $takeOutArchivePath"\folder-3")) { exit 1 }
    if (-Not (Test-Path $takeOutArchivePath"\folder-3\file-3.1-to-ignore.txt")) { exit 1 }

        # folder 3.1
        if (-Not (Test-Path $takeOutArchivePath"\folder-3\folder-3.1-to-delete")) { exit 1 }
        if (Test-Path $takeOutArchivePath"\folder-3\folder-3.1-to-delete\file-3.1.1-to-delete.json") { exit 1 }
    
    # folder 3.2
    if (-Not (Test-Path $takeOutArchivePath"\folder-3.2")) { exit 1 }
    if (-Not (Test-Path $takeOutArchivePath"\folder-3.2\file-3.2.1-to-ignore.txt")) { exit 1 }

    # folder 4
    if (-Not (Test-Path $takeOutArchivePath"\folder-4-not-found")) { exit 1 }
    if (-Not (Test-Path $takeOutArchivePath"\folder-4-not-found\file-4.1.txt")) { exit 1 }

    # folder 5
    if (-Not (Test-Path $takeOutArchivePath"\folder-5-several-matches")) { exit 1 }
    if (-Not (Test-Path $takeOutArchivePath"\folder-5-several-matches\file-5.1.txt")) { exit 1 }

    # folder 6.1.1
    if (-Not (Test-Path $takeOutArchivePath"\folder-6.1.1-2-levels-to-create")) { exit 1 }
    if (-Not (Test-Path $takeOutArchivePath"\folder-6.1.1-2-levels-to-create\file-6.1.1.1-to-ignore.txt")) { exit 1 }


# TODO launch verification on $referenceFolder

exit 0