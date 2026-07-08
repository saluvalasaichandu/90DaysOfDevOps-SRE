# 🚀 Day 68 – Introduction to Ansible & Inventory Setup

> **90 Days of DevOps | Ansible Week - Day 68**

## 📌 Objective

After provisioning infrastructure using Terraform, the next step is configuring and managing servers automatically. Ansible is an **agentless Configuration Management and Automation Tool** that connects to remote servers over SSH to install packages, configure services, copy files, and manage infrastructure.

---

# 📚 Task 1 – Understand Ansible

## What is Configuration Management?

Configuration Management is the process of maintaining servers in a desired and consistent state.

### Why do we need it?

- Automates repetitive tasks
- Reduces manual errors
- Maintains consistency
- Saves deployment time
- Supports Infrastructure as Code

---

## What is Ansible?

Ansible is an open-source automation tool developed by Red Hat.

### Features

- Agentless
- Uses SSH
- YAML-based Playbooks
- Idempotent
- Easy to Learn
- Multi-platform Support

---

## Ansible vs Other Tools

| Tool | Agent | Language |
|------|-------|----------|
| Ansible | ❌ No | YAML |
| Puppet | ✅ Yes | DSL |
| Chef | ✅ Yes | Ruby |
| SaltStack | Optional | YAML/Python |

---

## What does Agentless mean?

Agentless means **no software needs to be installed on the managed servers.**

Ansible only requires:

- SSH
- Python (usually pre-installed)

Connection Flow

```
Control Node
      │
      │ SSH
      ▼
Managed Nodes
```

---

## Ansible Architecture

```
                    Control Node
               (Ansible Installed)
                       │
                SSH (Port 22)
        ─────────┼─────────┼────────
        │        │         │
      Web      App       DB
     Server   Server    Server
```

### Components

| Component | Description |
|------------|-------------|
| Control Node | Machine where Ansible is installed |
| Managed Nodes | Target servers managed by Ansible |
| Inventory | List of managed servers |
| Modules | Small reusable tasks |
| Playbooks | YAML automation files |

---

# 📚 Task 2 – Setup Lab Environment

Launch **3 EC2 Instances**

| Server | Purpose |
|----------|----------|
| Web Server | Web Application |
| App Server | Application |
| DB Server | Database |

Configuration

- Amazon Linux 2
- t2.micro
- Port 22 Open
- Same Key Pair

Verify SSH

```bash
ssh -i key.pem ec2-user@<PUBLIC-IP>
```

Expected Output

```
Connected Successfully
```

---

# 📚 Task 3 – Install Ansible

## Ubuntu

```bash
sudo apt update
sudo apt install ansible -y
```

## Amazon Linux

```bash
sudo yum install ansible -y
```

OR

```bash
pip3 install ansible
```

Verify Installation

```bash
ansible --version
```

Example

```
ansible [core 2.18.x]
python version 3.x
```

### Answer

**Where is Ansible installed?**

Only on the **Control Node**.

**Why?**

Because Ansible connects remotely using SSH. Managed nodes do not require any agent.

---

# 📚 Task 4 – Create Inventory

Project Structure

```
ansible-practice/
│
├── inventory.ini
├── ansible.cfg
└── hello.txt
```

Create Inventory

```ini
[web]
web-server ansible_host=3.10.xx.xx

[app]
app-server ansible_host=13.22.xx.xx

[db]
db-server ansible_host=54.92.xx.xx

[all:vars]
ansible_user=ec2-user
ansible_ssh_private_key_file=~/key.pem
```

Verify Connectivity

```bash
ansible all -i inventory.ini -m ping
```

Output

```
web-server | SUCCESS
app-server | SUCCESS
db-server | SUCCESS

"ping":"pong"
```

Troubleshooting

- Check SSH Key
- Verify Security Group
- Verify ansible_user
- Verify Public IP
- Check SSH Connection

---

# 📚 Task 5 – Ad-Hoc Commands

## Check Uptime

```bash
ansible all -m command -a "uptime"
```

---

## Check Memory

```bash
ansible web -m command -a "free -h"
```

---

## Check Disk

```bash
ansible all -m command -a "df -h"
```

---

## Install Git

Amazon Linux

```bash
ansible web -m yum -a "name=git state=present" --become
```

Ubuntu

```bash
ansible web -m apt -a "name=git state=present" --become
```

---

## Copy File

```bash
echo "Hello from Ansible" > hello.txt

ansible all -m copy -a "src=hello.txt dest=/tmp/hello.txt"
```

---

## Verify File

```bash
ansible all -m command -a "cat /tmp/hello.txt"
```

Output

```
Hello from Ansible
```

---

### What does --become do?

`--become` executes commands with **root (sudo) privileges.**

Used for

- Package Installation
- User Management
- File Permissions
- Service Management

Example

```bash
ansible web -m yum -a "name=httpd state=present" --become
```

---

# 📚 Task 6 – Inventory Groups & Patterns

Inventory Groups

```ini
[application:children]
web
app

[all_servers:children]
application
db
```

Ping Application Servers

```bash
ansible application -m ping
```

Ping DB

```bash
ansible db -m ping
```

Ping All

```bash
ansible all_servers -m ping
```

---

## Inventory Patterns

Web OR App

```bash
ansible "web:app" -m ping
```

All Except DB

```bash
ansible "all:!db" -m ping
```

---

## Configure ansible.cfg

```ini
[defaults]

inventory = inventory.ini
host_key_checking = False
remote_user = ec2-user
private_key_file = ~/key.pem
```

Now execute

```bash
ansible all -m ping
```

No need to specify inventory every time.

---

# 📚 Command vs Shell Module

| Command | Shell |
|-----------|----------|
| No shell support | Supports pipes |
| Secure | Less Secure |
| No Redirects | Supports Redirects |
| Faster | Slightly Slower |

Example

Command

```bash
ansible all -m command -a "uptime"
```

Shell

```bash
ansible all -m shell -a "cat /etc/passwd | grep root"
```

---

# 📚 Useful Ansible Commands

```bash
ansible --version

ansible all -m ping

ansible all -m command -a "uptime"

ansible all -m shell -a "hostname"

ansible all -m copy -a "src=file dest=/tmp"

ansible all -m yum -a "name=httpd state=present" --become

ansible all -m service -a "name=httpd state=started" --become

ansible-inventory --list

ansible-doc yum

ansible-config dump
```

---

# 📚 Interview Questions

## What is Ansible?

Ansible is an agentless automation and configuration management tool.

---

## Why is Ansible Agentless?

Because it uses SSH instead of installing agents.

---

## What is Inventory?

Inventory contains the list of managed servers.

---

## What are Modules?

Modules are reusable units of work like:

- ping
- copy
- yum
- apt
- command
- shell
- service

---

## What are Playbooks?

Playbooks are YAML files containing multiple automation tasks.

---

## Difference between Command and Shell?

Command does not support shell operators.

Shell supports:

- Pipes
- Redirects
- Variables

---

## What is --become?

Runs commands using sudo/root privileges.

---

# 📚 Important Files

```
inventory.ini
```

Stores server information.

```
ansible.cfg
```

Stores Ansible configuration.

```
playbook.yml
```

Stores automation tasks.

---

# 📚 Key Learnings

- Understood Configuration Management.
- Learned Ansible Architecture.
- Installed Ansible on Control Node.
- Connected EC2 instances using SSH.
- Created Inventory File.
- Executed Ad-Hoc Commands.
- Used Inventory Groups.
- Used Inventory Patterns.
- Configured ansible.cfg.
- Learned Command vs Shell Module.
- Understood --become privilege escalation.

---

# 🎯 Conclusion

On Day 68, I learned the fundamentals of Ansible by setting up a Control Node, configuring multiple EC2 instances through an Inventory file, and executing Ad-Hoc Commands over SSH without installing any agents. This provides the foundation for building Ansible Playbooks, Roles, and fully automated server configuration in the upcoming days.

---