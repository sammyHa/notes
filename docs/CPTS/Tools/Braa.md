---
title: Braa
date: 2024-10-30
tags: 
techniques: 
tools:
  - braa
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

### Braa Cheat Sheet

#### **Overview**

**braa** is a fast, lightweight SNMP brute-force tool designed to query SNMP-enabled devices across large IP ranges. It’s particularly useful for testing multiple community strings (similar to passwords) against a set of IP addresses to see if they reveal SNMP-accessible information. This is an effective approach for identifying devices configured with default or weak SNMP community strings, which can expose device details to unauthorized users.

---

### **Basic Syntax**

The basic syntax of braa is as follows:

bash

Copy code

`braa <community_string>@<target_IP>`

- `<community_string>`: The SNMP community string to use (e.g., `public`, `private`).
- `<target_IP>`: The IP address of the SNMP-enabled device to query.

**Example**:

bash

Copy code

`braa public@192.168.1.1`

This command queries the SNMP service on `192.168.1.1` using the `public` community string.

---

### **Basic Commands**

1. **Single Target Query**:
    
    bash
    
    Copy code
    
    `braa public@192.168.1.1`
    
    This sends an SNMP request using the `public` community string to a single IP address.
    
2. **Multiple Targets with a Single Community String**:
    
    bash
    
    Copy code
    
    `braa public@192.168.1.1 192.168.1.2 192.168.1.3`
    
    This command queries multiple IP addresses using the `public` community string.
    
3. **Multiple Community Strings**: You can specify different community strings by using `@` to separate each community string and IP address:
    
    bash
    
    Copy code
    
    `braa public@192.168.1.1 private@192.168.1.2`
    
    This queries `192.168.1.1` with the `public` community string and `192.168.1.2` with the `private` community string.
    
4. **Using Wildcards for Bulk Queries**: If scanning a range of IP addresses with the same community string, you can specify wildcards:
    
    bash
    
    Copy code
    
    `braa public@192.168.1.*`
    
    This queries all IPs in the `192.168.1.*` range with the `public` community string.
    
5. **Specifying an OID**: By default, braa queries the standard `1.3.6.1.2.1` subtree, but you can specify a custom OID to retrieve targeted information:
    
    bash
    
    Copy code
    
    `braa public@192.168.1.1 1.3.6.1.2.1.1.5.0`
    
    This queries the OID `1.3.6.1.2.1.1.5.0` (usually the device’s hostname).
    

---

### **Advanced Usage**

#### **Using Braa with Multiple Community Strings from a File**

If you want to test multiple community strings against a target list of IPs, you can do so by scripting braa with community strings from a file:

bash

Copy code

`while read community; do braa "$community"@192.168.1.*; done < community_strings.txt`

Here:

- `community_strings.txt` is a file containing a list of potential SNMP community strings.
- This command will iterate through each community string, querying the SNMP service for each IP in the `192.168.1.*` range.

#### **Using Braa with Nmap**

You can pair braa with **Nmap** to first identify open SNMP ports and then target them specifically:

1. **Identify SNMP-Enabled Devices with Nmap**:
    
    bash
    
    Copy code
    
    `nmap -sU -p 161 --open -oG snmp_hosts.txt 192.168.1.0/24`
    
    This scans the specified subnet for open UDP port 161 and outputs results to `snmp_hosts.txt`.
    
2. **Filter and Use Output with Braa**: Extract IPs of SNMP-enabled devices and pass them to braa.
    
    bash
    
    Copy code
    
    `grep 'open' snmp_hosts.txt | awk '{print $2}' > open_ips.txt while read ip; do braa public@"$ip"; done < open_ips.txt`
    

---

### **Common Use Cases**

1. **SNMP Brute-Forcing**: Braa is mainly used to brute-force community strings for SNMP services by testing common or default values like `public`, `private`, etc., across a range of devices.
    
2. **Network Enumeration**: Using braa with correct community strings can reveal device information, system descriptions, network interfaces, and configurations, useful for mapping network topologies.
    
3. **Security Assessment**: Identifying devices configured with weak SNMP community strings can help administrators secure them by changing defaults or upgrading to SNMPv3.
    

---

### **Interpreting Results**

After running braa, results display information about each queried SNMP object. Typical information includes:

- **Device Name and OS**: Basic system information, which can be useful in identifying device types.
- **Network Interfaces**: Details about network interfaces on the device.
- **Location and Contact**: Location or contact information, if configured.

**Example Output**:

plaintext

Copy code

`192.168.1.1 [public] Linux 3.10.0-1160.15.2.el7.x86_64 192.168.1.2 [public] Cisco IOS Software, C880 Software`

---

### **Security Considerations**

As with other SNMP brute-force tools, running braa in production environments without authorization could expose sensitive device information or disrupt network operations. It is recommended to:

- Ensure permission before scanning networks.
- Avoid using braa on SNMPv3-secured devices since it targets SNMPv1 and SNMPv2, which have weaker security.