---
title: snmpwalk
date: 2024-10-30
tags: 
techniques: 
tools:
  - snmpwalk
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

### **SNMPwalk Cheat Sheet**

#### **Overview**

**SNMPwalk** is a command-line tool used to retrieve a sequence of SNMP objects from a target device. It sends an SNMP GETNEXT request to query information from an SNMP-enabled device, like routers, switches, servers, and IoT devices, over the network. **SNMPwalk** simplifies querying by automatically walking through the Management Information Base (MIB) tree to retrieve hierarchical data without needing to specify each Object Identifier (OID) individually.

#### **Common SNMP Versions and Ports**

- **SNMPv1**: Insecure, no encryption, uses community strings.
- **SNMPv2c**: Adds bulk requests but still lacks security.
- **SNMPv3**: Offers enhanced security with authentication and encryption.

Default ports:

- **UDP 161**: General SNMP queries.
- **UDP 162**: SNMP traps.

---

### **Basic Syntax**

The basic syntax of `snmpwalk` is as follows:

bash

Copy code

`snmpwalk -v <version> -c <community_string> <target_ip> <oid>`

- `-v <version>`: Specifies the SNMP version (e.g., 1, 2c, or 3).
- `-c <community_string>`: Community string for SNMP versions 1 and 2c (e.g., "public").
- `<target_ip>`: IP address or hostname of the SNMP-enabled device.
- `<oid>`: The Object Identifier you want to walk. If left blank, the entire MIB tree is walked.

**Example**:

bash

Copy code

`snmpwalk -v 2c -c public 192.168.1.1`

This command queries the entire MIB tree of the device at 192.168.1.1 using SNMPv2c with the community string "public".

---

### **Commonly Used SNMP OIDs**

Some frequently used Object Identifiers (OIDs):

- **System Information**: `.1.3.6.1.2.1.1` (e.g., uptime, contact, location)
- **Network Interfaces**: `.1.3.6.1.2.1.2`
- **IP Address Table**: `.1.3.6.1.2.1.4.20`
- **Routing Table**: `.1.3.6.1.2.1.4.21`
- **ARP Table**: `.1.3.6.1.2.1.4.22`
- **CPU Load**: `.1.3.6.1.4.1.2021.10`
- **Memory Usage**: `.1.3.6.1.4.1.2021.4`

**Example**:

bash

Copy code

`snmpwalk -v 2c -c public 192.168.1.1 1.3.6.1.2.1.1`

This command retrieves system information, including device uptime, system contact, and location.

---

### **Using SNMPv3 for Enhanced Security**

For SNMPv3, use the following options:

- `-u <username>`: Specifies the username.
- `-l <authLevel>`: Sets the security level (noAuthNoPriv, authNoPriv, authPriv).
- `-a <authProtocol>`: Authentication protocol (e.g., MD5 or SHA).
- `-A <authPassphrase>`: Authentication passphrase.
- `-x <privProtocol>`: Privacy protocol (e.g., DES or AES).
- `-X <privPassphrase>`: Privacy passphrase.

**Example with Authentication and Privacy**:

bash

Copy code

`snmpwalk -v 3 -u myUser -l authPriv -a SHA -A "authPass" -x AES -X "privPass" 192.168.1.1`

This command uses SNMPv3 with both authentication (SHA) and encryption (AES).

---

### **Advanced Usage**

#### **Limiting Output by MIB Tree or OID**

Specify an OID to target a specific branch of the MIB tree, improving efficiency and readability. For example:

bash

Copy code

`snmpwalk -v 2c -c public 192.168.1.1 1.3.6.1.2.1.2`

This command retrieves only network interface information, rather than the entire MIB tree.

#### **Using `snmpwalk` with Output Filtering**

Use `grep` or `awk` to filter specific information. For example, to get only interface names and statuses:

bash

Copy code

`snmpwalk -v 2c -c public 192.168.1.1 1.3.6.1.2.1.2 | grep "ifDescr\|ifOperStatus"`

This command outputs only the interface description and operational status.

#### **Setting Timeout and Retries**

Use the `-t` (timeout) and `-r` (retries) options to handle latency or unreliable connections:

bash

Copy code

`snmpwalk -v 2c -c public -t 5 -r 3 192.168.1.1`

This command sets a 5-second timeout and 3 retries.

#### **Saving Output to a File**

To save the results to a file for analysis or reporting:

bash

Copy code

`snmpwalk -v 2c -c public 192.168.1.1 > snmp_output.txt`

---

### **Common Errors and Troubleshooting**

- **Timeout or No Response**: Ensure the device allows SNMP requests from your IP. Check if SNMP is enabled and configured correctly on the device.
- **Incorrect Community String**: For SNMPv1 or SNMPv2, verify the correct community string (e.g., "public"). A wrong community string will cause "Timeout" errors.
- **Authentication Issues with SNMPv3**: Verify usernames, authentication protocols, and passphrases if using SNMPv3.

---

### **Practical Applications**

1. **Device Inventory**: Use `snmpwalk` to retrieve system descriptions, IP addresses, and other data, building an inventory of networked devices.
2. **Performance Monitoring**: Monitor CPU, memory usage, and network interface traffic statistics.
3. **Fault Detection**: Use SNMP traps to detect changes (e.g., link up/down, high CPU load) and automate alerts.
4. **Configuration Auditing**: Pull configuration details for auditing purposes to ensure compliance with standards or to detect unauthorized changes.