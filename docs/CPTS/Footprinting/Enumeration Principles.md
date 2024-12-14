---
title: Enumeration Principles
date: 2024-10-25
tags:
  - "#oscp"
  - "#technique"
  - footprinting
  - enumeration
techniques:
  - enumeration
  - footprint
tools:
  - ""
  - ""
machines: ""
difficulty:
  - ""
status:
  - completed
type: ""
os: ""
categories:
  - ""
exam-priority:
  - hard
time-invested: 
notes: |
  Key points and takeaways from the exercise.
---

### References
- [Example Tutorial](https://example.com/tutorial)
- [OSCP Exploit Documentation](https://documentation.oscp.org/exploitations)

### **Enumeration Principles**

**Definition**:

- **Enumeration** involves gathering information actively (through scans) and passively (using third-party providers).
- It is distinct from **OSINT**, which only uses passive gathering and should be separate from active enumeration.

**Purpose**:

- **Goal**: Repeatedly gather information from known or discovered data points.
- **Focus**: Understand target infrastructure (domains, IPs, services) rather than blindly attacking.

**Approach**:

- **Identify Services and Protocols**: Once targets are identified, examine protocols and services enabling interactions (e.g., SSH, RDP, WinRM).
- **Strategy Over Force**: Understand company structure, services, and security measures instead of brute-forcing blindly, which is noisy and can lead to blacklisting.
- **Analogy**: Like a treasure hunter, plan carefully, gather tools, and study the environment before “digging.”

### **Core Enumeration Questions**

1. **What can we see?**
2. **Why can we see it?**
3. **What image does what we see create for us?**
4. **What do we gain from it?**
5. **How can we use it?**
6. **What can we not see?**
7. **Why might it be hidden?**
8. **What image results from what we do not see?**

### **Enumeration Principles**

|No.|Principle|
|---|---|
|1|**There is more than meets the eye** - Consider all perspectives.|
|2|**Distinguish between what we see and what we do not see** - Both are relevant.|
|3|**There are always ways to gain more information** - Understand the target fully.|

### **Application**:

- The principles encourage technical understanding over brute-force tactics.
- Focus on **seeing hidden components** with experience and planning.