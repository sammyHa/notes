
```bash
sudo systemctl start nessusd
```
Username: deltacode
Password: admin
https://127.0.0.1:8834


Nessus is a vulnerability scanning tool developed by Tenable. It's widely used for identifying security vulnerabilities, configuration issues, and compliance violations. Here’s a complete guide from beginner to advanced usage.

---

## **1. Getting Started with Nessus**

### **What is Nessus?**

Nessus is a tool designed for vulnerability assessment. It scans networks, systems, and applications for vulnerabilities such as:

- Misconfigurations
- Outdated software
- Unpatched systems
- Policy violations

### **Installation**

1. Download Nessus from the official Tenable website. Select the appropriate version for your operating system.
    
2. Install Nessus using the downloaded package:
    
    - **For Debian/Ubuntu**:
        
        bash
        
        Copy code
        
        `sudo dpkg -i Nessus-<version>.deb sudo systemctl start nessusd`
        
    - **For RHEL/CentOS**:
        
        bash
        
        Copy code
        
        `sudo rpm -ivh Nessus-<version>.rpm sudo systemctl start nessusd`
        
3. Access the Nessus web interface:
    
    - Navigate to `https://<IP>:8834` in your browser.
4. Register for a license (free or professional) and activate Nessus.
    

---

### **Basic Configuration**

- **Add a Scan**:
    
    1. Log in to the Nessus web interface.
    2. Click **New Scan**.
    3. Choose a scan type (e.g., Basic Network Scan, Credentialed Scan).
    4. Provide target IPs or ranges.
    5. Configure scan settings (e.g., credentials, ports).
- **Launch a Scan**:
    
    - Select the created scan and click **Start**.
- **View Results**:
    
    - After the scan completes, open the results to review vulnerabilities by severity (Critical, High, Medium, Low).

---

## **2. Intermediate Usage**

### **Common Nessus Commands**

You can control Nessus via CLI (Nessus Command Line Interface). Here are some essential commands:

- **Start Nessus Service**:
    
    bash
    
    Copy code
    
    `sudo systemctl start nessusd`
    
- **Check Nessus Status**:
    
    bash
    
    Copy code
    
    `sudo systemctl status nessusd`
    
- **Restart Nessus**:
    
    bash
    
    Copy code
    
    `sudo systemctl restart nessusd`
    
- **Update Nessus Plugins**:
    
    bash
    
    Copy code
    
    `/opt/nessus/bin/nessuscli update`
    
- **List Users**:
    
    bash
    
    Copy code
    
    `/opt/nessus/sbin/nessuscli user list`
    
- **Add a User**:
    
    bash
    
    Copy code
    
    `/opt/nessus/sbin/nessuscli adduser`
    
- **Delete a User**:
    
    bash
    
    Copy code
    
    `/opt/nessus/sbin/nessuscli rmuser <username>`
    

---

### **Scan Types and When to Use Them**

1. **Basic Network Scan**:
    
    - Use for general network discovery and vulnerability assessment.
    - Targets IP ranges, subnets, or individual hosts.
2. **Credentialed Scan**:
    
    - Provides more in-depth results by logging into the target system.
    - Use credentials (SSH, SMB, etc.) to test for misconfigurations and missing patches.
3. **Web Application Tests**:
    
    - Test for OWASP vulnerabilities like SQL injection and XSS.
    - Requires specifying web application URLs.
4. **Compliance Scan**:
    
    - Use to check for policy compliance (e.g., CIS benchmarks, HIPAA, PCI DSS).
    - Requires configuring compliance plugins and audit files.

---

### **Custom Policies**

Create custom policies to tailor scans:

1. Go to **Settings > Policies**.
2. Click **New Policy**.
3. Configure:
    - **Discovery**: Define target discovery methods (e.g., ping, DNS, port scanning).
    - **Assessment**: Select the types of vulnerabilities to test for.
    - **Performance**: Adjust performance to reduce impact on network and systems.

---

## **3. Advanced Nessus Usage**

### **Tuning Scan Performance**

- **Avoid Overloading the Network**:
    
    - Limit concurrent connections:
        
        bash
        
        Copy code
        
        `Max Concurrent TCP Sessions: 5`
        
- **Exclude IPs or Hosts**: Add exclusions under **Settings** to avoid scanning sensitive systems.
    
- **Use Custom Scanning Windows**: Schedule scans during off-peak hours.
    

---

### **Analyzing Scan Results**

1. **Export Results**:
    
    - Export reports in various formats: HTML, PDF, CSV.
    - Use the CLI to export:
        
        bash
        
        Copy code
        
        `/opt/nessus/sbin/nessuscli export <scan-id> <format>`
        
2. **Filter Vulnerabilities**:
    
    - Filter by severity, CVSS score, or plugin family in the web interface.
3. **Prioritize Remediation**:
    
    - Focus on critical and high vulnerabilities first.
    - Group vulnerabilities by affected software for bulk remediation.

---

### **Advanced Techniques**

#### **1. Use API Integration**

Nessus offers a RESTful API for automation. Example commands:

- **Get Scan List**:
    
    bash
    
    Copy code
    
    `curl -X GET -H "X-ApiKeys: accessKey=<access_key>; secretKey=<secret_key>" "https://<nessus-host>:8834/scans"`
    
- **Launch a Scan**:
    
    bash
    
    Copy code
    
    `curl -X POST -H "X-ApiKeys: accessKey=<access_key>; secretKey=<secret_key>" "https://<nessus-host>:8834/scans/<scan-id>/launch"`
    

#### **2. Plugin Rules**

- Disable unnecessary plugins to reduce false positives:
    - Go to **Settings > Plugin Rules**.
    - Disable noisy or irrelevant plugins.

#### **3. Policy Compliance**

- Import audit files for compliance scans:
    - Go to **Compliance > Upload Audit File**.
    - Select the relevant framework (e.g., PCI DSS, CIS).

---

### **4. Tips and Tricks**

1. **Update Plugins Regularly**:
    
    - Ensure you’re scanning with the latest vulnerability database.
    - Run:
        
        bash
        
        Copy code
        
        `/opt/nessus/bin/nessuscli update`
        
2. **Enable Debug Logs**:
    
    - Troubleshoot issues by enabling debug logs:
        
        bash
        
        Copy code
        
        `/opt/nessus/sbin/nessuscli set log-level debug`
        
3. **Use Credentials**:
    
    - Credentialed scans provide more accurate results.
    - Configure credentials in **Settings > Authentication**.
4. **Exclude False Positives**:
    
    - Review scan results for false positives.
    - Add exceptions under **Settings > Plugin Rules**.
5. **Integrate with SIEM**:
    
    - Export Nessus results to SIEM tools like Splunk for correlation.
6. **Leverage Tags**:
    
    - Organize assets using tags for better management.

---

### **5. Common Nessus CLI Commands**

|Command|Description|
|---|---|
|`nessuscli update`|Update Nessus plugins.|
|`nessuscli adduser`|Add a Nessus user.|
|`nessuscli rmuser <username>`|Remove a Nessus user.|
|`nessuscli export <scan-id> <format>`|Export scan results.|
|`nessuscli set log-level debug`|Enable debug logs.|
|`nessuscli start`|Start Nessus service.|
|`nessuscli stop`|Stop Nessus service.|

---

### **6. Best Practices**

- **Credentialed Scans**: Always provide credentials for accurate results.
- **Scan Regularly**: Schedule scans weekly or monthly.
- **Prioritize Remediation**: Focus on critical vulnerabilities first.
- **Integrate with Tools**: Use Nessus with SIEMs or orchestration platforms.
- **Use Multiple Scan Types**: Combine network, credentialed, and web app scans for thorough coverage.