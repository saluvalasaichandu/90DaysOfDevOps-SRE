# 🚀 Day 03 – Linux Commands Cheat Sheet for DevOps Engineers

# 📌 Introduction

Linux command-line skills are one of the most important foundations for DevOps, Cloud, and SRE Engineers.

Most production troubleshooting, monitoring, deployment, and debugging activities happen through the Linux terminal.

As DevOps Engineers, we use Linux commands daily to:
- Troubleshoot production issues
- Monitor CPU and memory
- Analyze logs
- Manage services
- Debug networking problems
- Handle servers efficiently

This cheat sheet contains commonly used Linux commands categorized into:
- File System Commands
- Process Management Commands
- Networking Commands
- Log and Monitoring Commands
- Service Management Commands

---

# 📂 File System Commands

File system commands help us navigate, create, manage, and inspect files/directories in Linux.

---

# 1️⃣ pwd – Print Current Directory

Displays the current working directory.

## Command

```bash
pwd
```

## Example Output

```bash
/home/ubuntu
```
<img width="533" height="76" alt="image" src="https://github.com/user-attachments/assets/608119c2-1e3c-4d66-bdbe-c1e96fe75fe9" />

## Why It Matters

Useful when navigating servers and verifying current path before performing operations.

---

# 2️⃣ ls – List Files and Directories

Displays files and folders.

## Command

```bash
ls
```

## Detailed Listing

```bash
ls -l
```

## Hidden Files

```bash
ls -la
```

## Why It Matters

Used daily to inspect directories and file permissions.
<img width="847" height="407" alt="image" src="https://github.com/user-attachments/assets/bbf3a7ec-fddd-447b-b61f-7b1bfbc1b7d7" />


---

# 3️⃣ cd – Change Directory

Moves between directories.

## Command

```bash
cd /var/log
```

## Go Back One Directory

```bash
cd ..
```

## Go Home Directory

```bash
cd ~
```

---

# 4️⃣ mkdir – Create Directory

Creates new directories.

## Command

```bash
mkdir project
```

## Create Nested Directories

```bash
mkdir -p app/logs/archive
```
<img width="788" height="54" alt="image" src="https://github.com/user-attachments/assets/035fdb68-6ff4-4fd4-931a-1018d551eded" />
<img width="580" height="153" alt="image" src="https://github.com/user-attachments/assets/0b3e2b32-a209-42e2-a872-6a983b34cd4c" />


---

# 5️⃣ touch – Create Empty File

Creates files quickly.

## Command

```bash
touch app.log
```
<img width="659" height="155" alt="image" src="https://github.com/user-attachments/assets/7291c2a5-4c36-47b3-b196-102f3676affe" />

---

# 6️⃣ cp – Copy Files

Copies files/directories.

## Command

```bash
cp file1.txt backup.txt
```

## Copy Directory

```bash
cp -r project backup-project
```
<img width="960" height="298" alt="image" src="https://github.com/user-attachments/assets/ed287a0a-c089-43ac-8c04-551ef61e5966" />

---

# 7️⃣ mv – Move or Rename Files

Moves or renames files.

## Rename File

```bash
mv old.txt new.txt
```
<img width="714" height="268" alt="image" src="https://github.com/user-attachments/assets/594e4553-428c-4b77-8008-3c8b95dd1df2" />

## Move File

```bash
mv file.txt /tmp
```

---

# 8️⃣ rm – Remove Files

Deletes files/directories.

## Delete File

```bash
rm file.txt
```
<img width="706" height="131" alt="image" src="https://github.com/user-attachments/assets/bb145513-9489-42df-a3a8-bf10f72a6849" />

## Delete Directory

```bash
rm -rf project
```

⚠️ Use carefully in production.

---

# 9️⃣ cat – View File Content

Displays file contents.

## Command

```bash
cat file.txt
```

---

# 🔟 less – Read Large Files

Used to read large logs/files.

## Command

```bash
less /var/log/syslog
```

Useful during troubleshooting.

---

# ⚙️ Process Management Commands

Process management is critical for monitoring applications and debugging issues.

---

# 1️⃣1️⃣ ps – View Running Processes

Displays active processes.

## Command

```bash
ps -ef
```

## Why It Matters

Used to:
- Find process IDs
- Check running services
- Troubleshoot applications

---

# 1️⃣2️⃣ top – Real-Time Monitoring

Displays live CPU and memory usage.

## Command

```bash
top
```

## Why It Matters

Helps identify:
- High CPU usage
- Memory leaks
- Stuck processes

---

# 1️⃣3️⃣ htop – Interactive Process Viewer

Improved version of top.

## Command

```bash
htop
```

More user-friendly and interactive.

---

# 1️⃣4️⃣ kill – Stop Process

Terminates processes using PID.

## Command

```bash
kill 1234
```

## Force Kill

```bash
kill -9 1234
```

⚠️ Use `kill -9` only if normal kill fails.

---

# 1️⃣5️⃣ pstree – View Process Tree

Shows parent-child process hierarchy.

## Command

```bash
pstree
```

Useful for debugging services.

---

# 🌐 Networking Commands

Networking troubleshooting is one of the most important DevOps skills.

---

# 1️⃣6️⃣ ping – Check Connectivity

Tests network reachability.

## Command

```bash
ping google.com
```

## Why It Matters

Used to verify:
- Internet access
- Server reachability
- DNS resolution

---

# 1️⃣7️⃣ ip addr – View IP Address

Displays network interface details.

## Command

```bash
ip addr
```

## Why It Matters

Used to:
- Verify IP configuration
- Check interfaces
- Troubleshoot networking

---

# 1️⃣8️⃣ curl – Test APIs and URLs

Used for HTTP requests.

## Command

```bash
curl https://google.com
```

## Test REST API

```bash
curl http://localhost:8080/api
```

## Why It Matters

Very useful for:
- API testing
- Health checks
- Application troubleshooting

---

# 1️⃣9️⃣ ss – Check Listening Ports

Displays open ports and sockets.

## Command

```bash
ss -tunlp
```

## Why It Matters

Used to:
- Check service ports
- Verify applications are listening

---

# 2️⃣0️⃣ dig – DNS Troubleshooting

Checks DNS records.

## Command

```bash
dig google.com
```

## Why It Matters

Useful for debugging DNS issues.

---

# 📜 Log and Monitoring Commands

Logs are the first place DevOps Engineers check during incidents.

---

# 2️⃣1️⃣ tail – View Latest Logs

Displays latest lines from logs.

## Command

```bash
tail /var/log/syslog
```

## Real-Time Logs

```bash
tail -f app.log
```

---

# 2️⃣2️⃣ grep – Search Text

Searches patterns inside files.

## Command

```bash
grep ERROR app.log
```

## Why It Matters

Used for:
- Finding errors
- Filtering logs
- Searching configurations

---

# 2️⃣3️⃣ free – Check Memory Usage

Displays RAM usage.

## Command

```bash
free -h
```

---

# 2️⃣4️⃣ df – Check Disk Usage

Displays filesystem usage.

## Command

```bash
df -h
```

---

# ⚙️ Service Management Commands

Services are managed using `systemd`.

---

# 2️⃣5️⃣ systemctl – Manage Services

## Check Service Status

```bash
systemctl status nginx
```

## Start Service

```bash
systemctl start nginx
```

## Restart Service

```bash
systemctl restart nginx
```

## Enable Service During Boot

```bash
systemctl enable nginx
```

---

# 🧪 Real-Time Troubleshooting Scenario

## Scenario

Application is down in production.

## Step 1 – Check Service Status

```bash
systemctl status nginx
```

---

## Step 2 – Check Running Processes

```bash
ps -ef | grep nginx
```

---

## Step 3 – Verify Port Listening

```bash
ss -tunlp | grep 80
```

---

## Step 4 – Check Logs

```bash
tail -f /var/log/nginx/error.log
```

---

## Step 5 – Monitor CPU and Memory

```bash
top
free -h
```

---

# 🎯 Why Linux Commands Matter in DevOps

Strong Linux command-line skills help DevOps Engineers:
- Reduce downtime
- Debug issues faster
- Monitor infrastructure
- Handle incidents confidently
- Manage production systems efficiently

Most production troubleshooting starts with Linux commands.

---

# ✅ Commands Practiced Today

```bash
pwd
ls -la
cd
mkdir
touch
cp
mv
rm -rf
cat
less
ps -ef
top
htop
kill
pstree
ping
ip addr
curl
ss -tunlp
dig
tail -f
grep
free -h
df -h
systemctl
```

---

# 🏁 Conclusion

Linux commands are the daily toolkit of every DevOps and SRE Engineer.

The more comfortable you become with Linux commands, the faster and more confidently you can troubleshoot production systems.

Mastering Linux commands is one of the strongest long-term investments for any DevOps Engineer.

#90DaysOfDevOps
#DevOpsKaJosh
#TrainWithShubham
#Linux
#DevOps
#SRE
#CloudComputing
