<#
.SYNOPSIS
  Change a users password
.DESCRIPTION
  This script will change the given users password and force them to reset it when they log in next time.
  All you need to do is give the username to the $User variable.
.EXAMPLE
  To reset the password for the user JD Wilson (jwilson), change the $User variable to "jwilson"
#>

$User = ""

$NewPassword = (ConvertTo-SecureString -AsPlainText "Password1" -Force)
Set-ADAccountPassword -Identity $User -NewPassword $NewPassword -Reset