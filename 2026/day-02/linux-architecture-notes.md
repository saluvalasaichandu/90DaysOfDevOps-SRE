# Day 02 – Linux Architecture, Processes, and systemd

# Introduction

Linux is one of the most widely used operating systems in the world and forms the backbone of modern DevOps, Cloud, and SRE environments.

Most production servers, Kubernetes nodes, Docker hosts, CI/CD runners, and cloud virtual machines run on Linux.

Understanding Linux internals helps DevOps engineers:
- Troubleshoot production issues
- Debug failed services
- Monitor CPU and memory usage
- Analyze logs
- Handle incidents confidently

---

# Linux Architecture Overview

Linux architecture is mainly divided into:

```text
User Applications
       ↓
User Space
       ↓
System Calls
       ↓
Kernel
       ↓
Hardware
```

---

# 1. Kernel

The Kernel is the core component of Linux.

It directly interacts with hardware and manages system resources.

## Responsibilities of Kernel

- Process Management
- Memory Management
- Device Management
- File System Management
- CPU Scheduling
- Networking

## Examples

- Allocating RAM to applications
- Managing CPU time
- Communicating with storage devices
- Handling system calls

## Check Kernel Version

```bash
uname -r
```

Example Output:

```bash
6.8.0-1018-aws
```
<img width="640" height="139" alt="image" src="https://github.com/user-attachments/assets/6cfd5967-9b3c-4883-bf53-2141fc07c985" />

---

# 2. User Space

User Space is where applications and users interact with the operating system.

Applications cannot directly access hardware.

Instead, they communicate with the Kernel using system calls.

## Examples of User Space Applications

- Bash Shell
- Docker
- Nginx
- Python
- Jenkins
- Kubernetes tools

---

# 3. init and systemd

When Linux boots:
1. Kernel starts first
2. Kernel starts PID 1 process
3. PID 1 is usually `systemd`

---

# What is systemd?

`systemd` is the modern init system in Linux.

It manages:
- Services
- Background processes
- Boot process
- Logging
- Restart policies

---

# Why systemd Matters in DevOps

systemd helps:
- Automatically start services after reboot
- Restart failed services
- Monitor service health
- Analyze logs quickly

Examples:
- nginx
- docker
- sshd
- kubelet

---

# Process Management in Linux

A Process is a running instance of a program.

Examples:
- nginx process
- docker daemon
- ssh service

Each process has:
- PID (Process ID)
- Parent PID
- State
- CPU usage
- Memory usage

---

# How Processes are Created

Linux uses:
- `fork()`
- `exec()`

## Process Flow

1. Parent process creates child process using `fork()`
2. Child process executes program using `exec()`

Example:
- Bash creates a child process when you run commands

---

# Process States in Linux

## Running (R)
Process actively using CPU.

## Sleeping (S)
Waiting for event/resource.

Most Linux processes stay in sleeping state.

## Stopped (T)
Process paused manually.

## Zombie (Z)
Process completed execution but still exists in process table.

Zombie processes consume PID entries.

---

# Important Linux Commands

## View Running Processes

```bash
ps -ef
```
<img width="1366" height="267" alt="image" src="https://github.com/user-attachments/assets/6f4339e5-9944-4eee-97b2-850d4b94c472" />

---

## Real-Time Process Monitoring

```bash
top
```
<img width="1366" height="435" alt="image" src="https://github.com/user-attachments/assets/32610bc0-4d3c-4090-bf0f-6853515d3543" />

or

```bash
htop
```

---

## Check Memory Usage

```bash
free -h
```
<img width="1366" height="128" alt="image" src="https://github.com/user-attachments/assets/6b0b7697-1117-436d-bcfd-67ef07ab692a" />

---

## Check Disk Usage

```bash
df -h
```
<img width="807" height="325" alt="image" src="https://github.com/user-attachments/assets/efc01d29-6e1d-4475-b0d1-bf1968bd9afe" />

---

## View Process Tree

```bash
pstree
```
<img width="1040" height="558" alt="image" src="https://github.com/user-attachments/assets/97a0da97-a96c-4986-80a1-857b503802ff" />

---

# systemd Practical Commands

## Check Service Status

```bash
systemctl status nginx
```

---

## Start Service

```bash
systemctl start nginx
```

---

## Stop Service

```bash
systemctl stop nginx
```

---

## Restart Service

```bash
systemctl restart nginx
```

---

## Enable Service at Boot

```bash
systemctl enable nginx
```

---

## View Logs

```bash
journalctl -xe
```
<img width="1366" height="657" alt="image" src="https://github.com/user-attachments/assets/e370ae8e-05e8-4535-b61b-41d056362fbc" />

---

# Practical Hands-On

## 1. Check Current Running Processes

```bash
ps -ef
```

---

## 2. Monitor CPU and Memory Usage

```bash
top
```

---

## 3. Check Docker Service Status

```bash
systemctl status docker
```

---

## 4. View System Logs

```bash
journalctl -xe
```

---

## 5. Check Process Hierarchy

```bash
pstree
```

---

# Real-Time Troubleshooting Scenario

## Scenario

Nginx service is not accessible in production.

## Troubleshooting Steps

### Check Service Status

```bash
systemctl status nginx
```

---

### Check Logs

```bash
journalctl -u nginx
```

---

### Verify Port Usage

```bash
ss -tunlp | grep 80
```

---

### Check CPU and Memory

```bash
top
free -h
```

---

### Restart Service

```bash
systemctl restart nginx
```

---

# Difference Between Service and Process

| Service | Process |
|---|---|
| Long-running background application | Running instance of program |
| Managed by systemd | Managed by kernel |
| Example: nginx service | Example: nginx worker process |

---

# DevOps Importance

Linux knowledge is mandatory for DevOps Engineers because almost every production workload runs on Linux.

Understanding Linux internals helps in:
- Production troubleshooting
- Incident management
- Performance tuning
- Service debugging
- Kubernetes node troubleshooting
- Docker host management

---

# Key Takeaways

- Kernel is the core of Linux
- User space contains applications
- systemd manages services and boot process
- Processes are managed using PIDs
- Linux troubleshooting starts with process and log analysis

---

# Commands Practiced Today

```bash
uname -r
ps -ef
top
htop
free -h
df -h
pstree
systemctl status nginx
journalctl -xe
```

---

# Conclusion

Linux is the foundation of DevOps and Cloud Engineering.

A strong understanding of Linux architecture, processes, and systemd helps engineers confidently manage production systems, troubleshoot failures, and automate infrastructure efficiently.
