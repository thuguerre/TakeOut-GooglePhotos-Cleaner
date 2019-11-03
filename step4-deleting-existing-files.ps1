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


# getting both complete folder structures, only for files
$takeOutFolder = Get-ChildItem -Recurse -Path $takeOutArchivePath | Where-Object { $_.PsIsContainer -eq $false }
$referenceFolder = Get-ChildItem -Recurse -Path $referenceFolderPath | Where-Object { $_.PsIsContainer -eq $false }

# comparing both file lists, identifying what ones are existing on both sides and deleting them
Compare-Object -ReferenceObject $takeOutFolder -DifferenceObject $referenceFolder -IncludeEqual -ExcludeDifferent `
    | ForEach-Object {
        Add-Content $logFile -Value $_.InputObject.FullName
        Remove-Item -Path $_.InputObject.FullName
    }


Add-content $Logfile -value ""
Add-content $Logfile -value "# Deleting empty folders"
Add-content $Logfile -value ""

Do {

    #selecting folders to delete
    $allEmptyFolders = (Get-ChildItem $takeOutArchivePath -Recurse `
        | Where-Object { $_.PsIsContainer -eq $true } `
        | Where-Object { $_.GetFiles().Count -eq 0 -and $_.GetDirectories().Count -eq 0 } ).Fullname

    #logging folders to delete
    $allEmptyFolders | Add-Content $logFile

    #deleting empty folders
    if ( $allEmptyFolders.Count -gt 0 ) {
        $allEmptyFolders | Remove-Item
    }

} While ( $allEmptyFolders.Count -gt 0 )
    

Add-content $Logfile -value ""
Add-content $Logfile -value ""
Add-content $Logfile -value "###################################"
Add-content $Logfile -value "### end deleting existing files ###"
Add-content $Logfile -value "###################################"
Add-content $Logfile -value ""

