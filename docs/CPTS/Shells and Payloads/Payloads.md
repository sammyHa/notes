We have plenty of good options for dealing with generating payloads to use against Windows hosts. We touched on some of these already in previous sections. For example, the Metasploit-Framework and MSFVenom is a very handy way to generate payloads since it is OS agnostic. The table below lays out some of our options. However, this is not an exhaustive list, and new resources come out daily.

#### Common Payload Types

1. **DLLs**: Inject malicious DLLs for privilege escalation or UAC bypass.
2. **Batch**: Automate command execution with `.bat` files.
3. **VBS**: Lightweight scripts for phishing or macro-based attacks.
4. **MSI**: Use `.msi` files with `msiexec` for reverse shells or elevated access.
5. **PowerShell**: Dynamic scripting for shell access and automation.

#### Basic Tactics

1. **Generate Payload**: Use MSFVenom or other tools to create payloads.
2. **Obfuscate**: Utilize tools like Darkarmour to evade AV detection.
3. **Transfer Payload**: Transfer via HTTP servers (`python3 -m http.server`) or shared drives.
4. **Execute Payload**: Deploy using system utilities (e.g., `msiexec`, PowerShell).

|**Resource**|**Description**|
|---|---|
|`MSFVenom & Metasploit-Framework`|[Source](https://github.com/rapid7/metasploit-framework) MSF is an extremely versatile tool for any pentester's toolkit. It serves as a way to enumerate hosts, generate payloads, utilize public and custom exploits, and perform post-exploitation actions once on the host. Think of it as a swiss-army knife.|
|`Payloads All The Things`|[Source](https://github.com/swisskyrepo/PayloadsAllTheThings) Here, you can find many different resources and cheat sheets for payload generation and general methodology.|
|`Mythic C2 Framework`|[Source](https://github.com/its-a-feature/Mythic) The Mythic C2 framework is an alternative option to Metasploit as a Command and Control Framework and toolbox for unique payload generation.|
|`Nishang`|[Source](https://github.com/samratashok/nishang) Nishang is a framework collection of Offensive PowerShell implants and scripts. It includes many utilities that can be useful to any pentester.|
|`Darkarmour`|[Source](https://github.com/bats3c/darkarmour) Darkarmour is a tool to generate and utilize obfuscated binaries for use against Windows hosts.|

### Payload Transfer and Execution

#### Common Payload Transfer Methods

1. **Impacket**:
    
    - Python-based toolset for interacting with network protocols.
    - Key tools: `psexec`, `smbclient`, `wmi`, Kerberos, SMB server setup.
    - [GitHub](https://github.com/fortra/impacket)
2. **SMB (Server Message Block)**:
    
    - Transfer payloads using SMB shares like `C$` or `admin$`.
    - Useful for domain-joined hosts with shared data.
3. **Payloads All The Things**:
    
    - Resource for one-liners to transfer files quickly across hosts.
    - [GitHub](https://github.com/swisskyrepo/PayloadsAllTheThings)
4. **Remote Execution via Metasploit**:
    
    - Automates payload building, staging, and execution.
    - Integrates into many exploit modules.
5. **Other Protocols**:
    
    - **FTP/TFTP/HTTP/HTTPS**: Use available protocols for file uploads.
    - Enumerate open ports to find transfer options.

#### Key Tactics

- Use **Impacket’s SMB server** for hosting payloads.
- Leverage **MSF modules** to streamline delivery and execution.
- Utilize SMB shares for payload hosting or data exfiltration.
- Focus on protocol enumeration to identify delivery opportunities.