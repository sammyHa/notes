
Enumerate the server carefully and find the username "`HTB`" and its password. Then, submit this user's password as the answer.

### Nmap
```bash
nmap -sV -sC 10.129.158.159
```

Output:
```bash
PORT     STATE SERVICE       VERSION
111/tcp  open  rpcbind       2-4 (RPC #100000)
| rpcinfo: 
|   program version    port/proto  service
|   100000  2,3,4        111/tcp   rpcbind
|   100000  2,3,4        111/tcp6  rpcbind
|   100000  2,3,4        111/udp   rpcbind
|   100000  2,3,4        111/udp6  rpcbind
|   100003  2,3         2049/udp   nfs
|   100003  2,3         2049/udp6  nfs
|   100003  2,3,4       2049/tcp   nfs
|   100003  2,3,4       2049/tcp6  nfs
|   100005  1,2,3       2049/tcp   mountd
|   100005  1,2,3       2049/tcp6  mountd
|   100005  1,2,3       2049/udp   mountd
|   100005  1,2,3       2049/udp6  mountd
|   100021  1,2,3,4     2049/tcp   nlockmgr
|   100021  1,2,3,4     2049/tcp6  nlockmgr
|   100021  1,2,3,4     2049/udp   nlockmgr
|   100021  1,2,3,4     2049/udp6  nlockmgr
|   100024  1           2049/tcp   status
|   100024  1           2049/tcp6  status
|   100024  1           2049/udp   status
|_  100024  1           2049/udp6  status
135/tcp  open  msrpc         Microsoft Windows RPC
139/tcp  open  netbios-ssn   Microsoft Windows netbios-ssn
445/tcp  open  microsoft-ds?
2049/tcp open  nlockmgr      1-4 (RPC #100021)
3389/tcp open  ms-wbt-server Microsoft Terminal Services
| rdp-ntlm-info: 
|   Target_Name: WINMEDIUM
|   NetBIOS_Domain_Name: WINMEDIUM
|   NetBIOS_Computer_Name: WINMEDIUM
|   DNS_Domain_Name: WINMEDIUM
|   DNS_Computer_Name: WINMEDIUM
|   Product_Version: 10.0.17763
|_  System_Time: 2024-11-16T03:34:57+00:00
| ssl-cert: Subject: commonName=WINMEDIUM
| Not valid before: 2024-11-15T02:29:35
|_Not valid after:  2025-05-17T02:29:35
|_ssl-date: 2024-11-16T03:35:05+00:00; +56s from scanner time.
Service Info: OS: Windows; CPE: cpe:/o:microsoft:windows

Host script results:
|_clock-skew: mean: 55s, deviation: 0s, median: 55s
| smb2-time: 
|   date: 2024-11-16T03:34:57
|_  start_date: N/A
| smb2-security-mode: 
|   3:1:1: 
|_    Message signing enabled but not required
```

We Can use nmap to Enumerate RPC farther
```bash
nmap -p 2049 --script rpcinfo <target>
```
From the output we see that many version of RPC program are running. and there is NFS mount daemon as well. we will use the `showmount` command to see the mounted shares.
```bash
showmount -e $ip
```

Output
```bash
Export list for 10.129.158.159:
/TechSupport (everyone)
```

we see a shared directory `TechSupport` that everyone can access.
#### [[NFS Network File System]] 
Since we have a directory to mount we can use NFS to mount the share from a remote server to a local directory on Linux system.
```bash
mkdir target-nfs
cd target-nfs
sudo mount -t nfs 10.129.158.159:/ target-nfs/ -o nolock
cd target-nfs
sud ls -la
sudo ls -la TechSupport
sudo cat TechSupport/ticket4238791283782.txt 
```

`-t nfs` Specifies the type of filesystem to mount in this case `nfs` indicates that the filesystem is an `NFS` share

**`$ip:/`**:
- `$ip` is a placeholder for the **IP address** or **hostname** of the remote NFS server.
- `:/` specifies the **root directory** of the NFS export on the server. Replace `$ip` with the actual IP address or hostname of the server.

- **`./target-NFS/`**:
    - This is the **local mount point**, i.e., the directory on the local system where the NFS share will be mounted.
    - Replace `./target-NFS/` with the path to an existing directory. If the directory does not exist, it must be created first (e.g., using `mkdir`).
    
- **`-o nolock`**:
    - `-o` specifies options for the mount operation.
    - `nolock` disables NFS file locking, which can sometimes be necessary in environments where the `rpc.statd` or `lockd` daemons are not running (e.g., minimal or containerized environments).
Output of the `cat`
```bash
sudo cat TechSupport/ticket4238791283782.txt
Conversation with InlaneFreight Ltd

 5    user="alex"
 6    password="lol123!mD"
 7    from="alex.g@web.dev.inlanefreight.htb"

.......
```
We got the username and password now we can connect to 3389 RDP using `xfreerdp`
```bash
xfreerdp /cert:ignore /u:alex /p:"lol123!\mD" /v:10.129.158.159
```
We we'll get a windows connection window where we can interact with database.
![[Pasted image 20241115230238.png]]After looking around on the files and directories i found a file called `important`
![[Pasted image 20241115230633.png

Looks like a password  `sa:87N1ns@slls83`
after running the Microsfot SQL Server on desktop with administrator it requires a passwod and using the password about for `sa` will let us into the database.
![[Pasted image 20241115230900.png]]
And we are in. Now we just need to query the database for the user and password and submited.
![[Pasted image 20241115231055.png]]
By expanding the `accounts` > `Tables` > `dbo.devsacc` and write click and `select Top 1000 row` and scroll down to find user `HTB` and password `lnch7ehrdn43i7AoqVPK4zWR`. 
![[Pasted image 20241115231916.png]]
