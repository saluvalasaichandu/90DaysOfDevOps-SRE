# 🚀 Day 14 – Networking Fundamentals & Hands-on Checks

# 📌 Introduction

Networking is one of the most critical skills for every DevOps and SRE Engineer.

In real-world production environments, almost every issue eventually connects to networking:

* Application not reachable
* DNS resolution failures
* High latency
* Port connectivity issues
* API communication failures
* Load balancer issues
* Kubernetes networking problems

Strong networking fundamentals help engineers:

* Troubleshoot faster
* Understand traffic flow
* Debug connectivity issues
* Analyze application communication

In today’s hands-on challenge, I practiced:
✅ OSI & TCP/IP models
✅ IP addressing and DNS
✅ TCP/UDP protocols
✅ Connectivity troubleshooting
✅ HTTP status verification
✅ Port and service checks
✅ Network path analysis

---

# 🌐 What is Networking?

Networking allows systems and applications to communicate with each other.

Examples:

* Browser accessing websites
* Applications communicating with databases
* Kubernetes pods talking internally
* CI/CD servers deploying applications

---

# 🏗️ OSI Model vs TCP/IP Model

# 📌 OSI Model (7 Layers)

| Layer             | Purpose            |
| ----------------- | ------------------ |
| L7 – Application  | HTTP, HTTPS, DNS   |
| L6 – Presentation | Encryption, SSL    |
| L5 – Session      | Session management |
| L4 – Transport    | TCP/UDP            |
| L3 – Network      | IP Addressing      |
| L2 – Data Link    | MAC Address        |
| L1 – Physical     | Cables, Signals    |

---

# 📌 TCP/IP Model

| Layer       | Protocol Examples |
| ----------- | ----------------- |
| Application | HTTP, HTTPS, DNS  |
| Transport   | TCP, UDP          |
| Internet    | IP                |
| Link        | Ethernet          |

---

# 🔍 Where Protocols Sit in Networking Stack

| Protocol   | Layer              |
| ---------- | ------------------ |
| IP         | Network / Internet |
| TCP/UDP    | Transport          |
| HTTP/HTTPS | Application        |
| DNS        | Application        |

---

# 🌍 Real Networking Example

```text id="jlym250"
curl https://example.com
```

Flow:

```text id="jlym251"
Application Layer → HTTP/HTTPS
Transport Layer → TCP
Internet Layer → IP
Link Layer → Ethernet/WiFi
```

---

# 🧪 Hands-on Networking Checks

# 🎯 Target Used

For networking checks, I used:

* `google.com`
* Local Linux server
* Docker/Nginx services

---

# 🔹 Task 1 – Check System IP Address

# 📌 Why This Matters

Every machine requires an IP address to communicate over the network.

---

## Command

```bash id="jlym252"
hostname -I
```

or

```bash id="jlym253"
ip addr show
```
<img width="1365" height="525" alt="image" src="https://github.com/user-attachments/assets/a843038c-26b6-4f0f-8607-c4f0d1e67840" />

---

## Observation

```text id="jlym254"
172.31.41.72
```

This is the private IP assigned to the EC2 instance.

---

# 🔹 Task 2 – Connectivity Check using ping

# 📌 What is ping?

`ping` checks:

* Network reachability
* Latency
* Packet loss

---

## Command

```bash id="jlym255"
ping -c 4 google.com
```

---

## Example Output

```text id="jlym256"
4 packets transmitted, 4 received, 0% packet loss
```
<img width="1230" height="341" alt="image" src="https://github.com/user-attachments/assets/8c5b3df9-7dfa-4b0d-a0f2-52947e5a5073" />

---

## Observation

* Host reachable successfully
* No packet loss
* Low latency observed

---

# 🔹 Task 3 – Network Path Analysis

# 📌 What is traceroute?

`traceroute` shows:

* Network path
* Intermediate routers/hops
* Delays across network

---

## Command

```bash id="jlym257"
traceroute google.com
```

or

```bash id="jlym258"
tracepath google.com
```
<img width="1366" height="555" alt="image" src="https://github.com/user-attachments/assets/e0f904a5-b6f3-4c68-817b-e6295725d27d" />

---

## Observation

* Multiple hops between source and destination
* Some hops may timeout due to firewall restrictions

---

# 🔹 Task 4 – Check Listening Ports

# 📌 Why Port Checks Matter

Applications listen on ports.

Examples:

* SSH → 22
* HTTP → 80
* HTTPS → 443
* Docker → 2375

---

## Command

```bash id="jlym259"
ss -tulpn
```
<img width="1366" height="582" alt="image" src="https://github.com/user-attachments/assets/f21ecee8-ea56-4b12-ba66-053f32761588" />

---

## Example Output

```text id="jlym260"
tcp LISTEN 0 128 *:22
tcp LISTEN 0 511 *:80
```

---

## Observation

* SSH service listening on port 22
* Nginx listening on port 80

---

# 🔹 Task 5 – DNS Resolution Check

# 📌 What is DNS?

DNS converts:

* Domain names → IP addresses

Example:

```text id="jlym261"
google.com → 142.250.x.x
```
<img width="999" height="711" alt="image" src="https://github.com/user-attachments/assets/2014974d-1ca9-4612-b7d3-3b9ad4008e78" />

---

## Command

```bash id="jlym262"
dig google.com
```

or

```bash id="jlym263"
nslookup google.com
```
<img width="812" height="704" alt="image" src="https://github.com/user-attachments/assets/1fad8010-9d63-4990-8606-7c9a6deac048" />

---

## Observation

Successfully resolved domain to public IP address.

---

# 🔹 Task 6 – HTTP Connectivity Check

# 📌 What is curl?

`curl` tests:

* Web server connectivity
* HTTP responses
* APIs

---

## Command

```bash id="jlym264"
curl -I https://google.com
```

---

## Example Output

```text id="jlym265"
HTTP/2 200
```
<img width="1366" height="461" alt="image" src="https://github.com/user-attachments/assets/e0f2256c-0cce-45a7-8672-67ec7a1c94af" />

---

## Observation

* Website reachable
* HTTP response successful

---

# 🔹 Task 7 – Network Connections Snapshot

# 📌 Why This Matters

Helps identify:

* Active connections
* Listening services
* Established sessions

---

## Command

```bash id="jlym266"
netstat -an | head
```

---

## Observation

Observed:

* LISTEN state
* ESTABLISHED connections

---

# 🔍 Understanding TCP Connection States

| State       | Meaning                 |
| ----------- | ----------------------- |
| LISTEN      | Waiting for connections |
| ESTABLISHED | Active communication    |
| TIME_WAIT   | Connection closing      |
| CLOSE_WAIT  | Waiting to close        |

---

# 🧪 Mini Task – Port Probe & Interpretation

# 📌 Objective

Verify if service port is reachable.

---

# 🔹 Identify Listening Port

## Command

```bash id="jlym267"
ss -tulpn
```

Selected:

```text id="jlym268"
SSH → Port 22
```

---

# 🔹 Test Port Reachability

## Command

```bash id="jlym269"
nc -zv localhost 22
```

---

## Example Output

```text id="jlym270"
Connection to localhost 22 port [tcp/ssh] succeeded
```

---

## Observation

SSH port reachable successfully.

---

# 🚨 If Port is Not Reachable

Next checks:

1. Verify service status
2. Check firewall/security group
3. Check listening ports
4. Review service logs

---

# 🚨 Real-World Troubleshooting Scenarios

# Scenario 1 – Website Not Accessible

## Step 1 – Check Connectivity

```bash id="jlym271"
ping google.com
```

---

## Step 2 – Check DNS

```bash id="jlym272"
dig google.com
```

---

## Step 3 – Check HTTP Response

```bash id="jlym273"
curl -I http://localhost
```

---

## Step 4 – Verify Service Port

```bash id="jlym274"
ss -tulpn | grep 80
```

---

## Step 5 – Check Service Status

```bash id="jlym275"
systemctl status nginx
```

---

# Scenario 2 – DNS Failure

# Possible Layer to Inspect

| Layer       | Focus           |
| ----------- | --------------- |
| Application | DNS service     |
| Network     | IP connectivity |

---

# Scenario 3 – HTTP 500 Error

# Possible Layer to Inspect

| Layer             | Focus                |
| ----------------- | -------------------- |
| Application Layer | Web application logs |
| Transport Layer   | Service connectivity |

---

# 🎯 Which Command Gives Fastest Signal?

## Most Useful Command

```bash id="jlym276"
curl -I
```

### Why?

Quickly verifies:

* HTTP response
* Service availability
* Connectivity status

---

# 🎯 Two Follow-up Checks During Incidents

## Commands

```bash id="jlym277"
journalctl -u nginx
ss -tulpn
```

### Purpose

* Analyze logs
* Verify service ports

---

# 🌍 Real-World DevOps Use Cases

Networking skills are heavily used in:

* Kubernetes networking
* Ingress troubleshooting
* DNS debugging
* Load balancer issues
* API communication
* Cloud security groups
* Docker networking

Examples:

* Pod communication failures
* DNS resolution problems
* Nginx connectivity issues
* API timeout debugging

---

# 🎯 What I Learned

✅ OSI & TCP/IP models
✅ Difference between TCP and UDP
✅ DNS resolution process
✅ Network troubleshooting workflow
✅ HTTP response verification
✅ Port connectivity testing
✅ Real-world networking diagnostics

---

# ✅ Commands Practiced Today

```bash id="jlym278"
hostname -I
ip addr show
ping
traceroute
tracepath
ss -tulpn
netstat -an
dig
nslookup
curl -I
nc -zv
```

---

# 🏁 Conclusion

Networking fundamentals are essential for every DevOps and SRE Engineer.

Understanding:

* OSI and TCP/IP models
* IP addressing
* DNS
* Ports and protocols
* HTTP troubleshooting
* Connectivity diagnostics


