````markdown id="8n6jrp"
# 🚀 Day 04 – Linux Practice: Processes and Services

# 📌 Introduction

Linux process and service management are among the most important skills for DevOps and SRE Engineers.

In real-world production environments, most troubleshooting starts with:
- Checking running processes
- Verifying service health
- Analyzing logs
- Monitoring CPU and memory usage

Today’s hands-on practice focused on:
✅ Process Monitoring  
✅ Service Management with systemd  
✅ Log Analysis  
✅ Basic Troubleshooting Workflow  

---

# ⚙️ What is a Process in Linux?

A process is a running instance of a program.

Examples:
- nginx
- docker
- sshd
- kubelet

Each process has:
- PID (Process ID)
- Parent PID
- CPU usage
- Memory usage
- Process state

---

# 🔍 Process Monitoring Commands

# 1️⃣ View Running Processes

## Command

```bash
ps -ef
```

## Purpose

Displays all currently running processes.

## Example Output

```bash
root       1       0  0 08:00 ?        00:00:02 systemd
root     632       1  0 08:01 ?        00:00:01 sshd
ubuntu   1421    1400 0 08:10 pts/0    00:00:00 bash
```

## Why It Matters

Used to:
- Find running applications
- Check process IDs
- Troubleshoot services

---

# 2️⃣ Real-Time Process Monitoring

## Command

```bash
top
```

or

```bash
htop
```

## Purpose

Displays:
- CPU usage
- Memory usage
- Running processes
- System load

## Why It Matters

Helps identify:
- High CPU usage
- Memory leaks
- Stuck processes

---

# 3️⃣ Find Specific Process

## Command

```bash
pgrep nginx
```

## Purpose

Finds process IDs of specific applications.

---

# ⚙️ What is a Service in Linux?

A service is a long-running background application managed by `systemd`.

Examples:
- nginx
- docker
- sshd
- cron

Services automatically start during boot and continue running in the background.

---

# 🔧 Service Management with systemd

Linux uses `systemd` as the init system and service manager.

It helps:
- Start services
- Stop services
- Restart services
- Monitor service health
- Manage logs

---

# 🛠️ Service Commands Practice

# 1️⃣ Check Service Status

## Command

```bash
systemctl status docker
```

## Purpose

Checks whether Docker service is:
- Running
- Failed
- Restarting

## Example Output

```bash
Active: active (running)
```

---

# 2️⃣ List Running Services

## Command

```bash
systemctl list-units --type=service
```

## Purpose

Displays active services running on the server.

---

# 3️⃣ Restart Service

## Command

```bash
systemctl restart docker
```

## Purpose

Restarts service after configuration changes or failures.

---

# 📜 Log Management Commands

Logs are extremely important during production troubleshooting.

---

# 1️⃣ View Service Logs

## Command

```bash
journalctl -u docker
```

## Purpose

Displays logs related to Docker service.

---

# 2️⃣ View Recent Logs

## Command

```bash
tail -n 50 /var/log/syslog
```

## Purpose

Displays latest 50 log lines.

---

# 3️⃣ Monitor Logs in Real Time

## Command

```bash
tail -f /var/log/syslog
```

## Purpose

Useful during:
- Deployments
- Service restarts
- Troubleshooting

---

# 🚨 Mini Troubleshooting Scenario

# Scenario

Docker service is not working properly.

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

# Step 3 – Check Docker Logs

```bash
journalctl -u docker
```

---

# Step 4 – Monitor CPU and Memory

```bash
top
free -h
```

---

# Step 5 – Restart Docker Service

```bash
systemctl restart docker
```

---

# 🔍 Difference Between Process and Service

| Process | Service |
|---|---|
| Running instance of program | Background application |
| Managed by kernel | Managed by systemd |
| Has PID | Runs continuously |
| Example: nginx worker | Example: nginx service |

---

# 🎯 Why This Matters for DevOps

Linux process and service troubleshooting skills help DevOps Engineers:
- Resolve production incidents faster
- Debug failed applications
- Analyze logs quickly
- Reduce downtime
- Monitor infrastructure efficiently

Most real-world infrastructure issues involve:
- Failed services
- High CPU usage
- Memory problems
- Crashed processes
- Log analysis

---

# ✅ Commands Practiced Today

```bash
ps -ef
top
htop
pgrep nginx
systemctl status docker
systemctl list-units --type=service
systemctl restart docker
journalctl -u docker
tail -n 50 /var/log/syslog
tail -f /var/log/syslog
free -h
```

---

# 🏁 Conclusion

Linux process and service management are foundational skills for every DevOps and SRE Engineer.

The more comfortable you become with Linux troubleshooting commands, logs, and services, the faster and more confidently you can handle production incidents.

#90DaysOfDevOps
#DevOpsKaJosh
#TrainWithShubham
#Linux
#DevOps
#SRE
#CloudComputing
````
