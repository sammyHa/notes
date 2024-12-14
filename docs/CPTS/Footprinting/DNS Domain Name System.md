---
title: DNS
date: 2024-10-30
tags:
  - dns
techniques:
  - NS Record Query
tools:
  - bind9
  - dns
  - dig
  - axfr
  - rndc-key
machines: 
difficulty: 
status: 
type: 
os: Linux
categories: 
exam-priority:
  - medium
time-invested: -2
---
>[!tip]- Tips
>Write tips here

### References
- Layered Enumeration Framework Guide
- Comprehensive OSCP Enumeration Strategies


**Overview**  
DNS (Domain Name System) is a decentralized system that translates domain names (e.g., `www.hackthebox.com`) into IP addresses, allowing users to access web servers easily. Rather than a single central database, DNS data is stored across thousands of distributed servers worldwide. It is like a library of phone books, where each server holds a piece of information for global accessibility.

---

**Key DNS Server Types**

1. **DNS Root Server**
    
    - _Role_: Directs requests for top-level domains (TLDs, e.g., `.com`, `.org`).
    - _Description_: Acts as a final referral point in the DNS query chain when other servers don’t respond. ICANN manages 13 root servers worldwide.
2. **Authoritative Name Server**
    
    - _Role_: Holds definitive records for a specific DNS zone.
    - _Description_: Provides answers directly from its designated domain’s database. If it can’t respond, the request escalates to the root server.
3. **Non-Authoritative Name Server**
    
    - _Role_: Retrieves information from other DNS servers.
    - _Description_: Uses recursive or iterative queries to collect DNS zone data without direct responsibility for the zone.
4. **Caching DNS Server**
    
    - _Role_: Temporarily stores DNS query results.
    - _Description_: Speeds up response times by caching information from authoritative servers for a set duration defined by the authoritative server.
5. **Forwarding Server**
    
    - _Role_: Forwards DNS queries to other servers.
    - _Description_: Acts as an intermediary, forwarding DNS requests rather than resolving them directly.
6. **Resolver**
    
    - _Role_: Locally performs name resolution on devices or routers.
    - _Description_: Resolves domain names to IP addresses within a device’s or network’s local system.

---

**Security Considerations**

- **Encryption Methods**: DNS traffic is typically unencrypted, creating privacy risks as local networks and ISPs can monitor DNS queries. Common encryption solutions include:
    - **DNS over TLS (DoT)**
    - **DNS over HTTPS (DoH)**
    - **DNSCrypt**: Encrypts DNS traffic between devices and name servers.

---

**Additional DNS Functions**

- Besides IP translation, DNS can provide other data about domain-associated services, such as:
    - **Mail Server Information**: Identifies email servers for the domain.
    - **Name Server Information**: Lists servers responsible for the domain.

---

**Summary Flow of a DNS Query**

1. **User Request** → **Recursive Query** → **Root Server (if needed)** → **TLD Server** → **Authoritative Name Server**  
    The system resolves domain names to IP addresses, allowing seamless web access.
![[Pasted image 20241107235120.png]]

Different `DNS records` are used for the DNS queries, which all have various tasks. Moreover, separate entries exist for different functions since we can set up mail servers and other servers for a domain.

|**DNS Record**|**Description**|
|---|---|
|`A`|Returns an IPv4 address of the requested domain as a result.|
|`AAAA`|Returns an IPv6 address of the requested domain.|
|`MX`|Returns the responsible mail servers as a result.|
|`NS`|Returns the DNS servers (nameservers) of the domain.|
|`TXT`|This record can contain various information. The all-rounder can be used, e.g., to validate the Google Search Console or validate SSL certificates. In addition, SPF and DMARC entries are set to validate mail traffic and protect it from spam.|
|`CNAME`|This record serves as an alias for another domain name. If you want the domain www.hackthebox.eu to point to the same IP as hackthebox.eu, you would create an A record for hackthebox.eu and a CNAME record for www.hackthebox.eu.|
|`PTR`|The PTR record works the other way around (reverse lookup). It converts IP addresses into valid domain names.|
|`SOA`|Provides information about the corresponding DNS zone and email address of the administrative contact.|

The `SOA` record is located in a domain's zone file and specifies who is responsible for the operation of the domain and how DNS information for the domain is managed.

```shell
dig soa www.inlanefreight.com
```

### DNS Default Configuration - Notes

**Types of DNS Configuration Files**

1. **Local DNS Configuration Files**
    
    - Basic settings and options for the DNS server.
2. **Zone Files**
    
    - Define specific domains and their DNS records.
3. **Reverse Name Resolution Files**
    
    - Used for mapping IP addresses back to domain names.

**Common DNS Server (Bind9 on Linux)**

- **Bind9** is widely used for DNS on Linux distributions.
- Main configuration file: `named.conf`

**Key Configuration Files for Bind9**

1. `named.conf.local` - Holds local domain-specific configurations.
2. `named.conf.options` - Contains global settings that apply to all zones.
3. `named.conf.log` - Manages logging settings for the DNS server.

**Configuration File Structure**

- `named.conf` has two main sections:
    - **Options Section**: Contains **global settings** affecting the entire server.
    - **Zone Entries Section**: Defines settings for individual **zones/domains**.

**Types of Options in `named.conf`**

- **Global Options**: Apply server-wide, across all zones.
- **Zone Options**: Specific to individual zones; override global options if both are set.

**Notes**

- Unspecified options use **default values**.
- **Zone-specific options** take **priority** over global options when both are present.
```shell
cat /etc/bind/named.conf.local
```
![[Pasted image 20241108094650.png]]

### Purpose of `named.conf.local`

- **Defines Local Zones**: This file tells the DNS server which **domains** (zones) it is responsible for on the local network.
- **Sets Up Forward and Reverse Zones**: It often contains entries for **forward zones** (mapping domain names to IP addresses) and **reverse zones** (mapping IP addresses back to domain names).

### Typical Content of `named.conf.local`

In this file, you’ll usually find:

- **Zone Definitions**: Each zone definition specifies details about a domain, including its **file path** for the zone data (like `zone "example.com" { ... }`).
- **Forward Zones**: Defines domains for which the server will provide name-to-IP mappings.
- **Reverse Zones**: Defines IP address ranges for which the server will provide IP-to-name mappings.

### Example Content

```bash
zone "example.com" {
	type master;
	file "/etc/bind/zones/db.example.com"; 
	};  
	
zone "1.168.192.in-addr.arpa" {
	type master;
	file "/etc/bind/zones/db.192.168.1"; 

};
```

- **Forward Zone (`example.com`)**: Maps names (like `www.example.com`) to IPs.
- **Reverse Zone (`1.168.192.in-addr.arpa`)**: Maps IPs (like `192.168.1.1`) back to domain names.
### Summary

`named.conf.local` is where you tell the Bind9 DNS server about **specific domains it should manage** and where to find each domain’s data file. It helps the server resolve **local domain names** and can include both **forward and reverse DNS entries**.
https://wiki.debian.org/Bind9

```shell
sudo apt install bind9

#Zone File
cat /etc/bind/db.domain.com

# Reverse name resolution zone file
cat /etc/bind/db.<IP>
```

![[Pasted image 20241108094909.png]]


### Dangerous Settings
DNS servers are prone to vulnerabilities if not properly configured, as certain settings can unintentionally expose the server to attacks. Administrators may prioritize functionality over security, leading to misconfiguration. 


#### Key Vulnerable Settings

1. **allow-query**
    
    - Specifies which hosts can send requests to the DNS server.
    - Misconfiguration can allow unauthorized users to access DNS data.
    
1. **allow-recursion**
    - Defines which hosts can make recursive queries to the DNS server.
    - If too permissive, it allows attackers to use the server to amplify DDoS attacks.
    
1. **allow-transfer**
    - Specifies which hosts can perform zone transfers from the DNS server.
    - Misconfiguration allows attackers to retrieve zone data, exposing internal network information.
    
1. **zone-statistics**
    - Collects and reports statistical data about DNS zones.
    - Data collection can be useful for administrators but might expose sensitive information if accessed by unauthorized parties.

### Footprinting the DNS Service

- **Purpose**: Footprinting helps attackers gather information about the DNS infrastructure.
- **Techniques**:
    - **NS Record Query**: Use `NS` records to identify other name servers associated with the DNS server.
    - **@ Character in Queries**: Specify a DNS server for querying records, which can uncover differently configured servers, providing varied access to data across zones.

> **Summary**: Misconfigured DNS settings like `allow-query`, `allow-recursion`, and `allow-transfer` create vulnerabilities. Footprinting techniques help attackers gather data on DNS servers, identifying possible weak points for further exploitation.

#### DIG - NS Query
```shell
dig ns inlanefreight.htb @<ip>
```

Sometimes it possible to query a DNS server's version using a class `CHAOS` query and type `txt`
```shell
dig CH TXT version.bind <ip>
```

We can use `any` option to view all available records. not all entries from the zone will be shown.
```bash
dig any inlanefreight.htb @<ip>
```

### Zone Transfer (AXFR) Notes

Zone transfers are a critical process in DNS management, ensuring consistent data across DNS servers. They typically occur over **TCP port 53** and are formally known as **Asynchronous Full Transfer Zone (AXFR)**.

#### Key Components and Terms

1. **Purpose of Zone Transfer**:
    
    - Ensures DNS consistency across multiple servers.
    - Reduces the risk of service disruptions by having the same DNS data available on multiple servers.
2. **Types of DNS Servers**:
    
    - **Primary Name Server (Master)**:
        - Holds the original zone data.
        - Manages all updates to DNS entries (additions, modifications, deletions).
    - **Secondary Name Server (Slave)**:
        - Acts as a backup, obtaining data from the master to enhance reliability.
        - Helps in load balancing and protects the primary server from potential attacks.
    - **TLD Requirement**: For some Top-Level Domains, DNS zones must be accessible from at least two servers for redundancy.
3. **How Zone Transfer Works**:
    
    - **SOA Record (Start of Authority)**:
        - The SOA record includes a **serial number** that tracks updates.
    - **Serial Number Comparison**:
        - The slave server periodically checks the master’s SOA serial number to ensure it has the latest data.
        - If the master’s serial number is higher, the slave updates its records accordingly.
4. **Security with rndc-key**:
    
    - **rndc-key** is used to secure communication between master and slave, ensuring that only trusted servers participate in zone transfers.

> **Summary**: Zone transfers allow primary and secondary DNS servers to synchronize, maintaining data consistency and network reliability. The SOA record's serial number helps detect updates, while the **rndc-key** secures the transfer process.

```bash
dig axfr inlanefreight.htb @<ip>
```
![[Pasted image 20241108101325.png]]

If the admin used a subnet for the `allow-transfer` option for testing purposes or as a workaround solution or set it to `any` everyone would query the entire zone file at the DNS server.

#### DIG - AXFR Zone Transfer - Internal
```shell
dig axfr internal.inlanefreight.htb @10.129.14.128
```


### Brute-Forcing DNS A Records with a Hostname List

A brute-force attack on DNS A records helps identify individual hosts within a domain by trying out various hostnames. Here’s a breakdown of how this works:

#### Steps for DNS Brute-Forcing with A Records

1. **Hostname List**:
    
    - To perform a brute-force attack, you need a list of potential subdomains or hostnames, such as `www`, `mail`, `ftp`, etc.
    - **SecLists**: This tool offers pre-made lists of common hostnames which can be used for such purposes.
2. **For-Loop in Bash**:
    
    - Using a simple loop in Bash, you can iterate over each hostname in the list and perform a DNS query.
    - This can be done with commands like `dig` or `host` to check if the hostname has an associated A record (IP address).

#### Sample Bash Script

Here’s an example of a script that uses `dig` to query each hostname in the list against a specified DNS server:
```bash
#!/bin/bash

# Specify the target domain and DNS server
domain="example.com"
dns_server="8.8.8.8"  # Optional, specify DNS server or remove for default

# Loop through the hostname list (from SecLists or other source)
for hostname in $(cat hostnames.txt); do
    # Query the DNS server for each hostname
    result=$(dig @$dns_server +short "$hostname.$domain")
    
    # Check if there was an A record returned
    if [[ -n "$result" ]]; then
        echo "$hostname.$domain has IP: $result"
    fi
done

```
#### Explanation of the Script

- **hostname**: The loop reads each hostname from `hostnames.txt`.
- **dig command**: Sends a DNS query for each hostname combined with the domain (e.g., `ftp.example.com`) and checks for an IP address (A record).
- **Output**: If an A record is found, it prints the hostname and its IP address.

#### Usefulness for Penetration Testers

- **Discover Subdomains**: Reveals hidden or internal hosts that might not be publicly known.
- **Attack Surface Expansion**: Identifies additional points for reconnaissance or potential entry points within a target domain.
# OR
```bash
for sub in $(cat /opt/useful/seclists/Discovery/DNS/subdomains-top1million-110000.txt); do
    dig $sub.inlanefreight.htb @10.129.14.128 | grep -v ';\|SOA' | sed -r '/^\s*$/d' | grep $sub | tee -a subdomains.txt
done

```

- **File of Subdomains**: `cat /opt/useful/seclists/Discovery/DNS/subdomains-top1million-110000.txt`
    
    - Reads a list of potential subdomains from a SecLists file. This list is used to test various subdomains against the DNS server.
- **Loop through Each Subdomain**:
    
    - `for sub in $(cat ...); do ... done`
    - For each `sub` (subdomain) in the list, the loop:
        - Executes `dig` to query for an A record of each subdomain (like `ftp.inlanefreight.htb`).
        - Uses the DNS server at `10.129.14.128` for the query.
- **Filtering and Formatting**:
    
    - `grep -v ';\|SOA'`: Excludes lines with semicolons (metadata) and SOA records from the `dig` output.
    - `sed -r '/^\s*$/d'`: Removes any blank lines.
    - `grep $sub`: Filters for lines that contain the queried subdomain name to show only relevant results.
- **Output to File**:
    
    - `tee -a subdomains.txt`: Appends the final results to `subdomains.txt`, allowing you to keep a log of all resolved subdomains.

### Summary of Differences from the Original Script

- This loop has additional filters (e.g., `grep` and `sed`) to make the output cleaner by removing extraneous information and focusing on valid subdomains.
- The use of `tee -a` appends results to `subdomains.txt`, keeping a persistent record of found subdomains without needing to redirect output separately.

###  In Summary
>Both loops perform DNS queries on a list of potential subdomains, but this version includes extra filtering for cleaner output and saves results directly to a file. This is a useful addition for penetration testers, allowing for easier identification of valid subdomains in a target domain.

Many different tools can be used for this and most of them work in the same way. one of these examples [[DNSenum]]

https://github.com/realCheesyQuesadilla/HTBPenTest/blob/main/Footprinting