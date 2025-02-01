# Detection & Prevention Summary
- Focus Areas: Detect active shells, payloads, and network activity to identify and respond to attacks.
- MITRE ATT&CK Framework: Defines tactics attackers use. Key techniques include:
    - **Initial Access:** Gaining a foothold via web apps, misconfigured services, or vulnerabilities.
    - **Execution:** Running attacker-supplied code using methods like PowerShell, exploits, or file uploads.
    - **Command & Control (C2):** Maintaining access using standard ports/protocols (e.g., HTTP, DNS) or obfuscated methods.
### Key Detection Points
- **File Uploads:** Monitor logs for unusual uploads, especially to web applications.
- **Suspicious User Actions:** Watch for unexpected commands (e.g., whoami) or irregular SMB usage.
- **Anomalous Network Traffic:** Track unusual patterns, nonstandard ports (e.g., 4444), or spikes in GET/POST requests.
### Enhancing Network Visibility
- **Documentation & Visualization:** Maintain detailed network diagrams and use tools like Draw.io or NetBrain for interactive topology mapping.
- **Layer 7 Visibility:** Use modern network devices with traffic baselines, dashboards, and cloud controllers (e.g., Cisco Meraki, Palo Alto).
- **Deep Packet Inspection (DPI):** Inspect network traffic to detect and block unencrypted malicious payloads like Netcat-based traffic.
## Best Practices
- Establish baselines for normal activity.
- React quickly to deviations to minimize damage.
- Use network security appliances and monitoring tools (e.g., SIEMs, NetFlow).

### Protecting End Devices
End devices are the devices that connect at the "end" of a network. This means they are either the source or destination of data transmission. Some examples of end devices would be:

- Workstations (employees computers)
- Servers (providing various services on the network)
- Printers
- Network Attached Storage (NAS)
- Cameras
- Smart TVs
- Smart Speakers

### Potential Mitigations Summary
- **Application Sandboxing:** Isolate applications exposed to the internet to limit the impact of vulnerabilities or misconfigurations.

- **Least Privilege Policies:** Restrict user permissions to the minimum required for their roles. Prevent unnecessary administrative or domain-level access.

- **Host Segmentation & Hardening:**
    - Harden systems using standards like STIG guidelines.
    - Segregate internet-facing systems (e.g., web or VPN servers) into a DMZ to prevent lateral movement in the network.

- **Firewalls:**
    - Use physical and application-layer firewalls to enforce strict traffic rules.
    - Allow only necessary traffic and block unauthorized inbound/outbound connections.
    - Employ NAT to disrupt malicious shell payload functionality.

##### Conclusion

This module covered the basics of shells & payloads, ways to transfer & execute payloads to gain a shell on Windows & Linux systems. It introduced detection & prevention methods that can be implemented in any network environment.

### Module Key Takeaways

- Established an understanding of the difference between `Bind` & `Reverse` shells
- Experimented with common `one-liners` and studied them at a detailed level
- Used `Metasploit` to deploy a `payload` and establish a shell session
- Used `MSFvenom` to craft a payload
- Identified various methods of `spawning interactive shells`
- Experimented with various methods of gaining `web` shell sessions on web servers
- Applied an `enumeration methodology` to identify payloads & shells that would be useful in different situations
- Explored `detection` and `prevention` techniques