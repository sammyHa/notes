---
title: Penetration Testing Process
date: 2024-10-30
tags: 
techniques: 
tools: 
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


### Penetration Testing Process

![[Pasted image 20241116003902.png]]
- Pre-Engagement
- Information Gathering
- Vulnerability Assessment
- Exploitation
- Post-Exploitation
- Lateral Movement
- Proof of Concept
- Post Engagement

1. **Pre-Engagement**:  
    This is the planning stage, where the scope, rules of engagement, and objectives are defined. Communication between the client and the tester ensures that expectations are aligned.
    
2. **Information Gathering**:  
    The tester collects as much data as possible about the target, such as IP addresses, domains, email addresses, public records, and exposed technologies. This can involve passive reconnaissance (e.g., OSINT) or active scanning.
    
3. **Vulnerability Assessment**:  
    The gathered data is analyzed to identify vulnerabilities in the system, such as outdated software, misconfigurations, or default credentials.
    
4. **Exploitation**:  
    This phase involves attempting to exploit the identified vulnerabilities to gain unauthorized access or achieve specific objectives (e.g., privilege escalation or data extraction).
    
5. **Post-Exploitation**:  
    Once access is gained, the tester assesses the extent of the breach's impact. This can include data exfiltration, persistent access, or understanding the business implications of the exploited vulnerabilities.
    
6. **Lateral Movement**:  
    After gaining a foothold, the tester attempts to move laterally within the network to access other systems, gather more credentials, or escalate privileges further.
    
7. **Proof of Concept (PoC)**:  
    Evidence of successful exploitation is documented, often including screenshots, data dumps, or access logs, to demonstrate the vulnerabilities effectively to stakeholders.
    
8. **Post-Engagement**:  
    This involves reporting the findings to the client. The report typically includes an executive summary, technical details, risk ratings, and recommendations for remediation. Debriefing sessions may also occur to ensure the client understands the risks and suggested fixes.
    
    ---
#### The primary goal of a web reconnaissance include
### **Information Gathering**

- **Identifying Assets**:  
    Uncover publicly accessible components of the target, including web pages, subdomains, IP addresses, and technologies in use. This step creates a comprehensive overview of the target's digital footprint.
    
- **Discovering Hidden Information**:  
    Locate inadvertently exposed sensitive data, such as backup files, configuration files, or internal documentation. These findings can provide valuable insights and potential attack vectors.
    
- **Gathering Intelligence**:  
    Collect information that could be useful for exploitation or social engineering, such as details about key personnel, email addresses, or behavioral patterns.
    

### **Vulnerability Assessment**

- **Analyzing the Attack Surface**:  
    Examine the target's attack surface by evaluating technologies, configurations, and possible entry points. This process aims to uncover vulnerabilities and weaknesses that could be exploited during the penetration test.
---

### **Types of Reconnaissance**

**Web reconnaissance** is a critical step in the penetration testing process. It can be broadly categorized into two primary methodologies:
### **1. Active Reconnaissance**

- **Definition**:  
    Active reconnaissance involves directly interacting with the target system to gather information. This often includes sending packets, probing services, and analyzing responses.
- **Techniques**:
    - **Port Scanning**: Using tools like [[Nmap]] to identify open ports and active services.
    - **Web Application Scanning**: Tools like Burp Suite or [[Nikto]] are used to identify vulnerabilities in web applications.
    - **DNS Enumeration**: Actively querying DNS servers to discover subdomains and other records.
    - **Banner Grabbing**: Capturing service banners to determine software versions.
- **Advantages**:
    - Yields precise and detailed information.
    - Helps identify live services and vulnerabilities effectively.
- **Challenges**:
    - Risk of detection by security systems like IDS/IPS.
    - May trigger alerts, exposing the tester’s activities.

---

### **2. Passive Reconnaissance**

- **Definition**:  
    Passive reconnaissance gathers information without directly interacting with the target system. It relies on publicly accessible sources to avoid detection.
- **Techniques**:
    - **OSINT (Open-Source Intelligence)**: Using resources like Shodan, WHOIS, or public databases to gather data.
    - **Social Media Analysis**: Collecting information from platforms like LinkedIn or Twitter.
    - **Metadata Analysis**: Extracting metadata from publicly available documents or images.
    - **Google Dorking**: Utilizing advanced search operators to find sensitive information.
- **Advantages**:
    - Difficult to detect, as no direct interaction with the target occurs.
    - Provides useful contextual information, such as corporate structure or exposed credentials.
- **Challenges**:
    - Limited in scope compared to active reconnaissance.
    - May require more time and effort to find actionable data.

---

**Choosing the Right Methodology**:  
A successful reconnaissance strategy often blends **active** and **passive** techniques to balance information depth with stealth. While passive methods prioritize evasion, active reconnaissance allows for detailed technical insights critical for penetration testing.


### Active Reconnaissance

In active reconnaissance, the attacker `directly interacts with the target system` to gather information. This interaction can take various forms:

|Technique|Description|Example|Tools|Risk of Detection|
|---|---|---|---|---|
|`Port Scanning`|Identifying open ports and services running on the target.|Using Nmap to scan a web server for open ports like 80 (HTTP) and 443 (HTTPS).|Nmap, Masscan, Unicornscan|High: Direct interaction with the target can trigger intrusion detection systems (IDS) and firewalls.|
|`Vulnerability Scanning`|Probing the target for known vulnerabilities, such as outdated software or misconfigurations.|Running Nessus against a web application to check for SQL injection flaws or cross-site scripting (XSS) vulnerabilities.|Nessus, OpenVAS, Nikto|High: Vulnerability scanners send exploit payloads that security solutions can detect.|
|`Network Mapping`|Mapping the target's network topology, including connected devices and their relationships.|Using traceroute to determine the path packets take to reach the target server, revealing potential network hops and infrastructure.|Traceroute, Nmap|Medium to High: Excessive or unusual network traffic can raise suspicion.|
|`Banner Grabbing`|Retrieving information from banners displayed by services running on the target.|Connecting to a web server on port 80 and examining the HTTP banner to identify the web server software and version.|Netcat, curl|Low: Banner grabbing typically involves minimal interaction but can still be logged.|
|`OS Fingerprinting`|Identifying the operating system running on the target.|Using Nmap's OS detection capabilities (`-O`) to determine if the target is running Windows, Linux, or another OS.|Nmap, Xprobe2|Low: OS fingerprinting is usually passive, but some advanced techniques can be detected.|
|`Service Enumeration`|Determining the specific versions of services running on open ports.|Using Nmap's service version detection (`-sV`) to determine if a web server is running Apache 2.4.50 or Nginx 1.18.0.|Nmap|Low: Similar to banner grabbing, service enumeration can be logged but is less likely to trigger alerts.|
|`Web Spidering`|Crawling the target website to identify web pages, directories, and files.|Running a web crawler like Burp Suite Spider or OWASP ZAP Spider to map out the structure of a website and discover hidden resources.|Burp Suite Spider, OWASP ZAP Spider, Scrapy (customisable)|Low to Medium: Can be detected if the crawler's behaviour is not carefully configured to mimic legitimate traffic.|

Active reconnaissance provides a direct and often more comprehensive view of the target's infrastructure and security posture. However, it also carries a higher risk of detection, as the interactions with the target can trigger alerts or raise suspicion.