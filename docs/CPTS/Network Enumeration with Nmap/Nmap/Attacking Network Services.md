---
title: Attacking Network Services
date: 2024-10-23
tags:
  - "#oscp"
  - "#technique"
  - "#exploitation"
techniques:
  - ""
  - ""
tools:
  - nmap
  - nc
  - netcat
machines: 
difficulty:
  - Easy
status:
  - Completed
type: ""
os: 
categories:
  - ""
exam-priority:
  - medium
time-invested: "2"
notes: Key points and takeaways from the exercise.
---

### References
- [Example Tutorial](https://example.com/tutorial)
- [OSCP Exploit Documentation](https://documentation.oscp.org/exploitations)

### . **Banner Grabbing**

- **Purpose:** Quickly fingerprint a service.
- **Tools:**
    - **Nmap:**
        
        - Command: `nmap -sV --script=banner <target>`
    - **Netcat (nc):**
        
        - Command: `nc -nv <target_IP> <port>`
    - **Example:**Output:
        
        ```bash
        nc -nv 10.129.42.253 21
        ```
        
        ```scss
        (UNKNOWN) [10.129.42.253] 21 (ftp) open
        220 (vsFTPd 3.0.3)
        ```
        

### 2. **Service Scanning with Nmap**

- **Command for automating banner grabbing across a network:**
    
    ```bash
    nmap -sV --script=banner -p21 10.10.10.0/24
    ```
    
    - **Explanation:** This will scan all machines in the `10.10.10.0/24` subnet on port 21 (FTP), attempting to grab banners.

# FTP (File Transfer Protocol)

- **Importance**: Familiarity with FTP is crucial because it often contains interesting or sensitive data.
- **Common Ports**: FTP operates on port 21

### 1. **Nmap Scan for FTP**

- **Command to scan for FTP (port 21):**
    
    ```bash
    nmap -sV -p21 <target>
    ```
    
- **Example:**
    
    - A scan reveals an installation of **vsftpd 3.0.3**.
    
    ![[image.png]]
    

### 2. **Key Findings in FTP Scans**

- **Anonymous Authentication:**
    
    - If enabled, anyone can log in without credentials.
        
    - Example output indicating anonymous login:
        
        ```bash
        220 (vsFTPd 3.0.3)
        ```
        
- **Public Directory:**
    
    - A **`pub`** directory may be available, which could contain interesting or sensitive files.

# Connection to FTP

```bash
ftp -p 10.129.42.253
```

![[image 1.png]]

### FTP: Common Commands and File Access

- **FTP Shell Commands:**
    - **`cd`** – Change directory.
    - **`ls`** – List directory contents.
    - **`get <filename>`** – Download a file from the server.

### Example:

```bash
ftp> cd pub
ftp> ls
ftp> get login.txt
```

- **Inspecting Downloaded Files:**
    - **Command to view file contents (e.g., login.txt):**
        
        ```bash
        cat login.txt
        ```
        
    - The file might contain valuable information, such as **credentials** for further access.
        

### Study Tip:

- **Key Focus:** Remember FTP’s common commands and how to inspect downloaded files for potential access escalation (e.g., discovering credentials in files like `login.txt`).
- **Practice:** Set up an FTP server in a lab environment to practice using `cd`, `ls`, and `get` commands

# SMB (Server Message Block)

- **Importance:**
    - SMB is a common protocol on Windows machines, offering multiple attack vectors for **vertical** and **lateral movement**.
    - Network file shares may contain **sensitive data**, such as credentials.
    - Some SMB versions are vulnerable to **Remote Code Execution (RCE)** exploits like **EternalBlue**.

### 1. **Nmap SMB Enumeration**

- **Command to enumerate SMB OS information:**

```bash
nmap --script smb-os-discovery.nse -p445 10.10.10.40
```

**Example Output:**

```bash
PORT    STATE SERVICE
445/tcp open  microsoft-ds

Host script results:
| smb-os-discovery:
|   OS: Windows 7 Professional 7601 SP1
|   Computer name: CEO-PC
|   Workgroup: WORKGROUP

```

- **Reveals:** OS version, computer name, and workgroup. This can help identify whether the target is vulnerable to exploits like **EternalBlue**.

### 2. **Vulnerability Detection (EternalBlue)**

- **Further Enumeration:** Use tools like **Metasploit** to check if the system is vulnerable to **EternalBlue**.

### 3. **Advanced Nmap SMB Scanning**

- **Command for advanced service and OS detection:**
    
    ```bash
    nmap -A -p445 <target>
    sudo nmap --script smb-os-discovery.nse -p445 <target ip>
    ```
    
- **Example Output:**
    

```bash
PORT    STATE SERVICE     VERSION
445/tcp open  netbios-ssn Samba smbd 4.6.
```

- **Reveals:** Version of **Samba** running, the OS, and additional network information (e.g., hostname).
- **Host Script Results:**
    - **NetBIOS Information:** Shows the NetBIOS name, which is useful for further enumeration.
    - **SMB2 Security Mode:** Indicates whether message signing is enabled, which is a security feature.

### 4. **Traceroute**

- Nmap also performs a **traceroute** to map the network path to the target:
    
    ```bash
    TRACEROUTE (using port 445/tcp)
    HOP RTT       ADDRESS
    1   111.62 ms 10.10.14.1
    2   111.89 ms 10.129.42.253
    ```
    

### Study Tips:

- **Key Focus:** Understand how to enumerate SMB with Nmap to detect OS versions, services, and potential vulnerabilities.
- **Commands to Remember:**
    - **`nmap --script smb-os-discovery.nse -p445 <target>`** for SMB enumeration.
    - **`nmap -A -p445 <target>`** for advanced detection (OS, services, etc.).
- **Practice:** Set up a vulnerable lab environment and run Nmap scans to practice identifying SMB vulnerabilities, like **EternalBlue**.

# SMB Shares Enumeration & Interaction

- **Purpose:** SMB allows for remote access to shared folders, which may contain **sensitive information** (e.g., passwords).
- **Common Tools:** `smbclient` is useful for enumerating and interacting with SMB shares.

### 1. **Enumerating SMB Shares**

- **Command to list shares without a password prompt:**
    
    ```bash
    smbclient -N -L \\\\\\\\<target_ip>
    ```
    
    - **`L` flag:** Lists available shares.
    - **`N` flag:** Suppresses the password prompt.
- **Example Output:**
    
    ```bash
    Sharename       Type      Comment
    ---------       ----      -------
    print$          Disk      Printer Drivers
    users           Disk
    IPC$            IPC       IPC Service (Samba, Ubuntu
    ```
    
    - **Key Insight:** Shares like `users` might contain files with sensitive information, such as passwords.

### 2. **Connecting to an SMB Share**

- **Command to connect as a guest:**
    
    ```bash
    smbclient \\\\\\\\<target_ip>\\\\users
    ```
    
    - If access is denied (e.g., `NT_STATUS_ACCESS_DENIED`), credentials are required.
- **Command to connect with user credentials (e.g., `bob:Welcome1`):**
    
    ```bash
    smbclient -U bob \\\\\\\\<target_ip>\\\\users
    ```
    

### 3. **Interacting with SMB Shares**

- **Useful SMB commands once connected:**
    
    - **`ls`** – List directory contents.
    - **`cd <directory>`** – Change directory.
    - **`get <filename>`** – Download a file.
- **Example Commands:**
    
    ```bash
    smb: \\> ls
    smb: \\> cd bob
    smb: \\bob\\> ls
    ```
    
    - In the example, we find a file named `passwords.txt`.

### 4. **Downloading Files from SMB Share**

- **Command to download a file:**
    
    ```bash
    smb: \\bob\\> get passwords.txt
    ```
    
    - This downloads the file to the local machine.

---

### Study Tips:

- **Key Focus:** Understand how to enumerate SMB shares using `smbclient` and how to interact with shares using commands like `ls`, `cd`, and `get`.
- **Commands to Remember:**
    - **`smbclient -N -L \\\\\\\\<target_ip>`** to list shares.
    - **`smbclient -U <user> \\\\\\\\<target_ip>\\\\<share>`** to connect using credentials.
    - **`ls`, `cd`, `get`** for interacting with files.
- **Practice:** Set up an SMB share and practice connecting, listing contents, and downloading files.

# SNMP (Simple Network Management Protocol)

- **Purpose:** SNMP is used to gather **information** and **statistics** about devices such as routers. If community strings are known, they can provide access to valuable data.
- **Vulnerability:**
    - **SNMP v1 and v2c:** Uses **plaintext** community strings (default: `public` and `private`).
    - **SNMP v3:** Introduced encryption and authentication for better security.

### 1. **SNMP Community Strings**

- **Community Strings** are like passwords for accessing SNMP data.
- Common defaults:
    - **Public:** For read-only access.
    - **Private:** For read-write access.
- **Key Insight:** Many devices still use default community strings, making them easy to exploit.

### 2. **SNMP Enumeration with `snmpwalk`**

- **Command for SNMP enumeration using SNMP v2c:**
    
    ```bash
    snmpwalk -v 2c -c public <target_ip> 1.3.6.1.2.1.1.5.0
    ```
    
    - **`v 2c`** specifies the version of SNMP.
    - **`c public`** specifies the community string (in this case, `public`).
    - **`1.3.6.1.2.1.1.5.0`** is the OID for the device name (example output: `"gs-svcscan"`).
- **Example Output:**
    
    ```bash
    iso.3.6.1.2.1.1.5.0 = STRING: "gs-svcscan"
    ```
    
- **Error Handling:**
    
    - If the community string is incorrect, you may receive a **Timeout** response:
        
        ```bash
        snmpwalk -v 2c -c private <target_ip>
        ```
        

### 3. **Brute Forcing SNMP Community Strings**

- **Tool:** `onesixtyone` can be used to brute force community strings.
    
- **Command to brute force community strings:**
    
    ```bash
    onesixtyone -c dict.txt <target_ip>
    ```
    
    - **`c dict.txt`** specifies the dictionary file with common community strings.
    - **Output:** If successful, it will reveal the community string and some system information.
- **Example Output:**
    
    ```bash
    10.129.42.254 [public] Linux gs-svcscan 5.4.0-66-generic
    ```
    

### 4. **Key Information Revealed by SNMP**

- **Process Parameters:** May include **credentials** passed in command lines.
- **Routing Information:** Can reveal **services** bound to additional interfaces.
- **Software Versioning:** Can be used to identify potential **vulnerabilities** in the system.

---

### Study Tips:

- **Commands to Remember:**
    - **`snmpwalk -v 2c -c public <target_ip> <OID>`** for enumerating information.
    - **`onesixtyone -c dict.txt <target_ip>`** for brute forcing community strings.
- **Key Focus:** Learn the OID tree structure to target specific information (e.g., device name, OS version).
- **Practice:** Set up SNMP on a test machine and practice both enumeration and brute forcing.