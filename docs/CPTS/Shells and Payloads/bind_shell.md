## Bind Shell
In many cases, we will be working to establish a shell on a system on a local or remote network. This means we will be looking to use the terminal emulator application on our local attack box to control the remote system through its shell. This is typically done by using a Bind &/or Reverse shell.

### What Is It?
With a bind shell, the target system has a listener started and awaits a connection from a pentester's system (attack box).

### Bind Example

![bind shell](/Assets/attachments/bindshell.png)

As seen in the image, we would connect directly with the IP address and port listening on the target. There can be many challenges associated with getting a shell this way. Here are some to consider:

- There would have to be a listener already started on the target.
- If there is no listener started, we would need to find a way to make this happen.
- Admins typically configure strict incoming firewall rules and NAT (with PAT implementation) on the edge of the network (public-facing), so we would need to be on the internal network already.
- Operating system firewalls (on Windows & Linux) will likely block most incoming connections that aren't associated with trusted network-based applications.