---
title: SMB
date: 2024-10-30
tags:
  - oscp
  - filesharing
  - smb
techniques:
  - file and directory access
tools:
  - samba
  - rpc
  - rpcclient
  - smb
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

### Overview
- Purpose: SMB (Sever Message Block) is a protocol that facilitates client-server communication for accessing files, directories, printers, and other network resources.
- History: Initially popularized in LAN Manager and LAN Server within OS/2, it remains integral in windows os and has cross-platform support via Samba in Linux/Unix
-
### Functionality
- **File and Rersource Sharing:**  Enables clients to access shared files, directories, and services (printers routers)  within the network.
- **Cross-Platform Support** SMB is supported in Windows( Downward-compatible) and on LInux/UNix using Smaba allowing inter-communication.
-
### Access Control:
- **Access Control Lists (ACLs)** Define permissions (execute, read, full access) for specific user/groups
- **Granularity**: Control is based on network shares, which may differ from local server permissions. 
-
### Samba and CIFS:

- **Samba**: A free, open-source implementation of the SMB protocol for Unix-based systems (e.g., Linux). It allows Unix systems to communicate with Windows systems, supporting file and printer sharing.
- **CIFS (Common Internet File System)**: A specific version of SMB, created by Microsoft. It aligns with SMB version 1.0 and is sometimes referred to as "SMB/CIFS."
- **Samba and CIFS**: Samba enables Unix-based systems to use CIFS, making it compatible with Windows systems.

### Ports and Protocols:

- **SMB v1 / CIFS**: Typically operates over TCP ports **137, 138, and 139** when using NetBIOS, and **port 445** when using CIFS directly.
- **SMB 2 and SMB 3**: These newer versions use **port 445** exclusively, without relying on NetBIOS.

### SMB Versions and Key Features:

1. **CIFS / SMB 1.0**
    
    - **Supported in**: Windows NT 4.0, Windows 2000
    - **Features**: Communication via NetBIOS (TCP 137-139); later, direct TCP connections on port 445.
2. **SMB 2.0**
    
    - **Supported in**: Windows Vista, Windows Server 2008
    - **Features**: Faster, improved security with message signing, basic file caching.
3. **SMB 2.1**
    
    - **Supported in**: Windows 7, Windows Server 2008 R2
    - **Features**: Introduced file-locking improvements for better data consistency.
4. **SMB 3.0**
    
    - **Supported in**: Windows 8, Windows Server 2012
    - **Features**: Added multichannel support, encryption, and remote storage access.
5. **SMB 3.1.1**
    
    - **Supported in**: Windows 10, Windows Server 2016
    - **Features**: Integrity checks, AES-128 encryption for better security.

### Samba Features with SMB Versions:

- **Samba 3**: Allows a Linux system to join a Windows Active Directory as a member.
- **Samba 4**: Adds full Active Directory domain controller functionality to Linux, enabling it to serve as an AD controller.

### NetBIOS and Workgroups:

- **Workgroups**: Group name identifying a collection of computers and resources on an SMB network.
- **NetBIOS**: An API originally for IBM networks, facilitating name registration on the network. Each machine registers its name, or uses a **NetBIOS Name Server (NBNS)** or **Windows Internet Name Service (WINS)** for name resolution.

### Samba Configuration:

- **Config File**: Samba settings are controlled through a text configuration file, typically located at `/etc/samba/smb.conf`. This file lets you define shared directories, access permissions, and other settings to customize Samba behavior.
![[Pasted image 20241106221938.png]]


### Default Configuration
Samba offers wide range of settings that we can configure.
```shell
cat /etc/samba/smb.conf | grep -v "#\|\;"
```
We see global settings and two shares that are intened for printers. 
![[Pasted image 20241106224846.png]]

### Dangerous Settings
![[Pasted image 20241106224955.png]]

`Highly recommended` to look and read through the smb man page `man smb`

```shell
sudo systemctl restart smbd
```
`-L` display list of server's shares with `smbclient`
we use the so-called `null-session` (`-N`) which `anonymous` access without the input of existing users or valid passwords.

### SMBclient- connecting to the Share
```shell
smbclient -N -L //<IP>
```

![[Pasted image 20241106225404.png]]
WE can use the `help` command on successful login, listing all the possible commands we can execute.

![[Pasted image 20241106225550.png]]


## Download Files from SMB
```shell
get prep-prod.txt
```
![[Pasted image 20241106225651.png]]

`smbstatus` **Command**
- purpose: `smbstatus` helps administrators monitor active Samba connections
- **info Display** 
	- **Samba Version:** Shows which version of Samba is running
	- **Connected User:** Lists who is connected, from which host, and which shared resources.
	- **Network Insight** Essential for checking activity on subnets, even isolated ones, to ensure controlled access to shared resource. 
-
**Domain-level security**
- Samba as a Domain Member: In domain-level secutiy mode, samba integrates with a windows domain. This setup allows samba to authenticate users through a Windows domain controller.
**Key Components**
- Domain Controller
	- Acts as the central authentication server in a Windows domain.
	- Maintains user credentials and passwords, usaully on a windows NT server.
- **Password Server:** each workgroup has a designated password server, which generally a     domain controller.
- **User Authentication**
	- When a user logs in to access shared resources, the domain controller checks credentials stored in `NTDS.dit` (directory services database) and **`SAM`** (Security Authentication Module).
	- Once verified, the user gains access to the necessary shares on other machines in the domain.
	-
	This structure enhances security by centralizing password management and ensuring that users are authenticated before accessing shared files across the network.
![[Pasted image 20241106230824.png]]

### Footprinting the Service
```shell
sudo nmap <IP> -sV -sC -p139, 445
```
![[Pasted image 20241106230948.png]]

### Advanced SMB Enumeration with `rpcclient`:

- **Purpose of `rpcclient`**: This tool enables manual interaction with SMB by performing **Microsoft Remote Procedure Call (MS-RPC)** functions, allowing for specific data retrieval beyond what Nmap can typically provide.

### What is Remote Procedure Call (RPC)?

- **RPC Concept**: RPC allows processes on different networked devices to execute functions as if they were local, which is essential in distributed and client-server architectures.
- **Functionality**: RPC transmits parameters and returns values, enabling seamless communication and operational integration across networked systems.

### Useful `rpcclient` Commands for SMB Enumeration:

1. **Authentication and Basic Connection**:
    
    - `rpcclient -U <username> <IP>`: Connects to the SMB service on a remote server with a specified username. Use `-N` if no password is required.
    ```shell
    rcpclient -U "" <IP>
```
	*After the above command we can run the rest of these commands.*
1. **Enumerate Users**:
    
    - `enumdomusers`: Lists all users within the domain. Essential for identifying potential accounts to target in further enumeration or testing.
3. **Enumerate Groups**:
    
    - `enumdomgroups`: Retrieves all groups in the domain, allowing insight into group membership and permissions structures.
4. **Query User Information**:
    
    - `queryuser <username>`: Displays detailed information about a specific user, such as account flags, logon times, and password policies.
5. **Enumerate Domain Policies**:
    
    - `getdompwinfo`: Shows password policies for the domain, including password expiration and complexity requirements.
6. **Retrieve Shared Resources**:
    
    - `netshareenum`: Lists all shared resources on the target system. This is useful for identifying shares beyond those visible through standard SMB enumeration.
7. **List Printers**:
    
    - `enumprinters`: Displays available printers shared on the network, which may reveal additional infrastructure details or useful resources.
8. **Workstation Information**:
    
    - `lsaquery`: Retrieves information about the workstation, including details about the operating system and its configuration.
9. **Lookup SID**:
    
    - `lookupsids <SID>`: Translates a Security Identifier (SID) into its corresponding username or group name, helpful when SIDs appear in other enumeration outputs.
10. **Dump Password Policies**:
    
    - `getusrdompwinfo`: Pulls domain-level password policies, giving insight into security configurations and any potential weaknesses in password complexity or expiration.
11. **List Domain Controllers**:
    
    - `getdcinfo <domain>`: Returns the primary and backup domain controllers for a specified domain, crucial for understanding network architecture.
12. **Identify Trust Relationships**:
    
    - `lsaenumsid`: Enumerates trusted domains, which can reveal interconnected domains and possible privilege escalation paths in larger environments.

### Practical Tips:

- **Combined Use**: Pair `rpcclient` commands with other tools like `enum4linux` and `smbclient` to gather comprehensive information on SMB shares and domain users.
- **Permissions**: Some `rpcclient` commands may require specific user permissions to run successfully. Testing with different credentials may yield varied results.

Using these advanced `rpcclient` commands allows for more granular control over SMB enumeration, providing insights into network structure, user accounts, and security policies.

```shell
rpcclient -U "" <ip>
```
![[Pasted image 20241106233456.png]]

![[Pasted image 20241106233529.png]]

We can create a For-loop using Bash where we send a command to the service using rpcclient and filter out the results.

```bash
for i in $(seq 500 1100); do rpcclient -N -U "" <IP> -c "queryuser" 0x$(printf '%x\n' $i)" | grep "User Name\|user_rid\|group_rid" && echo "";done
```


An alternative to this would be a Python script from `impacket` called `samrdump.py`
```shell
samrdump.py <ip>
```

The information we have already obtianed with `rcpclient` can also be obtianed using other tools. For example the `SMBMap` and `CrackMapExec` tools are also widely used and helpful for the enumeration of SMB services.

```shell
smbmap -N <ip>
```

### CrackMapExec
```shell
crackmapexec smb <ip> --shares -u '' -p ''
```

Another tool worth mentioning is the so-called `enum4linux-ng` which is based on an older tool `enum4linx` This tool automates many of the queries but not all, and can return a large amount information. 

```bash
git clone https://github.com/cddmp/enum4linux-ng.git
cd enum4linux-ng
pip3 install -r requirements.txt
```

### Enum4linux-ng - ENumeration
```shell
./enum4linux-ng.py <IP> -A
```

