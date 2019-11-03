<#
.SYNOPSIS
    Verify if $referenceFolder content has not been modified at all.
.PARAMETER referenceFolderPath
    The folder containing referent files, to compare with. It will not be modified at all.
.PARAMETER logFile
    Path of the file where to log all this script's actions.
#>

param(  [Parameter(Mandatory=$true)] [string] $referenceFolderPath,
        [Parameter(Mandatory=$true)] [string] $logFile)


# root folder
if (-Not (Test-Path $referenceFolderPath)) { exit 1 }
if (-Not (Test-Path $referenceFolderPath"\file-1-to-ignore.txt")) { exit 1 }

    # folder 1
    if (-Not (Test-Path $referenceFolderPath"\folder-1")) { exit 1 }
    if (-Not (Test-Path $referenceFolderPath"\folder-1\file-1.1-to-ignore.txt")) { exit 1 }
    if (Test-Path $referenceFolderPath"\folder-1\file-1.4-to-synchronize.txt") { exit 1 }

        # folder 1.1
        if (-Not (Test-Path $referenceFolderPath"\folder-1\folder-1.1")) { exit 1 }
        if (-Not (Test-Path $referenceFolderPath"\folder-1\folder-1.1\file-1.1.1-to-ignore.txt")) { exit 1 }

        # folder 5
        if (-Not (Test-Path $referenceFolderPath"\folder-1\folder-5-several-matches")) { exit 1 }
        if (-Not (Test-Path $referenceFolderPath"\folder-1\folder-5-several-matches\file-5.1.txt")) { exit 1 }

    # folder 2
    if (Test-Path $referenceFolderPath"\folder-2-to-delete") { exit 1 }

    # folder 3
    if (-Not (Test-Path $referenceFolderPath"\folder-3")) { exit 1 }
    if (-Not (Test-Path $referenceFolderPath"\folder-3\file-3.1-to-ignore.txt")) { exit 1 }

        # folder 3.1
        if (Test-Path $referenceFolderPath"\folder-3\folder-3.1-to-delete") { exit 1 }
    
        # folder 3.2
        if (-Not (Test-Path $referenceFolderPath"\folder-3\folder-3.2")) { exit 1 }
        if (-Not (Test-Path $referenceFolderPath"\folder-3\folder-3.2\file-3.2.1-to-ignore.txt")) { exit 1 }

        # folder 5
        if (-Not (Test-Path $referenceFolderPath"\folder-3\folder-5-several-matches")) { exit 1 }
        if (-Not (Test-Path $referenceFolderPath"\folder-3\folder-5-several-matches\file-5.1.txt")) { exit 1 }

    # folder 3.2 - TAKE OUT ARCHIVE
    if (Test-Path $referenceFolderPath"\folder-3.2") { exit 1 }

    # folder 4 - TAKE OUT ARCHIVE
    if (Test-Path $referenceFolderPath"\folder-4-not-found") { exit 1 }

    # folder 5 - TAKE OUT ARCHIVE
    if (Test-Path $referenceFolderPath"\folder-5-several-matches") { exit 1 }

    # folder 6.1.1 - TAKE OUT ARCHIVE
    if (Test-Path $referenceFolderPath"\folder-6.1.1-2-levels-to-create") { exit 1 }

    # folder 6
    if (-Not (Test-Path $referenceFolderPath"\folder-6")) { exit 1 }
    
        # folder 6.1
        if (-Not (Test-Path $referenceFolderPath"\folder-6\folder-6.1")) { exit 1 }

            # folder 6.1.1
            if (-Not (Test-Path $referenceFolderPath"\folder-6\folder-6.1\folder-6.1.1-2-levels-to-create")) { exit 1 }
            if (-Not (Test-Path $referenceFolderPath"\folder-6\folder-6.1\folder-6.1.1-2-levels-to-create\file-6.1.1.1-to-ignore.txt")) { exit 1 }

        # folder 6.2
        if (-Not (Test-Path $referenceFolderPath"\folder-6\folder-6.2")) { exit 1 }
        if (Test-Path $referenceFolderPath"\folder-6\folder-6.2\file-6.2.1-to-synchronize.txt") { exit 1 }
        if (-Not (Test-Path $referenceFolderPath"\folder-6\folder-6.2\file-6.2.2-only-in-reference.txt")) { exit 1 }


Write-Host "Reference Folder Tests : `t SUCCESS" -ForegroundColor Green
exit 0