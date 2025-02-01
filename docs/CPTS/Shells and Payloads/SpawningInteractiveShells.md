### Spawning Interactive Shells
- **Initial Shell**:
    
    - Often, the initial shell is **limited** (jail shell).
    - Use **Python** to spawn a **TTY Bourne shell** for full command access and better usability.
- **Alternative Methods** (If Python is not available):
    
    - Utilize other binaries or methods to **spawn an interactive shell**.
    - Examples:
        - `/bin/sh`
        - `/bin/bash`
        - Other shell interpreter binaries present on the system.
- **Common Shells**:
    
    - **Bourne Shell (`/bin/sh`)**
    - **Bourne Again Shell (`/bin/bash`)**
    - These are often **natively present** on most Linux systems.
- **Practical Relevance**:
    
    - Encountered frequently on **Hack The Box** and **real-world engagements**.
    - Knowing multiple shell-spawning techniques is crucial for overcoming limitations.

### /bin/sh -i
This command will execute the shell interpreter specified in the path in interactive mode (-i).
```bash
/bin/sh -i
sh: no job control in this shell
sh-4.2$
```

### Perl
If the programming language Perl is present on the system, these commands will execute the shell interpreter specified.
```bash
perl —e 'exec "/bin/sh";'
```
```bash
perl: exec "/bin/sh";
```
The command directly above should be run from a script.

### Ruby
If the programming language Ruby is present on the system, this command will execute the shell interpreter specified:
```bash
ruby: exec "/bin/sh"
```
The command directly above should be run from a script.

### Lua
If the programming language Lua is present on the system, we can use the os.execute method to execute the shell interpreter specified using the full command below:

### Lua To Shell
Spawning Interactive Shells
lua: os.execute('/bin/sh')
The command directly above should be run from a script.

### AWK
AWK is a C-like pattern scanning and processing language present on most UNIX/Linux-based systems, widely used by developers and sysadmins to generate reports. It can also be used to spawn an interactive shell. This is shown in the short awk script below:

### AWK Shell
```bash
awk 'BEGIN {system("/bin/sh")}'
```

### Find
Find is a command present on most Unix/Linux systems widely used to search for & through files and directories using various criteria. It can also be used to execute applications and invoke a shell interpreter.

### Using Find For A Shell
```bash
find / -name nameoffile -exec /bin/awk 'BEGIN {system("/bin/sh")}' \;
```
This use of the find command is searching for any file listed after the -name option, then it executes awk (/bin/awk) and runs the same script we discussed in the awk section to execute a shell interpreter.

### Using Exec To Launch A Shell
```bash
find . -exec /bin/sh \; -quit
```
This use of the find command uses the execute option (-exec) to initiate the shell interpreter directly. If find can't find the specified file, then no shell will be attained.

### VIM
Yes, we can set the shell interpreter language from within the popular command-line-based text-editor VIM. This is a very niche situation we would find ourselves in to need to use this method, but it is good to know just in case.

### Vim To Shell
```bash
vim -c ':!/bin/sh'
```

### Vim Escape
```bash
vim
:set shell=/bin/sh
:shell
```
### Execution Permissions Considerations
In addition to knowing about all the options listed above, we should be mindful of the permissions we have with the shell session's account. We can always attempt to run this command to list the file properties and permissions our account has over any given file or binary:

### Permission
```bash
ls -la <path/to/fileorbinary>
```
We can also attempt to run this command to check what `sudo` permissions the account we landed on has:

### Sudo -l
The sudo -l command above will need a stable interactive shell to run. If you are not in a full shell or sitting in an unstable shell, you may not get any return from it. Not only will considering permissions allow us to see what commands we can execute, but it may also start to give us an idea of potential vectors that will allow us to escalate privileges.

