---
title: Metasploit
date: 2024-10-30
tags: 
techniques: 
tools:
  - metasploit
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

### Metasploit Framework Overview

**Metasploit** is a powerful open-source framework used for developing, testing, and executing exploit code against target systems. It's a popular tool among penetration testers due to its wide range of pre-built exploits, payloads, and auxiliary modules for various network and host-based attacks.

---

### Basic Commands in Metasploit

1. **Starting Metasploit**
    
    - Start Metasploit Console:
        
        bash
        
        Copy code
        
        `msfconsole`
        
    - Update Metasploit:
        
        bash
        
        Copy code
        
        `msfupdate`
        
2. **Finding Modules**
    
    - Search for an exploit or auxiliary module:
        
        bash
        
        Copy code
        
        `search <module-name>`
        
    - Show detailed information about a module:
        
        bash
        
        Copy code
        
        `info <module-name>`
        
3. **Using Modules**
    
    - Select a module to use:
        
        bash
        
        Copy code
        
        `use <module-path>`
        
    - Set options for the module (e.g., RHOST for the target IP):
        
        bash
        
        Copy code
        
        `set <option-name> <value>`
        
    - Show current options for a module:
        
        bash
        
        Copy code
        
        `show options`
        
    - Run the selected exploit or auxiliary module:
        
        bash
        
        Copy code
        
        `run`
        
        or
        
        bash
        
        Copy code
        
        `exploit`
        
4. **Common Payloads**
    
    - Set a payload (e.g., reverse shell):
        
        bash
        
        Copy code
        
        `set PAYLOAD <payload-name>`
        
    - View all available payloads:
        
        bash
        
        Copy code
        
        `show payloads`
        
5. **Managing Sessions**
    
    - List active sessions:
        
        bash
        
        Copy code
        
        `sessions -l`
        
    - Interact with a specific session:
        
        bash
        
        Copy code
        
        `sessions -i <session-id>`
        
    - Background a session:
        
        bash
        
        Copy code
        
        `background`
        

---

### Advanced Metasploit Commands

1. **Meterpreter Commands**  
    After obtaining a Meterpreter session, the following commands provide additional control:
    
    - Get system information:
        
        bash
        
        Copy code
        
        `sysinfo`
        
    - List files in a directory:
        
        bash
        
        Copy code
        
        `ls`
        
    - Download a file from the target:
        
        bash
        
        Copy code
        
        `download <file-path>`
        
    - Upload a file to the target:
        
        bash
        
        Copy code
        
        `upload <file-path>`
        
    - Execute a shell command:
        
        bash
        
        Copy code
        
        `shell`
        
    - Dump password hashes:
        
        bash
        
        Copy code
        
        `hashdump`
        
2. **Post-Exploitation Modules**  
    Use post-exploitation modules to gather further information or maintain access:
    
    - Use a post-exploitation module (e.g., gathering network info):
        
        bash
        
        Copy code
        
        `use post/windows/gather/arp_scanner`
        
    - Set options and run:
        
        bash
        
        Copy code
        
        `set SESSION <session-id> run`
        
3. **Pivoting and Routing**
    
    - Add a route to pivot through a compromised host:
        
        bash
        
        Copy code
        
        `route add <subnet> <netmask> <session-id>`
        
4. **Database Commands**  
    Store results and findings in the Metasploit database for later use.
    
    - Start and connect to the database:
        
        bash
        
        Copy code
        
        `db_connect <user>:<password>@localhost/metasploitdb`
        
    - Add a target to the database:
        
        bash
        
        Copy code
        
        `hosts -a <target-ip>`
        
    - Store scan results:
        
        bash
        
        Copy code
        
        `db_nmap <target-ip>`
        

---

### Study and Learning Tips for Metasploit

1. **Practice on Virtual Labs**
    
    - Set up a **safe lab environment** using virtual machines to test Metasploit modules and payloads. Try platforms like **Hack The Box**, **TryHackMe**, or **VulnHub** for practical challenges.
2. **Master Basic Commands First**
    
    - Gain confidence in finding and using basic modules before moving to advanced features. **Consistent practice** with `search`, `use`, `set`, `run`, and session management will build a solid foundation.
3. **Explore Payloads and Post-Exploitation**
    
    - Experiment with different payloads, especially **reverse shells** and **Meterpreter payloads**. Familiarize yourself with post-exploitation options for **data collection** and **privilege escalation**.
4. **Learn Nmap and Auxiliary Modules**
    
    - Practice running Nmap scans from within Metasploit to store results directly in the Metasploit database. Use **auxiliary modules** for scanning, reconnaissance, and service identification.
5. **Leverage the Documentation and Cheat Sheets**
    
    - Refer to **official Metasploit documentation** and **community resources**. Keep a cheat sheet of essential commands to accelerate your learning process.
6. **Join a Community**
    
    - Interacting with others in cybersecurity forums like **Reddit**, **Discord**, or **CyberSec groups** can offer insights, tips, and real-world advice on leveraging Metasploit effectively.
7. **Stay Updated with New Modules**
    
    - Regularly update Metasploit and read about new modules or exploits that become available. This is especially important as Metasploit is frequently updated with new capabilities.