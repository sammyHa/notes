---
title: WinRM
date: 2024-10-30
tags: 
techniques: 
tools: 
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


**Overview**  
Windows Remote Management (WinRM) is a Windows-based protocol that allows administrators to remotely manage systems via the command line. It is designed to help manage Windows machines, execute commands remotely, and automate administrative tasks. It is based on the **Simple Object Access Protocol (SOAP)** and relies on **HTTP** and **HTTPS** for communication.

WinRM must be explicitly enabled and configured starting from **Windows 10**. On Windows Server 2012 and later, WinRM is enabled by default, but proper configuration and firewall exceptions are still required for it to function properly.

---

### **Ports and Communication**

WinRM uses the following ports for communication:

- **Port 5985 (HTTP)**: For unencrypted communication.
- **Port 5986 (HTTPS)**: For encrypted communication (uses SSL/TLS).

These ports replaced **80** and **443**, which were previously used for SOAP communication but were blocked for security reasons in modern environments.

---

### **WinRM Components**

1. **Windows Remote Shell (WinRS)**:
    
    - A command-line tool that allows you to execute commands on remote systems via WinRM.
    - Included by default on **Windows 7** and later versions.
2. **PowerShell Remoting**:
    
    - WinRM is the underlying protocol used for **PowerShell Remoting**, allowing administrators to manage remote systems and execute commands or scripts.
3. **Event Log Merging**:
    
    - WinRM can be used to merge event logs from multiple systems, enabling centralized log management.

---

### **Enabling and Configuring WinRM**

**On Windows 10 and Server (pre-2012)**:  
To enable WinRM, the following steps can be used:

- **Enable WinRM on a local machine**:  
    Open **PowerShell** as an administrator and run the following command:
    
    powershell
    
    Copy code
    
    `winrm quickconfig`
    
    This will enable the service and configure it to start automatically, allowing connections.
    
- **Enable WinRM on a remote machine**: Run the same command on the target machine, or use PowerShell Remoting to enable it:
    
    powershell
    
    Copy code
    
    `Invoke-Command -ComputerName <target-computer> -ScriptBlock { winrm quickconfig }`
    

**Configure Firewall to Allow WinRM**:  
To allow WinRM traffic, the firewall must allow inbound connections on ports **5985** (HTTP) and **5986** (HTTPS). You can add a rule to the firewall to enable this:

powershell

Copy code

`New-NetFirewallRule -Name WinRM -DisplayName "Windows Remote Management" -Enabled True -Protocol TCP -LocalPort 5985,5986 -Action Allow`

---

### **Common WinRM Commands**

1. **Check WinRM Status**:  
    To check whether WinRM is configured correctly:
    
    powershell
    
    Copy code
    
    `winrm enumerate winrm/config/listener`
    
2. **Start WinRM Service**:  
    If WinRM is disabled, you can start the service with:
    
    powershell
    
    Copy code
    
    `Start-Service winrm`
    
3. **Testing Remote WinRM Connection**:  
    Use the following command to test if the remote machine is accessible via WinRM:
    
    powershell
    
    Copy code
    
    `Test-WsMan <remote-hostname-or-IP>`
    
4. **Remote Command Execution Using WinRS**:  
    To execute a command on a remote machine:
    
    powershell
    
    Copy code
    
    `winrs -r:<remote-hostname-or-IP> cmd.exe /c "dir C:\"`
    
5. **PowerShell Remoting**:  
    To start a remote PowerShell session:
    
    powershell
    
    Copy code
    
    `Enter-PSSession -ComputerName <remote-hostname-or-IP> -Credential <username>`
    
    To execute commands remotely:
    
    powershell
    
    Copy code
    
    `Invoke-Command -ComputerName <remote-hostname> -ScriptBlock { Get-Process }`
    

---

### **Advanced WinRM Techniques**

1. **Kerberos Authentication for WinRM**:  
    WinRM supports **Kerberos authentication** if the machines are part of the same domain. This adds an additional layer of security by using encrypted credentials. To enable Kerberos authentication:
    
    - Ensure that both the client and the target machine are in the same **Active Directory domain**.
    - Use the following command to configure WinRM to use Kerberos:
        
        powershell
        
        Copy code
        
        `Set-Item WSMan:\localhost\Client\TrustedHosts -Value <target-hostname-or-IP>`
        
2. **Custom WinRM Listeners**:  
    By default, WinRM listens on ports 5985 and 5986, but custom ports can be configured. To create a new listener on a different port:
    
    powershell
    
    Copy code
    
    `winrm create winrm/config/Listener?Address=*+Transport=HTTPS @{Port="8080"}`
    
3. **Using HTTPS with WinRM**:  
    If HTTPS is required for secure communication, an SSL certificate must be installed on the target machine. Here's how to configure WinRM to use HTTPS:
    
    powershell
    
    Copy code
    
    `winrm create winrm/config/Listener?Address=*+Transport=HTTPS @{Port="5986";CertificateThumbprint="<thumbprint-of-ssl-certificate>"}`
    
4. **Configuring WinRM for Remote Powershell Sessions**:  
    In environments where PowerShell remoting is needed, configure the **WinRM** listener to support remote connections securely:
    
    powershell
    
    Copy code
    
    `Set-Item WSMan:\localhost\Client\TrustedHosts -Value "<remote-hostname>"`
    
5. **Bypass Authentication (for Testing)**:  
    For penetration testing or lab environments, it's sometimes useful to bypass authentication (such as NTLM) to connect via WinRM. To do this, you can use **Powershell remoting over HTTP**:
    
    powershell
    
    Copy code
    
    `Enter-PSSession -ComputerName <target-hostname-or-IP> -Authentication Negotiate -Credential <username>`
    
6. **Exploiting WinRM (Brute-forcing)**:  
    For penetration testing, WinRM can be targeted using brute force techniques, especially if weak credentials are suspected. Tools like **Hydra** can be used to brute force the WinRM service:
    
    bash
    
    Copy code
    
    `hydra -l <username> -P <password-list> winrm://<target-IP>:5985`
    
7. **Using WinRM for Lateral Movement**:  
    If you have gained access to one machine, you can use WinRM for lateral movement to other systems within the network. Once WinRM is configured, use **PowerShell remoting** to execute commands on other machines:
    
    powershell
    
    Copy code
    
    `Invoke-Command -ComputerName <remote-machine> -ScriptBlock { <command-to-execute> }`
    

---

### **Security and Mitigation**

1. **Securing WinRM**:
    
    - Always use **HTTPS** (port 5986) to encrypt traffic.
    - Implement strong **authentication** mechanisms like **Kerberos** or **NTLMv2** and avoid weak passwords.
    - Restrict access to WinRM using **firewall rules** and ensure only trusted machines or users can connect.
2. **WinRM Hardening**:
    
    - Disable **WinRS** if not required.
    - Enable **Network Level Authentication (NLA)** for more secure connections.
    - Ensure that **SSL certificates** are properly managed, and do not rely on self-signed certificates for production environments.
3. **Monitoring WinRM Access**:
    
    - Use **Windows Event Logs** to monitor access and failures related to WinRM.
    - Track WinRM connections with **Audit Policy** and enable logging for both successful and failed login attempts.
4. **Restricting WinRM Access**:
    
    - Limit **trusted hosts** to only necessary machines:
        
        powershell
        
        Copy code
        
        `Set-Item WSMan:\localhost\Client\TrustedHosts -Value <target-IP>` 
        
    - Regularly review and adjust firewall rules to limit the IP ranges that can access WinRM services.

---

### **Key OSCP Takeaways**

- **Footprinting and Recon**: Use tools like **Nmap** to identify systems with open WinRM ports.
- **Exploitation**: Target weak configurations, such as lack of encryption or poor authentication settings, for exploitation.
- **Mitigation**: Enforce strong authentication (Kerberos, NTLMv2), enable encryption (HTTPS), and restrict access with firewalls and proper configuration.