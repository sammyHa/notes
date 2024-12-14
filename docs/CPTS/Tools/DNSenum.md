---
title: DNSenum
date: 2024-10-30
tags: 
techniques: 
tools:
  - dnsenum
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

```bash
dnsenum --dnsserver 10.129.14.128 --enum -p 0 -s 0 -o subdomains.txt -f /opt/useful/seclists/Discovery/DNS/subdomains-top1million-110000.txt inlanefreight.htb
```

### **dnsenum - DNS Enumeration Tool**

**Objective**:  
`dnsenum` is used for gathering DNS information such as subdomains, IP addresses, and other DNS-related information about a target domain.

#### **Basic Command**

```shell
dnsenum <domain>
```

- **Purpose**: Performs basic DNS enumeration on the given domain.
- **Example**:
```shell
dnsenum example.com
```

#### **Options and Commands**

- **`-r`**: Reverse DNS lookup
    
    - **Purpose**: Get a list of IPs that reverse resolve to the target domain.
    - **Command**:
    
    bash
    
    Copy code
    
    `dnsenum -r <domain>`
    
- **`-f`**: Use a wordlist for subdomain brute force
    
    - **Purpose**: Attempt subdomain enumeration using a wordlist (default is `/usr/share/wordlists/dnsenum.txt`).
    - **Command**:
    
    bash
    
    Copy code
    
    `dnsenum -f /path/to/wordlist.txt <domain>`
    
- **`-s`**: Specify nameservers
    
    - **Purpose**: Set custom nameservers for DNS queries.
    - **Command**:
    
    bash
    
    Copy code
    
    `dnsenum -s <nameserver> <domain>`
    
- **`-t`**: Enable trace route
    
    - **Purpose**: Perform a trace route to the target domain to find intermediary hops.
    - **Command**:
    
    bash
    
    Copy code
    
    `dnsenum -t <domain>`
    
- **`-v`**: Verbose output
    
    - **Purpose**: Provides more detailed output. Useful for debugging and understanding the process.
    - **Command**:
    
    ```bash
	dnsenum -v <domain>
	```
    
- **`-p`**: Perform a zone transfer
    
    - **Purpose**: Attempt a DNS zone transfer to gather all records from a DNS server.
    - **Command**:
    
    ```bash
dnsenum -p <domain>
```
    
- **`-i`**: IP range for brute force
    
    - **Purpose**: Specify an IP range for reverse DNS lookup brute-forcing.
    - **Command**:
    
    ```bash
dnsenum -i 192.168.0.0/24 <domain>
```
    

#### **Example Command Breakdown**

```bash
dnsenum -r -f /usr/share/wordlists/dnsenum.txt -v example.com
```

- **`-r`**: Perform reverse DNS lookup.
- **`-f /usr/share/wordlists/dnsenum.txt`**: Use the specified wordlist for subdomain enumeration.
- **`-v`**: Enable verbose output.
- **`example.com`**: The target domain for enumeration.

#### **Common Output and Results**

- **Subdomain Enumeration**: A list of discovered subdomains based on DNS records and brute-forcing.
- **NS Lookup**: Nameserver information, including authoritative DNS servers.
- **MX Records**: Mail exchange servers associated with the domain.
- **Zone Transfers**: If successful, a complete list of DNS records for the domain.
- **PTR Records**: Reverse DNS lookup for any IPs.

#### **DNS Record Types to Be Aware Of**

- **A**: IPv4 address for a hostname.
- **AAAA**: IPv6 address for a hostname.
- **MX**: Mail exchange server.
- **NS**: Name servers for the domain.
- **PTR**: Reverse lookup (for IP address).
- **TXT**: Text records, often used for verification and SPF records.

#### **Use Cases for OSCP**

- **Subdomain Enumeration**: Discover hidden subdomains that could be vulnerable.
- **Reverse DNS Lookup**: Find IP addresses associated with a target domain and cross-reference with other tools (e.g., Shodan).
- **Zone Transfers**: If a DNS server is misconfigured, a zone transfer can provide a comprehensive list of domain records.

---

**Key Takeaways**

- **dnsenum** is an essential tool for DNS enumeration in penetration testing.
- Familiarize yourself with the various flags and their use cases.
- Use the results to gather useful information for further exploitation or information gathering.

Keep these notes handy for your OSCP preparations, and practice running the tool on various targets to become more comfortable with its outputs.

### **Advanced dnsenum Commands**

#### **1. Brute Force with Custom Wordlist**

- **Objective**: Perform aggressive subdomain enumeration using a custom wordlist.
- **Command**:
    
    ```bash
dnsenum -f /path/to/custom_wordlist.txt -v <domain>
```
    
    - **Details**: Use a custom wordlist to find hidden subdomains. The `-v` flag adds verbosity to see more details during enumeration.

#### **2. Zone Transfer with Specific Nameserver**

- **Objective**: Attempt DNS zone transfer with a specific DNS server (if the server is misconfigured).
- **Command**:
    
    
    ```bash
    dnsenum -p -s <nameserver> <domain>
```
    - **Details**: Specify the nameserver to try for zone transfers. If the DNS server is misconfigured, a zone transfer could provide all DNS records.

#### **3. DNS Record and Reverse Lookup**

- **Objective**: Retrieve a variety of DNS records (A, MX, NS, TXT, etc.) for further exploration, combined with reverse lookup for IPs.
- **Command**:
    
    
    `dnsenum -r -v -t -s <nameserver> <domain>`
    
    - **Details**:
        - `-r` performs reverse DNS lookups.
        - `-t` includes trace route information to see the path DNS queries take.
        - `-v` enables verbose output for in-depth analysis.
        - `-s <nameserver>` allows specifying a particular DNS server.

#### **4. Brute Force Reverse DNS Lookup for IP Range**

- **Objective**: Enumerate reverse DNS records for an entire range of IP addresses (useful for large networks).
- **Command**:
    
    `dnsenum -i 192.168.1.0/24 <domain>`
    
    - **Details**: The `-i` option will brute-force through the specified IP range to perform reverse lookups on IP addresses within that range.

#### **5. DNS Query for Specific Record Types**

- **Objective**: Query specific types of DNS records (e.g., only MX records or A records).
- **Command**:
    
    
    `dnsenum -t mx -v <domain>`
    
    - **Details**: Query and list only MX records (Mail Exchange). You can replace `mx` with `a`, `ns`, `txt`, etc., for specific record types.

#### **6. Subdomain Enumeration with WHOIS Integration**

- **Objective**: Attempt subdomain enumeration with WHOIS integration to discover additional subdomains and associated information.
- **Command**:
    
    `dnsenum --whois -v <domain>`
    
    - **Details**: This will attempt subdomain enumeration while integrating WHOIS data for better insight into the domain registration and ownership.

#### **7. DNS Trace Route with Specific Nameserver**

- **Objective**: Perform a DNS trace route from a specific nameserver to understand the full path of the DNS query.
- **Command**:
    
    
    `dnsenum -t -s <nameserver> <domain>`
    
    - **Details**: The `-t` option will trace the DNS query path from the nameserver you specify to the target domain.

#### **8. Retrieve DNS Records for Multiple Domains**

- **Objective**: Perform DNS enumeration across multiple domains using a file with a list of domains.
- **Command**:
    
    
    `dnsenum -f /path/to/domains.txt -v`
    
    - **Details**: Enumerate DNS information for all domains listed in the `domains.txt` file. This can be useful for scanning multiple targets at once.

#### **9. Use DNS Cache Snooping**

- **Objective**: Check if a DNS server has cached records for a domain, revealing whether the server has looked up the domain recently.
- **Command**:
    
    
    `dnsenum --cache-snooping -v <domain>`
    
    - **Details**: This command attempts to snoop on the DNS cache of the specified server, revealing previously queried domains or records.

#### **10. Brute Force with Reverse DNS Range**

- **Objective**: Brute-force a range of reverse DNS entries (useful for testing entire subnets or IP ranges for PTR records).
- **Command**:
    
    
    `dnsenum -r -i 10.0.0.0/24 <domain>`
    
    - **Details**: `-r` attempts reverse DNS lookups, and `-i` brute-forces the given IP range. This is helpful for large subnets or targeting entire address spaces.