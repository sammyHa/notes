**Overview**

- **Network Mapper (Nmap)**: Open-source network analysis tool for network scanning, written in C, C++, Python, and Lua.
- **Key Purpose**: Scans networks to identify hosts, services, applications, versions, operating systems, and security defenses like firewalls and IDS.

---

**Nmap Use Cases**

- **Security Auditing**: Check network security, firewall, and IDS settings.
- **Penetration Testing**: Simulate attacks to find vulnerabilities.
- **Network Mapping**: Understand the structure of the network, identify devices, and open ports.
- **Response Analysis**: Analyze how devices and services respond to probing.

---

**Nmap Architecture**

Nmap's core functionalities can be broken down into the following techniques:

1. **Host Discovery**: Identify live hosts on a network.
2. **Port Scanning**: Check open/closed/filtered ports.
3. **Service Enumeration & Detection**: Identify running services and versions.
4. **OS Detection**: Discover the operating system and version on the target machine.
5. **Nmap Scripting Engine (NSE)**: Automate advanced interaction and service scanning with scripts.

---

### **Nmap Syntax**

Basic command structure:

```bash
nmap <scan types> <options> <target>

```

---

### **Common Scan Techniques**

**1. TCP Scans**

- **TCP SYN Scan (-sS)**: Default scan that sends a SYN packet to detect open ports without completing the TCP three-way handshake.
    - **SYN-ACK Response**: Port is open.
    - **RST Response**: Port is closed.
    - **No Response**: Port is filtered.

**2. TCP Connect Scan (-sT)**: Establishes a full connection (three-way handshake). Slower but more reliable for some networks.

**3. TCP ACK Scan (-sA)**: Determines whether a firewall is stateless or stateful by sending ACK packets.

**4. TCP Window Scan (-sW)**: Similar to ACK scan but checks TCP Window field to determine port status.

**5. TCP Maimon Scan (-sM)**: Rarely used, checks for open ports with an RST/ACK response.

**6. UDP Scan (-sU)**: Scans for open UDP ports; slower and harder to perform since UDP is connectionless.

**7. Null, FIN, Xmas Scans (-sN, -sF, -sX)**: Send unusual packet combinations to bypass some firewalls and IDS:

- **Null Scan (-sN)**: No flags set.
- **FIN Scan (-sF)**: Sends FIN flag.
- **Xmas Scan (-sX)**: Sends FIN, PSH, and URG flags.

**8. IP Protocol Scan (-sO)**: Detects supported IP protocols on the target.

**9. SCTP INIT/COOKIE-ECHO Scan (-sY, -sZ)**: Scan Stream Control Transmission Protocol (SCTP) INIT and COOKIE-ECHO ports.

**10. FTP Bounce Scan (-b)**: Attempts to scan through an FTP server, using it as a proxy.

**11. Idle Scan (-sI)**: Advanced, stealth scan using a "zombie" host to hide the attacker's identity.

---

### **Example Nmap Scans**

**Basic TCP SYN Scan Example**

```bash
sudo nmap -sS localhost

```

**Output Explanation**:

- **PORT**: Number of the open port.
- **STATE**: Whether the port is open, closed, or filtered.
- **SERVICE**: The type of service running on that port (e.g., SSH, HTTP).

---

### **Advanced Nmap Commands**

1. **Service Version Detection (-sV)**
    
    - Detects the version of the service running on open ports.
    
    ```bash
    nmap -sV <target>
    
    ```
    
2. **Operating System Detection (-O)**
    
    - Identifies the operating system and its version.
    
    ```bash
    nmap -O <target>
    
    ```
    
3. **Aggressive Scan (-A)**
    
    - Combines OS detection, version detection, script scanning, and traceroute for detailed information.
    
    ```bash
    nmap -A <target>
    
    ```
    
4. **Script Scan with NSE (-sC)**
    
    - Uses Nmap Scripting Engine to run default scripts on the target.
    
    ```bash
    nmap -sC <target>
    
    ```
    
5. **Scan Specific Ports (-p)**
    
    - Specify a range of ports to scan (e.g., from port 1 to 1000).
    
    ```bash
    nmap -p 1-1000 <target>
    
    ```
    
6. **Excluding Specific Hosts (--exclude)**
    
    - Exclude certain hosts from the scan.
    
    ```bash
    nmap --exclude <host> <target>
    
    ```
    
7. **Scan Multiple Hosts**
    
    - Scan multiple IP addresses at once.
    
    ```bash
    nmap <target1> <target2> <target3>
    
    ```
    
8. **Evade Firewalls and IDS (-D, -f)**
    
    - **Decoy Scan (-D)**: Uses decoy IPs to hide the actual attacker.
        
        ```bash
        nmap -D RND:10 <target>
        
        ```
        
    - **Fragmentation (-f)**: Sends fragmented packets to bypass firewalls.
        
        ```bash
        nmap -f <target>
        
        ```
        
9. **Timing & Performance Options (-T0 to -T5)**
    
    - Control speed and stealth of scans, ranging from `T0` (slowest, stealthiest) to `T5` (fastest).
    
    ```bash
    nmap -T4 <target>
    
    ```
    
10. **Save Scan Output (-oN, -oX, -oG)**
    
    - Save scan results in different formats (normal, XML, greppable).
    
    ```bash
    nmap -oN output.txt <target>
    
    ```
    

---

### **Study Tips for Nmap**

1. **Memorize Core Scans**: Focus on common commands like `sS`, `sU`, `A`, and `O`.
2. **Practice on Different Networks**: Set up virtual machines to simulate various network environments and practice different Nmap scans.
3. **Use NSE Scripts**: Get comfortable with Nmap Scripting Engine to automate specific tasks and advanced scans.
4. **Explore Firewall Evasion**: Learn techniques to bypass security measures such as decoy scans and fragmented packets.
5. **Timing & Performance Adjustments**: Test scans with different `T` options to understand the balance between speed and stealth.
6. **Analyze Outputs**: Spend time understanding scan results, focusing on the meaning of open, closed, and filtered ports.
7. **Watch Tutorials**: Supplement your practice by watching videos on Nmap techniques, especially advanced scans.
8. **Stay Current**: Keep updated on new Nmap features and scripts by visiting the [Nmap website](https://nmap.org/).

**Next** [[Nmap Host Discovery]]
