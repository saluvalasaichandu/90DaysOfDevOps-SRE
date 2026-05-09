# 🚀 Day 08 – Cloud Server Setup: Docker, Nginx & Web Deployment

# 📌 Introduction

Deploying applications on cloud servers is one of the most important responsibilities of a DevOps Engineer.

In real-world environments, DevOps Engineers frequently:

* Launch cloud servers
* Connect remotely using SSH
* Install applications and services
* Configure firewalls/security groups
* Deploy web applications
* Monitor logs and troubleshoot issues

In today’s hands-on practice, I worked on:
✅ Launching an AWS EC2 Instance
✅ Connecting via SSH
✅ Installing Docker & Nginx
✅ Configuring Security Groups
✅ Hosting a Web Server
✅ Extracting and Managing Logs

This exercise simulates real-world cloud infrastructure and server management tasks.

---

# ☁️ What is a Cloud Server?

A cloud server is a virtual machine hosted by cloud providers like:

* Amazon Web Services
* Utho
* Google Cloud
* Microsoft Azure

Cloud servers provide:

* Compute resources
* Storage
* Networking
* Scalability
* Remote accessibility

---

# 🖥️ Part 1 – Launch Cloud Instance

# 🎯 Objective

Create a Linux server in AWS EC2.

---

# 🔹 Step 1 – Launch EC2 Instance

## Configuration Used

| Setting        | Value            |
| -------------- | ---------------- |
| AMI            | Ubuntu 24.04     |
| Instance Type  | t2.micro         |
| Storage        | 8 GB             |
| Security Group | Allow SSH & HTTP |
| Key Pair       | day08-key.pem    |

---

# 🔹 Step 2 – Configure Security Group

Allowed inbound ports:

| Port | Purpose     |
| ---- | ----------- |
| 22   | SSH Access  |
| 80   | HTTP Access |

This allows:

* SSH remote login
* Public web access

---

# 🔹 Step 3 – Connect via SSH

## Command

```bash
ssh -i day08-key.pem ubuntu@<PUBLIC-IP>
```

## Example

```bash
ssh -i day08-key.pem ubuntu@54.210.10.25
```

## Purpose

Connects securely to remote Linux server.

---

# 🔹 Verify Connection

## Command

```bash
hostname
```

## Observation

Successfully connected to AWS EC2 Ubuntu server.

---

# 🐳 Part 2 – Install Docker

# 📌 Why Docker?

Docker helps package applications into containers.

Benefits:

* Portability
* Consistency
* Fast deployments
* Isolation

---

# 🔹 Update System Packages

## Command

```bash
sudo apt update && sudo apt upgrade -y
```

## Purpose

Updates package repositories and system packages.

---

# 🔹 Install Docker

## Command

```bash
sudo apt install docker.io -y
```

---

# 🔹 Start Docker Service

## Command

```bash
sudo systemctl start docker
sudo systemctl enable docker
```

## Purpose

* Starts Docker service
* Enables Docker during reboot

---

# 🔹 Verify Docker Installation

## Command

```bash
docker --version
```

## Example Output

```text
Docker version 27.5.1
```

---

# 🔹 Check Docker Service Status

## Command

```bash
sudo systemctl status docker
```

## Observation

Docker service is active and running.

---

# 🌐 Part 3 – Install Nginx

# 📌 What is Nginx?

Nginx is a high-performance web server used for:

* Hosting websites
* Reverse proxy
* Load balancing
* API routing

---

# 🔹 Install Nginx

## Command

```bash
sudo apt install nginx -y
```

---

# 🔹 Start Nginx Service

## Command

```bash
sudo systemctl start nginx
sudo systemctl enable nginx
```

---

# 🔹 Verify Nginx Status

## Command

```bash
sudo systemctl status nginx
```

## Observation

Nginx service is active and running.

---

# 🔓 Part 4 – Configure Security Group for Web Access

# 📌 Why Security Groups Matter

Security Groups act like firewalls for cloud servers.

Without opening port 80:

* Browser cannot access website

---

# 🔹 Allow HTTP Traffic

## Inbound Rule Added

| Type | Port |
| ---- | ---- |
| HTTP | 80   |

---

# 🔹 Test Website Access

Open browser:

```text
http://<PUBLIC-IP>
```

## Example

```text
http://54.210.10.25
```

## Observation

Nginx Welcome Page displayed successfully.

This confirms:
✅ Nginx installed correctly
✅ Security Group configured correctly
✅ Server accessible publicly

---

# 📜 Part 5 – Log Management

# 📌 Why Logs Matter in DevOps

Logs help engineers:

* Troubleshoot applications
* Analyze traffic
* Identify failures
* Monitor services

---

# 🔹 View Nginx Logs

## Access Logs

```bash
cat /var/log/nginx/access.log
```

## Error Logs

```bash
cat /var/log/nginx/error.log
```

---

# 🔹 Save Logs to File

## Command

```bash
cat /var/log/nginx/access.log > nginx-logs.txt
```

## Purpose

Exports logs into separate file.

---

# 🔹 Verify Log File

## Command

```bash
cat nginx-logs.txt
```

---

# 🔹 Download Logs to Local Machine

## Command

```bash
scp -i day08-key.pem ubuntu@<PUBLIC-IP>:~/nginx-logs.txt .
```

## Purpose

Copies logs from server to local system.

---

# 🧪 Deploy Simple HTML Page

# 🔹 Create Custom Webpage

## Command

```bash
echo "<h1>Welcome to My DevOps Server</h1>" | sudo tee /var/www/html/index.html
```

---

# 🔹 Refresh Browser

Visit:

```text
http://<PUBLIC-IP>
```

## Observation

Custom webpage displayed successfully.

---

# 🚨 Troubleshooting Scenario

# Problem

Nginx webpage not opening in browser.

---

# Step 1 – Check Nginx Status

```bash
sudo systemctl status nginx
```

---

# Step 2 – Verify Port 80

```bash
sudo ss -tulpn | grep 80
```

---

# Step 3 – Check Firewall/Security Group

Verify:

* Port 80 allowed
* Security group configured correctly

---

# Step 4 – Check Logs

```bash
sudo journalctl -u nginx -n 50
```

---

# Step 5 – Restart Nginx

```bash
sudo systemctl restart nginx
```

---

# 📂 Screenshots to Capture

## 📸 Required Screenshots

1️⃣ SSH connection to EC2 server
2️⃣ Nginx welcome page in browser
3️⃣ Docker service status
4️⃣ Nginx logs file

---

# 🎯 What I Learned

✅ How to launch cloud servers
✅ How to connect using SSH
✅ Docker installation and service management
✅ Nginx web server deployment
✅ Security group configuration
✅ Log management and troubleshooting
✅ Real-world Linux server administration

---

# ⚡ Challenges Faced

| Challenge                | Solution                         |
| ------------------------ | -------------------------------- |
| Unable to access website | Opened port 80 in Security Group |
| Permission issues        | Used sudo                        |
| SSH connection failed    | Verified key pair and public IP  |

---

# ✅ Commands Practiced Today

```bash
ssh -i day08-key.pem ubuntu@<PUBLIC-IP>
sudo apt update
sudo apt install docker.io -y
sudo systemctl start docker
docker --version
sudo apt install nginx -y
sudo systemctl start nginx
sudo systemctl status nginx
cat /var/log/nginx/access.log
cat /var/log/nginx/error.log
sudo ss -tulpn | grep 80
scp -i day08-key.pem ubuntu@<PUBLIC-IP>:~/nginx-logs.txt .
```

---

# 🏁 Conclusion

Cloud server deployment and Linux server management are foundational skills for every DevOps Engineer.

This hands-on exercise provided practical experience with:

* Cloud infrastructure
* Remote server access
* Docker installation
* Web server deployment
* Security configuration
* Log management

