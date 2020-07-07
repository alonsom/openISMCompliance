@echo off
REM Set the local ip address (required for the Ansible inventory)
REM set /p choice=Have you setup properties of all hosts including the local ansible IP (named server) in file build\hosts.yml (yes/no) [no]: 
REM if '%choice%'=='yes' goto skip_validation 
REM goto skip_install
REM :skip_validation
cd %~dp0
base.bat install install_all_nocloud
:skip_install
