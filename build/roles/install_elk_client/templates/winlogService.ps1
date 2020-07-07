#$Trigger= New-ScheduledTaskTrigger -Daily -At (Get-Date).AddMinutes(2) 
$Trigger= New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionDuration  (New-TimeSpan -Days 1)  -RepetitionInterval  (New-TimeSpan -Minutes 5)
#$Action= New-ScheduledTaskAction -Execute "C:\{{winlogbeat_folder}}\winlogbeat.exe" -Argument "-c `"C:\{{winlogbeat_folder}}\winlogbeat.yml`" -path.home `"C:\{{winlogbeat_folder}}`"" -WorkingDirectory "C:\{{winlogbeat_folder}}\config" 
$Action= New-ScheduledTaskAction -Execute "winlogbeat.exe" -WorkingDirectory "C:\{{winlogbeat_folder}}" 
#$Register-ScheduledTask -TaskName "Winlog" -Trigger $Trigger -User "LocalService" -Action $Action -RunLevel Highest
Register-ScheduledTask -TaskName "Winlog" -Trigger $Trigger -User "SYSTEM" -Action $Action -RunLevel Highest
