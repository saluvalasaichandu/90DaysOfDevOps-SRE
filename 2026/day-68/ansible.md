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
<img width="1366" height="276" alt="image" src="https://github.com/user-attachments/assets/f7276908-373a-49f2-a1b1-159c0154c721" />
<img width="1042" height="478" alt="image" src="https://github.com/user-attachments/assets/985075dd-dadc-406d-88ad-2f1ecbe428b2" />
<img width="779" height="560" alt="image" src="https://github.com/user-attachments/assets/c07f182e-7ea6-4b1b-b018-b206dca125e8" />
<img width="751" height="569" alt="image" src="https://github.com/user-attachments/assets/7cc2d30d-1753-4d0c-b463-c73c62dd7270" />
<img width="745" height="573" alt="image" src="https://github.com/user-attachments/assets/a99c7ad3-830f-444a-8a48-0c0fea3d86f8" />

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
[all:vars]
ansible_python_interpreter=/usr/bin/python3.14

[web]
ubuntu@34.204.49.70

[app]
ubuntu@54.221.180.49

[db]
ubuntu@34.227.49.194

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
<img width="765" height="548" alt="image" src="https://github.com/user-attachments/assets/608ad700-d8ec-44f8-8060-2002d17977e8" />

---

# 📚 Task 5 – Ad-Hoc Commands

## Check Uptime

```bash
ansible all -m command -a "uptime"
```
<img width="1366" height="729" alt="image" src="https://github.com/user-attachments/assets/eb6d081f-3ea4-462c-b6cb-d0dd5c539023" />

---

## Check Memory

```bash
ansible -i inventory.ini web -m command -a "free -h"
```

---

## Check Disk

```bash
ansible -i inventory.ini all -m command -a "df -h"
```
<img width="1365" height="725" alt="image" src="https://github.com/user-attachments/assets/68447965-9f84-49c4-bbbf-bbf0345f1ec0" />

---

## Install Git

Amazon Linux

```bash
ansible web -m yum -a "name=git state=present" --become
```

Ubuntu

```bash
ansible -i inventory.ini web -m apt -a "name=git state=present" --become
```
<img width="1028" height="171" alt="image" src="https://github.com/user-attachments/assets/b9aaad8a-59fb-43f1-8fa1-4a73b0fb45c1" />
<img width="572" height="122" alt="image" src="https://github.com/user-attachments/assets/b1ede767-0d0a-4040-bcfb-97f11e54a619" />

---

## Copy File

```bash
echo "Hello from Ansible" > hello.txt

ansible -i inventory.ini all -m copy -a "src=hello.txt dest=/tmp/hello.txt"

```
<img width="1051" height="718" alt="image" src="https://github.com/user-attachments/assets/874672a2-f30a-40f6-9761-102b8a57629d" />

---

## Verify File

```bash
ansible -i inventory.ini all -m command -a "cat /tmp/hello.txt"
```

Output

```
Hello from Ansible
```
<img width="1098" height="226" alt="image" src="https://github.com/user-attachments/assets/b006fcb6-3691-46ec-a3a9-689ced562487" />

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
