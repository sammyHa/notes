---
title: NFS Network File System
date: 2024-10-30
tags: 
techniques: 
tools:
  - nfs
machines: 
difficulty: 
status: 
type: 
os: 
categories: 
exam-priority: 
time-invested:
---
>[!tip]- Tips
>Write tips here

### References
- Layered Enumeration Framework Guide
- Comprehensive OSCP Enumeration Strategies

**Purpose**:

- **NFS** (Network File System) allows **file access over a network** as if they were local files.
- Developed by **Sun Microsystems**, it’s mainly used on **Linux/Unix** systems.

**Note**: **NFS and SMB** are similar in purpose but use **different protocols** and are not directly compatible.

### Key Protocol Versions:

1. **NFSv2**:
    
    - **Protocol**: Primarily over **UDP**
    - **Compatibility**: Broad system support but **lacks features** of later versions.
2. **NFSv3**:
    
    - **Features**: Variable file sizes, improved error reporting.
    - **Limitations**: Not fully compatible with **NFSv2 clients**.
3. **NFSv4**:
    
    - **Security**: Includes **Kerberos authentication**.
    - **Functionality**: **Firewall-friendly**, supports **ACLs**, and **stateful protocol**.
    - **Efficiency**: Only uses **port 2049** (UDP/TCP), simplifying firewall configuration.
4. **NFSv4.1**:
    
    - **Enhancements**: Cluster support with **pNFS** (parallel NFS), **multipathing** for session trunking.
    - **Advantage**: **Scalable** and **parallel file access** across multiple servers.

### NFS Protocol Basics

- **Based on**: **ONC-RPC/SUN-RPC** protocol.
- **Ports**: Uses **TCP/UDP port 2049**; **RPC services** run on **port 111**.
- **Data Format**: **External Data Representation (XDR)**, for system-independent data exchange.

### Authentication and Authorization

- **Auth via RPC**: Authentication managed by the **RPC protocol** options.
- **Authorization**:
    - Derived from **file system info**.
    - **Server Role**: Maps **UID/GID** from clients to **UNIX format** permissions.
    - **Note**: NFS primarily uses **UNIX UID/GID** and group memberships; less secure if mismatched mappings on client/server.

---

### Key Takeaways

- **NFSv4** is most **secure** and suitable for **trusted networks**.
- **UID/GID mapping** differences can cause permission issues; ensure alignment in **trusted networks** only.
- **pNFS** and **multipathing** (NFSv4.1) provide **scalable, efficient file access** across servers.

---

### Essential Keywords:

- **NFS, SMB, Sun Microsystems, Linux/Unix, RPC, UID/GID, Kerberos, ACLs, pNFS, Multipathing, Firewall-friendly, Port `2049`**

### Default Configuration
```shell
cat /etc/exports
```
The default `exports` file also contains some examples of configuring NFS shares. First, the folder is specified and made available to others, and then the rights they will have on this NFS share are connected to a host or a subnet. Finally, additional options can be added to the hosts or subnets.

![[Pasted image 20241107004705.png]]

Let us create such an entry for test purposes and play around with the settings.

```shell
echo '/mnt/nfs  10.129.14.0/24(sync,no_subtree_check)' >> /etc/exports
```

```shell
systemctl restart nfs-kernel-server

```

```shell
exportfs
```

We have shared the folder `/mnt/nfs` to the subnet `10.129.14.0/24` with the setting shown above. This means that all hosts on the network will be able to mount this NFS share and inspect the contents of this folder.

### Dangerous Settings
However, even with NFS, some settings can be dangerous for the company and its infrastructure. Here are some of them listed:

|**Option**|**Description**|
|---|---|
|`rw`|Read and write permissions.|
|`insecure`|Ports above 1024 will be used.|
|`nohide`|If another file system was mounted below an exported directory, this directory is exported by its own exports entry.|
|`no_root_squash`|All files created by root are kept with the UID/GID 0.|

It is highly recommended to create a local VM and experiment with the settings. We will discover methods that will show us how the NFS server is configured. For this, we can create several folders and assign different options to each one. Then we can inspect them and see what settings can have what effect on the NFS share and its permissions and the enumeration process.

We can take a look at the `insecure` option. This is dangerous because users can use ports above 1024. The first 1024 ports can only be used by root. This prevents the fact that no users can use sockets above port 1024 for the NFS service and interact with it.

### Footprinting The Service

when footprinting NFS the TCP port `111` and `2049` are essential. WE can also get information about the NFS service and the host via RPC, as shown below in the example.

```shell
sudo nmap <ip> -p111,2049 -sV -sC
```

──(kali㉿kali)-[~/Desktop]
└─$ sudo nmap -sV -sC -p111,2049 10.129.105.111
Starting Nmap 7.94SVN ( https://nmap.org ) at 2024-11-07 10:29 EST
Nmap scan report for 10.129.105.111
Host is up (0.20s latency).

PORT     STATE SERVICE VERSION
111/tcp  open  rpcbind 2-4 (RPC #100000)
| rpcinfo: 
|   program version    port/proto  service
|   100000  2,3,4        111/tcp   rpcbind
|   100000  2,3,4        111/udp   rpcbind
|   100000  3,4          111/tcp6  rpcbind
|   100000  3,4          111/udp6  rpcbind
|   100003  3           2049/udp   nfs
|   100003  3           2049/udp6  nfs
|   100003  3,4         2049/tcp   nfs
|   100003  3,4         2049/tcp6  nfs
|   100005  1,2,3      39937/udp   mountd
|   100005  1,2,3      40457/tcp   mountd
|   100005  1,2,3      58286/udp6  mountd
|   100005  1,2,3      59147/tcp6  mountd
|   100021  1,3,4      36399/tcp6  nlockmgr
|   100021  1,3,4      40427/tcp   nlockmgr
|   100021  1,3,4      50906/udp   nlockmgr
|   100021  1,3,4      51106/udp6  nlockmgr
|   100227  3           2049/tcp   nfs_acl
|   100227  3           2049/tcp6  nfs_acl
|   100227  3           2049/udp   nfs_acl
|_  100227  3           2049/udp6  nfs_acl
2049/tcp open  nfs     3-4 (RPC #100003)



Once we have discovered the nfs service, we can mount it on our local machine. 
- create a new empty folder for `NFS` share to be mounted to
- navigate to it and see the content

**Show available NFS shares**
```shell
showmount -e <ip>
```


### Mounting NFS Share
```shell
mkdir target-nfs
sudo mount -t nfs <ip>:/ ./target-nfs/ -o nolock
cd target-nfs
tree .
```
![[Pasted image 20241107104218.png]]

### List Contents with Username and Group Names

```shell
ls -l mnt/nfs/
```

![[Pasted image 20241107104630.png]]

### List contents with UID and GUIDs
```shell
ls -n mnt/nfs/
```
![[Pasted image 20241107104823.png]]


### Unmounting 
```shell
cd ..
sudo unmount ./target-nfs
```


### All The Commands needed for enumeration, mount and unmount

```shell
# Scan for open port
nmap -p 111,2049 <target_ip>

# Enumerate NFS Shares
showmount -e <target_ip>

# Create local mount directory
mkdir -p /mnt/nfs_share

# Mount the NSF Share
sudo mount -t nfs <target_ip>:/path/to/share /mnt/nfs_share

# List Files in Mounthed NFS Share
ls /mnt/nfs_share

#Unmount the NFS Share
sudo umount /mnt/nfs_share

```