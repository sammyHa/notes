---
title: MSSQL
date: 2024-10-30
tags: 
techniques: 
tools:
  - MSSQL
machines: 
difficulty: 
status: 
type: 
os: 
categories: 
exam-priority: 
time-invested:
---
>[!tip]- Tips
>Write tips here

### References
- Layered Enumeration Framework Guide
- Comprehensive OSCP Enumeration Strategies

### MSSQL - Microsoft SQL Server

**Overview**

- **MSSQL** (Microsoft SQL Server) is Microsoft's **closed-source** relational database management system (RDBMS).
- Primarily developed for **Windows OS**, though compatible versions exist for **Linux** and **macOS**.
- Popular among database administrators and developers for applications running on **Microsoft’s .NET framework** due to its native support.

**Key Points**

- **Closed Source**: Unlike MySQL, MSSQL is proprietary.
- **Platform**: Runs mainly on **Windows**; however, some versions support Linux and macOS.
- **Primary Use**: Frequently encountered on targets running **Windows** and in environments using **Microsoft-based tech stacks**.

---

### MSSQL Clients - SQL Server Management Studio (SSMS)

**Overview**

- **SQL Server Management Studio (SSMS)** is a client-side application used to manage MSSQL databases.
- Can be installed with the **MSSQL install package** or downloaded separately.
- Commonly used for both initial configuration and **long-term database management** by administrators.

**Key Points**

- **Installation**: Typically installed on the database server but can also be on other systems for **remote management**.
- **Usage**: Allows admin access and can sometimes be found with **saved credentials** on vulnerable systems.
- **Importance in Penetration Testing**: Saved credentials within SSMS could provide access to the MSSQL database if discovered on a compromised host.

**Important Tools & Concepts**

- **SSMS**: The primary tool for managing MSSQL databases, valuable for initial setup and ongoing maintenance.
- **Vulnerability Focus**: Systems with SSMS and saved credentials present potential points for privilege escalation or lateral movement.

---

This structure is suitable for a penetration testing perspective, focusing on MSSQL's features, typical deployment environments, and potential security implications related to SSMS.
![[Pasted image 20241111104929.png]]

Many other clients can be used to access a database running on MSSQL. Including but not limited to:

||||||
|---|---|---|---|---|
|[mssql-cli](https://docs.microsoft.com/en-us/sql/tools/mssql-cli?view=sql-server-ver15)|[SQL Server PowerShell](https://docs.microsoft.com/en-us/sql/powershell/sql-server-powershell?view=sql-server-ver15)|[HeidiSQL](https://www.heidisql.com/)|[SQLPro](https://www.macsqlclient.com/)|[Impacket's mssqlclient.py](https://github.com/SecureAuthCorp/impacket/blob/master/examples/mssqlclient.py)|

```shell
#using impacket's mssqlclient.py
locate mssqlclient
```

|Default System Database|Description|
|---|---|
|`master`|Tracks all system information for an SQL server instance|
|`model`|Template database that acts as a structure for every new database created. Any setting changed in the model database will be reflected in any new database created after changes to the model database|
|`msdb`|The SQL Server Agent uses this database to schedule jobs & alerts|
|`tempdb`|Stores temporary objects|
|`resource`|Read-only database containing system objects included with SQL server|

## Default Configuration

When an admin initially installs and configures MSSQL to be network accessible, the SQL service will likely run as `NT SERVICE\MSSQLSERVER`. Connecting from the client-side is possible through Windows Authentication, and by default, encryption is not enforced when attempting to connect.
![[Pasted image 20241111105111.png]]


### Dangerous Settings in MSSQL

**Overview**

- Adopting an **IT administrator's perspective** can be valuable when identifying **misconfigurations** during an engagement.
- IT environments are often pressured by **high workloads** and **time constraints**, which can lead to mistakes and overlooked settings.
- Even small misconfigurations can pose serious risks, particularly for **critical servers** or **services** like MSSQL.

**Key Points**

- **Misconfigurations** in MSSQL can leave the database vulnerable to compromise.
- The following settings are worth scrutinizing due to their security implications:

---

### Common MSSQL Misconfigurations to Check

1. **Lack of Encryption on MSSQL Client Connections**
    
    - **Risk**: Unencrypted connections expose data to **network eavesdropping**.
    - **Focus**: Ensure encryption is enforced for MSSQL clients connecting to the server.
2. **Use of Self-Signed Certificates for Encryption**
    
    - **Risk**: Self-signed certificates are susceptible to **spoofing**, potentially allowing attackers to impersonate the server.
    - **Focus**: Check if encryption is enabled and if so, verify that a trusted CA-signed certificate is used.
3. **Use of Named Pipes**
    
    - **Risk**: Named pipes are less secure and can be exploited for unauthorized access.
    - **Focus**: Assess if named pipes are necessary; if not, consider disabling this setting.
4. **Weak or Default `sa` Credentials**
    
    - **Risk**: Default or weak passwords for the **`sa` account** create easy entry points for attackers.
    - **Focus**: Verify that strong credentials are set and consider disabling the `sa` account if it’s not in use.

---

### Importance in Penetration Testing

These settings, if misconfigured, can provide **attack vectors** that allow for unauthorized database access, interception of sensitive data, or lateral movement within the network.

### Footprinting the MSSQL Service

**Overview**

- **Footprinting** helps gather detailed information about the **MSSQL service** by identifying specific configurations, versions, and instances.
- Using **Nmap** with MSSQL scripts can yield valuable data, especially when scanning the **default TCP port 1433** (typically used by MSSQL).

**Key Points**

- **Specific Scans**: Tailor Nmap scans to MSSQL to maximize information gathered.
- **Default Scripts**: Nmap has built-in MSSQL scripts designed to probe the service and extract relevant details.

---

### [[Nmap]] MSSQL Scripted Scan Example

**Information Gathered**

- **Hostname**: Provides the **server identity** within the network.
- **Database Instance Name**: Identifies specific **MSSQL instance** on the server.
- **Software Version**: Helps assess if the **MSSQL version** has known vulnerabilities.
- **Named Pipes Status**: Shows if **named pipes** are enabled, which may present additional security risks.

**Command to Run**

- Use Nmap's MSSQL scripts on the default MSSQL port (1433) for footprinting:
    
    ```bash
nmap -p 1433 --script ms-sql-* <target-ip>

```

---
### Importance in Penetration Testing

- **Documentation**: Record details like hostname, instance name, software version, and named pipes status, as they can aid in **further exploitation** or **network enumeration**.
- **Vulnerability Assessment**: Knowing the exact version and configuration can help identify **potential vulnerabilities** specific to that MSSQL setup.

```shell
sudo nmap --script ms-sql-info,ms-sql-empty-password,ms-sql-xp-cmdshell,ms-sql-config,ms-sql-ntlm-info,ms-sql-tables,ms-sql-hasdbaccess,ms-sql-dac,ms-sql-dump-hashes --script-args mssql.instance-port=1433,mssql.username=sa,mssql.password=,mssql.instance-name=MSSQLSERVER -sV -p 1433 10.129.201.248
```

### MSSQL Ping in [[Metasploit]]
```shell
msf6 > search mssql_ping
```
![[Pasted image 20241111110648.png]]


### Basic Commans
```bash
# Get Microsoft SQL server version
select @@version;

# Get usernames
select user_name()
go 

# We need to use GO after our query to execute the SQL syntax. 
# List databases
SELECT name FROM master.dbo.sysdatabases
go

# Select a database
USE $dbName
go
## Examples: Select a database master
## USE master

# Check out which one is the current selected database
SELECT DB_NAME()
go

# Show tables
SELECT table_name FROM $dbName.INFORMATION_SCHEMA.TABLES
go

# Select a database and show content of a specific table.  
USE $dbName
SELECT * FROM $tableName 

# Example: Select all Data from Table "users". The name of the table ("users") was obtained when running the command for showing the tables.
SELECT * FROM users
go

# Get a list of users in the domain
SELECT name FROM master..syslogins
go

# Get a list of users that are sysadmins
SELECT name FROM master..syslogins WHERE sysadmin = 1
go

# And to make sure: 
SELECT is_srvrolemember('sysadmin')
go
# If your user is admin, it will return 1.
```