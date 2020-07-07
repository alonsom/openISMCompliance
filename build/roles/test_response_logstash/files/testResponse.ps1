#
# TO RUN
#
# cd C:\cygwin64\home\tmp
# PowerShell.exe -ExecutionPolicy UnRestricted -File test.ps1
#
#Set-PSDebug -Trace 1
Set-StrictMode -Version 2.0
$ErrorActionPreference = "Stop"
$PSDefaultParameterValues['*:ErrorAction']='Stop'
$LOGSTASH_PATH = $env:LOGSTASH_PATH
echo cd $LOGSTASH_PATH/config
cd $LOGSTASH_PATH/config
echo ..\bin\logstash -f testFilterResponse.conf 
..\bin\logstash -f testFilterResponse.conf 







