@echo on
cd %~dp0
powershell.exe .\\sendEmail.ps1 -TargetUserName '%1' -TargetDomainName '%2' -NonWhitelistedExec '%~3'
powershell.exe Write-Output %3

