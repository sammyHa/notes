---
title: Get OS Information
date: 2024-10-23
tags:
  - "#oscp"
  - "#technique"
  - "#exploitation"
techniques:
  - ""
  - ""
tools:
  - hostnamectl
  - find
  - searchploit
  - dmesg
  - lpstat
  - systemctl
  - ps aux
  - linEnum.sh
machines: ""
difficulty:
  - ""
status:
  - Completed
type: ""
os: Linux
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


### 1. **Get OS Information**

Use the following commands to determine the operating system and kernel version:

- `uname -a` (Displays system information)
- `cat /etc/*release` (Displays OS distribution info)
- `hostnamectl` (Provides detailed info about the OS)

### 2. **Check the PATH, Any Writable Folder?**

- Check the PATH variable with `echo $PATH`.
    
- Use `find` to identify writable directories in your PATH:
    
    ```bash
   find $(echo $PATH | tr ':' ' ') -writable 2>/dev/null
    
    ```
    
- To check general writable directories:
    
    ```bash
   find / -type d -writable 2>/dev/null
    
    ```
    

### 3. **Check Environment Variables for Sensitive Details**

- List all environment variables:
    
    ```bash
    printenv
    
    ```
    
- Look for sensitive details like credentials, keys, or secrets.
    

### 4. **Search for Kernel Exploits (e.g., DirtyCow)**

- Use `uname -r` to get the kernel version.
    
- Search for kernel exploits (manual search via exploit databases):
    
    - **DirtyCow**: Check if the system is vulnerable by matching the kernel version against public exploit information:
    
    ```bash
   searchsploit dirtycow
    
    ```
    
- Use automated tools like **LinEnum** or **Linux Exploit Suggester**:
    
    ```bash
  wget <https://raw.githubusercontent.com/rebootuser/LinEnum/master/LinEnum.sh>
    chmod +x LinEnum.sh
    ./LinEnum.sh
    
    ```
    
    ```bash
    wget <https://raw.githubusercontent.com/mzet-/linux-exploit-suggester/master/linux-exploit-suggester.sh>
    chmod +x linux-exploit-suggester.sh
    ./linux-exploit-suggester.sh
    
    ```
    

### 5. **Check if the `sudo` Version is Vulnerable**

- First, check the `sudo` version:
    
    ```bash
    sudo -V
    
    ```
    
- Then, search for vulnerabilities based on the version:
    
    ```bash
    searchsploit sudo
    
    ```
    

### 6. **Check `dmesg` for Errors like Signature Verification Failed**

- View kernel messages to look for any signature verification failures or other security-related logs:
    
    ```bash
    dmesg | grep -i "signature verification"
    
    ```
    

### 7. **More System Enumeration (Date, System Stats, CPU Info, Printers)**

- **Date and time**:
    
    ```bash
    date
    
    ```
    
- **System uptime and load**:
    
    ```bash
    uptime
    
    ```
    
- **CPU information**:
    
    ```bash
    lscpu
    cat /proc/cpuinfo
    
    ```
    
- **Memory and swap usage**:
    
    ```bash
    free -h
    
    ```
    
- **Disk usage**:
    
    ```bash
    df -h
    
    ```
    
- **Printers**:
    
    ```bash
    lpstat -p
    
    ```
    

### 8. **Enumerate Defenses (Firewalls, AppArmor, SELinux, etc.)**

- **Check for firewall rules** (iptables):
    
    ```bash
    iptables -L
    
    ```
    
- **Check if SELinux is enabled**:
    
    ```bash
    getenforce
    sestatus
    
    ```
    
- **Check if AppArmor is enabled**:
    
    ```bash
    aa-status
    
    ```
    
- **List running services** (some might be security services):
    
    ```bash
    systemctl list-units --type=service --state=running
    
    ```
    
- **Check for security tools** (e.g., intrusion detection systems like `tripwire`, `aide`):
    
    ```bash
    ps aux | grep -i "tripwire\\|aide"
    
    ```
    

By following these steps, you can thoroughly enumerate a system and identify potential security weaknesses or misconfigurations.