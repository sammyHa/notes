---
title: Windows Remote Management Protocols
date: 2024-10-30
tags: 
techniques: 
tools:
  - rdp
  - winRm
  - Wmi
  - NAT
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

**Windows Remote Management Protocols** [[WinRM]]

Windows remote management allows for managing server hardware and configurations both locally and remotely. Key features include WS-Management, hardware diagnostics, and a COM API for remote communication. Starting with Windows Server 2016, remote management is enabled by default.

---

**Remote Management Components**

1. **Remote Desktop Protocol (RDP)**
    
    - **Purpose**: Provides GUI-based remote access to Windows systems.
    - **Ports**:
        - Default: TCP 3389.
        - Alternative: UDP 3389.
    - **Encryption**:
        - TLS/SSL encryption since Windows Vista.
        - Vulnerabilities include self-signed certificates or weak encryption through RDP Security.
    - **Activation**:
        - Installed by default on Windows servers.
        - Managed through Server Manager.
        - By default, Network Level Authentication (NLA) is enabled.
    
    **Requirements for RDP Connections:**
    
    - **Firewall Rules**: Ensure TCP/UDP port 3389 is open.
    - **NAT Setup**: Public IP and port forwarding are necessary when NAT is in use.
    - **Certificate Security**: Avoid self-signed certificates, which create client-side warnings and are exploitable.
2. **Windows Remote Management (WinRM)**
    
    - **Purpose**: Implements the WS-Management protocol for managing Windows servers remotely.
    - **Features**:
        - Supports scripting and automation via the COM API.
        - Standards-based and lightweight, ensuring compatibility with modern management tools.
    - **Compatibility**: Enabled by default in modern Windows servers.
3. **Windows Management Instrumentation (WMI)**
    
    - **Purpose**: Provides a framework for querying and managing local and remote Windows systems.
    - **Features**:
        - Access to system details like hardware, services, and logs.
        - Enables complex automation and scripting for system administration.

---

**RDP Footprinting**  
Scanning the RDP service can reveal valuable information about the target host, such as:

- **NLA Status**: Indicates whether it is enabled or disabled.
- **Product Version**: Identifies potential vulnerabilities.
- **Hostname**: Provides reconnaissance details about the environment.

**Tools for RDP Footprinting:**

- **[[Nmap]]**: Used to identify service versions and NLA status. Example command: 
```bash 
nmap -p 3389 -sV <target_IP>

nmap -sV -sC 10.129.201.248 -p3389 --script rdp*
```
- **Metasploit**: Useful for exploiting misconfigured RDP services.
- **Hydra**: Can perform brute-force attacks if weak credentials are suspected.
In addition, we can use `--packet-trace` to track the individual packages and inspect their contents manually. We can see that the `RDP cookies` (`mstshash=nmap`) used by Nmap to interact with the RDP server can be identified by `threat hunters` and various security services such as [Endpoint Detection and Response](https://en.wikipedia.org/wiki/Endpoint_detection_and_response) (`EDR`), and can lock us out as penetration testers on hardened

```shell
nmap -sV -sC 10.129.201.248 -p3389 --packet-trace --disable-arp-ping -n
```

A Perl script named [rdp-sec-check.pl](https://github.com/CiscoCXSecurity/rdp-sec-check) has also been developed by [Cisco CX Security Labs](https://github.com/CiscoCXSecurity) that can unauthentically identify the security settings of RDP servers based on the handshakes.

#### RDP Security Check - Installation
```bash
sudo cpan
```
![[Pasted image 20241115002253.png]]

#### RDP Security Check
```shell
git clone https://github.com/CiscoCXSecurity/rdp-sec-check.git && cd rdp-sec-check
./rdp-sec-check.pl 10.129.201.248
```
 Authentication and connection to such RDP servers can be made in several ways. For example, we can connect to RDP servers on Linux using `xfreerdp`, `rdesktop`, or `Remmina` and interact with the GUI of the server accordingly.


#### Initiate an RDP Session

```bash
xfreerdp /u:cry0l1t3 /p:"P455w0rd!" /v:<o[>]
```
After successful authentication, a new window will appear with access to the server's desktop to which we have connected.

### Windows Remote Management Protocols ([[WinRM]])

**Overview**  
Windows Remote Management (WinRM) is a Windows-integrated remote management protocol that operates via the command line. It uses the **Simple Object Access Protocol (SOAP)** to establish connections with remote hosts and applications. WinRM is not enabled by default and must be explicitly configured, starting with **Windows 10**.

**Ports and Communication**

- WinRM relies on **TCP ports 5985** (HTTP) and **5986** (HTTPS) for communication.
    - Port 5986 (HTTPS) is used for secure communication, while port 5985 (HTTP) is used for unencrypted connections.
    - These newer ports (5985 and 5986) were adopted as ports 80 and 443 were previously used but were often blocked for security reasons.

**Components of WinRM**

- **Windows Remote Shell (WinRS)**:
    
    - WinRS is a component of WinRM that allows execution of arbitrary commands on remote systems.
    - It is included by default on **Windows 7** and can be used to interact with remote machines in a command-line interface.
- **PowerShell and Event Log Merging**:
    
    - Services like remote sessions using **PowerShell** and merging **event logs** require WinRM.
    - WinRM enables secure and efficient remote management and administration of Windows systems.

**Configuration and Firewall Considerations**

- **Windows Server 2012 and later**:
    
    - WinRM is enabled by default.
    - Configuration may still be required for certain advanced setups and clients.
    - Necessary **firewall exceptions** should be created for proper communication.
- **Older Windows Server Versions**:
    
    - For versions prior to **Windows Server 2012**, WinRM must be manually enabled and configured.
    - Firewalls must also be adjusted to allow communication through the necessary ports (5985 and 5986).

**Key OSCP Notes**

- **Exploitation**:
    - Misconfigured WinRM services can provide unauthorized remote access, making it an important service to test during penetration testing engagements.
    - Brute-forcing WinRM credentials or exploiting weak configurations can lead to full system compromise.
- **Mitigation**:
    - Ensure WinRM is properly configured and secured, especially on legacy systems.
    - Implement proper firewall rules and restrict access to WinRM services to trusted IP addresses only.
-
## Footprinting the Service

As we already know, WinRM uses TCP ports `5985` (`HTTP`) and `5986` (`HTTPS`) by default, which we can scan using Nmap. However, often we will see that only HTTP (`TCP 5985`) is used instead of HTTPS (`TCP 5986`).

### [[Nmap]] WinRm
```bash
nmap -sV -sC <ip> -p5985,5986 --disable-arp-ping -n
```
If we want to find out whether one or more remote servers can be reached via WinRM, we can easily do this with the help of PowerShell. The [Test-WsMan](https://docs.microsoft.com/en-us/powershell/module/microsoft.wsman.management/test-wsman?view=powershell-7.2) cmdlet is responsible for this, and the host's name in question is passed to it. In Linux-based environments, we can use the tool called [evil-winrm](https://github.com/Hackplayers/evil-winrm), another penetration testing tool designed to interact with WinRM.

```shell
evil-winrm -i 10.129.201.248 -u Cry0l1t3 -p P455w0rD!
```


## [[WMI (Windows Management Instrumentation)]]

## Footprinting the Service
The initialization of the WMI communication always takes place on `TCP` port `135`, and after the successful establishment of the connection, the communication is moved to a random port. For example, the program [wmiexec.py](https://github.com/SecureAuthCorp/impacket/blob/master/examples/wmiexec.py) from the Impacket toolkit can be used for this.

```bash
/usr/share/doc/python3-impacket/examples/wmiexec.py Cry0l1t2:"P455w0rD!"@<ip> "hostname"
```
Again, it is necessary to mention that the knowledge gained from installing these services and playing around with the configurations on our own Windows Server VM for gaining experience and developing the functional principle and the administrator's point of view cannot be replaced by reading manuals. Therefore, we strongly recommend setting up your own Windows Server, experimenting with the settings, and scanning these services repeatedly to see the differences in the results.

**Key Notes for OSCP**

- **RDP Misconfigurations**:
    - Systems relying on weak encryption or self-signed certificates are vulnerable to MITM attacks.
    - Disabling NLA can expose systems to unauthorized access attempts.
- **Exploitation**:
    - Misconfigured firewalls or NAT settings may allow access to RDP services.
    - Tools like Metasploit can test and exploit RDP vulnerabilities effectively.
- **Mitigation Analysis**:
    - Understanding and bypassing firewalls or NAT restrictions is critical in penetration testing scenarios.