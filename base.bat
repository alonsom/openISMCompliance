@echo off
type CopyrightNotice
PAUSE
REM Check running the script with elevated rights
net.exe session 1>NUL 2>NUL || (Echo "This script requires elevated rights." & timeout 10 & Exit /b 1 )

set CIGWIN_PATH=C:\cygwin64
set JAVA_VERSION=11
set JAVA_ZIP=openjdk-%JAVA_VERSION%+28_windows-x64_bin.zip
set ELASTIC_VERSION=7.7.0
set LOGSTASH_PATH=C:/logstash-%ELASTIC_VERSION%
REM
REM Do not change from here
REM
set ANSIBLE_CONFIG=/tmp/build/ansible.cfg
REM Basic setup including any download required
cd %~dp0
powershell.exe -ExecutionPolicy UnRestricted -File .\setup.ps1
if %errorLevel% == 0 goto skip_download_script_error
echo There has been an error downloading or installing cywin/azure cli
echo If it was a download error, please ensure that TLS 1.2 is enabled in Internet Properties
echo If the install of cygwin failed, it might be your antivirus. 
echo    please scan any .exe downloaded (e.g. setup-x86_64.exe), disable your antivirus, remove C:\cygwin64, install again and enable the antivirus back
goto skip_delete
:skip_download_script_error
REM Remove all project (just in case)
RMDIR /Q/S %CIGWIN_PATH%\tmp\build

REM Copy the project to the new cygwin environment
Xcopy /E /I /Y build %CIGWIN_PATH%\tmp\build > ..\xcopy.log

REM Copy your public/private keys to ~/.ssh (enable when using certificates)
REM Xcopy ../id_rsa ~/.ssh
REM Xcopy ../id_rsa.pub ~/.ssh

if NOT "%1" == "install" goto skip_install
REM Execute ansible using cygwin to install server and clients
%CIGWIN_PATH%\bin\bash.exe --login -i -c 'ansible-playbook -i /tmp/build/hosts.yml /tmp/build/%2.yml'

:skip_install
if NOT "%1" == "del" goto skip_delete 
REM  Execute ansible using cygwin to remove everything except cygwin
%CIGWIN_PATH%\bin\bash.exe --login -i -c 'ansible-playbook -i /tmp/build/hosts.yml /tmp/build/%2.yml'

REM Remove cygwin environment
set choice=no
set /p choice=Are you sure you want to delete cygwin (yes/no)?
if '%choice%'=='yes' rmdir /S /Q %CIGWIN_PATH%
:skip_delete

Echo "This script finished. Press any key"
PAUSE