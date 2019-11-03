<#
.SYNOPSIS
    Reorganize $takeOutArchivePath's folders (and its contained files) to reproduce a referenced folder's structure.
    This step is a pre-requisite to compare files between two similar folder structures (see step 4).
    All folders from $takeOutArchivePath which are not found in $referenceFolderPath are moved to an 'unknown' folder to be processed manually.
.PARAMETER takeOutArchivePath
    The folder in which we are trying to reorganize folders.
.PARAMETER referenceFolderPath
    The folder we will try to copy the structure. It will not be modified at all.
.PARAMETER unknownFolderPath
    The folder path in which all unfound folders from $takeOutArchivePath will be moved to be processed manually later.
.PARAMETER logFile
    Path to the file where to log all folder moves.
.PARAMETER testing
    If set to "YES", launch post auto-tests
#>

param(  [Parameter(Mandatory=$true)] [string] $takeOutArchivePath,
        [Parameter(Mandatory=$true)] [string] $referenceFolderPath,
        [Parameter(Mandatory=$true)] [string] $unknownFolderPath,
        [Parameter(Mandatory=$true)] [string] $logFile,
        [Parameter(Mandatory=$true)] [string] $testing)


Add-content $Logfile -value ""
Add-content $Logfile -value ""
Add-content $Logfile -value "##################################"
Add-content $Logfile -value "### start reorganizing folders ###"
Add-content $Logfile -value "##################################"
Add-content $Logfile -value ""


$takeOutArchivePathFullPath = Resolve-Path $takeOutArchivePath
$referenceFolderPathFullPath = Resolve-Path $referenceFolderPath

function MoveAtRightPlace {
    param (
        [System.IO.DirectoryInfo] $sourceItem
    )
    
    $possibleMatches = (Get-ChildItem $referenceFolderPath -Recurse -filter $sourceItem.Name | Where-Object { $_.PsIsContainer -eq $true }).Fullname

    if ( $possibleMatches.Count -eq 0 ) {

        # in this case, the folder has no found reference in referenced folder.
        # it has to be moved in 'unknown\not-found' to be processed manually later

        $destinationPath = $unknownFolderPath + "\not-found\" + $sourceItem.Name
        Move-Item -Path $sourceItem.FullName -Destination $destinationPath -Force

        $moveLog = "no equivalent found for '" + $sourceItem.Name + "'. Move to 'not-found' folder"
        Add-Content $logFile -value $moveLog

    } elseif ( $possibleMatches.Count -eq 1) {
        
        $currentSourceFolderPath = $sourceItem.Fullname.Replace($takeOutArchivePathFullPath, "")
        $currentreferenceFolderPathPath = $possibleMatches.Replace($referenceFolderPathFullPath, "")

        if ($currentSourceFolderPath -eq $currentreferenceFolderPathPath) {

            $msg = "nothing to do for folder '" + $currentSourceFolderPath + "'"
            Add-Content $logFile -value $msg

        } else {

            $currentDestinationFolderPath = $takeOutArchivePathFullPath.ToString() + $currentreferenceFolderPathPath

            if (-Not (Test-Path $currentDestinationFolderPath)) {
                
                # creating all the destination path, in order to be sure all directory levels are created
                # indeed, if not, the Move-Item will fail because of missing part of the path
                New-Item -Path $currentDestinationFolderPath -ItemType Directory -Force | Out-Null

                # removing the lower level directoy, keeping the rest of the path
                Remove-Item -Path $currentDestinationFolderPath -Force
            }

            Move-Item -Path $sourceItem.FullName -Destination $currentDestinationFolderPath -Force

            $moveLog = "folder '" + $currentSourceFolderPath + "' moved to '" + $currentDestinationFolderPath + "'"
            Add-Content $logFile -value $moveLog
        }

    } else {
        
        # in this case, the folder has several possible references found in referenced folder.
        # we do not know where to move it
        # it has to be moved in 'unknown\several-matches' to be processed manually later

        $destinationPath = $unknownFolderPath + "\several-matches\" + $sourceItem.Name
        Move-Item -Path $sourceItem.FullName -Destination $destinationPath -Force

        $moveLog = "several references found for '" + $sourceItem.Name + "'. Move to 'several-matches' folder"
        Add-Content $logFile -value $moveLog

        $i = 0
        Do {
            $possibleMatch = "   > " + $possibleMatches[$i]
            Add-Content $logFile -Value $possibleMatch
            $i++
        } Until ( $i -eq $possibleMatches.Count )

        # TODO if there are several matches, but one of them is the exact path of the current item, we have to do nothing.
    }
}


#$alltakeOutArchivePaths =
Get-ChildItem $takeOutArchivePath -Recurse `
    | Where-Object { $_.PsIsContainer -eq $true } `
    | ForEach-Object { MoveAtRightPlace -sourceItem $_ }



Add-content $Logfile -value ""
Add-content $Logfile -value ""
Add-content $Logfile -value "################################"
Add-content $Logfile -value "### end reorganizing folders ###"
Add-content $Logfile -value "################################"
Add-content $Logfile -value ""


if ( $testing -eq "YES" ) {

    # performing auto-verification
    $test3Path = ".\test-step3-post.ps1" `
        + " -takeOutArchivePath """ + $takeOutArchivePath + """" `
        + " -referenceFolderPath """ + $referenceFolderPath + """" `
        + " -unknownFolderPath """ + $unknownFolderPath + """" `
        + " -logFile """ + $logFile + """"
    Invoke-Expression $test3Path
    if ($LastExitCode -ne 0) {
        Write-Host "Step 3 post tests fails" -ForegroundColor Red
        exit $LastExitCode
    }
}