# Script partially came from this site: https://www.powershellbros.com/run-script-to-check-cpu-and-memory-utilization/

function Get-DiskUtilization($server){
   # Get LogicalDisk info and write it to a CSV file
   Get-WmiObject -Query "SELECT * FROM Win32_LogicalDisk WHERE DriveType=3" -ComputerName $server |
   Select-Object SystemName, Name, FreeSpace, Size |
   Export-Csv -Path "\\server1\ImportPath\DiskUtilization.csv" -NoTypeInformation -Append
}

function Remove-QuotationMarks($file){
    ForEach($line in $file)
    {
        $Content = Get-Content -path $file
        $Content | ForEach {$_ -replace "`"", ""} | Set-Content $file
    }
}

# Clear the csv files, so that we only display the current information
# We will import the data into SQL, so these files only need to store the current snapshot data
Clear-Content -Path "\\server1\ImportPath\DiskUtilization.csv"
Clear-Content -Path "\\server1\ImportPath\ServerAvailabilityMemoryAndCPU.csv"

$Servers = Get-Content "\\server1\Example\servers.txt"
$Array = @()

ForEach($Server in $Servers)
{
    $Server = $Server.Trim()

    Write-Host "Processing $Server"

    $Check = $null
    $Processor = $null
    $ComputerMemory = $null
    $RoundMemory = $null
    $Object = $null

    # Creating custom object
    $Object = New-Object PSCustomObject
    $Object | Add-Member -MemberType NoteProperty -Name ServerName -Value $Server

    $Check = Test-Path -Path "\\$Server\c$" -ErrorAction SilentlyContinue

    If($Check -match "True")
    {
        $Status = 1

        Try
        {
            # Processsor Utilization
            $Processor = (Get-WmiObject -ComputerName $Server -Class Win32_Processor -ErrorAction Stop | Measure-Object -Property LoadPercentage -Average | Select-Object Average).Average

            # Memory Utilization
            $ComputerMemory = Get-WmiObject -ComputerName $Server -Class Win32_OperatingSystem -ErrorAction Stop
            $Memory = ((($ComputerMemory.TotalVisibleMemorySize - $ComputerMemory.FreePhysicalMemory) * 100) / $ComputerMemory.TotalVisibleMemorySize)
            $RoundMemory = [math]::Round($Memory, 2)

            # Disk Utilization
            Get-DiskUtilization($server)
        }
        Catch
        {
            Write-Host "Something went wrong" -ForegroundColor Red
            Continue
        }

        If(!$Processor -and $RoundMemory)
        {
            $RoundMemory = $null
            $Processor = $null
        }

        $Object | Add-Member -MemberType NoteProperty -Name IsOnline? -Value $Status
        $Object | Add-Member -MemberType NoteProperty -Name Memory% -Value $RoundMemory
        $Object | Add-Member -MemberType NoteProperty -Name CPU% -Value $Processor

        # Adding custom object to our array
        $Array += $Object
    }
    Else
    {
        $Object | Add-Member -MemberType NoteProperty -Name IsOnline? -Value 0
        $Object | Add-Member -MemberType NoteProperty -Name Memory% -Value $null
        $Object | Add-Member -MemberType NoteProperty -Name CPU% -Value $null

        # Adding custom object to our array
        $Array += $Object
    }
}

If($Array)
{
    $Array | 
    Sort-Object IsOnline? |
    Export-Csv -Path "\\server1\ImportPath\ServerAvailabilityMemoryAndCPU.csv" -NoTypeInformation -Append
}


# Clean up the files so SQL can import correctly
$FileName = "\\server1\ImportPath\DiskUtilization.csv"
Remove-QuotationMarks($FileName)


$FileName = "\\server1\ImportPath\ServerAvailabilityMemoryAndCPU.csv"
Remove-QuotationMarks($FileName)

