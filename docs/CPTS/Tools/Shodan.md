---
title: Shodan
date: 2024-10-30
tags: 
techniques: 
tools:
  - shodan
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

### **What is Shodan?**

Shodan is used to:

- Find exposed services/devices on the internet (e.g., IoT devices, webcams, databases).
- Identify vulnerabilities based on software and versions.
- Analyze network exposure and security posture.

### **Setting Up a Shodan Account**

1. Go to [Shodan](https://www.shodan.io/) and create a free or paid account.
2. Obtain your **API Key** from your account page for CLI or automation.

### **Installing Shodan CLI**

To use Shodan’s Command Line Interface:

1. Install Python (if not already installed).
2. Install Shodan CLI:
    
    `pip install shodan`
    
3. Authenticate with your API key:

    `shodan init YOUR_API_KEY`
    

---

## **2. Beginner Usage**

### **Shodan Web Interface**

- **Search Basics**: Enter keywords in the search bar to find exposed services.
    - Example: `apache` (find devices running Apache HTTP Server).
- **Filters**:
    - **Country**: `country:US`
    - **Port**: `port:22`
    - **Organization**: `org:"Google"`
    - **Product**: `product:nginx`
    - Example: `apache country:US port:443`

---

### **Shodan CLI Basics**

#### **1. Search**

Run a search query from the CLI:
```bash
shodan search apache
```

#### **2. List Your Plan's Limit**

To check API limits and usage:

```bash
shodan info
```

#### **3. Lookup an IP**

Get details about a specific IP address:

```bash
shodan host <IP>
```

#### **4. Explore Scanned Services**

To see which ports Shodan has indexed globally:

```bash
shodan ports
```

---

## **3. Intermediate Usage**

### **Shodan Filters**

Combine multiple filters for more precise results:

- **Basic Filters**:
    - `port:<port>`: Search for services running on a specific port.
    - `country:<code>`: Specify a country.
    - `city:<name>`: Narrow results to a specific city.
    - `product:<name>`: Search for a specific product (e.g., nginx, Apache).
- **Advanced Filters**:
    - `after:<date>` or `before:<date>`: Find results from specific timeframes.
    - `os:<name>`: Find devices by operating system.
    - `org:<name>`: Search by organization name.

Example:

`shodan search "nginx country:DE port:443"`

### **File Output**

Export results to a file for later use:

`shodan search "apache" --limit 100 --fields ip_str,port,org --separator , > results.csv`

Fields can include:

- `ip_str`: IP Address.
- `port`: Open port.
- `org`: Organization.
- `vulns`: List of vulnerabilities.

---

### **Shodan CLI Commands**

#### **1. Explore Scans**

Get a list of available services scanned by Shodan:


`shodan services`

#### **2. Scan Your Network**

To scan your own IP or range (requires a paid plan):

`shodan scan submit <IP_OR_RANGE>`

#### **3. Retrieve Scan Results**

After submission, get scan results:

`shodan scan download <SCAN_ID>`

#### **4. Check Exploits**

Search for known exploits using Shodan Exploits API:

`shodan exploits search "cve-2022-1388"`

---

## **4. Advanced Usage**

### **Advanced Filters**

- **SSL/TLS Certificates**:
    
    - `ssl:"<string>"`: Search SSL certificates for specific strings.
    - Example: `ssl:"Let's Encrypt"`
- **HTTP Headers**:
    
    - `http.title:"<string>"`: Search for devices with a specific webpage title.
    - Example: `http.title:"Welcome to nginx!"`
- **Vulnerabilities**:
    
    - `vuln:"<CVE-ID>"`: Search for devices with specific vulnerabilities.
    - Example: `vuln:"CVE-2023-12345"`

---

### **Using Shodan API**

#### **Python Script Example**

Install the Python module:

`pip install shodan`

Example script:

```python
import shodan  API_KEY = "YOUR_API_KEY" shodan_api = shodan.Shodan(API_KEY)  # Search for devices running nginx results = shodan_api.search("nginx") print(f"Total results: {results['total']}")  for result in results['matches']:     print(f"IP: {result['ip_str']}, Port: {result['port']}")
```

---

### **Automated Monitoring**

Use Shodan to monitor your network for exposure or vulnerabilities:

1. **Add Alert**:

    `shodan alert create "My Network" <IP_OR_RANGE>`
    
2. **Get Alerts**:
    
    `shodan alert list`
    

---

### **Analyzing Results with JSON**

Shodan CLI outputs JSON by default. You can process it with tools like `jq`:

bash

Copy code

`shodan search "nginx" --limit 10 --fields ip_str,port,vulns | jq .`

---

### **Shodan Maps**

Visualize search results on a map (requires a paid plan):

1. Export data:
    
    bash
    
    Copy code
    
    `shodan search "nginx" --limit 100 --fields ip_str,port,location.latitude,location.longitude > map_data.csv`
    
2. Use tools like Google Maps or Python libraries (e.g., Folium) to plot results.

---

## **5. Tips and Tricks**

### **1. Focus on High-Value Targets**

Look for misconfigured devices or forgotten services using:

- `default password` searches.
- Exposed databases (`product:mongodb`, `product:mysql`).
- Misconfigured cameras (`webcam` or `axis`).

### **2. Refine Searches**

Combine multiple filters to refine results:

bash

Copy code

`shodan search "default password country:US port:80"`

### **3. Avoid Overwhelming Data**

Limit results to a manageable number:

bash

Copy code

`shodan search "nginx" --limit 50`

### **4. Stay Anonymous**

Shodan queries don't expose your IP, but use VPN/proxies for accessing exposed systems ethically.

### **5. Use Reports**

Export reports for compliance or team sharing:

bash

Copy code

`shodan myip > report.txt`

---

## **6. Best Practices**

- **Legal Boundaries**: Ensure you have permission before exploring or interacting with exposed systems.
- **Ethical Use**: Use Shodan for research, compliance, and security assessments only.
- **Regular Monitoring**: Continuously monitor your organization’s IP ranges for exposed devices.

---

### **Common CLI Commands Summary**

|Command|Description|
|---|---|
|`shodan init YOUR_API_KEY`|Initialize Shodan CLI with your API key.|
|`shodan search <query>`|Perform a search query.|
|`shodan host <IP>`|Get details of a specific host.|
|`shodan services`|List common services scanned by Shodan.|
|`shodan scan submit <IP_OR_RANGE>`|Submit a scan request (requires a paid account).|
|`shodan alert create "Name" <IP_OR_RANGE>`|Create an alert for specific IPs or ranges.|
|`shodan exploits search "<CVE-ID>"`|Search for exploits by CVE ID or keywords.|