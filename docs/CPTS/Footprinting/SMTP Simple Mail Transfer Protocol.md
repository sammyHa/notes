---
title: SMTP Simple Mail Transfer Protocol
date: 2024-10-30
tags:
  - smtp
techniques: 
tools:
  - telnet
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

## **SMTP (Simple Mail Transfer Protocol) Overview**

- **Purpose**: SMTP is a protocol used for sending emails in IP networks.
- **Usage**:
    - **Client to Server**: Between an email client and an outgoing mail server.
    - **Server to Server**: Between two SMTP servers for relaying emails.

---

### **Key SMTP Ports**

- **Port 25**: Default port for SMTP; used for unencrypted email transmission.
- **Port 587**: Commonly used for encrypted email transmission (using STARTTLS).
- **Port 465**: Often used for secure SSL/TLS connections to SMTP servers.

---

### **SMTP Components & Workflow**

1. **Mail User Agent (MUA)**: Email client that initiates the email transmission.
2. **Mail Submission Agent (MSA)**: Verifies email validity (origin and integrity).
3. **Mail Transfer Agent (MTA)**: Handles email routing, storage, and spam checking.
    - **Open Relay Attack**: A vulnerability in improperly configured MTAs allowing spam or spoofing.
4. **Mail Delivery Agent (MDA)**: Delivers the email to the recipient’s mailbox (POP3/IMAP).

---

### **SMTP Protocol Flow**

1. **Connection**: MUA connects to SMTP server, optionally authenticates (username, password).
2. **Transmission**:
    - **Commands & Data**: Sent in plaintext by default.
    - **Information Transmitted**: Sender & recipient addresses, email content, headers.
3. **Encryption (STARTTLS)**: Switches connection to secure (encrypted) mode.
    - **TLS Activation**: Triggered with the `EHLO` command, followed by `STARTTLS`.
4. **Email Reception**: Destination server receives and reassembles the email for delivery.

---

### **Enhanced Security with ESMTP**

- **ESMTP (Extended SMTP)**: Modern SMTP that includes additional authentication and encryption.
- **SMTP-AUTH**: Authenticates the sender to prevent unauthorized email sending.
- **Anti-Spam Mechanisms**:
    - **DomainKeys Identified Mail (DKIM)**: Validates the sender’s domain.
    - **Sender Policy Framework (SPF)**: Protects against email spoofing.

---

### **SMTP Vulnerabilities**

1. **Lack of Delivery Confirmation**: SMTP does not provide standard delivery receipts.
2. **Unreliable Sender Authentication**: Allows potential misuse for spamming.
3. **Open Relay Risks**: Misconfiguration may allow unauthorized relaying of emails (spam risk).

---

### **SMTP Command Examples**

- **STARTTLS**: Initiates encryption on port 587.
- **EHLO**: Used in ESMTP to identify the client and prepare for STARTTLS.
- **AUTH PLAIN**: Enables encrypted login with username/password.
-
```shell-session
cat /etc/postfix/main.cf | grep -v "#" | sed -r "/^\s*$/d"
```
The sending and communication are also done by special commands that cause the SMTP server to do what the user requires.

| **Command**  | **Description**                                                                                  |
| ------------ | ------------------------------------------------------------------------------------------------ |
| `AUTH PLAIN` | AUTH is a service extension used to authenticate the client.                                     |
| `HELO`       | The client logs in with its computer name and thus starts the session.                           |
| `MAIL FROM`  | The client names the email sender.                                                               |
| `RCPT TO`    | The client names the email recipient.                                                            |
| `DATA`       | The client initiates the transmission of the email.                                              |
| `RSET`       | The client aborts the initiated transmission but keeps the connection between client and server. |
| `VRFY`       | The client checks if a mailbox is available for message transfer.                                |
| `EXPN`       | The client also checks if a mailbox is available for messaging with this command.                |
| `NOOP`       | The client requests a response from the server to prevent disconnection due to time-out.         |
| `QUIT`       | The client terminates the session.                                                               |
|              |                                                                                                  |
#### Telnet - HELO/EHLO
```shell
telnet <ip>
```

### [[Nmap]] Scan
```shell-session
sudo nmap 10.129.14.128 -sC -sV -p25
```

### [[Nmap]] Open relay
```shell-session
sudo nmap 10.129.14.128 -p25 --script smtp-open-relay -v
```