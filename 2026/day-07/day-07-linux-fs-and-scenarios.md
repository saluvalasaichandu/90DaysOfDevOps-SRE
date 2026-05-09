# 🚀 Day 07 – Linux File System Hierarchy & Scenario-Based Practice

## 📌 Introduction

Linux File System knowledge is one of the most important fundamentals for DevOps and SRE Engineers.

In real-world environments, engineers constantly interact with:

* Configuration files
* Logs
* User directories
* Application binaries
* Temporary files
* System services

Understanding where files live in Linux helps DevOps Engineers:

* Troubleshoot production issues faster
* Locate logs and configs quickly
* Debug applications efficiently
* Write better automation scripts

In today’s practice, I focused on:
✅ Linux File System Hierarchy
✅ Important Linux Directories
✅ Hands-on Navigation
✅ Real-world Troubleshooting Scenarios
✅ Service & Log Troubleshooting

---

# 🗂️ Linux File System Hierarchy

Linux uses a hierarchical directory structure that starts from:

```bash id="m4b04h"
/
```

This is called the **root directory**.

Everything in Linux starts from `/`.

---

# 📁 Core Linux Directories

# 1️⃣ `/` – Root Directory

The starting point of the Linux filesystem hierarchy.

All files, directories, devices, and configurations exist under `/`.

## Command

```bash id="e2m4mt"
ls -l /
```

## Example Directories

```text id="vq8szs"
bin
etc
home
root
usr
var
tmp
```

## I Would Use This When

Navigating the Linux filesystem structure.

---

# 2️⃣ `/home` – User Home Directories

Contains normal user accounts and their personal files.

## Command

```bash id="tjlwmx"
ls -l /home
```

## Example

```text id="z9g5x0"
ubuntu
ec2-user
developer
```

## I Would Use This When

Managing user files and scripts.

---

# 3️⃣ `/root` – Root User Home Directory

Home directory of the root user.

## Command

```bash id="jlwmxo"
ls -l /root
```

## I Would Use This When

Performing administrative tasks.

---

# 4️⃣ `/etc` – Configuration Files

Contains system-wide configuration files.

Very important for DevOps Engineers.

## Command

```bash id="0upupn"
ls -l /etc
```

## Common Files

```text id="kxsg5g"
hosts
hostname
passwd
ssh
systemd
```

## I Would Use This When

Editing service or application configurations.

---

# 5️⃣ `/var/log` – Log Files

Contains application and system logs.

One of the most important directories for troubleshooting.

## Command

```bash id="vh0mkt"
ls -l /var/log
```

## Common Logs

```text id="qim7w5"
syslog
auth.log
kern.log
nginx
docker
```

## I Would Use This When

Debugging services and production incidents.

---

# 6️⃣ `/tmp` – Temporary Files

Stores temporary files created by applications and users.

## Command

```bash id="z55r4x"
ls -l /tmp
```

## I Would Use This When

Creating temporary troubleshooting files.

---

# 📂 Additional Linux Directories

# 7️⃣ `/bin` – Essential Binaries

Contains important Linux commands.

## Command

```bash id="0f4u7f"
ls -l /bin
```

## Examples

```text id="22b4ah"
ls
cp
mv
cat
bash
```

## I Would Use This When

Running basic Linux commands.

---

# 8️⃣ `/usr/bin` – User Command Binaries

Contains user-level application binaries.

## Command

```bash id="mz2uh6"
ls -l /usr/bin | head
```

## I Would Use This When

Accessing installed software binaries.

---

# 9️⃣ `/opt` – Optional Applications

Used for third-party software installations.

## Command

```bash id="flkpsm"
ls -l /opt
```

## I Would Use This When

Installing external applications.

---

# 🧪 Hands-On Practice

# 🔹 Find Largest Log Files

## Command

```bash id="y6vlr8"
du -sh /var/log/* 2>/dev/null | sort -h | tail -5
```

## Purpose

Finds largest log files in the system.

## Observation

Useful during disk space troubleshooting.

---

# 🔹 View Hostname Configuration

## Command

```bash id="dkvw7x"
cat /etc/hostname
```

## Purpose

Displays system hostname.

---

# 🔹 Check Home Directory

## Command

```bash id="5y09ns"
ls -la ~
```

## Purpose

Displays hidden files and user configurations.

---

# 🚨 Scenario-Based Practice

# Scenario 1 – Service Not Starting

## Problem

A service called `myapp` failed after reboot.

---

## Step 1 – Check Service Status

```bash id="urh0gv"
systemctl status myapp
```

### Why

Checks whether service is:

* Running
* Failed
* Stopped

---

## Step 2 – Check Service Logs

```bash id="vgjqc4"
journalctl -u myapp -n 50
```

### Why

Displays recent service logs and errors.

---

## Step 3 – Verify Service Boot Status

```bash id="0k2wgn"
systemctl is-enabled myapp
```

### Why

Checks if service starts automatically after reboot.

---

## Step 4 – List Available Services

```bash id="tr0kk0"
systemctl list-units --type=service
```

### Why

Checks whether service exists in systemd.

---

# Scenario 2 – High CPU Usage

## Problem

Server is slow and CPU usage is high.

---

## Step 1 – Check Live CPU Usage

```bash id="6tr4lh"
top
```

### Why

Identifies high CPU-consuming processes.

---

## Step 2 – Sort Processes by CPU

```bash id="1efymk"
ps aux --sort=-%cpu | head -10
```

### Why

Displays top CPU-consuming processes.

---

## Step 3 – Find Specific PID

```bash id="nrg7j4"
pgrep nginx
```

### Why

Gets PID of specific application.

---

# Scenario 3 – Finding Service Logs

## Problem

Developer asks for Docker logs.

---

## Step 1 – Check Service Status

```bash id="db8npa"
systemctl status docker
```

---

## Step 2 – View Recent Logs

```bash id="b3ty3r"
journalctl -u docker -n 50
```

---

## Step 3 – Monitor Logs Live

```bash id="n2h0l9"
journalctl -u docker -f
```

### Why

Monitors logs in real time during troubleshooting.

---

# Scenario 4 – File Permission Issue

## Problem

Script is showing:

```text id="p9tqsu"
Permission denied
```

---

## Step 1 – Check File Permissions

```bash id="jlwmxp"
ls -l backup.sh
```

### Observation

```text id="y9jj50"
-rw-r--r--
```

No execute permission available.

---

## Step 2 – Add Execute Permission

```bash id="1i2dgq"
chmod +x backup.sh
```

---

## Step 3 – Verify Permissions

```bash id="qmjlwm"
ls -l backup.sh
```

### Observation

```text id="hvdtnc"
-rwxr-xr-x
```

---

## Step 4 – Run Script

```bash id="4nb0pn"
./backup.sh
```

---

# 🎯 Why Linux File System Matters for DevOps

Linux File System knowledge helps DevOps Engineers:

* Find logs quickly
* Edit configurations
* Troubleshoot services
* Debug deployments
* Manage applications efficiently

Scenario-based troubleshooting improves:

* Incident response
* Debugging confidence
* Production troubleshooting speed

---

# ✅ Commands Practiced Today

```bash id="61f1n7"
ls -l /
ls -l /home
ls -l /root
ls -l /etc
ls -l /var/log
ls -l /tmp
du -sh /var/log/*
cat /etc/hostname
ls -la ~
systemctl status myapp
journalctl -u myapp -n 50
top
ps aux --sort=-%cpu
pgrep nginx
journalctl -u docker -f
chmod +x backup.sh
```

---

# 🏁 Conclusion

Linux filesystem knowledge and troubleshooting skills are foundational for every DevOps and SRE Engineer.

Understanding:

* Where logs live
* Where configs exist
* How services behave
* How permissions work

helps engineers troubleshoot production systems faster and more confidently.

The stronger your Linux fundamentals become, the easier advanced DevOps troubleshooting and automation will feel.