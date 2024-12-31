## Certutil

Certutil is a versatile command-line utility included in Windows for managing certificates and keys, diagnosing issues, and performing various cryptographic operations. This cheatsheet covers its essential uses, from basic to advanced tasks.

---

### **Basics**

#### Display Help

```
certutil -?
```

Displays the list of all available commands and options for certutil.

#### Check Certutil Version

```
certutil -version
```

Shows the installed version of certutil.

#### Display Cryptographic Service Provider (CSP) Information

```
certutil -csplist
```

Lists all available CSPs and their capabilities.

---

### **Certificate Management**

#### View Certificates in a Store

```
certutil -store my
```

Displays all certificates in the specified store (e.g., `my`, `CA`, `root`).

#### Add a Certificate to a Store

```
certutil -addstore root certfile.cer
```

Adds a certificate file to the specified store (e.g., `root`, `my`).

#### Remove a Certificate from a Store

```
certutil -delstore my "SerialNumber"
```

Removes a certificate with the specified serial number from the store.

#### Export a Certificate

```
certutil -store my "SerialNumber" > cert.cer
```

Exports a certificate to a `.cer` file.

#### Verify a Certificate

```
certutil -verify certfile.cer
```

Validates a certificate’s trust chain and revocation status.

---

### **Private Keys**

#### Export Private Key

```
certutil -exportPFX my "SerialNumber" output.pfx
```

Exports a certificate and private key as a PFX file. May require permissions.

#### Import a PFX File

```
certutil -f -p "password" -importPFX my file.pfx
```

Imports a PFX file into the specified certificate store.

#### List Key Containers

```
certutil -key
```

Lists key containers available on the system.

---

### **Cryptographic Operations**

#### Encode a File to Base64

```
certutil -encode input.txt output.b64
```

Encodes the contents of `input.txt` to Base64 format.

#### Decode a Base64 File

```
certutil -decode input.b64 output.txt
```

Decodes a Base64-encoded file back to its original format.

#### Hash a File

```
certutil -hashfile file.txt SHA256
```

Generates a hash for the specified file using algorithms like `MD5`, `SHA1`, or `SHA256`.

#### Generate a Random Key

```
certutil -getrandom 32 random.key
```

Generates 32 random bytes and saves them to `random.key`.

---

### **Diagnostics and Troubleshooting**

#### Test Certificate Chain

```
certutil -verify -urlfetch certfile.cer
```

Performs a detailed test of a certificate’s chain, including CRL and AIA retrieval.

#### Check Configuration

```
certutil -config -
```

Displays available certificate authorities (CAs) for enrollment.

#### Test Connectivity to CA

```
certutil -ping CAName
```

Tests connectivity to a specified CA.

#### Decode a Certificate or CRL

```
certutil -dump certfile.cer
```

Displays detailed information about a certificate or CRL.

---

### **Advanced Tasks**

#### Create a Self-Signed Certificate

```
certutil -selfsign -f -v mycert.cer
```

Generates a self-signed certificate.

#### Generate a Certificate Request

```
certutil -newreq -f -v myrequest.req mykey.key
```

Creates a certificate signing request (CSR) and saves the key.

#### Retrieve and Install a Certificate from CA

```
certutil -retrieve 1234 output.cer
certutil -addstore my output.cer
```

Retrieves a certificate by request ID (`1234`) and installs it.

#### View CA Certificate Revocation List (CRL)

```
certutil -viewstore root
```

Displays the CRL of a CA in the root store.

---

### **Useful Tips**

- Use `-f` to force an action if prompted for confirmation.
    
- Always back up critical certificates or keys before performing actions.
    
- Combine certutil with PowerShell or batch scripts for automation.
    

### **Resources**

- [Microsoft Documentation on Certutil](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/certutil)
    
- Explore `certutil -?` for additional advanced options.