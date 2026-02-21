# Day 08 – Cloud Server Setup: Docker, Nginx & Web Deployment

## Task
Today's goal is to **deploy a real web server on the cloud** and learn practical server management.

## nginx is deployed in utho cloud 

### What is nginx?
  Nginx is a high-performance web server and reverse proxy that handles HTTP requests, load balancing, and serving static content efficiently.

- Nginx is installed by using 
  ```bash
  $ apt install nginx
  ```
- Verify nginx
  ``` bash
  $ nginx -v
  ```
- Start nginx 
- ```bash
  $ systemctl start nginx
  # check status
  $ systemctl status nginx
  ```

- Getting ip of the machine.
  ``` bash
  $ ip addr
  ```
- After getting the ip address go to browser and type public ip of the instance followed by :80
  ![nginx](./nginx%20screenshot.png)
- Nginx is running in port 80

- Collecting Nginx logs:
  ``` bash 
  $ cat /var/log/nginx/access.log
  ```

### Download Log File to Your Local Machine
```bash
#To get the file from remote to local machine 
scp -i your-key.pem ubuntu@<your-instance-ip>:~/nginx_log.txt .
```

## Why This Matters for DevOps

This exercise teaches you:
- **Cloud infrastructure provisioning** - launching and configuring servers
- **Remote server management** - SSH, security, access control
- **Service deployment** - installing and running applications
- **Log management** - accessing and analyzing logs
- **Security** - configuring firewalls and security groups

These are core skills for any DevOps engineer working in production.