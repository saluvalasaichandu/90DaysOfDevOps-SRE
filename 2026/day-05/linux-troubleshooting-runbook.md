# 🚀 Day 05 – Linux Troubleshooting Drill: CPU, Memory, and Logs

# 📌 Introduction

Linux troubleshooting is one of the most critical responsibilities for DevOps and SRE Engineers.

In real-world production environments, incidents usually involve:

* High CPU usage
* Memory pressure
* Disk space issues
* Network failures
* Service crashes
* Log analysis

A proper troubleshooting workflow helps engineers:

* Capture evidence quickly
* Identify root cause faster
* Reduce downtime
* Avoid guesswork during incidents

In this hands-on troubleshooting drill, I performed:
✅ CPU & Memory Analysis
✅ Disk & IO Checks
✅ Network Troubleshooting
✅ Log Analysis
✅ Service Health Verification
✅ Mini Incident Runbook Creation

---

# 🎯 Target Service

For this troubleshooting drill, the target service is:

```bash
Docker Service
```

Docker is one of the most commonly used services in DevOps environments and is critical for containerized workloads.

---

# 🖥️ Environment Information

## 🔹 Check Kernel Information

```bash
uname -a
```

### Purpose

Displays:

* Kernel version
* OS architecture
* Host information

### Example Output

```bash
Linux ip-172-31-41-72 6.8.0-1018-aws x86_64 GNU/Linux
```

### Observation

System is running Ubuntu Linux on AWS EC2 instance.

---

## 🔹 Check OS Information

```bash
cat /etc/os-release
```

### Purpose

Displays Linux distribution information.

### Observation

Server is running Ubuntu 24.04 LTS.

---

# 📂 File System Sanity Checks

## 🔹 Create Temporary Troubleshooting Folder

```bash
mkdir /tmp/runbook-demo
```

### Purpose

Creates temporary workspace for troubleshooting tasks.

---

## 🔹 Copy File and Verify

```bash
cp /etc/hosts /tmp/runbook-demo/hosts-copy
ls -l /tmp/runbook-demo
```

### Purpose

Verifies:

* File operations
* Disk functionality
* File permissions

### Observation

File copied successfully with correct permissions.

---

# ⚙️ CPU and Memory Troubleshooting

CPU and memory are the first things checked during performance issues.

---

# 🔹 Real-Time System Monitoring

```bash
top
```

or

```bash
htop
```

### Purpose

Monitors:

* CPU utilization
* Memory consumption
* Running processes
* System load

### Observation

CPU utilization remains stable below 10%.

No abnormal spikes observed.

---

# 🔹 Check Memory Usage

```bash
free -h
```

### Purpose

Displays:

* Used memory
* Free memory
* Swap usage

### Observation

Sufficient free memory available.

No swap pressure detected.

---

# 🔹 Check Specific Process Resource Usage

```bash
ps -o pid,pcpu,pmem,comm -p $(pgrep docker)
```

### Purpose

Displays:

* Docker process CPU usage
* Docker memory usage

### Observation

Docker service consuming minimal CPU and memory resources.

---

# 💽 Disk and IO Troubleshooting

Disk usage and IO performance are critical for application stability.

---

# 🔹 Check Disk Space

```bash
df -h
```

### Purpose

Displays filesystem usage.

### Observation

Disk usage below 60%.

Sufficient free storage available.

---

# 🔹 Check Log Directory Size

```bash
du -sh /var/log
```

### Purpose

Checks size of log files.

### Observation

Log directory size is within normal range.

No abnormal log growth observed.

---

# 🔹 Check System IO Statistics

```bash
vmstat
```

### Purpose

Displays:

* CPU statistics
* Memory activity
* IO wait
* System performance

### Observation

No high IO wait detected.

System performance stable.

---

# 🌐 Network Troubleshooting

Network checks are essential during service outages.

---

# 🔹 Check Listening Ports

```bash
ss -tulpn
```

### Purpose

Displays:

* Open ports
* Listening services
* Network sockets

### Observation

Docker service listening correctly on expected ports.

---

# 🔹 Test Network Connectivity

```bash
ping google.com
```

### Purpose

Verifies:

* Internet connectivity
* DNS resolution
* Network latency

### Observation

Network connectivity working successfully.

---

# 🔹 Test Service Endpoint

```bash
curl -I http://localhost
```

### Purpose

Checks HTTP response from local service.

### Observation

HTTP response received successfully.

---

# 📜 Log Analysis

Logs provide the most important troubleshooting information.

---

# 🔹 Check Docker Service Logs

```bash
journalctl -u docker -n 50
```

### Purpose

Displays recent Docker service logs.

### Observation

No recent critical errors found.

Docker service started successfully.

---

# 🔹 Check System Logs

```bash
tail -n 50 /var/log/syslog
```

### Purpose

Displays latest system log entries.

### Observation

No major system-level warnings observed.

---

# 🚨 Mini Troubleshooting Workflow

# Scenario

Docker containers are not starting properly.

---

# Step 1 – Check Docker Service Status

```bash
systemctl status docker
```

---

# Step 2 – Verify Docker Process

```bash
ps -ef | grep docker
```

---

# Step 3 – Monitor CPU and Memory

```bash
top
free -h
```

---

# Step 4 – Verify Disk Usage

```bash
df -h
```

---

# Step 5 – Check Docker Logs

```bash
journalctl -u docker -n 50
```

---

# Step 6 – Verify Docker Ports

```bash
ss -tulpn
```

---

# 🔍 Quick Findings

✅ Docker service running successfully
✅ CPU and memory usage normal
✅ Disk usage healthy
✅ Network connectivity working
✅ No critical errors in logs
✅ System performance stable

---

# 🚨 If This Worsens (Next Steps)

If the issue becomes severe, next troubleshooting actions would be:

## 1️⃣ Restart Docker Service

```bash
systemctl restart docker
```

---

## 2️⃣ Increase Log Analysis

```bash
journalctl -u docker -f
```

Monitor logs continuously for failures.

---

## 3️⃣ Advanced Troubleshooting

Use advanced debugging tools:

* `strace`
* `lsof`
* `iotop`
* `tcpdump`

---

# 🎯 Why This Matters for DevOps

A structured troubleshooting workflow helps DevOps Engineers:

* Diagnose incidents faster
* Capture evidence before restart
* Avoid unnecessary downtime
* Improve incident response

Most production incidents involve:

* CPU spikes
* Memory leaks
* Disk exhaustion
* Network failures
* Service crashes
* Log analysis

---

# ✅ Commands Practiced Today

```bash
uname -a
cat /etc/os-release
mkdir /tmp/runbook-demo
cp /etc/hosts /tmp/runbook-demo/hosts-copy
ls -l /tmp/runbook-demo
top
htop
free -h
ps -o pid,pcpu,pmem,comm
df -h
du -sh /var/log
vmstat
ss -tulpn
ping google.com
curl -I http://localhost
journalctl -u docker -n 50
tail -n 50 /var/log/syslog
systemctl status docker
```

---

# 🏁 Conclusion

Linux troubleshooting is one of the most valuable real-world skills for DevOps and SRE Engineers.

A proper troubleshooting workflow involving:

* CPU analysis
* Memory monitoring
* Disk checks
* Network troubleshooting
* Log analysis

helps engineers resolve incidents quickly and confidently in production environments.

The more troubleshooting practice you do, the stronger your production debugging skills become.
