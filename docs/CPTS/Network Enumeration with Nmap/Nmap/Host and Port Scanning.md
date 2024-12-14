---
title: Host and Port Scanning
date: 2024-10-23
tags:
  - "#oscp"
  - "#technique"
  - "#exploitation"
techniques:
  - ""
  - ""
tools:
  - nmap
machines: 
difficulty:
  - ""
status:
  - Completed
type: ""
os: 
categories:
  - ""
exam-priority:
  - medium
time-invested: "2"
notes: |
  Key points and takeaways from the exercise.
---

### References
- [Example Tutorial](https://example.com/tutorial)
- [OSCP Exploit Documentation](https://documentation.oscp.org/exploitations)


Understanding how scanning tools work is essential to interpreting results and identifying system vulnerabilities. When scanning a system, the goal is to gather key information such as:

- Open ports and their services
- Service versions
- Data provided by these services
- Operating system details

---

### **Port States in Nmap**

Nmap identifies six possible port states during scans:

1. **Open**: A connection to the port is established (e.g., TCP, UDP, SCTP).
2. **Closed**: The TCP packet received contains an RST flag, indicating that the port is closed. This can also help determine if a target is alive.
3. **Filtered**: Nmap cannot determine whether the port is open or closed due to no response or receiving an error code.
4. **Unfiltered**: Only occurs in TCP-ACK scans. The port is accessible, but its open/closed state cannot be determined.
5. **Open|Filtered**: The port is not responding, potentially due to firewall or packet filtering.
6. **Closed|Filtered**: Occurs in IP ID idle scans, indicating Nmap could not determine the port’s status.

---

### **Discovering Open TCP Ports**

- **Default Behavior**: Nmap scans the top 1000 TCP ports using a SYN scan (`sS`) if run as root. Otherwise, it uses a TCP connect scan (`sT`).
- **Port Selection**: Ports can be scanned individually (e.g., `p 22,25,80`), by range (`p 22-445`), or using top frequent ports (`-top-ports=10`).
- **Fast Scanning**: Scans can be performed quickly using the top 100 ports (`F`).

---

### **SYN Scan (Stealth Scan)**

- **Packet Tracing Example**:
    - A packet with the SYN flag is sent from our machine, and the target responds with an RST and ACK flags if the port is closed.
    - This method allows for faster and stealthier scanning.
    - Options used: `Pn` (disable ICMP), `n` (disable DNS resolution), and `-disable-arp-ping`.

---

### **Connect Scan (Full TCP Handshake)**

- **Process**: Nmap uses the TCP three-way handshake to determine if a port is open. If the port responds with SYN-ACK, it is open. If it responds with RST, it is closed.
- **Advantages**:
    - More accurate since it completes the full handshake.
    - Useful when interacting cleanly with services, especially when outgoing connections bypass firewalls.
- **Disadvantages**:
    - Not stealthy, as it fully establishes connections, which are easily logged by firewalls and IDS/IPS systems.

---

### **Filtered Ports**

When ports are **filtered**, Nmap doesn't receive responses from the target, often due to firewalls or packet filters. It retries the packet several times (by default, 10 retries). Example scenarios include:

- **Dropped packets**: No response, leading Nmap to label the port as filtered.
- **Rejected packets**: The target returns an ICMP unreachable message (type 3/code 3), indicating the port is blocked by a firewall.

---

### **Discovering Open UDP Ports**

- **UDP Scans**:
    - UDP scans (`sU`) do not involve a three-way handshake and are slower compared to TCP scans.
    - UDP is a stateless protocol, and timeouts make scanning slower since no acknowledgments are received from the target.

---

### **Example Scanning Techniques**

- **Scanning top 10 TCP ports:**
    
    ```bash
   sudo nmap 10.129.2.28 --top-ports=10
    
    ```
    
    Output includes information about the state of the most frequent ports (e.g., SSH, HTTP).
    
- **Packet tracing SYN scan:**
    
    ```bash
   sudo nmap 10.129.2.28 -p 21 --packet-trace -Pn -n --disable-arp-ping
    
    ```
    
    This shows SYN flags being sent to the target, and the RST/ACK response when the port is closed.
    
- **Connect scan on TCP port 443:**
    
    ```bash
   sudo nmap 10.129.2.28 -p 443 --packet-trace --disable-arp- ping -Pn -n --reason -sT
    
    ```
    
    Shows the three-way handshake used to establish if port 443 is open (HTTPS).
    
- **UDP scan example:**
    
    ```bash
   sudo nmap 10.129.2.28 -F -sU
    
    ```
    
    This performs a fast UDP scan and can reveal open UDP ports on the target.
    

---

### **Key Nmap Options Used in Examples**

- **sS**: SYN scan (stealth).
- **sT**: TCP connect scan (full handshake).
- **p**: Specify port(s) to scan.
- **Pn**: Disable ICMP echo requests (assumes host is up).
- **n**: Disable DNS resolution.
- **-packet-trace**: Show packets sent/received.
- **-disable-arp-ping**: Disable ARP ping.

---

### **Nmap Host Discovery**

Nmap offers various techniques for host discovery. This helps in determining which hosts are up before scanning ports and services.

1. **ICMP Echo Request (`ping`)**:
    
    - Default host discovery method.
    - Sends an ICMP Echo Request to the target; if it responds, the host is considered alive.
    - Some networks block ICMP, making this less reliable in certain environments.
    
    Example:
    
    ```bash
    bash
    Copy code
    nmap -sn 10.129.2.28
    
    ```
    
2. **TCP SYN Ping**:
    
    - Sends a SYN packet to a port (commonly port 443) to determine if the host is alive.
    - Often used when ICMP is blocked, as many firewalls still allow outbound TCP connections.
    
    Example:
    
    ```bash
    bash
    Copy code
    nmap -PS443 10.129.2.28
    
    ```
    
3. **TCP ACK Ping**:
    
    - Sends a TCP packet with the ACK flag set.
    - Used to check if the host responds with RST (a sign that the host is alive).
    
    Example:
    
    ```bash
    bash
    Copy code
    nmap -PA80,443 10.129.2.28
    
    ```
    
4. **UDP Ping**:
    
    - Sends an empty UDP packet to a specified port. If an ICMP Port Unreachable message (type 3, code 3) is received, the host is considered alive.
    
    Example:
    
    ```bash
    bash
    Copy code
    nmap -PU53,123 10.129.2.28
    
    ```
    
5. **ARP Ping**:
    
    - For local networks, ARP requests are used to detect active devices.
    - This technique is extremely reliable for detecting devices on a local subnet since ARP is not typically filtered.
    
    Example:
    
    ```bash
    bash
    Copy code
    nmap -PR 10.129.2.0/24
    
    ```
    
6. **Disabling Ping (`Pn`)**:
    
    - Assumes the host is up without checking for any response, often used when ICMP is blocked entirely.
    
    Example:
    
    ```bash
    bash
    Copy code
    nmap -Pn 10.129.2.28
    
    ```
    

---

### **Service Version Detection**

Once open ports are identified, the next step is determining the services running behind those ports and their versions. Nmap provides detailed service and version information with the `-sV` option.

- **Service Version Detection (`sV`)**: This feature attempts to determine:
    
    - The name of the application listening on a port.
    - The version of the software.
    - Sometimes the OS type (especially for web servers).
    
    Example:
    
    ```bash
    sudo nmap -sV 10.129.2.28
    
    ```
    
    Output:
    
    ```
    plaintext
    Copy code
    PORT   STATE SERVICE VERSION
    22/tcp open  ssh     OpenSSH 7.6p1 Ubuntu 4ubuntu0.7 (Ubuntu Linux; protocol 2.0)
    80/tcp open  http    Apache httpd 2.4.29 ((Ubuntu))
    
    ```
    
- **Version Intensity (`-version-intensity`)**:
    
    - Nmap tries different techniques to identify services, ranging from basic to aggressive.
    - The intensity level can be adjusted (default is 7). A lower intensity can be faster but might not capture as much detail.
    
    Example:
    
    ```bash
    bash
    Copy code
    sudo nmap --version-intensity 9 10.129.2.28
    
    ```
    

---

### **Operating System (OS) Detection**

Nmap attempts to determine the target’s operating system based on various network-level responses.

- **OS Detection (`O`)**: This enables OS detection based on the characteristics of the responses received (e.g., TCP/IP stack fingerprinting).
    
    - Nmap compares response details like TCP window size, TTL, and specific packet behaviors to a known database of OS signatures.
    
    Example:
    
    ```bash
    bash
    Copy code
    sudo nmap -O 10.129.2.28
    
    ```
    
- **Aggressive Scanning (`A`)**:
    
    - The `A` option includes OS detection, version detection, script scanning, and traceroute in a single command.
    
    Example:
    
    ```bash
    bash
    Copy code
    sudo nmap -A 10.129.2.28
    
    ```
    
    This command will provide detailed information about the target’s services, versions, and operating system.
    

---

### **Script Scanning with Nmap (NSE)**

Nmap's Scripting Engine (NSE) allows users to run specific scripts to perform advanced service detection, vulnerability detection, and exploitation.

1. **Default Scripts**:
    
    - Running Nmap with the `sC` option executes a set of default NSE scripts.
    
    Example:
    
    ```bash
    bash
    Copy code
    sudo nmap -sC 10.129.2.28
    
    ```
    
2. **Specifying a Script**:
    
    - You can use a specific script or category of scripts to further probe services or vulnerabilities.
    - For example, to run the `http-enum` script, which enumerates common directories and files on web servers:
    
    Example:
    
    ```bash
    bash
    Copy code
    sudo nmap --script http-enum 10.129.2.28
    
    ```
    
3. **Using Vulnerability Scripts**:
    
    - Nmap provides several scripts specifically for vulnerability detection.
    - For example, to check if a web server is vulnerable to Heartbleed, you can use the following script:
    
    Example:
    
    ```bash
    bash
    Copy code
    sudo nmap --script ssl-heartbleed 10.129.2.28
    
    ```
    
4. **Script Categories**:
    
    - Nmap scripts are organized into categories such as `auth`, `vuln`, `discovery`, etc. You can scan with a particular category, for instance:
    
    Example:
    
    ```bash
    bash
    Copy code
    sudo nmap --script vuln 10.129.2.28
    
    ```
    

---

### **Nmap Timing and Performance Options**

When scanning large networks or when stealth is not a concern, optimizing Nmap's performance is essential. Nmap provides several options to control timing and performance:

- **Timing Templates (`T`)**:
    
    - Nmap provides six timing templates (`T0` to `T5`) to adjust the speed and aggressiveness of a scan.
    - `T4` is often a good balance between speed and reliability.
    - `T5` is the most aggressive but may miss information due to packet loss.
    
    Example:
    
    ```bash
    bash
    Copy code
    sudo nmap -T4 10.129.2.28
    
    ```
    
- **Max Parallelism (`-min-parallelism` and `-max-parallelism`)**:
    
    - These options control the number of probes Nmap sends at the same time.
    - Higher parallelism increases scan speed but can overwhelm network resources or be blocked by firewalls.
    
    Example:
    
    ```bash
    bash
    Copy code
    sudo nmap --min-parallelism 10 --max-parallelism 100 10.129.2.28
    
    ```
    

---

This comprehensive coverage of host and port scanning, service and version detection, operating system identification, and advanced scripting illustrates how powerful Nmap is for vulnerability assessment and network discovery. Each technique has its place depending on the network and services being targeted.

**Next** [[Saving the Result]]
