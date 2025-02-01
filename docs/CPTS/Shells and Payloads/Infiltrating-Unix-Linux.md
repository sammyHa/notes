### Infiltrating Unix/Linux
#### Unix/Linux Usage and Pivoting in Environments

1. **Unix/Linux Dominance**:
    
    - Over **70% of websites** run on Unix-based systems.
    - Knowledge of Unix/Linux is critical for web server exploitation and pivoting.
2. **Third-Party Hosting vs. On-Premises**:
    
    - Many organizations use **3rd parties or cloud providers** for hosting.
    - However, some still host **websites/web apps on-premises**, providing an opportunity to gain deeper access.
3. **Pivoting Strategy**:
    
    - Establish a **shell session** on the target Unix/Linux server.
    - Use this access to **enumerate the internal network** and **pivot to other systems**.
4. **Key Skills to Focus On**:
    
    - Shell exploitation on Unix/Linux systems.
    - Post-exploitation techniques for network pivoting.
    - Identifying and leveraging on-premise hosting environments.

### Common Considerations
- What distribution of Linux is the system running?
- What shell & programming languages exist on the system?
- What function is the system serving for the network environment it is on?
- What application is the system hosting?
- Are there any known vulnerabilities?

### Gaining a Shell Through Attacking a Vulnerable Application
As in most engagements, we will start with an initial enumeration of the system using [Nmap].

### Enumerate the Host
```bash
nmap -sC -sV $ip
-----------------
Starting Nmap 7.91 ( https://nmap.org ) at 2021-09-27 09:09 EDT
Nmap scan report for 10.129.201.101
Host is up (0.11s latency).
Not shown: 994 closed ports
PORT     STATE SERVICE  VERSION
21/tcp   open  ftp      vsftpd 2.0.8 or later
22/tcp   open  ssh      OpenSSH 7.4 (protocol 2.0)
| ssh-hostkey: 
|   2048 2d:b2:23:75:87:57:b9:d2:dc:88:b9:f4:c1:9e:36:2a (RSA)
|   256 c4:88:20:b0:22:2b:66:d0:8e:9d:2f:e5:dd:32:71:b1 (ECDSA)
|_  256 e3:2a:ec:f0:e4:12:fc:da:cf:76:d5:43:17:30:23:27 (ED25519)
80/tcp   open  http     Apache httpd 2.4.6 ((CentOS) OpenSSL/1.0.2k-fips PHP/7.2.34)
|_http-server-header: Apache/2.4.6 (CentOS) OpenSSL/1.0.2k-fips PHP/7.2.34
|_http-title: Did not follow redirect to https://10.129.201.101/
111/tcp  open  rpcbind  2-4 (RPC #100000)
| rpcinfo: 
|   program version    port/proto  service
|   100000  2,3,4        111/tcp   rpcbind
|   100000  2,3,4        111/udp   rpcbind
|   100000  3,4          111/tcp6  rpcbind
|_  100000  3,4          111/udp6  rpcbind
443/tcp  open  ssl/http Apache httpd 2.4.6 ((CentOS) OpenSSL/1.0.2k-fips PHP/7.2.34)
|_http-server-header: Apache/2.4.6 (CentOS) OpenSSL/1.0.2k-fips PHP/7.2.34
|_http-title: Site doesn't have a title (text/html; charset=UTF-8).
| ssl-cert: Subject: commonName=localhost.localdomain/organizationName=SomeOrganization/stateOrProvinceName=SomeState/countryName=--
| Not valid before: 2021-09-24T19:29:26
|_Not valid after:  2022-09-24T19:29:26
|_ssl-date: TLS randomness does not represent time
3306/tcp open  mysql    MySQL (unauthorized)
``` 
Keeping our goal of gaining a shell session in mind, we must establish some next steps after examining our scan output.

What information could we gather from the output?

Considering we can see the system is listening on ports `80 (HTTP)`, `443 (HTTPS)`, `3306 (MySQL)`, and `21 (FTP)`, it may be safe to assume that this is a web server hosting a web application. We can also see some version numbers revealed associated with the web stack (`Apache 2.4.6 and PHP 7.2.34` ) and the distribution of Linux running on the system (`CentOS`). Before deciding on a direction to research further (dive down a rabbit hole), we should also try navigating to the IP address through a web browser to discover the hosted application if possible.
Here we discover a network configuration management tool called `rConfig`. This application is used by network & system administrators to automate the process of configuring network appliances. 

### Discovering a Vulnerability in rConfig
Take a close look at the bottom of the web login page, and we can see the `rConfig` version number (`3.9.6`). We should use this information to start looking for any CVEs, publicly available exploits, and proof of concepts (PoCs). As we research, be sure to look closely at what we find and understand what it is doing. We, of course, want it to lead us to a shell session with the target.

Using your search engine of choice will turn up some promising results. We can use the keywords: `rConfig 3.9.6` *vulnerability*.

### Search For an Exploit Module

```bash
msf6 > search rconfig

Matching Modules
================

#Name                                             Disclosure Date  Rank       Check  Description
-  ----                                             ---------------  ----       -----  -----------
0  exploit/multi/http/solr_velocity_rce             2019-10-29       excellent  Yes    Apache Solr Remote Code Execution via Velocity Template
1  auxiliary/gather/nuuo_cms_file_download          2018-10-11       normal     No     Nuuo Central Management Server Authenticated Arbitrary File Download
2  exploit/linux/http/rconfig_ajaxarchivefiles_rce  2020-03-11       good       Yes    Rconfig 3.x Chained Remote Code Execution
3  exploit/unix/webapp/rconfig_install_cmd_exec     2019-10-28       excellent  Yes    rConfig install Command Execution
```
We can drop into a system shell (shell) to gain access to the target system as if we were logged in and open a terminal.

#### Spawning a TTY Shell with Python
When we drop into the system shell, we notice that no prompt is present, yet we can still issue some system commands. This is a shell typically referred to as a `non-tty shell`. These shells have limited functionality and can often prevent our use of essential commands like su (switch user) and sudo (super user do), which we will likely need if we seek to escalate privileges. This happened because the payload was executed on the target by the apache user. Our session is established as the apache user. Normally, admins are not accessing the system as the apache user, so there is no need for a shell interpreter language to be defined in the environment variables associated with apache.

We can manually spawn a TTY shell using Python if it is present on the system. We can always check for Python's presence on Linux systems by typing the command: which python. To spawn the TTY shell session using Python, we type the following command:

### Interactive Python
```bash
python -c 'import pty; pty.spawn("/bin/sh")' 

sh-4.2$         
sh-4.2$ whoami
whoami
apache
```
This command uses python to import the pty module, then uses the pty.spawn function to execute the bourne shell binary (/bin/sh). We now have a prompt (sh-4.2$) and access to more system commands to move about the system as we please.