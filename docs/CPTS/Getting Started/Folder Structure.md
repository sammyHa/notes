---
title: Folder Structure
date: 2024-10-23
tags:
  - "#oscp"
  - "#technique"
  - "#exploitation"
techniques:
  - ""
  - ""
tools:
  - ""
  - ""
machines: 
difficulty:
  - Easy
status:
  - In-Progress
type: 
os: Windows
categories:
  - ""
exam-priority:
  - medium
time-invested: 
references:
  - url: ""
  - title: ""
notes: Key points and takeaways from the exercise.
---


![[folder_structure.png]]

# Common Penetration Testing Terms:

1. **Shell**:
    - **Definition**: A program that allows interaction with an operating system via command-line inputs.
    - **Types**:
        - **Reverse Shell**: The target machine connects back to the attacker's machine.
        - **Bind Shell**: The target machine listens for a connection from the attacker.
        - **Web Shell**: Runs commands via a browser (typically less interactive).
2. **Port**:
    - **Definition**: Virtual points where network connections begin and end, used to differentiate traffic types.
        
    - **Categories**:
        
        - **TCP (Transmission Control Protocol)**: Connection-oriented; reliable, requires a handshake.
        - **UDP (User Datagram Protocol)**: Connectionless; faster, less reliable.
    - **Common Ports**:
        
        - 20/21 (FTP), 22 (SSH), 80 (HTTP), 443 (HTTPS), 3389 (RDP).
        

|   **Protocols**   |  **Port(s)**  |
| :---------------: | :-----------: |
|        FTP        | 20 / 21 (TCP) |
|        SSH        |   22 (TCP)    |
|      Telnet       |   23 (TCP)    |
|       SMTP        |   25 (TCP)    |
|       HTTP        |   80 (TCP)    |
|       SNMP        | 161 (TCP/UDP) |
|       LDAP        | 389 (TCP/UDP) |
| SSL / TLS (HTTPS) |   443 (TCP)   |
|        SMB        |   445 (TCP)   |
|        RDP        |  3389 (TCP)   |
|                   |               |

        
3. **Web Server**:
    - **Definition**: Software that handles HTTP/HTTPS traffic and connects users to web application components.
    - **Vulnerabilities**: Can expose a server to attacks if misconfigured or vulnerable, making it a target for penetration testing.
4. **OWASP Top 10** (Web Application Vulnerabilities):
    - **1. Broken Access Control**: Improper restrictions allowing unauthorized access.
    - **2. Cryptographic Failures**: Weak encryption leading to sensitive data exposure.
    - **3. Injection**: Inserting malicious data (e.g., SQL injection) into applications.
    - **4. Insecure Design**: Applications not designed with security in mind.
    - **5. Security Misconfiguration**: Weak security settings, default configurations, verbose errors.
    - **6. Vulnerable Components**: Using outdated or vulnerable software components.
    - **7. Identification & Authentication Failures**: Issues related to user identity and authentication.
    - **8. Software & Data Integrity Failures**: Using untrusted sources leading to integrity issues.
    - **9. Security Logging & Monitoring Failures**: Lack of monitoring leads to missed breach detections.
    - **10. Server-Side Request Forgery (SSRF)**: Application fetches resources without validating user input, exposing the server to remote requests.

These terms and concepts are essential in penetration testing to understand vulnerabilities and how attackers gain access to systems.