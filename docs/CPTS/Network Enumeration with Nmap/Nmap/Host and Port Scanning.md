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

- **Default Behavior**: Nmap scans the top 1000 TCP ports using a SYN scan (`-sS`) if run as root. Otherwise, it uses a TCP connect scan (`-sT`).
- **Port Selection**: Ports can be scanned individually (e.g., `-p 22,25,80`), by range (`-p 22-445`), or using top frequent ports (`--top-ports=10`).
- **Fast Scanning**: Scans can be performed quickly using the top 100 ports (`-F`).

---

### **SYN Scan (Stealth Scan)**

- **Packet Tracing Example**:
    - A packet with the SYN flag is sent from our machine, and the target responds with RST and ACK flags if the port is closed.
    - This method allows for faster and stealthier scanning.
    - Options used: `-Pn` (disable ICMP), `-n` (disable DNS resolution), and `--disable-arp-ping`.

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
    - UDP scans (`-sU`) do not involve a three-way handshake and are slower compared to TCP scans.
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
    sudo nmap 10.129.2.28 -p 443 --packet-trace --disable-arp-ping -Pn -n --reason -sT
    ```
    Shows the three-way handshake used to establish if port 443 is open (HTTPS).

- **UDP scan example:**
    ```bash
    sudo nmap 10.129.2.28 -F -sU
    ```
    This performs a fast UDP scan and can reveal open UDP ports on the target.

---

### **Key Nmap Options Used in Examples**

- `-sS`: SYN scan (stealth).
- `-sT`: TCP connect scan (full handshake).
- `-p`: Specify port(s) to scan.
- `-Pn`: Disable ICMP echo requests (assumes host is up).
- `-n`: Disable DNS resolution.
- `--packet-trace`: Show packets sent/received.
- `--disable-arp-ping`: Disable ARP ping.

---

### **Nmap Host Discovery**

Nmap offers various techniques for host discovery. This helps in determining which hosts are up before scanning ports and services.

1. **ICMP Echo Request (`ping`)**:
    ```bash
    nmap -sn 10.129.2.28
    ```

2. **TCP SYN Ping**:
    ```bash
    nmap -PS443 10.129.2.28
    ```

3. **TCP ACK Ping**:
    ```bash
    nmap -PA80,443 10.129.2.28
    ```

4. **UDP Ping**:
    ```bash
    nmap -PU53,123 10.129.2.28
    ```

5. **ARP Ping**:
    ```bash
    nmap -PR 10.129.2.0/24
    ```

6. **Disabling Ping (`-Pn`)**:
    ```bash
    nmap -Pn 10.129.2.28
    ```

---

### **Service Version Detection**

- **Service Version Detection (`-sV`)**:
    ```bash
    sudo nmap -sV 10.129.2.28
    ```

- **Version Intensity (`--version-intensity`)**:
    ```bash
    sudo nmap --version-intensity 9 10.129.2.28
    ```

---

### **Operating System (OS) Detection**

- **OS Detection (`-O`)**:
    ```bash
    sudo nmap -O 10.129.2.28
    ```

- **Aggressive Scanning (`-A`)**:
    ```bash
    sudo nmap -A 10.129.2.28
    ```

---

### **Script Scanning with Nmap (NSE)**

1. **Default Scripts**:
    ```bash
    sudo nmap -sC 10.129.2.28
    ```

2. **Specifying a Script**:
    ```bash
    sudo nmap --script http-enum 10.129.2.28
    ```

3. **Using Vulnerability Scripts**:
    ```bash
    sudo nmap --script ssl-heartbleed 10.129.2.28
    ```

4. **Script Categories**:
    ```bash
    sudo nmap --script vuln 10.129.2.28
    ```

---

### **Nmap Timing and Performance Options**

- **Timing Templates (`-T`)**:
    ```bash
    sudo nmap -T4 10.129.2.28
    ```

- **Max Parallelism (`--min-parallelism` and `--max-parallelism`)**:
    ```bash
    sudo nmap --min-parallelism 10 --max-parallelism 100 10.129.2.28
    ```

---

This comprehensive coverage of host and port scanning, service and version detection, operating system identification, and advanced scripting illustrates how powerful Nmap is for vulnerability assessment and network discovery.
