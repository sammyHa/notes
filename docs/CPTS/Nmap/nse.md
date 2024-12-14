
**Overview**:  
The Nmap Scripting Engine (NSE) allows users to create and run scripts in Lua to interact with various services during network scans. This powerful feature enhances Nmap’s capabilities by providing automated checks and service interactions.

### Script Categories

|Category|Description|
|---|---|
|auth|Determines authentication credentials.|
|broadcast|Used for host discovery by broadcasting; discovered hosts can be automatically added to subsequent scans.|
|brute|Attempts to log in to services through brute-forcing with credentials.|
|default|Executes default scripts when using the `-sC` option.|
|discovery|Evaluates accessible services.|
|dos|Checks services for denial-of-service vulnerabilities (used sparingly as it can harm services).|
|exploit|Attempts to exploit known vulnerabilities on scanned ports.|
|external|Uses external services for additional processing.|
|fuzzer|Identifies vulnerabilities and unexpected packet handling by sending varied packets (may take significant time).|
|intrusive|Scripts that could negatively impact the target system.|
|malware|Checks for malware infections on the target system.|
|safe|Defensive scripts that do not perform intrusive or destructive actions.|
|version|Extension for service detection.|
|vuln|Identifies specific vulnerabilities.|

### Running NSE Scripts

**1. Default Scripts**  
Use the command below to run Nmap with default scripts:

```bash
	sudo nmap <target> -sC
	```

**2. Specific Script Category**  
Run a specific category of scripts with the command:

```bash
	sudo nmap <target> --script <category>
	```

**3. Defined Scripts**  
To specify particular scripts, use the command:

	```bash
	sudo nmap <target> --script <script-name>,<script-name>
	```

### Example: Specifying Scripts

To run specific scripts on the SMTP port, use:

```bash
	sudo nmap 10.129.2.28 -p 25 --script banner,smtp-commands
	```
#### Sample Output

```ruby
`Nmap scan report for 10.129.2.28 Host is up (0.050s latency). PORT   STATE SERVICE 25/tcp open  smtp |_banner: 220 inlane ESMTP Postfix (Ubuntu) |_smtp-commands: inlane, PIPELINING, SIZE 10240000, VRFY, ETRN, STARTTLS, ENHANCEDSTATUSCODES, 8BITMIME, DSN, SMTPUTF8, MAC Address: DE:AD:00:00:BE:EF (Intel Corporate)
```

### Aggressive Scan

To conduct an aggressive scan with multiple options:

```shell
	sudo nmap 10.129.2.28 -p 80 -A
```

#### Sample Output

makefile
```bash
	Nmap scan report for 10.129.2.28 Host is up (0.012s latency). PORT   STATE SERVICE VERSION 80/tcp open  http    Apache httpd 2.4.29 ((Ubuntu)) |_http-generator: WordPress 5.3.4 |_http-server-header: Apache/2.4.29 (Ubuntu) |_http-title: blog.inlanefreight.com
```

### Vulnerability Assessment

To scan for vulnerabilities on HTTP port 80 using NSE's vuln category:

```shell
	sudo nmap 10.129.2.28 -p 80 -sV --script vuln
	```

#### Sample Output


```ruby 
	Nmap scan report for 10.129.2.28 PORT   STATE SERVICE VERSION 80/tcp open  http    Apache httpd 2.4.29 ((Ubuntu)) | http-enum: |   /wp-login.php: Possible admin folder |   /readme.html: WordPress version: 2 |   /: WordPress version: 5.3.4 |_http-server-header: Apache/2.4.29 (Ubuntu) |_http-wordpress-users: | Username found: admin
	```

### Additional Resources

For more information on NSE scripts and categories, visit: [Nmap NSE Documentation](https://nmap.org/nsedoc/index.html)


**Next** [[Performance]]
