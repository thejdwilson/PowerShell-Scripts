<#
.SYNOPSIS
    Create SSRS Subscription
        
.DESCRIPTION
    Takes in arguments and uses those to create a new report subscription in SSRS
        
.NOTES
    Some useful links:
    https://www.powershellgallery.com/packages/ReportingServicesTools/0.0.6.4  --> Where to download this library
    https://github.com/microsoft/ReportingServicesTools  --> Official Microsoft Github repo for this library
    https://www.mssqltips.com/sqlservertip/4738/powershell-commands-for-sql-server-reporting-services/  --> General tips
#>

server = $args[0]
$report = $args[1]
$description = $args[2]
$eventType = $args[3]
$startTime = $args[4]
$deliveryFormat = $args[5]
$sendTo = $args[6]
$renderFormat = $args[7]
$subject = $args[8]
$replyTo = $args[9]
$priority = $args[10]

<#
Write-Host "Args[0] = $args[0], " `
"Args[1] = $args[1], " `
"Args[2] = $args[2], " `
"Args[3] = $args[3], " `
"Args[4] = $args[4], " `
"Args[5] = $args[5], " `
"Args[6] = $args[6], " `
"Args[7] = $args[7], " `
"Args[8] = $args[8], " `
"Args[9] = $args[9], " `
"Args[10] = $args[10], "
#>

New-RsSubscription `
 -ReportServerUri $server `
 -RsItem $report `
 -Description $description `
 -EventType $eventType `
 -Schedule (New-RsScheduleXML -Daily -Interval 1 -Start $startTime) `
 -DeliveryMethod $deliveryFormat `
 -To $sendTo `
 -RenderFormat $renderFormat `
 -Subject $subject `
 -ReplyTo $replyTo `
 -Priority $priority
