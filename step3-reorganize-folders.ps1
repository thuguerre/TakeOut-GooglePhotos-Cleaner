<#
.SYNOPSIS
    Reorganize $targetFolder's folders (and its contained files) to reproduce a referenced folder's structure.
    This step is a pre-requisite to compare files between two similar folder structures (see step 4).
    All folders from $targetFolder which are not found in $referenceFolder are moved to an 'unknown' folder to be processed manually.
.PARAMETER TargetFolder
    The folder in which we are trying to reorganize folders.
    By default, ".\test-resources\test-folder" in order to perform tests.
.PARAMETER ReferenceFolder
    The folder we will try to copy the structure. It will not be modified at all.
    By default, ".\test-resources\reference-folder" in order to perform tests.
.PARAMETER UnknownFolder
    The folder path in which all unfound folders from $targetFolder will be moved to be processed manually later.
    By default, ".\test-resources\unknown", outside $targetFolder in order to disturb process with pre-requisite technical files.
.PARAMETER LogFile
    Path to the file where to log all folder moves.
    By default, ".\takeout-googlephotos-cleaner.log" in root folder, ignored by GIT.
#>

param(  [string]$targetFolder = ".\test-resources\test-folder",
        [string]$referenceFolder = ".\test-resources\reference-folder",
        [string]$unknownFolder = ".\test-resources\unknown",
        [string]$logFile = ".\takeout-googlephotos-cleaner.log")


Add-content $Logfile -value ""
Add-content $Logfile -value ""
Add-content $Logfile -value "##################################"
Add-content $Logfile -value "### start reorganizing folders ###"
Add-content $Logfile -value "##################################"
Add-content $Logfile -value ""


$targetFolderFullPath = Resolve-Path $targetFolder
$referenceFolderFullPath = Resolve-Path $referenceFolder

function MoveAtRightPlace {
    param (
        [System.IO.DirectoryInfo] $sourceItem
    )
    
    $possibleMatches = (Get-ChildItem $referenceFolder -Recurse -filter $sourceItem.Name | Where-Object { $_.PsIsContainer -eq $true }).Fullname

    if ( $possibleMatches.Count -eq 0 ) {

        # in this case, the folder has no found reference in referenced folder.
        # it has to be moved in 'unknown\not-found' to be processed manually later

        $destinationPath = $unknownFolder + "\not-found\" + $sourceItem.Name
        Move-Item -Path $sourceItem.FullName -Destination $destinationPath

        $moveLog = "no equivalent found for '" + $sourceItem.Name + "'. Move to 'not-found' folder"
        Add-Content $logFile -value $moveLog

    } elseif ( $possibleMatches.Count -eq 1) {
        
        $currentSourceFolderPath = $sourceItem.Fullname.Replace($targetFolderFullPath, "")
        $currentReferenceFolderPath = $possibleMatches.Replace($referenceFolderFullPath, "")

        if ($currentSourceFolderPath -eq $currentReferenceFolderPath) {

            $msg = "nothing to do for folder '" + $currentSourceFolderPath + "'"
            Add-Content $logFile -value $msg

        } else {

            $currentDestinationFolderPath = $targetFolderFullPath.ToString() + $currentReferenceFolderPath
            Move-Item -Path $sourceItem.FullName -Destination $currentDestinationFolderPath
            
            $moveLog = "folder '" + $currentSourceFolderPath + "' moved to '" + $currentDestinationFolderPath + "'"
            Add-Content $logFile -value $moveLog
        }

    } else {
        
        # in this case, the folder has several possible references found in referenced folder.
        # we do not know where to move it
        # it has to be moved in 'unknown\several-matches' to be processed manually later

        $destinationPath = $unknownFolder + "\several-matches\" + $sourceItem.Name
        Move-Item -Path $sourceItem.FullName -Destination $destinationPath

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


#$allTargetFolders =
Get-ChildItem $targetFolder -Recurse `
    | Where-Object { $_.PsIsContainer -eq $true } `
    | ForEach-Object { MoveAtRightPlace -sourceItem $_ }



Add-content $Logfile -value ""
Add-content $Logfile -value ""
Add-content $Logfile -value "################################"
Add-content $Logfile -value "### end reorganizing folders ###"
Add-content $Logfile -value "################################"
Add-content $Logfile -value ""