#
# TO RUN
#
# cd C:\cygwin64\home\tmp
# PowerShell.exe -ExecutionPolicy UnRestricted -File setup.ps1
#
#Set-PSDebug -Trace 1
Set-StrictMode -Version 2.0
$ErrorActionPreference = "Stop"
$PSDefaultParameterValues['*:ErrorAction']='Stop'

# 
# COMMON PROPERTIES
#
$DOWNLOAD_PATH="$env:USERPROFILE\Downloads"
$CIGWIN_MIRROR="ftp://mirror.internode.on.net/pub/cygwin/"

# Do not change from here
$CYGWIN_URL="https://cygwin.com"
$CYGWIN_EXEC="setup-x86_64.exe"
$WINRM_URL = "https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/"
$WINRM_PS1 = "ConfigureRemotingForAnsible.ps1"
$AZURE_CLI = "AzureCLI.msi"

# Variables shared with Ansible
$CIGWIN_PATH=$env:CIGWIN_PATH
$JAVA_VERSION=$env:JAVA_VERSION
$JAVA_ZIP=$env:JAVA_ZIP
$ELASTIC_VERSION=$env:ELASTIC_VERSION

# ELK/Java Properties
# Check https://jdk.java.net/
$JAVA_URL="https://download.java.net/openjdk/jdk$JAVA_VERSION/ri"
$ELASTIC_BASE_URL="https://artifacts.elastic.co/downloads"
$ELASTIC_BEATS_URL="$ELASTIC_BASE_URL/beats"
$ELASTICSEARCH_VERSION="elasticsearch-$ELASTIC_VERSION-windows-x86_64"
$LOGSTASH_VERSION="logstash-$ELASTIC_VERSION"
$WINLOGBEAT_VERSION="winlogbeat-$ELASTIC_VERSION-windows-x86_64"
$AUDITBEAT_VERSION="auditbeat-$ELASTIC_VERSION-linux-x86_64"
$FILEBEAT_VERSION="filebeat-$ELASTIC_VERSION-linux-x86_64"
$CIGWIN_TMP="$CIGWIN_PATH\tmp"
$ELASTICSEARCH_ZIP="$ELASTICSEARCH_VERSION.zip"
$LOGSTASH_ZIP="$LOGSTASH_VERSION.zip"
$WINLOGBEAT_MSI="$WINLOGBEAT_VERSION.msi"
$WINLOGBEAT_ZIP="$WINLOGBEAT_VERSION.zip"
$AUDITBEAT_GZ="$AUDITBEAT_VERSION.tar.gz"
$FILEBEAT_GZ="$FILEBEAT_VERSION.tar.gz"

#
# Install cygwin (needed for running ansible scripts and host downloaded files) and other critical components like git and ansible
#
# https://www.jeffgeerling.com/blog/running-ansible-within-windows
#Set-PSDebug -Trace 1
if(-not (Test-Path $DOWNLOAD_PATH\$CYGWIN_EXEC)) {
echo Downloading $CYGWIN_URL/$CYGWIN_EXEC
Invoke-WebRequest -UseBasicParsing -Uri $CYGWIN_URL/$CYGWIN_EXEC -OutFile $DOWNLOAD_PATH\$CYGWIN_EXEC; 
}
# Please check https://cygwin.com/faq/faq.html#faq.setup.cli for cywin install options/documentation
if(-not (Test-Path $CIGWIN_PATH\Cygwin.bat)) {
echo Installing $DOWNLOAD_PATH\$CYGWIN_EXEC -Wait -ArgumentList "--no-admin -s $CIGWIN_MIRROR -n -l $DOWNLOAD_PATH -P ansible,curl,python,python-jinja,python-crypto,python-openssl,python-setuptools,git,vim,openssh,openssl,openssl-devel,pip,sshpass,unzip"
echo Please hit return if the message "Changing gid to Administrators" appears
Start-Process  $DOWNLOAD_PATH\$CYGWIN_EXEC -Wait -ArgumentList "-s $CIGWIN_MIRROR -n -l $DOWNLOAD_PATH -P ansible,curl,python,python-jinja,python-crypto,python-openssl,python-setuptools,git,vim,openssh,openssl,openssl-devel,pip,sshpass,unzip"
}

cd $CIGWIN_TMP
#
# Download other project dependencies (if the download fail you will need to remove old install files from /home/tmp
# - Azure cli to create remote log server (optional)
# - Java to install local log server (optional)
#

if(-not (Test-Path .\$AZURE_CLI)) {
echo Downloading https://aka.ms/installazurecliwindows
Invoke-WebRequest -UseBasicParsing -Uri https://aka.ms/installazurecliwindows -OutFile .\$AZURE_CLI
echo Please hit return if Azure Cli installation has not started
Start-Process msiexec.exe -Wait -ArgumentList "/I $AZURE_CLI"
}

# Download ELASTICSEARCH
if(-not (Test-Path .\$ELASTICSEARCH_ZIP)) {
echo Downloading $ELASTIC_BASE_URL/elasticsearch/$ELASTICSEARCH_ZIP
echo Please hit return if download has not started
Invoke-WebRequest -UseBasicParsing -Uri $ELASTIC_BASE_URL/elasticsearch/$ELASTICSEARCH_ZIP -OutFile .\$ELASTICSEARCH_ZIP; 
}
# Download Java for Windows (required for Logstash)
if(-not (Test-Path .\$JAVA_ZIP)) {
echo Downloading $JAVA_URL/$JAVA_ZIP
echo Please hit return if download has not started
Invoke-WebRequest -UseBasicParsing -Uri $JAVA_URL/$JAVA_ZIP -OutFile .\$JAVA_ZIP -PassThru; 
}
# Download LOGSTASH
if(-not (Test-Path .\$LOGSTASH_ZIP)) {
echo Downloading $ELASTIC_BASE_URL/logstash/$LOGSTASH_ZIP
Invoke-WebRequest -UseBasicParsing -Uri $ELASTIC_BASE_URL/logstash/$LOGSTASH_ZIP -OutFile .\$LOGSTASH_ZIP; 
}
# Download winlogbeat to capture windows logs
if(-not (Test-Path .\$WINLOGBEAT_ZIP)) {
echo Please hit return if download has not started
echo Downloading $ELASTIC_BEATS_URL/winlogbeat/$WINLOGBEAT_ZIP
Invoke-WebRequest -UseBasicParsing -Uri $ELASTIC_BEATS_URL/winlogbeat/$WINLOGBEAT_ZIP -OutFile .\$WINLOGBEAT_ZIP; 
}
# DOwnload auditbeat to capture linux logs
if(-not (Test-Path .\$AUDITBEAT_GZ)) {
echo Downloading $ELASTIC_BEATS_URL/auditbeat/$AUDITBEAT_GZ
echo Please hit return if download has not started
Invoke-WebRequest -UseBasicParsing -Uri $ELASTIC_BEATS_URL/auditbeat/$AUDITBEAT_GZ -OutFile .\$AUDITBEAT_GZ
}
# DOwnload filebeat to capture linux logs
if(-not (Test-Path .\$FILEBEAT_GZ)) {
echo Downloading $ELASTIC_BEATS_URL/filebeat/$FILEBEAT_GZ
echo Please hit return if download has not started
Invoke-WebRequest -UseBasicParsing -Uri $ELASTIC_BEATS_URL/filebeat/$FILEBEAT_GZ -OutFile .\$FILEBEAT_GZ
}

#
# Allow winrm in this machine
#
if(-not (Test-Path .\$WINRM_PS1)) {
echo Downloading $WINRM_URL/$WINRM_PS1
Invoke-WebRequest -UseBasicParsing -Uri $WINRM_URL/$WINRM_PS1 -OutFile .\$WINRM_PS1; 
}
powershell.exe -ExecutionPolicy ByPass -File $WINRM_PS1

#
# Allow winrm in clients
# Can be done using GPO or
# https://docs.ansible.com/ansible/latest/user_guide/windows_setup.html#winrm-setup
# Please check link but a summary is running as admin in Powershell
#   $url = "https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1"
#   $file = "$env:temp\ConfigureRemotingForAnsible.ps1"
#   (New-Object -TypeName System.Net.WebClient).DownloadFile($url, $file)
#   powershell.exe -ExecutionPolicy ByPass -File $file

# winrm quickconfig -transport:https

# https://www.howtogeek.com/245982/whats-the-difference-between-private-and-public-networks-in-windows/
# Yo might also need to run the commands above if the computers aren't in a domain 
#   Set-Item wsman:\localhost\client\trustedhosts REMOTE_IP (in localhost and remote machines)
#   Restart-Service WinRM

# Alternatively

# https://thwack.solarwinds.com/t5/SAM-Discussions/Unable-to-get-a-remote-Powershell-script-running/td-p/211096
# Open a cmd console in admin mode and run
#   winrm quickconfig
#   winrm set winrm/config/client @{TrustedHosts="IP_ADDRESS"}
# where IP_ADDRESS is the IP of this server
# Enable winrm on a less insecure way (using self-signed certificates)
#   $url = "https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1"
#   $file = "$env:temp\ConfigureRemotingForAnsible.ps1"
#   (New-Object -TypeName System.Net.WebClient).DownloadFile($url, $file)
#   powershell.exe -ExecutionPolicy ByPass -File $file






