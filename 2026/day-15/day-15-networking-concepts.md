# 🚀 Day 15 – Networking Concepts: DNS, IP, Subnets & Ports

# 📌 Introduction

Networking fundamentals are one of the most important skills for every DevOps and SRE Engineer.

In modern cloud and Kubernetes environments, applications constantly communicate through:

* DNS
* IP addresses
* Subnets
* Ports
* Protocols

Understanding networking helps engineers:

* Troubleshoot faster
* Debug connectivity issues
* Configure cloud infrastructure
* Manage Kubernetes networking
* Understand traffic flow between applications

In today’s hands-on challenge, I focused on:
✅ DNS Resolution
✅ IPv4 Addressing
✅ Public vs Private IPs
✅ CIDR & Subnetting
✅ Ports & Services
✅ Network Troubleshooting Basics

---

# 🌐 Task 1 – DNS: How Names Become IPs

# 📌 What Happens When You Type `google.com` in a Browser?

When we enter:

```text id="jlym279"
google.com
```

the following process happens:

1. Browser checks local DNS cache
2. System asks configured DNS server
3. DNS resolves domain name to IP address
4. Browser connects to that IP using TCP/IP
5. HTTP/HTTPS request is sent to the server

---

# 📌 Common DNS Record Types

| Record | Purpose                  |
| ------ | ------------------------ |
| A      | Maps domain → IPv4       |
| AAAA   | Maps domain → IPv6       |
| CNAME  | Alias for another domain |
| MX     | Mail server record       |
| NS     | Name server record       |

---

# 🔹 Run DNS Lookup

## Command

```bash id="jlym280"
dig google.com
```

---

## Example Output

```text id="jlym281"
google.com. 300 IN A 142.250.183.14
```

---

# 📌 Understanding Output

| Field          | Meaning            |
| -------------- | ------------------ |
| google.com     | Domain             |
| 300            | TTL (Time To Live) |
| A              | Record Type        |
| 142.250.183.14 | IPv4 Address       |

---

# 🌍 Task 2 – IP Addressing

# 📌 What is an IPv4 Address?

IPv4 is a 32-bit address used to identify devices in a network.

Example:

```text id="jlym282"
192.168.1.10
```

It contains:

* 4 octets
* Each octet ranges from 0–255

---

# 📌 Public vs Private IP

| Type       | Description                   | Example    |
| ---------- | ----------------------------- | ---------- |
| Public IP  | Accessible from internet      | 54.210.x.x |
| Private IP | Used inside internal networks | 10.0.1.10  |

---

# 📌 Private IP Ranges

| Range                         | Purpose                 |
| ----------------------------- | ----------------------- |
| 10.0.0.0 – 10.255.255.255     | Large private networks  |
| 172.16.0.0 – 172.31.255.255   | Medium private networks |
| 192.168.0.0 – 192.168.255.255 | Home/private networks   |

---

# 🔹 Check System IP Address

## Command

```bash id="jlym283"
ip addr show
```

---

## Example Output

```text id="jlym284"
inet 172.31.41.72/20
```

---

# 📌 Observation

`172.31.41.72` belongs to private IP range:

```text id="jlym285"
172.16.x.x – 172.31.x.x
```

---

# 🧮 Task 3 – CIDR & Subnetting

# 📌 What is CIDR?

CIDR = Classless Inter-Domain Routing

Used to define:

* Network size
* Number of hosts
* Subnet boundaries

---

# 📌 What Does `/24` Mean?

Example:

```text id="jlym286"
192.168.1.0/24
```

Means:

* First 24 bits → Network portion
* Remaining 8 bits → Host portion

---

# 📌 Why Subnetting Matters

Subnetting helps:

* Organize networks
* Improve security
* Reduce broadcast traffic
* Separate environments

Examples:

* Dev subnet
* Prod subnet
* Database subnet

---

# 📌 CIDR Table

| CIDR | Subnet Mask     | Total IPs | Usable Hosts |
| ---- | --------------- | --------- | ------------ |
| /24  | 255.255.255.0   | 256       | 254          |
| /16  | 255.255.0.0     | 65,536    | 65,534       |
| /28  | 255.255.255.240 | 16        | 14           |

---

# 📌 Understanding Host Calculation

Formula:

```text id="jlym287"
2^(host bits) - 2
```

Subtracting:

* Network address
* Broadcast address

---

# 🚪 Task 4 – Ports: Doors to Services

# 📌 What is a Port?

Ports identify specific services running on a machine.

Examples:

* One machine can run:

  * SSH
  * Nginx
  * MySQL
  * Redis

Each service listens on a different port.

---

# 📌 Common Ports

| Port  | Service |
| ----- | ------- |
| 22    | SSH     |
| 80    | HTTP    |
| 443   | HTTPS   |
| 53    | DNS     |
| 3306  | MySQL   |
| 6379  | Redis   |
| 27017 | MongoDB |

---

# 🔹 Check Listening Ports

## Command

```bash id="jlym288"
ss -tulpn
```

---

## Example Output

```text id="jlym289"
tcp LISTEN 0 128 *:22
tcp LISTEN 0 511 *:80
```

---

# 📌 Observation

| Port | Service |
| ---- | ------- |
| 22   | SSH     |
| 80   | Nginx   |

---

# 🌍 Task 5 – Putting It Together

# 📌 Scenario 1

## Command

```text id="jlym290"
curl http://myapp.com:8080
```

---

# 📌 Networking Concepts Involved

| Concept    | Purpose                   |
| ---------- | ------------------------- |
| DNS        | Resolves `myapp.com`      |
| IP Address | Identifies server         |
| TCP        | Reliable connection       |
| Port 8080  | Application service       |
| HTTP       | Application communication |

---

# 📌 Scenario 2

## Database Connectivity Issue

```text id="jlym291"
10.0.1.50:3306
```

---

# 🔍 First Checks

1. Verify server reachable using `ping`
2. Verify MySQL listening on port `3306`
3. Check firewall/security group
4. Check DNS/IP configuration
5. Verify database service status

---

# 🧪 Hands-on Networking Commands

# 🔹 DNS Check

```bash id="jlym292"
dig google.com
```

---

# 🔹 IP Address Check

```bash id="jlym293"
ip addr show
```

---

# 🔹 Connectivity Check

```bash id="jlym294"
ping google.com
```

---

# 🔹 Port Check

```bash id="jlym295"
ss -tulpn
```

---

# 🔹 HTTP Check

```bash id="jlym296"
curl -I https://google.com
```

---

# 🔹 Network Connections

```bash id="jlym297"
netstat -an | head
```

---

# 🚨 Real-World DevOps Use Cases

Networking concepts are heavily used in:

* Kubernetes Services
* Ingress controllers
* Load balancers
* Cloud VPCs
* Docker networking
* API communication
* DNS troubleshooting

Examples:

* Pod communication issues
* Service discovery failures
* DNS outages
* API timeout debugging

---

# 🎯 What I Learned

✅ DNS resolution workflow
✅ IPv4 structure and private IP ranges
✅ CIDR and subnetting basics
✅ Common networking ports
✅ Difference between public and private IPs
✅ Port and connectivity troubleshooting

---

# ✅ Commands Practiced Today

```bash id="jlym298"
dig
ip addr show
ping
ss -tulpn
curl -I
netstat -an
```

---

# 🏁 Conclusion

Networking fundamentals are essential for every DevOps and SRE Engineer.

Understanding:

* DNS
* IP addressing
* Subnets
* Ports
* Connectivity troubleshooting
