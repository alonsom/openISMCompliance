$Trigger= New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionDuration  (New-TimeSpan -Days 1)  -RepetitionInterval  (New-TimeSpan -Minutes 25)
#$Trigger= New-ScheduledTaskTrigger -Daily -At (Get-Date).AddMinutes(2)  
#-RepetitionDuration  (New-TimeSpan -Days 1)  -RepetitionInterval  (New-TimeSpan -Minutes 5)
#$Trigger= New-ScheduledTaskTrigger -Daily -AsJob -AtStartup
#$Action= New-ScheduledTaskAction -Execute "C:\{{logstash_folder}}\config\filter.bat" -WorkingDirectory "C:\{{logstash_folder}}\config" 
$Action= New-ScheduledTaskAction -Execute "cmd.exe" -Argument "/C filter.bat" -WorkingDirectory "C:\{{logstash_folder}}\config" 
#Register-ScheduledTask -TaskName "Logstash" -Trigger $Trigger -User "SYSTEM" -Action $Action -RunLevel Highest
Register-ScheduledTask -TaskName "Logstash" -Trigger $Trigger -User "{{ ansible_user}}" -Password "{{ ansible_password }}" -Action $Action -RunLevel Highest 
