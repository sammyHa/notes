---
title: Domain Information
date: 2024-10-30
tags:
  - oscp
  - passive-osint
  - domain-enumeration
  - oscp-notes
techniques:
  - ssl certificate analysis
  - subdomain discovery
  - certificate transparency
  - adjusting timing
  - shodan
  - dns records
  - osint
  - dns record
  - dns enumeration
tools:
  - curl
  - crt.sh
  - jq
  - shodan
  - dig
machines: inlanefreight.com
difficulty:
  - Meduim
status:
  - completed
type: passive-recon
os: Linux
categories:
  - osint
  - reconnaisance
exam-priority:
  - high
time-invested: 2
---
>[!tip]- Tips
>Write tips here

### References
- ref
- ref

### Overview
- Purpose: Gather domain information to understand the company's online presence passively
- Approach: Collect information without active scanning, mimicking customer/visitor navigation to avoid direct connections to the company.

### Key Points
1. **Understanding Domain and Services:**
	- focus on technologies and structures necessary for company services.
	- Identify service offerings (e.g., app development, IoT, hosting, etc). and use a developer's perspective to gain insights into underlying technical requirements.

2. **Analyzing Oline Presence:**
	- Determine company's internet footprint (e.g, ssl certificates, subdomains).
	- Example scenario: Conduct a black-box test on a company with only a target scope provided.
3. **Using SSL Certificate for Enumeration:**
	- Examine the company's SSL certificate for subdomains and other linked domains.
	- Tool: `crt.sh` for certificate transparency logs to find additional subdomains.
	
1. **Certificate Transparency Analysis**:
    
    - URL example: 
	    `https://crt.sh/?q=inlanefreight.com`
    - JSON Output:
        `curl -s https://crt.sh/?q=inlanefreight.com&output=json | jq .`
        
    - Extract unique subdomains:
```shell 
	curl -s https://crt.sh/?q=inlanefreight.com&output=json | jq . | grep name | cut -d":" -f2 | grep -v "CN=" | cut -d'"' -f2 | awk '{gsub(/\\n/,"\n");}1;' | sort -u
```
        
5. **Identifying Company-Hosted Servers**:
    
    - Check if subdomains are hosted by the company:
        
        ```sh
for i in $(cat subdomainlist); do host $i | grep "has address" | grep inlanefreight.com | cut -d" " -f1,4; done
```
        
6. **Shodan for Open Port Analysis**:
    
    - Collect IPs and analyze with Shodan for IoT and other internet-connected systems.
    - Example commands:
    -
        `for i in $(cat subdomainlist); do host $i | grep "has address" | grep inlanefreight.com | cut -d" " -f4 >> ip-addresses.txt; done for i in $(cat ip-addresses.txt); do shodan host $i; done`
        
7. **Gathering DNS Records**:
    
    - Obtain DNS records to discover more hosts:
        

        `dig any inlanefreight.com`
        
### Notable Findings

- **Subdomains Identified**: matomo.inlanefreight.com, smartfactory.inlanefreight.com, account.ttn.inlanefreight.com, etc.
- **Company IPs**: 10.129.24.93, 10.129.27.33, 10.129.127.22
- **SSL Details**: Found entries for SSLv2, SSLv3, TLSv1.1, TLSv1.2, TLSv1.3.
- **Shodan Output**:
    - Example IP `10.129.24.93` shows open ports 80/tcp and 443/tcp (nginx).
    - Example IP `10.129.27.33` with OpenSSH, nginx, TLS configurations.

### A Records

- **Purpose**: Resolves (sub)domain names to IP addresses.
- **Findings**: Only one IP address was found, which was already known.

### MX Records

- **Purpose**: Identifies the mail server responsible for handling emails for the domain.
- **Findings**: Google handles the mail server, confirming that email management uses Gmail. Further analysis is skipped.

### NS Records

- **Purpose**: Indicates which name servers resolve the domain's FQDN (Fully Qualified Domain Name) to IP addresses.
- **Findings**: Name servers were likely associated with the hosting provider, which can reveal the provider’s identity.

### TXT Records

- **Purpose**: Contains various types of data, such as third-party verification keys and security records.
- **Key Findings**:
    - **SPF, DMARC, DKIM**: Security-focused DNS records for email verification.
    - **Verification Records**:
        - `google-site-verification`: `O7zV5-xFh_jn7JQ31`, `bow47-er9LdgoUeah`, `gZsCG-BINLopf4hr2`
        - `atlassian-domain-verification`: `IJdXMt1rKCy68JFszSdCKVpwPN`
        - `logmein-verification-code`: `87123gff5a479e-61d4325gddkbvc1-b2bnfghfsed1-3c789427sdjirew63fc`
        - `MS=ms92346782372`: Likely an identifier or user ID for a domain management platform.

### Notable Platforms and Services Identified

- **Atlassian**: Used for software development and collaboration.
- **Google Gmail**: Indicates the use of Google’s email service, suggesting potential GDrive accessibility for open resources.
- **LogMeIn**: Used for centralized remote access management; could provide system-wide access if administrator credentials are obtained.
- **Mailgun**: Offers email APIs; potential target for API vulnerabilities like IDOR, SSRF, and other HTTP methods (e.g., POST, PUT).
- **Outlook**: Suggests use of Office 365 and potentially Azure storage, which may include SMB protocol-based Azure File Storage.
- **INWX**: Likely the domain's hosting provider, with "MS" as a verification identifier potentially linked to an account username.

### IP Addresses Found

- **Additional IPs**:
    - `10.129.24.8`
    - `10.129.27.2`
    - `10.72.82.106`

### Observations

- TXT records revealed extensive information on third-party services and systems in use.
- Various email and remote management services are in use, posing potential entry points if security measures are weak.
-
### Commands
- json format

```shell
curl -s https://crt.sh/\?q\=inlanefreight.com\&output\=json | jq .
``````

- **Filter by unique subdomains

```shell
```shell-session
curl -s https://crt.sh/\?q\=inlanefreight.com\&output\=json | jq . | grep name | cut -d":" -f2 | grep -v "CN=" | cut -d'"' -f2 | awk '{gsub(/\\n/,"\n");}1;' | sort -u
``````


- Company Hosted Servers
-
```shell
 for i in $(cat subdomainlist);do host $i | grep "has address" | grep inlanefreight.com | cut -d" " -f1,4;done
```

- **shodan - IP List**
```shell
for i in $(cat subdomainlist);do host $i | grep "has address" | grep inlanefreight.com | cut -d" " -f4 >> ip-addresses.txt;done

for i in $(cat subdomainlist);do host $i | grep "has address" | grep inlanefreight.com | cut -d" " -f4 >> ip-addresses.txt;done
```

**Display all the available DNS records**

```shell
dig any <doamin>
```