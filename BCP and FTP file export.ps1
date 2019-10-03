<#
.SYNOPSIS
  Send data from SQL via FTP
.DESCRIPTION
  This runs a stored procedure to generate the data, sends it to a file, zips the file, then sends the file to the final destination.
#>

$servername = "server1"
$database = "database1"
$fileName = "FILENAME_$(Get-Date -Format MM)_$(Get-Date -Format dd)_$(Get-Date -Format yyyy)"
$outputFile = "\\server1\ExportPath\$fileName.csv"
$zipFile = "\\server1\ExportPath\ZIP_$fileName.zip"
$query = "EXEC $servername.$database.ExportContactsWithHeaderRow"

bcp $query queryout $outputFile -S sqlsvr1 -t"|" -T -c

# Zip the file
Compress-Archive -LiteralPath $outputFile -CompressionLevel Optimal -DestinationPath $zipFile -Force # -Force used to overwrite the existing archive file

# Send the file
# Got this sample script from here: https://stackoverflow.com/questions/38732025/upload-file-to-sftp-using-powershell/38735275

# Set the credentials
$Password = ConvertTo-SecureString '{example}' -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential ('{example}', $Password)

# Set local file path, SFTP path, and the backup location path which I assume is an SMB path
$FilePath = $zipFile
$SftpPath = '/import'
$BackupPath = '\\server1\BackupPath'

# Set the location of the SFTP server
$SftpHost = 'ftp1.exacttarget.com'

# Load the Posh-SSH module - run (Get-Module -ListAvailable Posh-SSH).path to get path. Moving it somewhere simple might be a better idea
Import-Module "C:\Program Files\WindowsPowerShell\Modules\Posh-SSH\2.0.2\Posh-SSH.psd1"

# Establish the SFTP connection
$ThisSession = New-SFTPSession -ComputerName $SftpHost -Credential $Credential

# Upload the file to the SFTP path
Set-SFTPFile -SessionId ($ThisSession).SessionId -LocalFile $FilePath -RemotePath $SftpPath -Overwrite

#Disconnect all SFTP Sessions
Get-SFTPSession | % { Remove-SFTPSession -SessionId ($_.SessionId) }

# Copy the zipped file to the backup location
Copy-Item -Path $FilePath -Destination $BackupPath -Force