---
title: Rsync
date: 2024-10-30
tags: 
techniques: 
tools:
  - rsync
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

### **Rsync**

#### **Overview**

Rsync is a powerful and efficient tool for copying files both locally and remotely. It is widely used for **backups**, **file mirroring**, and **synchronization** due to its ability to minimize network usage through a **delta-transfer algorithm**.

---

#### **Key Features**

1. **Delta-Transfer Algorithm**:
    
    - Only transmits file differences (deltas) to reduce network load.
    - Compares **file size** and **last modified time** to identify changes.
2. **Default Port**:
    
    - Operates on **port 873** by default.
    - Can be secured by leveraging **SSH** for encrypted file transfers.
3. **Versatility**:
    
    - Can copy files locally or between remote hosts.
    - Supports synchronization of files and directories.

---

#### **Security Risks & Misconfigurations**

1. **Unauthorized Access**:
    
    - Some Rsync configurations allow **listing or retrieving files** from a target server without authentication.
2. **Credential Reuse**:
    
    - If credentials are discovered during a penetration test, check for re-use on Rsync services.
    - Sensitive files retrieved may help escalate access or pivot within the network.
3. **Unsecured Rsync Services**:
    
    - Running Rsync over the default port **without SSH** exposes it to interception.

---

#### **Penetration Testing Tips**

- **Identify Rsync Usage**:
    
    - Protocol **31** indicates Rsync is in use.
    - Use `nmap` or manual port scanning to detect **`port 873`** or Rsync over SSH.
```bash
nmap -sV -p 873 <ip>
```
- **Check Shared Folders**:
    
    - Test if folder contents can be **listed or downloaded** without authentication.
    - If credentials are required, use previously discovered passwords for access.
- **Explore Sensitive Files**:
    
    - Look for backup files, configuration files, or password hashes.
    - These files might provide additional leverage to access the target system.

---

### **Example Commands**

1. **List Contents of a Shared Folder** (Unauthenticated):
 
    ```bash
rsync rsync://<target_ip>/shared_folder/
```
    
2. **Download Files** (Using Discovered Credentials):

    
    ```bash
rsync -avz <username>@<target_ip>:<remote_path> <local_path>
```
    
3. **Secure Rsync with SSH**:

    ```bash
rsync -e ssh <source> <destination>
```
    

---

### **Key Takeaways**

- Rsync's **delta-transfer algorithm** makes it efficient for file synchronization.
- Misconfigured Rsync services are a valuable target during penetration tests.
- Always test for **unauthenticated access** and **password reuse** when encountering Rsync on a system.

**Exam Priority**: Medium  
**Techniques/Tools**: Rsync, Delta Transfers, Credential Analysis  
**Tags**: #Rsync #FileTransfers #Pentesting

### **Advanced Rsync Commands**

#### **1. Bandwidth Control**

Limit the transfer rate to avoid overloading the network.

bash

Copy code

`rsync --bwlimit=1000 -avz <source> <destination>`

- **`--bwlimit=1000`**: Limits bandwidth usage to 1000 KB/s.

---

#### **2. Compress Data During Transfer**

Speeds up transfers for large files by compressing data during transmission.

bash

Copy code

`rsync -az <source> <destination>`

- **`-z`**: Enables compression.

---

#### **3. Preserve Permissions, Ownership, and Timestamps**

Maintain file metadata when copying.

bash

Copy code

`rsync -a --perms --owner --group --times <source> <destination>`

- **`-a`**: Archive mode (preserves most file attributes).
- **`--perms --owner --group --times`**: Ensures complete metadata preservation.

---

#### **4. Sync Files Excluding Certain Types**

Skip specific files or directories using `--exclude`.

bash

Copy code

`rsync -av --exclude='*.tmp' --exclude='cache/' <source> <destination>`

- **`--exclude='*.tmp'`**: Excludes all `.tmp` files.
- **`--exclude='cache/'`**: Excludes the `cache` directory.

---

#### **5. Perform Dry Runs**

Test the command without actually transferring files.

bash

Copy code

`rsync -av --dry-run <source> <destination>`

- **`--dry-run`**: Simulates the operation and shows what would be copied.

---

#### **6. Transfer Only New or Changed Files**

Update files that are new or have changed since the last sync.

bash

Copy code

`rsync -av --update <source> <destination>`

- **`--update`**: Skips files that are newer on the destination.

---

#### **7. Delete Files on Destination That Are Not in Source**

Ensure the destination mirrors the source exactly by removing extra files.

bash

Copy code

`rsync -av --delete <source> <destination>`

- **`--delete`**: Deletes files from the destination that are not present in the source.

---

#### **8. Use Checksum-Based Comparison**

Ensure integrity by comparing file checksums instead of timestamps and file size.

bash

Copy code

`rsync -ac <source> <destination>`

- **`-c`**: Enables checksum-based comparison.

---

#### **9. Sync Files Over SSH with Custom Port**

Specify a custom SSH port for secure file transfers.

```bash
rsync -e 'ssh -p 2222' <source> <user>@<destination>:/path
```

- **`-e 'ssh -p 2222'`**: Uses SSH on port `2222` for transfer.

---

#### **10. Log Transfer Details**

Write a detailed log of the transfer to a file.

```bash
rsync -av --log-file=/path/to/logfile.log <source> <destination>
```

- **`--log-file`**: Outputs transfer details to a specified log file.

---

#### **11. Limit Maximum File Size**

Transfer only files below a specific size.

```bash
rsync -av --max-size='10M' <source> <destination>
```

- **`--max-size='10M'`**: Limits transfer to files smaller than 10 MB.

---

#### **12. Backup Deleted or Overwritten Files**

Keep backups of files that are deleted or overwritten during transfer.

```bash
rsync -av --backup --backup-dir=/path/to/backup <source> <destination>
```

- **`--backup`**: Enables backups.
- **`--backup-dir=/path/to/backup`**: Specifies the backup directory.

---

#### **13. Show Progress During Transfer**

Track progress for large transfers.

```bash
rsync -av --progress <source> <destination>
```

- **`--progress`**: Displays transfer progress.

---

#### **14. Hard-Link Preservation**

Preserve hard links in the source directory.

```bash
rsync -avH <source> <destination>
```

- **`-H`**: Ensures hard links are maintained.

---

#### **15. Partial Transfers**

Resume interrupted transfers instead of starting over.

```shell
rsync -av --partial <source> <destination>
```

- **`--partial`**: Keeps partially transferred files for resumption.

---

### **Example Penetration Testing Commands**

#### **Scan and List Publicly Accessible Rsync Modules**

```bash
rsync --list-only rsync://<target_ip>/
```

#### **Retrieve Files from an Rsync Module**

```bash
rsync -av rsync://<target_ip>/<module_name>/ <local_path>
```

#### **Scan for Rsync with [[Nmap]]**

```bash
nmap -p 873 --script rsync-list-modules <target_ip>```

- **`rsync-list-modules`**: Lists available Rsync modules.

---

### **Key Takeaways**

- Rsync's versatility makes it indispensable for secure file transfers, backups, and synchronization.
- Advanced options like **compression**, **checksums**, and **partial transfers** enhance efficiency.
- Misconfigured Rsync services are a valuable penetration testing target.

**Exam Priority**: High  
**Techniques/Tools**: Rsync, SSH, Exclusion Rules, Delta Transfers  
**Tags**: #Rsync #AdvancedCommands #Pentesting