---
title: Cloud Resources
date: 2024-10-30
tags:
  - oscp
techniques: 
tools:
  - aws
  - gcp 
  - azure
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

1. S3 Buckets (AWS)
2. Blobs (Azure)
3. cloud storage (GCP)

**Company Hosted Servers**
```shell
for i in $(cat subdomainlist); do host $i | grep "has address" | grep inlanefreight.com | cut -d " " -f1, 4; done
```

**Cloud Storage in DNS Records**

- **Purpose of Cloud Storage in DNS**: Companies often add cloud storage services (e.g., Amazon S3) to DNS to streamline access for employees managing resources, allowing easy administrative access.
    
- **Example Observation**: During IP lookup, an IP may reveal association with cloud storage servers, such as `s3-website-us-west-2.amazonaws.com`, indicating Amazon S3 storage in use.
    
- **Discovering Cloud Storage**:
    
    - **Google Dorks**: Use `inurl:` and `intext:` operators in Google search to locate relevant cloud storage or company assets.
    - **Example Use Case**: Input company-specific terms (e.g., company name) with Google Dorks to refine results, potentially revealing publicly accessible storage paths.
- **Additional Note**: Dorking may uncover sensitive or hidden storage URLs linked to cloud services, which may be beneficial for both administrative access and security assessments.   
![[Pasted image 20241103220809.png]]

![[Pasted image 20241103220817.png]]

![[Pasted image 20241104103338.png]]

https://buckets.grayhatwarfare.com/
![[Pasted image 20241104103406.png]]
### Private and Public SSH Keys Leaked
![[Pasted image 20241104103530.png]]

