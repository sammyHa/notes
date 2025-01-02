### Catching Files over HTTP/S

#### HTTP/S Overview

Web transfer is one of the most common methods for transferring files due to HTTP/HTTPS being widely allowed through firewalls. Additionally, file transfers over HTTPS are encrypted in transit, reducing the risk of interception. However, transferring sensitive files in plaintext can trigger alerts from a client’s network IDS and lead to security concerns.

Previously, we discussed setting up a Python3 upload server for file transfers. Here, we explore creating a secure web server using Nginx for file uploads.

#### Nginx - Enabling PUT

Nginx is a robust alternative to Apache for file transfers. Its configuration is straightforward, and its module system mitigates some of the security risks inherent to Apache, such as inadvertent PHP execution.

##### Steps to Configure Nginx:

1. **Create a Directory for Uploaded Files**
    
    ```
    sudo mkdir -p /var/www/uploads/SecretUploadDirectory
    ```
    
2. **Change Ownership to** `**www-data**`
    
    ```
    sudo chown -R www-data:www-data /var/www/uploads/SecretUploadDirectory
    ```
    
3. **Create an Nginx Configuration File** Create the file `/etc/nginx/sites-available/upload.conf` with the following content:
    
    ```
    server {
        listen 9001;
        
        location /SecretUploadDirectory/ {
            root    /var/www/uploads;
            dav_methods PUT;
        }
    }
    ```
    
4. **Symlink the Site to the** `**sites-enabled**` **Directory**
    
    ```
    sudo ln -s /etc/nginx/sites-available/upload.conf /etc/nginx/sites-enabled/
    ```
    
5. **Start Nginx**
    
    ```
    sudo systemctl restart nginx.service
    ```
    
    If errors occur, check the logs at `/var/log/nginx/error.log`. For example:
    
    ```
    tail -2 /var/log/nginx/error.log
    ```
    

##### Troubleshooting:

If port 80 is already in use, identify the process using it:

```
ss -lnpt | grep 80
ps -ef | grep [PID]
```

Remove the default Nginx configuration to free up port 80:

```
sudo rm /etc/nginx/sites-enabled/default
```

##### Testing File Uploads with cURL:

Upload a file using a PUT request:

```
curl -T /etc/passwd http://localhost:9001/SecretUploadDirectory/users.txt
```

Verify the upload:

```
sudo tail -1 /var/www/uploads/SecretUploadDirectory/users.txt
```

Ensure directory listing is disabled by visiting `http://localhost/SecretUploadDirectory`. Unlike Apache, Nginx does not enable directory listing by default.

#### Using Built-in Tools

In subsequent sections, we will explore the concept of "Living off the Land," leveraging built-in utilities in Windows and Linux for file transfers and other tasks such as privilege escalation and Active Directory exploitation. This approach minimizes the need for external tools and enhances stealth during penetration tests.