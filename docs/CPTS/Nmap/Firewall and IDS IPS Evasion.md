### References
- [Example Tutorial](https://example.com/tutorial)
- [OSCP Exploit Documentation](https://documentation.oscp.org/exploitations)


### Firewall and IDS/IPS Evasion Techniques

#### 1. **Understanding Firewalls**

- **Purpose**: Prevents unauthorized external connections.
- **Operation**: Uses rules to monitor network traffic and decide whether to pass, ignore, or block packets.
- **Packet Actions**:
    - **Drop**: Packet is ignored, no response from the host.
    - **Reject**: Host responds with an RST flag or ICMP error.

#### 2. **IDS vs. IPS**

- **IDS (Intrusion Detection System)**:
    - **Function**: Monitors for potential attacks, analyzing and reporting detected threats.
    - **Detection Method**: Pattern matching and signature analysis.
- **IPS (Intrusion Prevention System)**:
    - **Function**: Takes active measures against detected threats.
    - **Reaction**: Blocks or modifies packets based on set rules.
- **Comparison to Firewalls**: Unlike firewalls, IDS/IPS are passive and usually examine all traffic.

#### 3. **Identifying Firewalls and Rules**

- **Filtered Ports**: Could indicate firewall presence with specific rules.
- **Response Types**:
    - **No response**: Packet likely dropped.
    - **ICMP error/RST response**: Indicates packet rejection.

#### 4. **Firewall Evasion with Nmap**

- **SYN Scan (-sS)**:
    
    - Useful for checking open or closed status.
    - Host responds with SYN-ACK for open ports, RST for closed.
- **ACK Scan (-sA)**:
    
    - Bypasses some firewalls; only sends ACK packets.
    - Hosts respond with RST for both open and closed ports.
    - Effective when SYN scans are blocked by firewalls.
- **Example Command**:
    
    ```shell
    sudo nmap [target IP] -p [ports] -sS / -sA -Pn -n --disable-arp-ping --packet-trace
    ```

#### 5. **Detecting IDS/IPS Systems**

- **Active Detection**: IDS only reports to admins, while IPS may block IPs.
- **Testing**:
    - Use a VPS; if it gets blocked, assume IPS presence.
    - Switch to another IP if necessary, and reduce scan aggressiveness.

#### 6. **Decoys for Obfuscation**

- **Purpose**: Hide the true source IP by adding random IPs as decoys.
    
- **Usage**:
    
    - Use `-D` flag to add decoys; your real IP blends among others.
    - Example:
        
        ```shell
    sudo nmap [target IP] -p [ports] -sS -Pn -n --disable-arp-ping --packet-trace -D RND:[number of IPs]
```
        
        
- **Considerations**: Not all decoy IPs are guaranteed to work, as ISPs may filter spoofed packets.
    

#### 7. **Testing Firewall Rules with IP Manipulation**

- **Purpose**: See if altering the source IP affects access to certain services.
- **Commands**:
    - Specifying Source IP: `-S [IP]`
    - Operating System Detection: `-O` for guessing OS type.

---
#### **Common Commands**

1. **TCP SYN Scan**:
    
	```shell
	sudo nmap <target-IP> -p <ports> -sS -Pn -n --disable-arp-ping --packet-trace
```
    
	**Description**: Detects open ports by sending SYN packets. May trigger firewalls/IDS.
1. **TCP ACK Scan**:

	```shell
	sudo nmap <target-IP> -p <ports> -sA -Pn -n --disable-arp-ping --packet-trace
```
    
    - **Description**: Bypasses some firewall rules; uses only ACK flag, triggering less strict filtering.

2. **Decoy Scan**:
    
    ```shell
sudo nmap <target-IP> -p <ports> -sS -Pn -n --disable-arp-ping --packet-trace -D RND:5
```
    
    - **Description**: Uses random IPs as decoys to mask the origin of the scan; helpful for evading IPS detection.
    
3. **Operating System Detection**:
    
    
    ```shell
    sudo nmap <target-IP> -n -Pn -p445 -O
    ```
    
    - **Description**: OS detection scan with specified port; can test for firewall rules.
4. **Specific Source IP (-S)**:
    
    ```shell
	sudo nmap <target-IP> -S <spoofed-IP> -p <ports> -Pn -n --packet-trace
	```
    
    - **Description**: Masks actual IP by specifying a source IP, useful if certain subnets/IPs are blocked.

#### **Flag Definitions**

- `-Pn`: Disables ICMP Echo requests.
- `-n`: Disables DNS resolution.
- `--disable-arp-ping`: Disables ARP ping.
- `--packet-trace`: Shows packets sent/received.
- `-D <IP(s)>`: Adds decoy IPs.
- `-sS`: SYN scan.
- `-sA`: ACK scan.
---
#### Testing Firewall Rule

  Firewall and IDS/IPS Evasion

```shell-session
0xs5@htb[/htb]$ sudo nmap 10.129.2.28 -n -Pn -p445 -O

Starting Nmap 7.80 ( https://nmap.org ) at 2020-06-22 01:23 CEST
Nmap scan report for 10.129.2.28
Host is up (0.032s latency).

PORT    STATE    SERVICE
445/tcp filtered microsoft-ds
MAC Address: DE:AD:00:00:BE:EF (Intel Corporate)
Too many fingerprints match this host to give specific OS details
Network Distance: 1 hop

OS detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 3.14 seconds
```

#### Scan by Using Different Source IP

  Firewall and IDS/IPS Evasion

```shell
0xs5@htb[/htb]$ sudo nmap 10.129.2.28 -n -Pn -p 445 -O -S 10.129.2.200 -e tun0

Starting Nmap 7.80 ( https://nmap.org ) at 2020-06-22 01:16 CEST
Nmap scan report for 10.129.2.28
Host is up (0.010s latency).

PORT    STATE SERVICE
445/tcp open  microsoft-ds
MAC Address: DE:AD:00:00:BE:EF (Intel Corporate)
Warning: OSScan results may be unreliable because we could not find at least 1 open and 1 closed port
Aggressive OS guesses: Linux 2.6.32 (96%), Linux 3.2 - 4.9 (96%), Linux 2.6.32 - 3.10 (96%), Linux 3.4 - 3.10 (95%), Linux 3.1 (95%), Linux 3.2 (95%), AXIS 210A or 211 Network Camera (Linux 2.6.17) (94%), Synology DiskStation Manager 5.2-5644 (94%), Linux 2.6.32 - 2.6.35 (94%), Linux 2.6.32 - 3.5 (94%)
No exact OS matches for host (test conditions non-ideal).
Network Distance: 1 hop

OS detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 4.11 seconds
```

|**Scanning Options**|**Description**|
|---|---|
|`10.129.2.28`|Scans the specified target.|
|`-n`|Disables DNS resolution.|
|`-Pn`|Disables ICMP Echo requests.|
|`-p 445`|Scans only the specified ports.|
|`-O`|Performs operation system detection scan.|
|`-S`|Scans the target by using different source IP address.|
|`10.129.2.200`|Specifies the source IP address.|
|`-e tun0`|Sends all requests through the specified interface.|

---

## DNS Proxying

By default, `Nmap` performs a reverse DNS resolution unless otherwise specified to find more important information about our target. These DNS queries are also passed in most cases because the given web server is supposed to be found and visited. The DNS queries are made over the `UDP port 53`. The `TCP port 53` was previously only used for the so-called "`Zone transfers`" between the DNS servers or data transfer larger than 512 bytes. More and more, this is changing due to IPv6 and DNSSEC expansions. These changes cause many DNS requests to be made via TCP port 53.

However, `Nmap` still gives us a way to specify DNS servers ourselves (`--dns-server <ns>,<ns>`). This method could be fundamental to us if we are in a demilitarized zone (`DMZ`). The company's DNS servers are usually more trusted than those from the Internet. So, for example, we could use them to interact with the hosts of the internal network. As another example, we can use `TCP port 53` as a source port (`--source-port`) for our scans. If the administrator uses the firewall to control this port and does not filter IDS/IPS properly, our TCP packets will be trusted and passed through.

#### SYN-Scan of a Filtered Port

  Firewall and IDS/IPS Evasion

```shell
0xs5@htb[/htb]$ sudo nmap 10.129.2.28 -p50000 -sS -Pn -n --disable-arp-ping --packet-trace

Starting Nmap 7.80 ( https://nmap.org ) at 2020-06-21 22:50 CEST
SENT (0.0417s) TCP 10.10.14.2:33436 > 10.129.2.28:50000 S ttl=41 id=21939 iplen=44  seq=736533153 win=1024 <mss 1460>
SENT (1.0481s) TCP 10.10.14.2:33437 > 10.129.2.28:50000 S ttl=46 id=6446 iplen=44  seq=736598688 win=1024 <mss 1460>
Nmap scan report for 10.129.2.28
Host is up.

PORT      STATE    SERVICE
50000/tcp filtered ibm-db2

Nmap done: 1 IP address (1 host up) scanned in 2.06 seconds
```

#### SYN-Scan From DNS Port

  Firewall and IDS/IPS Evasion

```shell
0xs5@htb[/htb]$ sudo nmap 10.129.2.28 -p50000 -sS -Pn -n --disable-arp-ping --packet-trace --source-port 53

SENT (0.0482s) TCP 10.10.14.2:53 > 10.129.2.28:50000 S ttl=58 id=27470 iplen=44  seq=4003923435 win=1024 <mss 1460>
RCVD (0.0608s) TCP 10.129.2.28:50000 > 10.10.14.2:53 SA ttl=64 id=0 iplen=44  seq=540635485 win=64240 <mss 1460>
Nmap scan report for 10.129.2.28
Host is up (0.013s latency).

PORT      STATE SERVICE
50000/tcp open  ibm-db2
MAC Address: DE:AD:00:00:BE:EF (Intel Corporate)

Nmap done: 1 IP address (1 host up) scanned in 0.08 seconds
```

|**Scanning Options**|**Description**|
|---|---|
|`10.129.2.28`|Scans the specified target.|
|`-p 50000`|Scans only the specified ports.|
|`-sS`|Performs SYN scan on specified ports.|
|`-Pn`|Disables ICMP Echo requests.|
|`-n`|Disables DNS resolution.|
|`--disable-arp-ping`|Disables ARP ping.|
|`--packet-trace`|Shows all packets sent and received.|
|`--source-port 53`|Performs the scans from specified source port.|

---

Now that we have found out that the firewall accepts `TCP port 53`, it is very likely that IDS/IPS filters might also be configured much weaker than others. We can test this by trying to connect to this port by using `Netcat`.

#### Connect To The Filtered Port

  Firewall and IDS/IPS Evasion

```shell
0xs5@htb[/htb]$ ncat -nv --source-port 53 10.129.2.28 50000

Ncat: Version 7.80 ( https://nmap.org/ncat )
Ncat: Connected to 10.129.2.28:50000.
220 ProFTPd
```


---

### Study Tips

1. **Practice Commands**: Get hands-on with Nmap’s evasion options; understanding their output will help solidify the concepts.
2. **Flashcards**: Make flashcards for key commands and flags (`-sS`, `-sA`, `-D`, `--packet-trace`, etc.) to reinforce learning.
3. **Simulate Scenarios**: Set up small network labs with virtual machines to practice firewall/IDS/IPS detection and evasion.
4. **Review Response Codes**: Recognize common ICMP error codes and TCP flags (RST, SYN-ACK) and their implications.
5. **Time Management**: In the exam, prioritize evasion techniques if scans are blocked, and practice adjusting strategies on-the-fly.

**Next Lesson** [[Firewall and IDs and IPs Evasion Labs]]
