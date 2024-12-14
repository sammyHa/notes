---
title: Nmap Host Discovery
date: 2024-10-23
tags:
  - "#oscp"
  - "#technique"
  - "#exploitation"
techniques:
  - ""
  - ""
tools:
  - ""
  - ""
machines: ""
difficulty:
  - ""
status:
  - in-progress
type: ""
os: ""
categories:
  - ""
exam-priority:
  - medium
time-invested: ""
notes: |
  Key points and takeaways from the exercise.
---


### References
- [Example Tutorial](https://example.com/tutorial)
- [OSCP Exploit Documentation](https://documentation.oscp.org/exploitations)

**Introduction to Nmap Host Discovery**

Host discovery is crucial in identifying systems that are online and can be tested in a network during penetration testing. Nmap provides various techniques to perform host discovery effectively. This process helps determine which systems are live and ready for further security assessment. Here's a detailed breakdown of Nmap's commands and scanning options used for host discovery.

---

### **Scan Network Range**

**Command:**

```bash
sudo nmap 10.129.2.0/24 -sn -oA tnet | grep for | cut -d" " -f5

```

- **Description**: Scans an entire network range (e.g., `/24`) for live hosts without performing port scans.
- **Options:**
    - `10.129.2.0/24`: The network range to scan.
    - `sn`: Disables port scanning; only checks if hosts are up.
    - `oA tnet`: Stores results in all formats starting with the prefix 'tnet'.

---

### **Scan IP List**

**Command:**

```bash
sudo nmap -sn -oA tnet -iL hosts.lst | grep for | cut -d" " -f5

```

- **Description**: Scans hosts from a predefined list.
- **Options:**
    - `iL hosts.lst`: Reads a list of target hosts from `hosts.lst`.
    - `oA tnet`: Stores the results in multiple formats starting with 'tnet'.
    - `sn`: Disables port scanning.

---

### **Scan Multiple IPs**

**Command:**

```bash
sudo nmap -sn -oA tnet 10.129.2.18 10.129.2.19 10.129.2.20 | grep for | cut -d" " -f5

```

- **Description**: Scans specific IP addresses without performing port scanning.
- **Options**:
    - Multiple IP addresses (e.g., `10.129.2.18 10.129.2.19 10.129.2.20`): Specifies multiple targets.
    - `sn`: Disables port scanning.

**Alternatively**, you can scan a range of IPs:

```bash
sudo nmap -sn -oA tnet 10.129.2.18-20 | grep for | cut -d" " -f5

```

---

### **Scan a Single IP**

**Command:**

```bash
sudo nmap 10.129.2.18 -sn -oA host

```

- **Description**: Scans a single host to check if it is online.
- **Options**:
    - `10.129.2.18`: The target IP address.
    - `sn`: Disables port scanning.
    - `oA host`: Stores results starting with the prefix 'host'.

---

### **Enable ICMP Echo Requests**

Nmap uses ARP requests by default for host discovery. To force ICMP Echo requests, use the `-PE` option.

**Command:**

```bash
sudo nmap 10.129.2.18 -sn -oA host -PE --packet-trace

```

- **Options**:
    - `PE`: Performs ICMP Echo request (ping) to check if a host is alive.
    - `-packet-trace`: Displays all packets sent and received for analysis.

---

### **View the Reason for Host Detection**

You can use the `--reason` option to check why a host is marked as alive.

**Command:**

```bash
sudo nmap 10.129.2.18 -sn -oA host -PE --reason

```

- **Option**:
    - `-reason`: Displays the reason why the host is detected as alive.

---

### **Disable ARP Pings**

To disable ARP pings and rely solely on ICMP Echo requests:

**Command:**

```bash
sudo nmap 10.129.2.18 -sn -oA host -PE --packet-trace --disable-arp-ping

```

- **Option**:
    - `-disable-arp-ping`: Prevents Nmap from sending ARP pings, using ICMP Echo requests instead.

---

### **TTL and OS Detection**

In the example below, you can analyze the TTL (Time to Live) value to infer the target OS.

**Example:**

```bash
SENT (0.0107s) ICMP [10.10.14.2 > 10.129.2.18 Echo request (type=8/code=0)]
RCVD (0.0152s) ICMP [10.129.2.18 > 10.10.14.2 Echo reply (type=0/code=0)] IP [ttl=128]

```

- **TTL = 128**: Likely indicates a **Windows** operating system.

---

### Additional Resources

For more advanced host discovery strategies, visit the Nmap book: [https://nmap.org/book/host-discovery-strategies.html](https://nmap.org/book/host-discovery-strategies.html)

---

By mastering these Nmap commands and techniques, you'll be well-equipped to conduct thorough host discovery for penetration testing and network auditing purposes.

**Next** [[Host and Port Scanning]]
