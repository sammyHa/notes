is a set of standardized specifications for hardware-based host management systems used for system management and monitoring. It acts as an autonomous subsystem and works independently of the host's BIOS, CPU, firmware, and underlying operating system.

#### **Overview**

- **IPMI**: A standardized hardware-based host management system for system management and monitoring.
- Functions **independently** of the host's OS, BIOS, CPU, or firmware.
- Allows **sysadmins** to manage and monitor systems even when powered off or unresponsive.
- Operates via a **network connection** without requiring OS access.

---

#### **Common Use Cases**

1. **Pre-OS Management**: Modify BIOS settings.
2. **Powered-Down Hosts**: Manage systems even when powered off.
3. **Post-Failure Recovery**: Access and diagnose unresponsive systems.

---

#### **Key Features**

- **Monitoring**: System temperature, voltage, fan status, power supplies.
- **Alerting**: Via SNMP.
- **Hardware Logs**: Query inventory and review system event logs.
- **Remote Upgrades**: Update systems without physical access.

---

#### **Architecture Components**

- **Baseboard Management Controller (BMC)**: Embedded microcontroller for hardware management.
- **Intelligent Chassis Management Bus (ICMB)**: Enables inter-chassis communication.
- **Intelligent Platform Management Bus (IPMB)**: Extends BMC communication.
- **IPMI Memory**: Stores logs, repository data, etc.
- **Communication Interfaces**: Includes local, serial, LAN, ICMB, and PCI buses.

---

#### **Technical Details**

- **Protocol**: Operates on **port 623 UDP**.
- **System Support**: Found in motherboards, PCI cards, or added as external modules.
- **Version 2.0**: Supports **Serial over LAN (SoL)** for in-band serial console output.
- **BMC Access**: Grants near-physical control of a system:
    - Monitor hardware.
    - Reboot/power off systems.
    - Reinstall OS.

---

#### **Security Implications**

- **BMC Access = Physical Access**: Exploiting IPMI provides control over the host motherboard.
- **Vulnerable Services**: Many BMCs expose:
    - Web-based management consoles.
    - Remote access via Telnet/SSH.
    - Open **port 623 UDP**.

---

#### **[[Nmap]] Footprinting Example**

Use the **ipmi-version** NSE script to discover and enumerate IPMI services.


```bash
nmap -sU -p 623 --script ipmi-version <target>
```
![[Pasted image 20241113104020.png]]

We can see that the IPMI protocol is indeed listening on port `623` and nmap has fingerprinted version 2.0 of the protocol. 
 we can also use [[Metasploit]] scanner modeul `IPMI information discovery (auxilitary/scanner/ipmi/ipmi_verion)`
---
![[Pasted image 20241113104441.png]]

### using the metasploit dumping hashes
![[Pasted image 20241113105149.png]]

![[Pasted image 20241113105226.png]]

**What is the account's cleartext password?**

```bash
set PASS_FILE /usr/share/wordlists/rockyou.txt
```
![[Pasted image 20241113111201.png]]
Answer: `trinity`

#### **Supported Vendors**

- **Examples**: Cisco, Dell (DRAC), HP (iLO), Supermicro, Intel, etc.

---

### **Summary**

IPMI is a robust system management protocol offering remote monitoring and control capabilities. While it ensures convenience for sysadmins, improper configuration or exposure can lead to critical security risks, equivalent to granting physical access to attackers. Properly securing IPMI access and monitoring port 623 UDP are essential steps in minimizing vulnerabilities.


