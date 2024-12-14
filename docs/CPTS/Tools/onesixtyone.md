---
title: onesixtyone
date: 2024-10-30
tags: 
techniques: 
tools:
  - onesixtyone
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

### **Onesixtyone Cheat Sheet**

#### **Overview**

**Onesixtyone** is a lightweight SNMP scanning tool designed to quickly identify SNMP-enabled devices on a network. It allows users to scan a range of IP addresses for open SNMP services and check for vulnerabilities by attempting to retrieve SNMP data using various community strings. Commonly used by network administrators and penetration testers, onesixtyone is an effective tool for identifying misconfigured SNMP services that may expose critical device information.

---

### **Basic Syntax**

The basic syntax of onesixtyone is as follows:

```bash
onesixtyone -c <community_file> -i <ip_file>
```

- `-c <community_file>`: Specifies the file containing community strings (like passwords) to try against the SNMP service. Common community strings include `public`, `private`, and `community`.
- `-i <ip_file>`: Specifies the file containing IP addresses to scan.

**Example**:

bash

Copy code

`onesixtyone -c community.txt -i ips.txt`

This command scans the IP addresses in `ips.txt` using the community strings in `community.txt`.

---

### **Setting Up the Community and IP Files**

**Community String File**:

- The `community.txt` file contains a list of possible SNMP community strings, each on a new line.
- **Example**:
    
    arduino
    
    Copy code
    
    `public private secret community`
    

**IP Address File**:

- The `ips.txt` file contains the IP addresses or IP ranges to be scanned.
- **Example**:
    
    Copy code
    
    `192.168.1.1 192.168.1.0/24`
    

---

### **Basic Scanning Commands**

1. **Single IP Scan**:
    
    bash
    
    Copy code
    
    `onesixtyone -c community.txt 192.168.1.1`
    
    This command tests the IP `192.168.1.1` against the community strings listed in `community.txt`.
    
2. **IP Range Scan**:
    
    bash
    
    Copy code
    
    `onesixtyone -c community.txt -i ips.txt`
    
    This command scans all IP addresses in `ips.txt`, attempting to authenticate with each listed community string.
    
3. **Verbose Mode**:
    
    bash
    
    Copy code
    
    `onesixtyone -v -c community.txt -i ips.txt`
    
    Adding the `-v` flag enables verbose output, which can provide more detailed feedback about each attempt.
    

---

### **Advanced Usage**

#### **Port and Timeout Options**

By default, onesixtyone scans SNMP on UDP port 161. However, these options are customizable:

- **Custom Port**: Specify a non-standard SNMP port with the `-p` option.
    
    bash
    
    Copy code
    
    `onesixtyone -p 1161 -c community.txt -i ips.txt`
    
    This scans the SNMP service on port `1161` instead of the default `161`.
    
- **Timeout Settings**: Control the timeout duration for each request using `-t` (in milliseconds).
    
    ```bash
onesixtyone -t 500 -c community.txt -i ips.txt
```
    
    This sets a 500 ms timeout per request.
    

#### **Using Onesixtyone with Nmap**

To maximize efficiency, pair onesixtyone with **Nmap** to identify SNMP services before using onesixtyone to query them.

1. **Identify SNMP-Enabled Devices with Nmap**:
    
    bash
    
    Copy code
    
    `nmap -sU -p 161 --open -oG snmp_hosts.txt 192.168.1.0/24`
    
    This command scans the specified subnet for open UDP port 161 and saves results to `snmp_hosts.txt`.
    
2. **Filter and Feed Results to Onesixtyone**: Use the results of Nmap to create an IP file and feed it to onesixtyone.
    
    bash
    
    Copy code
    
    `grep 'open' snmp_hosts.txt | awk '{print $2}' > open_ips.txt onesixtyone -c community.txt -i open_ips.txt`
    

---

### **Interpreting Onesixtyone Results**

After running onesixtyone, the output typically displays each IP and the corresponding SNMP system information if a valid community string is found. The information may include:

- **System Description**: Basic details about the operating system and device type.
- **Uptime**: Device uptime, which can help estimate system stability or determine if a device was recently rebooted.
- **Contact Information**: Administrator details (if configured).
- **Location**: Physical or logical location of the device.

**Example Output**:

plaintext

Copy code

`192.168.1.1 [public] Linux 3.10.0-1160.15.2.el7.x86_64 192.168.1.2 [private] Cisco IOS Software, C880 Software`

---

### **Common Use Cases**

1. **Identify Default or Weak Community Strings**: Use common strings like "public" and "private" to detect devices using default SNMP settings.
2. **Network Mapping**: Discover devices and basic details to create a network topology.
3. **Vulnerability Scanning**: Find devices exposing sensitive information through misconfigured SNMP.

---

### **Troubleshooting**

- **No Output or Timeout**: Check that SNMP is enabled on the target device and accessible from your network.
- **Connection Refused or Blocked**: Ensure UDP port 161 is open on the target. Firewalls may block SNMP traffic.
- **No Results**: Try different community strings, as the target might not be using default values.

---

### **Security Considerations**

Since **SNMPv1** and **SNMPv2c** lack encryption, any data, including community strings, is transmitted in plain text, making it vulnerable to interception. Using strong, unique community strings or migrating to **SNMPv3** with authentication and encryption is recommended for security.