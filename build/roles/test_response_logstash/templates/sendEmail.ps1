#
# TO RUN
#
# PowerShell.exe -ExecutionPolicy UnRestricted -File sendEmail.ps1
#
param ([Parameter(Mandatory)]$TargetUserName,[Parameter(Mandatory)]$NonWhitelistedExec,[Parameter(Mandatory)]$TargetDomainName)

#Set-PSDebug -Trace 1
Set-StrictMode -Version 2.0
$ErrorActionPreference = "Stop"
$PSDefaultParameterValues['*:ErrorAction']='Stop'

$SmtpServer= "{{SmtpServer}}"
$SmtpUser = "{{SmtpUser}}"
$SmtpPassword = "{{SmtpPassword}}"
$To = "{{To}}"
$From = $To
$Subject = "Whitelisting violation detected"
$Body = "User=$TargetUserName has executed non-whitelisted file=$NonWhitelistedExec in host=$TargetDomainName"

$PWord = ConvertTo-SecureString -String $SmtpPassword -AsPlainText -Force
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $SmtpUser, $PWord
Send-MailMessage -SmtpServer $SmtpServer -From $From -Body $Body -Subject $Subject -To $To -UseSsl -Credential $Credential









