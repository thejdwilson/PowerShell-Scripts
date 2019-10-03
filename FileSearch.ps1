<#
.SYNOPSIS
  Search for files that match a search string
.DESCRIPTION
  It can take forever to find a file in our current documentation directories.
  This script takes a general search string (e.g. "SQL") and shows you every file it can find
  within the "{example1}" and "{example2}" directories that has that
  string as part of the file name.
.NOTES
  1) This will need to be installed on the server itself
  2) After finding the files, generate links that can quickly open the files
  3) Make a GUI?
  4) ????
  5) Profit
#>



Write-Host("This script will search for files within the ""{example1}"" and ""{example2}"" directories.");
Write-Host("This will use whatever you type as a wildcard. No need to add any special characters like ""*"".");
Write-Host("Because of this, you do not need to supply the entire filename; just part of it.");
Write-Host(" ");
Write-Host(" ");
$fileName = Read-Host("What file are you searching for? ");

$directories = @("C:\Temp\TestFolder", "C:\Temp\TestFolder2");
$matchingFiles = @();

ForEach($directory IN $directories)
{
  Set-Location $directory;
  $matchingFiles += Get-ChildItem -Filter "*$fileName*" -Recurse |  %{$_.FullName} |Out-String;
}

ForEach($file in $matchingFiles)
{
  if($file.Trim() -ne '')
  {
    Write-Host $file
  }
}



Set-Location C:\Temp;

