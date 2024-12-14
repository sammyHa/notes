---
title: FTP
date: 2024-10-30
tags: 
techniques:
  - ftp commands
  - tftp commands
  - anonymous login
  - configuration settings
  - advanced debugging
tools:
  - vsftpd
  - ftp
  - tftp
machines: 
difficulty:
  - Meduim
status:
  - completed
type: study notes
os: Linux
categories:
  - network services
  - file transfer protocols
exam-priority: 
time-invested:
---
>[!tip]- Tips
>Write tips here

### References
- Layered Enumeration Framework Guide
- Comprehensive OSCP Enumeration Strategies

### Overview

**File Transfer Protocol (FTP)** is one of the earliest protocols in the TCP/IP stack and operates on the application layer. FTP works on two channels: a control channel (TCP port 21) for command and response exchanges and a data channel (TCP port 20) for data transfer. A distinction is made between **active** and **passive** modes:

- **Active Mode**: Client opens control channel, server opens data channel on client-specified port. May encounter firewall issues.
- **Passive Mode**: Server designates a port, client establishes data channel, bypassing firewall restrictions.

FTP is primarily used to upload/download files and organize directories. It uses clear-text transmission, posing a potential security risk if sniffed.

**Trivial File Transfer Protocol (TFTP)** is a simplified, insecure alternative to FTP, using UDP instead of TCP, without authentication and limited to public directories. TFTP is best suited for local and secure networks.

---

### Key Commands and Configurations

#### FTP Commands:

- **connect**: Set the remote host and port.
- **get**: Download files from the remote host.
- **put**: Upload files to the remote host.
- **quit**: Exit FTP session.
- **status**: Show current status, transfer mode, and connection status.
- **verbose**: Enable/disable additional transfer info.

**FTP Example Commands**:


```bash
ftp> connect 10.129.14.136 ftp> get file.txt ftp> put localfile.txt ftp> quit
```

#### TFTP Commands:

- **connect**: Set remote host and optional port.
- **get/put**: Transfer files.
- **quit**: Exit session.
- **status**: Display current mode and connection status.
- **verbose**: Toggle verbose mode.

**TFTP Example Commands**:

```bash
tftp> connect 10.129.14.136 tftp> get file.txt tftp> put file.txt tftp> quit
```

#### vsFTPd Configuration

Key settings in `/etc/vsftpd.conf`:

- **listen=NO**: Run from inetd.
- **anonymous_enable=NO**: Disable anonymous access.
- **local_enable=YES**: Allow local user login.
- **use_localtime=YES**: Set local time for file transfers.
- **xferlog_enable=YES**: Enable logging of file transfers.

Advanced options:

- **anonymous_enable=YES**: Enable anonymous login.
- **anon_upload_enable=YES**: Allow anonymous file uploads.
- **chroot_local_user=YES**: Restrict local users to their directories.

**To install vsFTPd**:


```shell
sudo apt install vsftpd

#To view configurations:
cat /etc/vsftpd.conf | grep -v "#"
```

**Footprinting the Service**

Footprinting with network scanners is a popular way to identify services, even those not on standard ports. A key tool for this task is Nmap, which includes the Nmap Scripting Engine (NSE) for running specialized scripts on specific services. To update the NSE script database, use the following command:

```bash
sudo nmap --script-updatedb
````

On a local system, NSE scripts can be located with:

bash

Copy code

```bash 
find / -type f -name ftp* 2>/dev/null | grep scripts
```

These scripts can be used to scan the FTP server typically on TCP port 21. Commands like version scan (`-sV`), aggressive scan (`-A`), and default script scan (`-sC`) can gather detailed information on the target.


```shell
sudo nmap -sV -p21 -sC -A 10.129.14.136
```

This command identifies open ports and services, checks for anonymous FTP access, and lists accessible directories or files.

**Using NSE Scripts for FTP**

The `ftp-anon` script checks for anonymous FTP login, while `ftp-syst` uses the `STAT` command to retrieve the server’s status and configuration details. To monitor the commands sent and received, add `--script-trace`:


```shell
sudo nmap -sV -p21 -sC -A 10.129.14.136 --script-trace
```

For more direct interaction with the FTP service, tools like `netcat` or `telnet` can be useful:


```shell
nc -nv 10.129.14.136 21
```

If FTP runs over TLS/SSL, `openssl` is necessary for encrypted connections, and it provides visibility into the SSL certificate:


```shell
openssl s_client -connect 10.129.14.136:21 -starttls ftp
```

Viewing the certificate can help identify details like the hostname, email, and sometimes even the organization's location.

### Advanced FTP Techniques and Commands

- **Anonymous Login**:
    
    - Allows login with `ftp` or `anonymous` user. May expose information about the server if permissions are not correctly set.
    
    ```shell
    ftp> connect 10.129.14.136 Name (10.129.14.136:anonymous): anonymous
    ```
    
- **Debugging and Tracing**:
    
    - Use `debug` and `trace` to get detailed logs for FTP commands, useful for troubleshooting connections.
    

    ```shell 
    ftp> debug ftp> trace
    ```
    
- **Security Configuration**:
    
    - Avoid enabling `anonymous_enable=YES` on public servers.
    - Configure `chroot_local_user=YES` to restrict local users.

---

### vsFTPd Security Settings

- **FTPUSERS**:
    
    - Controls denied access for specific users. Listed users in `/etc/ftpusers` cannot log in, regardless of other permissions.
    
    ```shell
    cat /etc/ftpusers
```

    
- **Dangerous Settings**:
    
    - Allowing anonymous uploads (`anon_upload_enable=YES`) or directory creation (`anon_mkdir_write_enable=YES`) increases risk.
    - **hide_ids=YES** hides UID/GID in directory listings, increasing anonymity.

### Example Configurations

**Hiding IDs**:

```shell
ftp> ls -rw-rw-r--    1 ftp     ftp      8138592 Sep 14 16:54 Calendar.pptx
```

**Anonymous Settings**:

```bash
anonymous_enable=YES anon_upload_enable=YES anon_mkdir_write_enable=YES
```

---

### Study Tip

Practice setting up and securing vsFTPd on a virtual machine. Test different configurations, especially around anonymous access and chroot restrictions, to understand the security implications and behaviors.