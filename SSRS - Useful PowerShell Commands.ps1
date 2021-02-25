<#
.SYNOPSIS
    This script configures some Settings for SQL Server Reporting Services.
        
.DESCRIPTION
    I had a project requirement to utilize SSRS reports/subscriptions while limiting/preventing users access to the web portal.
    Microsoft's ReportingServicesTools made this a fairly easy endeavor. Here are some notes/useful commands from that process.
        
.NOTES
    Some useful links:
    https://www.powershellgallery.com/packages/ReportingServicesTools/0.0.6.4  --> Where to download
    https://github.com/microsoft/ReportingServicesTools  --> Official repo for this library
    https://www.mssqltips.com/sqlservertip/4738/powershell-commands-for-sql-server-reporting-services/  --> General tips
#>


# Create a new subscription
New-RsSubscription `
 -ReportServerUri 'http://ssrs_server/Reportserver' `
 -RsItem '/Report Directory/Report1' `
 -Description 'Report 1 (Generated through PowerShell)' `
 -EventType 'TimedSubscription' `
 -Schedule (New-RsScheduleXML -Daily -Interval 1 -Start '02/24/2021 06:00') `
 -DeliveryMethod 'Email' `
 -To 'jdwilson@email.com' `
 -RenderFormat 'MHTML' `
 -Subject 'Report 1' `
 -ReplyTo 'do-not-reply@email.com' `
 -Priority 'Normal'


# Create a new subscription with a single parameter
New-RsSubscription `
 -ReportServerUri 'http://ssrs_server/Reportserver' `
 -RsItem '/Report Directory/Report2' `
 -Description 'Report 2 (Generated through PowerShell)' `
 -EventType 'TimedSubscription' `
 -Schedule (New-RsScheduleXML -Daily -Interval 1 -Start '02/25/2021 9:04') `
 -DeliveryMethod 'Email' `
 -To 'jdwilson@email.com' `
 -RenderFormat 'MHTML' `
 -Subject 'Report 2' `
 -ReplyTo 'do-not-reply@email.com' `
 -Priority 'Normal' `
 -Parameters @{
 'RunDate'='1/6/2021'
 }

 
# Create a new subscription with multiple parameters
New-RsSubscription `
 -ReportServerUri 'http://ssrs_server/Reportserver' `
 -RsItem '/Report Directory/Report3' `
 -Description 'Report 3 (Generated through PowerShell)' `
 -EventType 'TimedSubscription' `
 -Schedule (New-RsScheduleXML -Daily -Interval 1 -Start '02/25/2021 9:00') `
 -DeliveryMethod 'Email' `
 -To 'jdwilson@email.com' `
 -RenderFormat 'MHTML' `
 -Subject 'Report 3' `
 -ReplyTo 'do-not-reply@email.com' `
 -Priority 'Normal' `
 -Parameters @{
 'RunDate'='1/6/2021'
 'OrderNo'='123456'
 }


# Get the subscriptions for this report
Get-RsSubscription -ReportServerUri 'http://ssrs_server/Reportserver' -RsItem '/Report Directory/Report1'



# To update a subscription you must first use the Get-RsSubscription, pipe that into a Where-Object, then pipe that into Set-RsSubscription
# Set-RsSubscription needs you to reverify the server, otherwise it will try to update that report on localhost
Get-RsSubscription -ReportServerUri 'http://ssrs_server/Reportserver' -RsItem '/Report Directory/Report1' | `
Where-Object {$_.Description -like "*powershell*"} | `
Set-RsSubscription -ReportServerUri 'http://ssrs_server/Reportserver' -StartDateTime "2/24/2021 9:08am"


# To delete a subscription you must first use the Get-RsSubscription, pipe that into a Where-Object, then pipe that into Remove-RsSubscription
# Remove-RsSubscription needs you to reverify the server, otherwise it will try to update that report on localhost
# This automatically prompts you to confirm whether or not you want to delete the subscription. You can bypass this with -Confirm:$false (!!BE VERY CAREFUL WITH THIS!!)
Get-RsSubscription -ReportServerUri 'http://ssrs_server/Reportserver' -RsItem '/Report Directory/Report1' | `
Where-Object {$_.Description -like "*powershell*"} | `
Remove-RsSubscription -ReportServerUri 'http://ssrs_server/Reportserver' -Confirm:$false # <-- THIS WILL RUN FOR EVERYTHING IT FINDS WITHOUT ASKING YOU TO CONFIRM EACH ITEM


# Enable/Disable subscriptions via Proxy
$proxy = New-RsWebServiceProxy -ReportServerUri 'http://ssrs_server/Reportserver/ReportService2010.asmx?wsdl';  

#$mySubscriptions = $proxy.ListMySubscriptions("/");  
#$mySubscriptions | select report, subscriptionid, description, owner, status, lastexecuted | format-table -auto

#$proxy.EnableSubscription('enter id here');
#$proxy.DisableSubscription('enter id here');
#$proxy.DeleteSubscription('enter id here');