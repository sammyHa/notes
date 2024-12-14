---
title: Saving the Result
date: 2024-10-23
tags:
  - "#oscp"
  - "#technique"
  - "#exploitation"
  - "#documentation"
techniques:
  - nmap scanning
  - xml to html conversion
tools:
  - nmap
  - xsltproc
machines: ""
difficulty:
  - Meduim
status:
  - completed
type: exploitation
os: Linux
categories:
  - ""
exam-priority:
  - high
time-invested: 1
notes: " - Always save scan results in multiple formats using `-oA`. - XML output can be converted to HTML for non-technical documentation using `xsltproc`."
---

### References
- [Example Tutorial](https://example.com/tutorial)
- [OSCP Exploit Documentation](https://documentation.oscp.org/exploitations)


**Saving the Results:**

- **Importance:** Always save results for later analysis and comparison between different scanning methods.

**Nmap Formats:**

1. **Normal Output (-oN):** Saves output with `.nmap` extension.
2. **Grepable Output (-oG):** Saves output with `.gnmap` extension.
3. **XML Output (-oX):** Saves output with `.xml` extension.
4. **All Formats (-oA):** Saves in all formats at once.

**Example Command:**

```shell 
sudo nmap 10.129.2.28 -p- -oA target
```

- **Target IP:** 10.129.2.28
- **Ports Scanned:** All (-p-)
- **Output Files:** `target.nmap`, `target.gnmap`, `target.xml`

**Nmap Output Examples:**

- **Normal Output:**

```shell 
cat target.nmap
```

- **Grepable Output:**

```bash
cat target.gnmap
```
![[Pasted image 20241023111452.png]]

- **XML Output:**
```shell
cat target.xml
```

---

**XML to HTML Conversion:**

- **Tool:** `xsltproc`
- **Command:**


```shell
xsltproc target.xml -o target.html
```

![[Pasted image 20241023111402.png]]
- This generates a readable HTML report from the XML file, useful for documentation.

**Next** [[Service Enumeration]]
