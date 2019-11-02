<#
.SYNOPSIS
    Reorganize $takeOutArchivePath's folders (and its contained files) to reproduce a referenced folder's structure.
    This step is a pre-requisite to compare files between two similar folder structures (see step 4).
    All folders from $takeOutArchivePath which are not found in $referenceFolderPath are moved to an 'unknown' folder to be processed manually.
.PARAMETER takeOutArchivePath
    The folder in which we are trying to reorganize folders.
    By default, ".\test-resources\take-out-archive" in order to perform tests.
.PARAMETER referenceFolderPath
    The folder we will try to copy the structure. It will not be modified at all.
    By default, ".\test-resources\reference-folder" in order to perform tests.
.PARAMETER unknownFolderPath
    The folder path in which all unfound folders from $takeOutArchivePath will be moved to be processed manually later.
    By default, ".\test-resources\take-out-archive-unknown", outside $takeOutArchivePath in order to disturb process with pre-requisite technical files.
.PARAMETER logFile
    Path to the file where to log all folder moves.
    By default, ".\takeout-googlephotos-cleaner.log" in root folder, ignored by GIT.
#>

param(  [string] $takeOutArchivePath = ".\test-resources\take-out-archive",
        [string] $referenceFolderPath = ".\test-resources\reference-folder",
        [string] $unknownFolderPath = ".\test-resources\take-out-archive-unknown",
        [string] $logFile = ".\takeout-googlephotos-cleaner.log")


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