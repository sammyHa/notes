---
title: Nikto
date: 2024-10-30
tags: 
techniques: 
tools:
  - nikto
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

### Nikto

Nikto is a powerful open-source web server scanner used for identifying vulnerabilities, misconfigurations, and outdated components in web servers. Here’s a structured guide from beginner to advanced usage:

### **1. Getting Started with Nikto**

#### **Installation**

- Install Nikto on **Kali Linux** or your preferred system:
    ```bash
    sudo apt update
    sudo apt install nikto
```
Alternatively, clone from GitHub for the latest version:
```bash
git clone https://github.com/sullo/nikto.git
cd nikto
```

#### **Basic Command**

- Scan a single target:
    
    ```bash
nikto -h <target>
```
    
    Example:
    
    ```bash
nikto -h http://example.com
```
    
    This performs a default scan, identifying common vulnerabilities, configuration issues, and outdated software.

---

### **2. Intermediate Usage**

#### **Customizing Scans**

- **Specify Ports**:  
    Target a specific port (default is 80 for HTTP).
    ```bash
    nikto -h <target> -p <port>
```
    
    Example:
    
    ```bash
nikto -h http://example.com -p 8080
```
    
- **SSL Scans**:  
    Force SSL/TLS for HTTPS sites.
    ```bash
nikto -h <target> -ssl
```
    
- **Use Host Headers**:  
    Test specific subdomains on shared hosts.
    ```bash
nikto -h <IP> -vhost <subdomain.example.com>
```
#### **Saving Output**

- Save scan results to a file:
    
    ```bash
nikto -h <target> -o <filename> -Format <format>
```
    
    Supported formats: **html, csv, txt, xml**  
    Example:
    ```bash
nikto -h http://example.com -o report.html -Format html
```
    

#### **Timeouts and Delay**

- Set timeouts and delays to avoid detection or rate limits:
    
    ```bash
nikto -h <target> -timeout <seconds> -Tuning <options>
```
    
    Example:
    
    ```bash
nikto -h http://example.com -timeout 10
```
    

---

### **3. Advanced Techniques**

#### **Tuning Options**

Tuning allows targeting specific types of vulnerabilities:

- **0**: File Uploads
- **1**: Interesting Files / Directories
- **2**: Misconfiguration / Default Files
- **3**: Information Disclosure
- **4**: Injection (XSS, SQL, etc.)
- **5**: Remote File Retrieval
- **6**: Denial of Service
- **7**: Remote Source Inclusion
- **8**: Command Execution / Remote Shell
- **9**: Authentication Bypass

Example (scan for injection vulnerabilities only):

```bash
nikto -h <target> -Tuning 4
```

#### **Using Plugins**

Leverage Nikto plugins for extended functionality:

- List available plugins:
    
    ```bash
nikto -list-plugins
```
    
- Use a specific plugin:
    
    ```bash
nikto -h <target> -plugin <plugin_name>
```
    

#### **Scan Behind a Proxy**

If you want to route traffic through a proxy:

```bash
nikto -h <target> -useproxy <proxy_address:port>
```

Example:

```bash
nikto -h http://example.com -useproxy 127.0.0.1:8080
```

#### **Bypassing WAF/IDS**

- Use custom headers to obfuscate requests:

    ```bash
nikto -h <target> -headers "X-Custom-Header: Value"
```
    
- Use randomized user-agent strings:
    ```bash
nikto -h <target> -useragent <user-agent-string>
```
    

---

### **4. Tips and Tricks**

1. **Combine with Other Tools**:  
    Use Nikto alongside tools like **Burp Suite**, **Nmap**, or **Metasploit** for a comprehensive security assessment.
    
    - Example: Nmap + Nikto:
        
        ```bash
nmap -p 80,443 --script=http-enum <target> nikto -h <target>
```
        
2. **Scan Specific Paths**:  
    Focus on specific directories or endpoints:
    
    ```bash
nikto -h <target> -file <file_with_paths>
```
    
    Example file:
    
    ```bash
/admin /backup
```
    
3. **Update Nikto Regularly**:  
    Keep Nikto's vulnerability database up to date:
    ```bash
nikto -update
```
    
4. **Use Rate Limiting**:  
    Avoid triggering rate-limiting mechanisms:
    
    ```bash
nikto -h <target> -delay <milliseconds>
```
    
5. **Combine SSL and Host Headers**:  
    Test HTTPS subdomains:
    
    ```bash
nikto -h <IP> -vhost <subdomain.example.com> -ssl
```
    

---

### **5. Interpreting Results**

- Nikto provides a detailed report highlighting:
    - Vulnerabilities (e.g., outdated software, weak configurations).
    - Paths of interest (e.g., `/admin`, `/backup`).
    - Potential exploits and their impact.
- Always validate findings using other tools or manual methods.

---

With these commands, tips, and techniques, you can utilize Nikto for beginner-friendly scans or sophisticated penetration testing workflows. Let me know if you'd like more details or examples!