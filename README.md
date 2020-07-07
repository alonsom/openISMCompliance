# OpenISMControls
Automatic and continuous compliance solution for the ISM's Essential 8.
Version 1.0
Copyright (C) 2020 Dr. Alonso Marquez

## Objective
The objective of this project is to create a community supporting and improving an open source, free solution for ISM's Essential 8 compliance.
The system showcases the "streaming compliance" pattern for automatic and continuous compliance.

## Description
Open source project containing Ansible and Powershell scripts for installing, configuring and testing
an Essential 8 compliance assessment/remediation solution (this initial release only includes the assessment of control 843 - Whitelisting). 
This solution install and configure a Logstash instance that collects and process security related events. It also install security agents collecting
critical security logs.

## Features
* User-friendly: Enables a non-IT expert to install/try the tool and assess its Essential 8 compliance (only whitelisting in this release)
* Pure open source: Fully Built using open source products (Logstash, Winlog/Filebeat, Ansible, powershell/shell)
* Supports Windows and RHEL (other Linux distributions to be added soon)
* Test and Production options: Could be installed in a local server (non-cloud option) or in the Cloud (Azure option)
  * Capture and store elk logs and whitelisting notable events in the local server running the scripts OR
  * Capture and store elk logs and whitelisting notable events in a remote Logstash server created in Azure
* Centralized logging facility: Captures and stores in compressed format most critical security logs for later analysis
* Enterprise Ready: Could be easily adapted to a full enterprise solution (please see instructions below)
  * Cloud version follows stringent security standards including 
    * only allow access for ssh, http/httpd and logs traffic
	* RHEL firewall blocks any access except for ssh, http/httpd and logs traffic
	* Easily extensible using configs files (e.g. windlogbeat.yml  and hosts.yml
* Fully automated including validations: The scripts cover the whole life-cycle:
  * Initial Install
  * Testing suite to validate installation health
  * Update all/specific components and/or configurations
  * Upgrade to a later ELK/Java version 
  * Delete whole system or specific components
* Declarative: Idempotent scripts based on desired state could be repeatedly run and they will only apply changes from previous runs.
* The scripts have been tested in Windows 10 and RHEL environments using Java 11 and ELK 7.7
		
## Steps to make the solution Production Ready
  * Create and enable certificates between ELK clients and Logstash
  * Enable SSH key host checking in ansible.cfg (host_key_checking = True) and manually add machine certificates to Cygwin know_hosts (e.g. by connection using ssh to new machines from Cygwin bash).
  * Update windows_approved_executables.yml in build\roles\schedule_logstash\templates with your environment approved executables
  * Limit the allowed connections to remote Logstash instance to the IP of the machine where Ansible has been installed.
  * Encrypt any beat client users/passwords using ansible-vault

## Pending tasks/improvements
* Improve code documentation, include SOP for running and updating critical properties
* Add a copyrigth line to every file
* Add feedback received from beta-testers
* Include examples for other Essential 8 controls
* Include examples of automatic response (e.g. blocking the execution using GPO)
* Whitelisting for Linux machines
* Support other linux families (e.g. Ubuntu)
* Replace some powershell scripts for the equivalent ansible module (e.g. win_scheduled_task)
* Diagnostic bug found when using the Winlogbeat service and replace schedule task by service if solution found 
* Manage better the failures of the setup.ps1 script
* log4j2 configuration missing at path /usr/share/logstash/config/log4j2.properties (only NIX version) 
* Add another maintream Cloud provider (e.g. AWS)
* Add another streaming options (e.g. Yara or Splunk Heavy Forwarders)
* Automate learning phase of the whitelisting solution


