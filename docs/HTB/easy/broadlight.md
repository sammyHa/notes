# Broadlight

## Nmap Enumeration
```bash
sudo nmap -sVC -A -O 10.129.231.37
```
![nmap scan](/Assets/walktrhough-assets/broadlight-namp.png)

### Website
After visiting adding the `board.htb` to the `/etc/hosts` file we can visit the site.
![website ](/Assets/walktrhough-assets/board-htb-website.png)

After visiting the the about and contact us pages we can see that the site is using `php`.

### Directory Brutfocing
Let's use the `feroxbuster` and use the -X `php` since we know the site is using the `php`.
```bash
feroxbuster -u http://board.htb
```
![feroxbuster ](/Assets/walktrhough-assets/dir-buster.png)
There is nothing new we already know most of these so let's move to the next step of enumeration.

### Subdomina brutfocing
We can use the `ffuf` for this to brutfoce the subdoamins and add them to the `/etc/hosts` file.
```bash
ffuf -u http://board.htb -H "Host: FUZZ.board.htb" -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -mc all -ac
```
We can see that the crm sbudomain is giving us a `200` status code.
![fuff scan ](/Assets/walktrhough-assets/ffuff-subdoamin.png)

We can addd it to the `/etc/hosts` file.
![etc hosts ](/Assets/walktrhough-assets/etc-hosts.png)

### crm.board.htb
let's visit the subdomain.
![crm-board ](/Assets/walktrhough-assets/crm-board.png)

We can see that the cms is `Dolibarr 17.0.0`.
This verion is vulnerable to the CVE `CVE-2023-30253`.
![https://www.swascan.com/security-advisory-dolibarr-17-0-0/]

We can use the default credentails to login to the cms but we don't have much previlages.

```bash
username: admin
password: admin
```
![crm-board ](/Assets/walktrhough-assets/cms-admin-login.png)

