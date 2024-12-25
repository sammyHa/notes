# John the Ripper (JtR) Comprehensive Guide

## Table of Contents

1. Introduction to John the Ripper
    
2. Basic Usage
    
3. Working with Wordlists
    
4. Cracking Password Hashes
    
5. Advanced Techniques
    
6. Cracking Encrypted PDFs
    
7. Custom Rules
    
8. Tips and Optimization
    
9. References
    

---

## 1. Introduction to John the Ripper

John the Ripper (JtR) is a versatile and powerful password-cracking tool used by penetration testers and security professionals. It supports numerous hash types and offers extensive customization options.

### Installation

1. On Linux-based systems:
    
    ```
    sudo apt update
    sudo apt install john
    ```
    
2. Clone the Jumbo version (recommended for additional features):
    
    ```
    git clone https://github.com/openwall/john.git
    cd john/src
    ./configure && make
    ```
    
3. Verify the installation:
    
    ```
    john --version
    ```
    

---

## 2. Basic Usage

### Syntax

```
john [options] <file>
```

### Example: Cracking a Basic Hash File

1. Create a hash file (e.g., `hashes.txt`):
    
    ```
    admin:$6$randomhashvalue
    ```
    
2. Run JtR:
    
    ```
    john hashes.txt
    ```
    
3. View results:
    
    ```
    john --show hashes.txt
    ```
    

---

## 3. Working with Wordlists

### Using a Wordlist

```
john --wordlist=<path_to_wordlist> <file>
```

#### Example:

```
john --wordlist=/usr/share/wordlists/rockyou.txt hashes.txt
```

### Generating Wordlists with `--rules`

```
john --wordlist=/usr/share/wordlists/rockyou.txt --rules hashes.txt
```

---

## 4. Cracking Password Hashes

### Supported Hash Types

List all supported formats:

```
john --list=formats
```

### Specify a Format

```
john --format=<format> hashes.txt
```

#### Example: Cracking MD5 Hashes

```
john --format=raw-md5 hashes.txt
```

---

## 5. Advanced Techniques

### Incremental Mode

Incremental mode uses brute force to generate possible passwords:

```
john --incremental hashes.txt
```

### External Mode

Leverage custom cracking logic:

```
john --external=<mode> hashes.txt
```

---

## 6. Cracking Encrypted PDFs

### Extract Hash from a PDF

Use the `pdf2john` utility (bundled with JtR):

```
python3 pdf2john.py <file.pdf> > pdf_hash.txt
```

### Crack the PDF Password

```
john --wordlist=/usr/share/wordlists/rockyou.txt pdf_hash.txt
```

### Show Results

```
john --show pdf_hash.txt
```

---

## 7. Custom Rules

### Adding Custom Rules in `john.conf`

1. Open the configuration file:
    
    ```
    nano ~/.john/john.conf
    ```
    
2. Add a rule under the `[List.Rules:Wordlist]` section:
    
    ```
    Az"s[0-9]"
    ```
    
3. Apply the rule during cracking:
    
    ```
    john --wordlist=/usr/share/wordlists/rockyou.txt --rules hashes.txt
    ```
    

---

## 8. Tips and Optimization

### Restore a Cracking Session

If a session is interrupted, restore it with:

```
john --restore
```

### Save a Session

Save progress in a named session:

```
john --session=my_session hashes.txt
```

### Parallel Processing

Use OpenMP to utilize multiple CPU cores:

```
john --fork=<num_of_cores> hashes.txt
```

---

## 9. References

- [John the Ripper Documentation](https://www.openwall.com/john/)
    
- [RockYou Wordlist](https://github.com/brannondorsey/naive-hashcat/releases/download/data/rockyou.txt)