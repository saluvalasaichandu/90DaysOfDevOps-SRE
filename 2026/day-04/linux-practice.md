# 🚀 Day 04 – Linux Practice: Processes and Services

## 📌 Introduction

Linux process and service management are core skills for DevOps and SRE Engineers.

Most production troubleshooting starts with:

* Checking processes
* Verifying services
* Monitoring logs
* Analyzing CPU and memory usage

In this hands-on practice, I worked on:

* Process Monitoring
* Service Management with systemd
* Log Analysis
* Basic Troubleshooting Workflow

---

# ⚙️ Process Management Practice

## 🔹 View Running Processes

```bash
ps -ef
```

### Purpose

Displays all running processes in the system.

### Example Output

```bash
root       1       0  0 08:00 ?        00:00:02 systemd
root     632       1  0 08:01 ?        00:00:01 sshd
ubuntu   1421    1400 0 08:10 pts/0    00:00:00 bash
```

---

## 🔹 Real-Time Monitoring

```bash
top
```

or

```bash
htop
```

### Purpose

Used to monitor:

* CPU usage
* Memory usage
* Running processes
* System load

---

## 🔹 Find Specific Process

```bash
pgrep nginx
```

### Purpose

Finds PID of a specific application.

---

# ⚙️ Service Management Practice

## 🔹 Check Service Status

```bash
systemctl status docker
```
<img width="1366" height="422" alt="image" src="https://github.com/user-attachments/assets/c31886d9-be78-4c5e-9c97-b50e09c430f4" />

### Purpose

Checks whether Docker service is:

* Running
* Failed
* Restarting

### Example Output

```bash
Active: active (running)
```

---

## 🔹 List Running Services

```bash
systemctl list-units --type=service
```

### Purpose

Displays active services running in the system.

---

## 🔹 Restart Service

```bash
systemctl restart docker
```

### Purpose

Restarts Docker service.

---

# 📜 Log Analysis Practice

## 🔹 View Service Logs

```bash
journalctl -u docker
```

### Purpose

Displays logs related to Docker service.

---

## 🔹 View Last 50 Log Lines

```bash
tail -n 50 /var/log/syslog
```

### Purpose

Displays latest log entries.

---

## 🔹 Monitor Logs in Real Time

```bash
tail -f /var/log/syslog
```

### Purpose

Used during:

* Deployments
* Service restarts
* Troubleshooting

---

# 🚨 Mini Troubleshooting Scenario

## Scenario

Docker service is not working properly.

---

## Step 1 – Check Docker Service Status

```bash
systemctl status docker
```

---

## Step 2 – Verify Docker Process

```bash
ps -ef | grep docker
```
<img width="1366" height="153" alt="image" src="https://github.com/user-attachments/assets/5ebd1fc9-ffca-48fc-b595-26db9d339d29" />

---

## Step 3 – Check Docker Logs

```bash
journalctl -u docker
```

---

## Step 4 – Monitor CPU and Memory

```bash
top
free -h
```

---

## Step 5 – Restart Docker Service

```bash
systemctl restart docker
```

---

# 🔍 Difference Between Process and Service

| Process                       | Service                             |
| ----------------------------- | ----------------------------------- |
| Running instance of program   | Long-running background application |
| Managed by Kernel             | Managed by systemd                  |
| Has PID                       | Runs continuously                   |
| Example: nginx worker process | Example: nginx service              |

---

# 🎯 Why This Matters for DevOps

Linux process and service troubleshooting skills help DevOps Engineers:

* Resolve production incidents faster
* Debug failed applications
* Analyze logs quickly
* Reduce downtime
* Monitor infrastructure efficiently

Most production issues involve:

* Failed services
* High CPU usage
* Memory problems
* Crashed processes
* Log analysis

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

The better your Linux troubleshooting skills become, the faster and more confidently you can handle real-world production incidents.

#90DaysOfDevOps
#DevOpsKaJosh
#TrainWithShubham
#Linux
#DevOps
#SRE
#CloudComputing
