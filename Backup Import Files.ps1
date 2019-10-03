<#
.SYNOPSIS
  Backup import files
.DESCRIPTION
  Zip the backup files, send them to a separate area, then delete the original files. This script searches for files from the day before yesterday.
#>


# Get the table import names
$array = @("table1", "table2", "table3", "table4", "table5")

foreach($element in $array)
{
    # Find the day before yesterday's files (yesterday's file is the "current" one, so leaving that alone will make troubleshooting import issues a little easier)
    $fileName = "${element}_EXAMPLE_$((get-date).AddDays(-2).ToString("MMddyyy"))"
    $originalPath = "\\server1\ImportPath\$fileName.csv"

    # This is where the zipped files will be sent
    $zipFile = "\\server1\ImportPath\BackupPath\$fileName.zip"
    
    # Zip the file in the backup location (this is the location Darrell prefers)
    Compress-Archive -LiteralPath $originalPath -CompressionLevel Optimal -DestinationPath $zipFile -Force

    # Remove the original file
    Remove-Item $originalPath
}