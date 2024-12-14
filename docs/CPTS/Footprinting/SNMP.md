---
title: SNMP
date: 2024-10-30
tags: 
techniques: 
tools:
  - braa
  - onesixtyone
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

### 1. **SNMP Overview**

- **Definition**: Simple Network Management Protocol (SNMP) is used for **monitoring and managing network devices** remotely, including routers, switches, servers, and IoT devices.
- **Purpose**: Enables **remote configuration** and **status monitoring**.
- **Current Version**: SNMPv3, offering **increased security** but with added **complexity**.

### 2. **Communication and Ports**

- **Control Commands**: Sent over **UDP port 161** to change device settings.
- **Traps**: **Unrequested data packets** sent from the server to the client on **UDP port 162** for specific events.

### 3. **SNMP Components**

- **MIB (Management Information Base)**: A standardized **hierarchical format** listing SNMP objects for each device, facilitating cross-manufacturer access.
    - **Object Identifier (OID)**: Unique **numeric address** for each object; organized in **dot notation**.
- **Community Strings**: Act as **passwords**; still widely used in SNMPv2c, leading to security concerns due to lack of encryption.

### 4. **Protocol Versions**

- **SNMPv1**:
    - Basic **network management and monitoring**.
    - **No encryption** or authentication; **plain-text data**.
    - Still used in smaller networks.
    
- **SNMPv2 (v2c)**:
    - **Adds features** but lacks security improvements.
    - **Community string** remains unencrypted.
    
- **SNMPv3**:
    - Improved **security with authentication and encryption**.
    - **Complex setup** deters some administrators from upgrading.

### 5. **Security Concerns**
- **Community Strings**:
    - Many organizations still use **SNMPv2** due to **complexity in transitioning to SNMPv3**.
    - **Plain-text transmission** allows for potential interception.
    
- **Default Configuration**:
    - Includes IP addresses, ports, MIB, OIDs, **authentication**, and **community strings**.
    - Inadequate knowledge of SNMP’s security features makes networks **vulnerable to attacks**.

---

**Summary**: SNMP facilitates **monitoring and management** of network devices through **MIBs, OIDs,** and **community strings**. **SNMPv3** offers enhanced security but requires significant configuration, while **SNMPv1** and **SNMPv2** remain widely used despite their vulnerabilities. **Default SNMP configurations** are often left unsecured, making networks susceptible to **data interception and unauthorized access**.

#### SNMP Daemon Config
```shell
cat /etc/snmp/snmpd.conf | grep -v "#" | sed -r '/^\s*$/d'
```

![[Pasted image 20241110233020.png]]
All the settings that can be make for the NSMP daemon are defined and described in the 
http://www.net-snmp.org/docs/man/snmpd.conf.html

## Dangerous Settings

Some dangerous settings that the administrator can make with SNMP are:

| **Settings**                                     | **Description**                                                                       |
| ------------------------------------------------ | ------------------------------------------------------------------------------------- |
| `rwuser noauth`                                  | Provides access to the full OID tree without authentication.                          |
| `rwcommunity <community string> <IPv4 address>`  | Provides access to the full OID tree regardless of where the requests were sent from. |
| `rwcommunity6 <community string> <IPv6 address>` | Same access as with `rwcommunity` with the difference of using IPv6.                  |
|                                                  |                                                                                       |
## Footprinting the Service

For footprinting SNMP, we can use tools like [[snmpwalk]], [[onesixtyone]], and [[braa]]. `Snmpwalk` is used to query the OIDs with their information. `Onesixtyone` can be used to brute-force the names of the community strings since they can be named arbitrarily by the administrator. Since these community strings can be bound to any source, identifying the existing community strings can take quite some time.

```bash
snmpwalk -v2c -c public 10.129.14.128
sudo apt install onesixtyone
sudo apt install braa
```

![[Pasted image 20241111003414.png]]