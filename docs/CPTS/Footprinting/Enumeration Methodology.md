---
title: Enumeration Methodology
date: 2024-10-30
tags:
  - oscp
  - methodology
  - enumeration
techniques:
  - infrastructure-based enumeration
  - host-based enumeration
  - os-based enumeration
  - layered enumeration
  - Infrastructure Analysis
tools: 
machines: 
difficulty:
  - Meduim
status:
  - completed
type: Enumeration Strategy
os: 
categories:
  - standardized processes
exam-priority:
  - high
time-invested: 2
---

>[!tip]- Tip
>	Tip one
>	Tip two


### Summary

Complex processes in penetration testing require a standardized methodology to ensure consistency and thoroughness, especially given the unpredictability of target system cases. While many testers rely on personal experience or familiar steps, a standardized approach is more reliable for comprehensive results.

### Key Points

- **Dynamic vs. Static Methodology**: Penetration testing, including enumeration, is dynamic. However, having a static methodology allows consistency and adaptability.
- **6-Layered Methodology**: Enumeration is divided into six metaphorical layers representing boundaries to be passed.
- **Three Levels of Enumeration**:
    1. **Infrastructure-based Enumeration**: Focuses on network and infrastructure-level elements.
    2. **Host-based Enumeration**: Involves information gathering at the host level.
    3. **OS-based Enumeration**: Targets OS-specific details for deeper insights.

### Enumeration Strategy

- **Standardized Approach**: Reduces chances of missing critical steps and adapts to the unique nature of each environment.
- **Dynamic Adaptability**: Methodology supports flexibility, allowing testers to adjust their techniques as they learn more about the target environment.

### Takeaways & Lessons Learned

- Using a standardized approach helps streamline complex testing processes.
- Balancing static structure with dynamic flexibility in methodology enhances effectiveness.

### References

- OSCP Testing Methodology Documentation
- Penetration Testing Execution Standard (PTES)

![[Pasted image 20241030103446.png]]

### Summary

This 6-layer enumeration approach treats each layer as an "obstacle" that needs analysis to locate points of access or weaknesses. Instead of brute-forcing through these layers, penetration testers are encouraged to explore systematically, aiming to find optimal entry points rather than forcing access inefficiently.

### Layered Enumeration Breakdown

| **Layer**                | **Description**                                                                                        | **Information Categories**                                                                         |     |     |
| ------------------------ | ------------------------------------------------------------------------------------------------------ | -------------------------------------------------------------------------------------------------- | --- | --- |
| `1. Internet Presence`   | Identification of internet presence and externally accessible infrastructure.                          | Domains, Subdomains, vHosts, ASN, Netblocks, IP Addresses, Cloud Instances, Security Measures      |     |     |
| `2. Gateway`             | Identify the possible security measures to protect the company's external and internal infrastructure. | Firewalls, DMZ, IPS/IDS, EDR, Proxies, NAC, Network Segmentation, VPN, Cloudflare                  |     |     |
| `3. Accessible Services` | Identify accessible interfaces and services that are hosted externally or internally.                  | Service Type, Functionality, Configuration, Port, Version, Interface                               |     |     |
| `4. Processes`           | Identify the internal processes, sources, and destinations associated with the services.               | PID, Processed Data, Tasks, Source, Destination                                                    |     |     |
| `5.Privileges`           | Identification of the internal permissions and privileges to the accessible services.                  | Groups, Users, Permissions, Restrictions, Environment                                              |     |     |
| `6. OS Setup`            | Identification of the internal components and systems setup.                                           | OS Type, Patch Level, Network config, OS Environment, Configuration files, sensitive private files |     |     |
|                          |                                                                                                        |                                                                                                    |     |     |


1. **Layer 1 - Internet Presence**: Focuses on the identification of external infrastructure and internet-facing assets.
    
    - **Information Categories**: Domains, subdomains, vHosts, ASN, IP addresses, cloud instances, security measures.
2. **Layer 2 - Gateway**: Identifies external and internal security measures protecting the company's assets.
    
    - **Information Categories**: Firewalls, DMZ, IPS/IDS, EDR, proxies, NAC, network segmentation, VPN, services like Cloudflare.
3. **Layer 3 - Accessible Services**: Enumeration of accessible services/interfaces, focusing on configurations and details.
    
    - **Information Categories**: Service type, functionality, configuration, port, version, interface.
4. **Layer 4 - Processes**: Examines internal processes associated with the identified services.
    
    - **Information Categories**: Process IDs (PIDs), processed data, tasks, sources, destinations.
5. **Layer 5 - Privileges**: Focuses on permissions and privileges within the environment, identifying possible access points.
    
    - **Information Categories**: Groups, users, permissions, restrictions, environment setup.
6. **Layer 6 - OS Setup**: Explores the operating system setup and configurations for security and sensitive file identification.
    
    - **Information Categories**: OS type, patch level, network configuration, OS environment, configuration files, sensitive files.

### Takeaways & Lessons Learned

- Each layer builds on the previous, creating a structured and comprehensive view of the target environment.
- Avoid brute-forcing entry points; instead, focus on strategic entry based on the identified weaknesses in each layer.

### Important Notes

- OSINT on employees or human factors has been excluded from the “Internet Presence” layer for simplicity.

### References

- Layered Enumeration Framework Guide
- Comprehensive OSCP Enumeration Strategies