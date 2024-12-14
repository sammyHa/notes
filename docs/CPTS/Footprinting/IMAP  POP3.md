---
title: IMAP  POP3
date: 2024-10-30
tags: 
techniques: 
tools: 
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

### **Overview**

- **Purpose**: IMAP provides **online email management** directly on a remote server.
- **Functionality**: Unlike POP3, which only lists, retrieves, and deletes emails, IMAP offers **hierarchical mailbox structures**, access to multiple mailboxes, and synchronization across clients.
- **Server Interaction**: Emails stay on the server, allowing access from multiple devices and **uniform synchronization**.

### **Key Features**
1. **Folder Structure Support**: Organizes emails in folders, enhancing mailbox clarity.
2. **Multiple Client Access**: Simultaneous access across clients with **real-time synchronization**.
3. **Offline Mode**: Certain email clients allow offline email access and sync updates upon reconnection.
4. **Extended Commands**: Uses ASCII text-based commands that can be processed in batches without waiting for server confirmation.

### **Technical Details**
- **Port**: Default port `143`; **encrypted sessions** usually via port `993` with SSL/TLS for secure connections.
- **Authentication**: Users authenticate via username and password post-connection.
- **Synchronization**: Creates a network file system for emails, allowing continuous synchronization across clients.
-
### **Comparison with POP3**
- **IMAP**:
    - Supports **online folder structures** and **multiple mailbox access**.
    - Keeps emails on the server until deleted, enabling **multi-client synchronization**.
    - Allows email browsing on the server without downloading.
- **POP3**:
    
    - **Limited functions**: Lists, retrieves, and deletes emails only.
    - Primarily downloads emails to a local device without maintaining server copies.
    -
- ### **Security**
- **Plaintext Transmission**: By default, IMAP transmits credentials and data in plaintext.
- **Encryption**: Most email servers enforce SSL/TLS-encrypted sessions for secure email traffic, typically over port `993`.
### **SMTP Integration**

- **Sending Emails**: SMTP is generally used, with sent emails copied to IMAP folders, enabling access to sent emails across devices.
#### IMAP Commands

| **Command**                     | **Description**                                                                                               |
| ------------------------------- | ------------------------------------------------------------------------------------------------------------- |
| `1 LOGIN username password`     | User's login.                                                                                                 |
| `1 LIST "" *`                   | Lists all directories.                                                                                        |
| `1 CREATE "INBOX"`              | Creates a mailbox with a specified name.                                                                      |
| `1 DELETE "INBOX"`              | Deletes a mailbox.                                                                                            |
| `1 RENAME "ToRead" "Important"` | Renames a mailbox.                                                                                            |
| `1 LSUB "" *`                   | Returns a subset of names from the set of names that the User has declared as being `active` or `subscribed`. |
| `1 SELECT INBOX`                | Selects a mailbox so that messages in the mailbox can be accessed.                                            |
| `1 UNSELECT INBOX`              | Exits the selected mailbox.                                                                                   |
| `1 FETCH <ID> all`              | Retrieves data associated with a message in the mailbox.                                                      |
| `1 CLOSE`                       | Removes all messages with the `Deleted` flag set.                                                             |
| `1 LOGOUT`                      | Closes the connection with the IMAP server.                                                                   |

#### POP3 Commands

|**Command**|**Description**|
|---|---|
|`USER username`|Identifies the user.|
|`PASS password`|Authentication of the user using its password.|
|`STAT`|Requests the number of saved emails from the server.|
|`LIST`|Requests from the server the number and size of all emails.|
|`RETR id`|Requests the server to deliver the requested email by ID.|
|`DELE id`|Requests the server to delete the requested email by ID.|
|`CAPA`|Requests the server to display the server capabilities.|
|`RSET`|Requests the server to reset the transmitted information.|
|`QUIT`|Closes the connection with the POP3 server.|

---

## Dangerous Settings

Nevertheless, configuration options that were improperly configured could allow us to obtain more information, such as debugging the executed commands on the service or logging in as anonymous, similar to the FTP service. Most companies use third-party email providers such as Google, Microsoft, and many others. However, some companies still use their own mail servers for many different reasons. One of these reasons is to maintain the privacy that they want to keep in their own hands. Many configuration mistakes can be made by administrators, which in the worst cases will allow us to read all the emails sent and received, which may even contain confidential or sensitive information. Some of these configuration options include:

| **Setting**               | **Description**                                                                           |
| ------------------------- | ----------------------------------------------------------------------------------------- |
| `auth_debug`              | Enables all authentication debug logging.                                                 |
| `auth_debug_passwords`    | This setting adjusts log verbosity, the submitted passwords, and the scheme gets logged.  |
| `auth_verbose`            | Logs unsuccessful authentication attempts and their reasons.                              |
| `auth_verbose_passwords`  | Passwords used for authentication are logged and can also be truncated.                   |
| `auth_anonymous_username` | This specifies the username to be used when logging in with the ANONYMOUS SASL mechanism. |
### Footprinting the Service
```bash
nmap <ip> -sV -p110,143,993,995 -sC

#curl
curl -k 'imaps://<ip>' --user user:p4ssw0rd

# verbose (-v)
curl -k 'imaps://<ip>' --user cry0l1t3:1234 -v

# intract with pop3 over ssl and ncat
openssl -s_client --connect <ip>:pop3s
```

### openSSL - TLS Encrypted Interaction IMAP
```shell
openssl s_client --connect <ip>:imaps
```


Once we have successfully initiated a connection and logged in to the target mail server, we can use the above commands to work with and navigate the server. We want to point out that the configuration of our own mail server, the research for it, and the experiments we can do together with other community members will give us the know-how to understand the communication taking place and what configuration options are responsible for this.

In the SMTP section, we have found the user `robin`. Another member of our team was able to find out that the user also uses his username as a password (`robin`:`robin`). We can use these credentials and try them to interact with the IMAP/POP3 services.

![[Pasted image 20241110225315.png]]

for login to imap use the `a001 LOGIN user_name password`
```bash
1 fetch 1 all
1 fetch 1 body[text]
```

![[Pasted image 20241110230512.png]]