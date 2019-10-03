<#
.SYNOPSIS
  Find when a user had last logged on

.DESCRIPTION
  This program takes one variable ($User) and checks against Active Directory to see when they last logged on.
  This was originally created to verify if a user had logged on after having their password reset.
  I knew the reset was successful because their "LastLogonDate" was after I had reset the password.

.EXAMPLE
  To find when the user JD Wilson (jwilson) had last logged on, change the $User variable to "jwilson"
#>

$User = ""

Get-ADUser -Identity $User -Properties "LastLogonDate"