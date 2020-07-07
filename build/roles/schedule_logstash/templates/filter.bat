@echo off
cd %~dp0
..\bin\logstash.bat -f filter.conf
