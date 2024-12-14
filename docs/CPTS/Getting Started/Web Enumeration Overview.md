---
title: Web Enumeration Overview
date: 2024-10-23
tags:
  - "#oscp"
  - "#technique"
  - "#exploitation"
techniques:
  - ""
  - ""
tools:
  - gobuster
  - whatweb
  - seclist
machines: ""
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
time-invested: ""
notes: |
  Key points and takeaways from the exercise.
---

### References
- [Example Tutorial](https://example.com/tutorial)
- [OSCP Exploit Documentation](https://documentation.oscp.org/exploitations)


When scanning web services on common ports (80, 443), web servers hosting applications provide a significant attack surface. A web server may contain hidden directories, subdomains, or exposed sensitive data that could be leveraged for vulnerabilities like remote code execution (RCE). Proper **web enumeration** is critical, especially for well-secured environments.

---

### Directory Enumeration with **Gobuster**

- **Tool:** `Gobuster` is used for directory brute-forcing to uncover hidden files or directories on a web server. It can also perform DNS and vhost enumeration.

### **Gobuster Command:**

```bash
gobuster dir -u <http://10.10.10.121/> -w /usr/share/seclists/Discovery/Web-Content/common.txt
```

- **`u <URL>`**: Specifies the target URL.
    
- **`w <wordlist>`**: Uses a wordlist (`common.txt` in this case) for directory brute-forcing.
    
- **Output Example:**
    
    ```bash
    /htpasswd (Status: 403)
    /index.php (Status: 200)
    /server-status (Status: 403)
    /wordpress (Status: 301)
    ```
    
    - **200:** Resource request was successful.
    - **301:** Indicates redirection.
    - **403:** Access forbidden.
- **Key Result:** The WordPress installation at `/wordpress` is revealed, which can be explored further.
    

---

### Subdomain Enumeration with Gobuster

**DNS Subdomain Enumeration:** Subdomains may host valuable services like admin panels. `Gobuster` can be used to enumerate subdomains using the **dns** mode.

### **Gobuster DNS Command:**

```bash
gobuster dns -d inlanefreight.com -w /usr/share/SecLists/Discovery/DNS/namelist.txt
```

- **`d <domain>`**: Specifies the target domain.
    
- **Output Example:**
    
    ```bash
    Found: blog.inlanefreight.com
    Found: customer.inlanefreight.com
    ```
    

---

### Banner Grabbing & Web Server Headers

- **Banner grabbing** helps in identifying server details (e.g., the server software, version, etc.).
    
- **Command to Grab Web Server Headers:**
    
    ```bash
    curl -IL <https://www.inlanefreight.com>
    ```
    
    - Output might include:
        
        ```bash
        Server: Apache/2.4.29 (Ubuntu)
        Link: <https://www.inlanefreight.com/index.php/wp-json/>
        ```
        
- **Tip:** Use tools like `curl` to get server headers, which can reveal configuration details.
    

---

### Web Technologies & Service Discovery with **WhatWeb**

- **WhatWeb** helps identify web technologies, servers, frameworks, and other information useful for vulnerability discovery.

### **WhatWeb Command:**

```bash
whatweb <http://10.10.10.121>
```

- **Output Example:**
    
    ```bash
    <http://10.10.10.121> [200 OK] Apache[2.4.41], Title[PHP 7.4.3 - phpinfo()]
    ```
    

---

### SSL/TLS Certificates

- HTTPS services often use SSL/TLS certificates, which may contain information like **email addresses** or **company details**. Browsing an HTTPS URL and viewing its certificate can help gather additional details useful for attacks like phishing.

---

### Robots.txt

- **Purpose:** Instructs web crawlers on what should not be indexed.
- **Tip:** Checking the `robots.txt` file may reveal disallowed entries, such as private or admin directories. These can often provide access to sensitive resources.

---

### Source Code Review

- **Tip:** Always check the source code of web pages for developer comments, hardcoded credentials, or other sensitive information. For example, pressing `CTRL + U` in a browser reveals the page source.

---

### Tools Summary:

- **Gobuster:** Directory and subdomain enumeration.
- **Curl:** Banner grabbing and HTTP server headers.
- **WhatWeb:** Web technology and service discovery.
- **EyeWitness:** Screenshots and fingerprinting for web applications.
- **SecLists:** Wordlists for fuzzing and brute-forcing.