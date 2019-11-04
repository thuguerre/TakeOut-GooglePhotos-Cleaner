<#
.SYNOPSIS
    Crawl Take Out Archive in order to delete files existing in Reference Folder.
    It will let only the files to later manually synchronize into Reference Folder.
.PARAMETER takeOutArchivePath
    The folder in which deleting existing files.
.PARAMETER referenceFolderPath
    The folder containing referent files, to compare with. It will not be modified at all.
.PARAMETER unknownFolderPath
    The folder path in which all unfound folders from $takeOutArchivePath will be moved to be processed manually later.
    Only used to perform auto-tests.
.PARAMETER logFile
    Path to the file where to log all files deletion.
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
Add-content $Logfile -value "#####################################"
Add-content $Logfile -value "### start deleting existing files ###"
Add-content $Logfile -value "#####################################"
Add-content $Logfile -value ""


# getting both complete folder structures, only for files
$takeOutFolder = Get-ChildItem -Recurse -Path $takeOutArchivePath | Where-Object { $_.PsIsContainer -eq $false }
$referenceFolder = Get-ChildItem -Recurse -Path $referenceFolderPath | Where-Object { $_.PsIsContainer -eq $false }

# comparing both file lists, identifying what ones are existing on both sides and deleting them
$filesToIgnore = (Compare-Object -ReferenceObject $takeOutFolder -DifferenceObject $referenceFolder -IncludeEqual -ExcludeDifferent)

$i = 0
foreach ($file in $filesToIgnore) {

    Add-Content $logFile -Value $file.InputObject.FullName
    Remove-Item -Path $file.InputObject.FullName

    $percent = [System.Math]::Round($i++ / $filesToIgnore.Count * 100)
    Write-Progress -Activity "Deleting files which are on both side" -Status "$percent% Complete:" -PercentComplete $percent;
    Start-Sleep -Milliseconds 500
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


if ( $testing -eq "YES" ) {

    # performing auto-verification
    $test4Path = ".\test-step4-post.ps1" `
        + " -takeOutArchivePath """ + $takeOutArchivePath + """" `
        + " -referenceFolderPath """ + $referenceFolderPath + """" `
        + " -unknownFolderPath """ + $unknownFolderPath + """" `
        + " -logFile """ + $logFile + """"

    Invoke-Expression $test4Path

    if ($LastExitCode -ne 0) {
        Write-Host "Step 4 Post-Tests : `t`t FAILED" -ForegroundColor Red
        exit $LastExitCode
    }
}