### Protected File Transfers

As penetration testers, we often gain access to highly sensitive data such as user lists, credentials (e.g., downloading the NTDS.dit file for offline password cracking), and enumeration data that can contain critical information about the organization's network infrastructure and Active Directory (AD) environment. It is essential to encrypt this data or use encrypted data connections such as SSH, SFTP, and HTTPS. However, when these options are unavailable, alternative approaches are required.

**Note:** Unless specifically requested by a client, we do not recommend exfiltrating data such as Personally Identifiable Information (PII), financial data (e.g., credit card numbers), or trade secrets from a client environment. For testing Data Loss Prevention (DLP) controls or egress filtering protections, create a file with dummy data that mimics the data the client is trying to protect. Encrypting the data or files before transfer is crucial to prevent interception during transit.

Data leakage during a penetration test could have severe consequences for the penetration tester, their company, and the client. As information security professionals, we must act responsibly and take all measures to protect any data encountered during an assessment.

---

### File Encryption on Windows

Many methods can encrypt files and information on Windows systems. One of the simplest methods is using the `Invoke-AESEncryption.ps1` PowerShell script. This script provides encryption of files and strings.

#### Invoke-AESEncryption.ps1
```
<#
.SYNOPSIS
Encryptes or Decrypts Strings or Byte-Arrays with AES
 
.DESCRIPTION
Takes a String or File and a Key and encrypts or decrypts it with AES256 (CBC)
 
.PARAMETER Mode
Encryption or Decryption Mode
 
.PARAMETER Key
Key used to encrypt or decrypt
 
.PARAMETER Text
String value to encrypt or decrypt
 
.PARAMETER Path
Filepath for file to encrypt or decrypt
 
.EXAMPLE
Invoke-AESEncryption -Mode Encrypt -Key "p@ssw0rd" -Text "Secret Text"
 
Description
-----------
Encrypts the string "Secret Test" and outputs a Base64 encoded cipher text.
 
.EXAMPLE
Invoke-AESEncryption -Mode Decrypt -Key "p@ssw0rd" -Text "LtxcRelxrDLrDB9rBD6JrfX/czKjZ2CUJkrg++kAMfs="
 
Description
-----------
Decrypts the Base64 encoded string "LtxcRelxrDLrDB9rBD6JrfX/czKjZ2CUJkrg++kAMfs=" and outputs plain text.
 
.EXAMPLE
Invoke-AESEncryption -Mode Encrypt -Key "p@ssw0rd" -Path file.bin
 
Description
-----------
Encrypts the file "file.bin" and outputs an encrypted file "file.bin.aes"
 
.EXAMPLE
Invoke-AESEncryption -Mode Encrypt -Key "p@ssw0rd" -Path file.bin.aes
 
Description
-----------
Decrypts the file "file.bin.aes" and outputs an encrypted file "file.bin"
#>
function Invoke-AESEncryption {
    [CmdletBinding()]
    [OutputType([string])]
    Param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Encrypt', 'Decrypt')]
        [String]$Mode,

        [Parameter(Mandatory = $true)]
        [String]$Key,

        [Parameter(Mandatory = $true, ParameterSetName = "CryptText")]
        [String]$Text,

        [Parameter(Mandatory = $true, ParameterSetName = "CryptFile")]
        [String]$Path
    )

    Begin {
        $shaManaged = New-Object System.Security.Cryptography.SHA256Managed
        $aesManaged = New-Object System.Security.Cryptography.AesManaged
        $aesManaged.Mode = [System.Security.Cryptography.CipherMode]::CBC
        $aesManaged.Padding = [System.Security.Cryptography.PaddingMode]::Zeros
        $aesManaged.BlockSize = 128
        $aesManaged.KeySize = 256
    }

    Process {
        $aesManaged.Key = $shaManaged.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($Key))

        switch ($Mode) {
            'Encrypt' {
                if ($Text) {$plainBytes = [System.Text.Encoding]::UTF8.GetBytes($Text)}
                
                if ($Path) {
                    $File = Get-Item -Path $Path -ErrorAction SilentlyContinue
                    if (!$File.FullName) {
                        Write-Error -Message "File not found!"
                        break
                    }
                    $plainBytes = [System.IO.File]::ReadAllBytes($File.FullName)
                    $outPath = $File.FullName + ".aes"
                }

                $encryptor = $aesManaged.CreateEncryptor()
                $encryptedBytes = $encryptor.TransformFinalBlock($plainBytes, 0, $plainBytes.Length)
                $encryptedBytes = $aesManaged.IV + $encryptedBytes
                $aesManaged.Dispose()

                if ($Text) {return [System.Convert]::ToBase64String($encryptedBytes)}
                
                if ($Path) {
                    [System.IO.File]::WriteAllBytes($outPath, $encryptedBytes)
                    (Get-Item $outPath).LastWriteTime = $File.LastWriteTime
                    return "File encrypted to $outPath"
                }
            }

            'Decrypt' {
                if ($Text) {$cipherBytes = [System.Convert]::FromBase64String($Text)}
                
                if ($Path) {
                    $File = Get-Item -Path $Path -ErrorAction SilentlyContinue
                    if (!$File.FullName) {
                        Write-Error -Message "File not found!"
                        break
                    }
                    $cipherBytes = [System.IO.File]::ReadAllBytes($File.FullName)
                    $outPath = $File.FullName -replace ".aes"
                }

                $aesManaged.IV = $cipherBytes[0..15]
                $decryptor = $aesManaged.CreateDecryptor()
                $decryptedBytes = $decryptor.TransformFinalBlock($cipherBytes, 16, $cipherBytes.Length - 16)
                $aesManaged.Dispose()

                if ($Text) {return [System.Text.Encoding]::UTF8.GetString($decryptedBytes).Trim([char]0)}
                
                if ($Path) {
                    [System.IO.File]::WriteAllBytes($outPath, $decryptedBytes)
                    (Get-Item $outPath).LastWriteTime = $File.LastWriteTime
                    return "File decrypted to $outPath"
                }
            }
        }
    }

    End {
        $shaManaged.Dispose()
        $aesManaged.Dispose()
    }
}
```
**Example Usage:**

1. **Encrypt a String:**
    
    ```
    Invoke-AESEncryption -Mode Encrypt -Key "p@ssw0rd" -Text "Secret Text"
    ```
    
    **Description:** Encrypts the string "Secret Text" and outputs a Base64 encoded ciphertext.
    
2. **Decrypt a String:**
    
    ```
    Invoke-AESEncryption -Mode Decrypt -Key "p@ssw0rd" -Text "LtxcRelxrDLrDB9rBD6JrfX/czKjZ2CUJkrg++kAMfs="
    ```
    
    **Description:** Decrypts the Base64 encoded string and outputs plain text.
    
3. **Encrypt a File:**
    
    ```
    Invoke-AESEncryption -Mode Encrypt -Key "p@ssw0rd" -Path file.bin
    ```
    
    **Description:** Encrypts the file "file.bin" and outputs "file.bin.aes".
    
4. **Decrypt a File:**
    
    ```
    Invoke-AESEncryption -Mode Decrypt -Key "p@ssw0rd" -Path file.bin.aes
    ```
    
    **Description:** Decrypts "file.bin.aes" and outputs the original file.
    

**Importing and Using the Script:**

Transfer the script to the target host and import it as a module:

```
PS C:\htb> Import-Module .\Invoke-AESEncryption.ps1
```

**Encrypting a File Example:**

```
PS C:\htb> Invoke-AESEncryption -Mode Encrypt -Key "p4ssw0rd" -Path .\scan-results.txt
```

**Output:**

```
File encrypted to C:\htb\scan-results.txt.aes
```

**Note:** Use strong and unique passwords for encryption for each company to prevent sensitive information from being decrypted with a compromised password.

---

### File Encryption on Linux

`OpenSSL` is a common tool included in Linux distributions, often used for generating security certificates and encrypting files.

#### Encrypting Files with OpenSSL

**Example:**

```
openssl enc -aes256 -iter 100000 -pbkdf2 -in /etc/passwd -out passwd.enc
```

**Description:** Encrypts "/etc/passwd" using AES-256 encryption.

**Decrypting Files:**

```
openssl enc -d -aes256 -iter 100000 -pbkdf2 -in passwd.enc -out passwd
```

**Description:** Decrypts "passwd.enc" back to its original format.

**Best Practices:**

- Always use strong, unique passwords to avoid brute-force attacks.
    
- Use secure transport methods such as HTTPS, SFTP, or SSH to transfer files.
    

---

### Secure File Transfers

When transferring files during penetration tests, always prioritize secure protocols:

- **SSH, SFTP, HTTPS:** Preferred methods for transferring encrypted data.
    
- **Alternative Tools:** Practice examples using target hosts or modules such as Pwnbox to replicate secure file transfer scenarios.
    

By encrypting sensitive files and leveraging secure transfer methods, penetration testers can mitigate risks associated with data interception and ensure responsible handling of client information.