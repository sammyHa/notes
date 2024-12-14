---
title: vnStat
date: 2024-10-30
tags: 
techniques: 
tools:
  - vnstat
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

### **What is vnStat?**

**vnStat** is a lightweight, command-line network traffic monitoring tool. It is designed to provide detailed information about network usage and bandwidth consumption over time. Unlike other network monitoring tools, **vnStat** focuses on minimal resource usage by reading directly from network interface statistics provided by the operating system, rather than capturing and analyzing packets.

---

### **Key Features**

1. **Low Resource Usage**:
    
    - Does not require superuser privileges after installation.
    - Reads data from `/proc/net/dev` (Linux) instead of intercepting network traffic.
2. **Traffic Statistics**:
    
    - Tracks incoming and outgoing traffic for specified network interfaces.
    - Displays usage by hours, days, months, or a specified time period.
3. **Customizable**:
    
    - Allows users to monitor specific interfaces (e.g., `eth0`, `wlan0`).
    - Supports exporting reports in various formats.
4. **Persistent Data**:
    
    - Stores usage statistics in a database for long-term tracking, surviving reboots.
5. **Compatibility**:
    
    - Works on various Unix-based systems like Linux and BSD.

---

### **Use Cases**

1. **Bandwidth Monitoring**:
    
    - Ideal for tracking network usage over time to avoid exceeding data limits.
2. **Troubleshooting**:
    
    - Helps identify high bandwidth consumption periods or interfaces.
3. **Reporting**:
    
    - Provides usage summaries for IT teams or personal monitoring.

---

### **Basic Commands**

1. **View Daily Traffic**:
    
    bash
    
    Copy code
    
    `vnstat -d`
    
2. **View Monthly Traffic**:
    
    bash
    
    Copy code
    
    `vnstat -m`
    
3. **View Hourly Traffic**:
    
    bash
    
    Copy code
    
    `vnstat -h`
    
4. **Live Traffic Monitoring**:
    
    bash
    
    Copy code
    
    `vnstat -l`
    
5. **Network Interface Summary**:
    
    bash
    
    Copy code
    
    `vnstat`
    

---

### **Installation**

1. On Debian/Ubuntu-based systems:
    
    bash
    
    Copy code
    
    `sudo apt install vnstat`
    
2. On Red Hat-based systems:
    
    bash
    
    Copy code
    
    `sudo yum install vnstat`
    
3. Start the vnStat service:
    
    bash
    
    Copy code
    
    `sudo systemctl start vnstat sudo systemctl enable vnstat`
    

---

### **Configuration**

- The configuration file is typically located at:
    
    bash
    
    Copy code
    
    `/etc/vnstat.conf`
    
- You can customize:
    - Monitored interfaces.
    - Data retention policies.
    - Output formatting options.

---

### **Why Use vnStat?**

- Minimal impact on system performance.
- No need for deep packet inspection.
- Easy setup and long-term traffic tracking for accurate insights.