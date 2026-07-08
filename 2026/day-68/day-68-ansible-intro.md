# Day 68 — Introduction to Ansible and Inventory Setup

`#90DaysOfDevOps` `#DevOpsKaJosh` `#TrainWithShubham`

Terraform provisions infrastructure. Ansible keeps it in the desired state afterwards — installing packages, configuring services, managing users — all **agentless**, over plain SSH.

---

## Task 1: Understanding Ansible (Theory)

### 1. What is Configuration Management? Why do we need it?

Configuration management (CM) is the practice of automating the setup, configuration, and maintenance of servers so that every environment (dev, staging, prod) is consistent, repeatable, and version-controlled — instead of manually SSH-ing into boxes and running commands by hand.

**Why we need it:**
- Eliminates "it works on my machine" / configuration drift between servers
- Makes infrastructure changes repeatable and auditable (stored as code in Git)
- Saves time when managing tens or hundreds of servers at once
- Enables fast, consistent disaster recovery — rebuild a server from scratch in minutes
- Reduces human error from manual configuration

### 2. How is Ansible different from Chef, Puppet, and Salt?

| Feature | Ansible | Chef | Puppet | Salt |
|---|---|---|---|---|
| Agent required | No (agentless) | Yes (chef-client) | Yes (puppet agent) | Optional (minion or agentless via SSH) |
| Language | YAML (declarative) | Ruby DSL | Puppet DSL | YAML / Python |
| Transport | SSH / WinRM | HTTPS (pull from server) | HTTPS (pull from master) | ZeroMQ / SSH |
| Learning curve | Low | Steep (Ruby knowledge helps) | Moderate | Moderate |
| Push vs Pull | Push | Pull | Pull | Push or Pull |

Ansible's biggest differentiator is that it needs **no agent installed on managed nodes** and uses **human-readable YAML** instead of a programming-language DSL, which makes it faster to pick up.

### 3. What does "agentless" mean? How does Ansible connect to managed nodes?

"Agentless" means there is no persistent background service or software that has to be pre-installed on the target (managed) servers. Ansible connects to managed nodes over standard **SSH** (or **WinRM** for Windows), runs Python-based modules temporarily on the remote machine, executes the task, and then cleans up after itself. The only requirements on the managed node are SSH access and Python installed — nothing else runs in the background.

### 4. Ansible Architecture

```
                      ┌─────────────────────────┐
                      │       CONTROL NODE       │
                      │  (your laptop / jump box)│
                      │                          │
                      │  - Ansible installed     │
                      │  - Inventory file        │
                      │  - Playbooks             │
                      │  - Ansible.cfg           │
                      └────────────┬─────────────┘
                                   │  SSH (port 22)
                 ┌─────────────────┼─────────────────┐
                 ▼                 ▼                 ▼
        ┌────────────────┐┌────────────────┐┌────────────────┐
        │  MANAGED NODE   ││  MANAGED NODE  ││  MANAGED NODE  │
        │   web-server    ││   app-server   ││   db-server    │
        │  (no agent,     ││  (no agent,    ││  (no agent,    │
        │   just Python)  ││   just Python) ││   just Python) │
        └────────────────┘└────────────────┘└────────────────┘
```

| Component | Description |
|---|---|
| **Control Node** | The machine where Ansible is installed and commands/playbooks are executed from. |
| **Managed Nodes** | The remote servers Ansible configures. No agent needed — just SSH + Python. |
| **Inventory** | A file (INI or YAML) listing managed nodes, grouped logically (e.g., `web`, `db`). |
| **Modules** | Reusable units of work — e.g., `yum`, `copy`, `service`, `command` — that Ansible ships to nodes and executes. |
| **Playbooks** | YAML files describing *what* should happen on *which* hosts, in order, idempotently. |

---

## Task 2: Lab Environment Setup

**Approach used:** Terraform (reusing TerraWeek skills) to provision 3 EC2 instances.

| Instance | Role | OS | Type |
|---|---|---|---|
| Instance 1 | web-server | Ubuntu 22.04 | t2.micro |
| Instance 2 | app-server | Ubuntu 22.04 | t2.micro |
| Instance 3 | db-server | Ubuntu 22.04 | t2.micro |

A security group was created allowing inbound SSH (port 22) from my IP, and a single key pair (`devops-key.pem`) was used for all three instances.

Verified SSH access to each node from the control node:
```bash
ssh -i ~/devops-key.pem ubuntu@<public-ip-1>
ssh -i ~/devops-key.pem ubuntu@<public-ip-2>
ssh -i ~/devops-key.pem ubuntu@<public-ip-3>
```

---

## Task 3: Installing Ansible

**Installed on:** the control node only (my local machine acting as the orchestrator) — **not** on any of the EC2 instances.

**Why only the control node?** Ansible is agentless — it pushes modules over SSH to managed nodes at runtime and removes them after execution. The managed nodes never need Ansible itself installed; they only need SSH access and Python. Only the control node needs the Ansible binary, inventory, and playbooks.

```bash
# Ubuntu/Debian control node
sudo apt update
sudo apt install ansible -y

# Verify installation
ansible --version
```

Sample output confirms the Ansible version, the config file being used (`/etc/ansible/ansible.cfg` by default), and the Python interpreter version:
```
ansible [core 2.16.x]
  config file = /etc/ansible/ansible.cfg
  python version = 3.11.x
```

---

## Task 4: Inventory File Setup

Project structure:
```bash
mkdir ansible-practice && cd ansible-practice
```

`inventory.ini`:
```ini
[web]
web-server ansible_host=<REDACTED_IP_1>

[app]
app-server ansible_host=<REDACTED_IP_2>

[db]
db-server ansible_host=<REDACTED_IP_3>

[all:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=~/devops-key.pem
```

**Connectivity check:**
```bash
ansible all -i inventory.ini -m ping
```

Expected result — all three hosts return green `SUCCESS`:
```
web-server | SUCCESS => { "ping": "pong" }
app-server | SUCCESS => { "ping": "pong" }
db-server  | SUCCESS => { "ping": "pong" }
```

**Troubleshooting checklist used:**
- `chmod 400 devops-key.pem` to fix key permission errors
- Confirmed the security group allowed SSH from my current IP
- Confirmed `ansible_user=ubuntu` matched the AMI (would be `ec2-user` for Amazon Linux)

---

## Task 5: Ad-Hoc Commands

Ad-hoc commands run one-off tasks without writing a full playbook — great for quick checks.

**1. Uptime on all servers**
```bash
ansible all -i inventory.ini -m command -a "uptime"
```
```
web-server | CHANGED | rc=0 >>
 14:02:11 up 2 days,  3:11,  1 user,  load average: 0.00, 0.01, 0.05
```

**2. Free memory on web servers only**
```bash
ansible web -i inventory.ini -m command -a "free -h"
```
```
web-server | CHANGED | rc=0 >>
              total        used        free      shared  buff/cache   available
Mem:           957Mi       178Mi       412Mi        1Mi        366Mi       650Mi
```

**3. Disk space on all servers**
```bash
ansible all -i inventory.ini -m command -a "df -h"
```
```
web-server | CHANGED | rc=0 >>
Filesystem      Size  Used Avail Use% Mounted on
/dev/root        7.6G  1.9G  5.6G  25% /
```

**4. Install a package (git) on the web group**
```bash
ansible web -i inventory.ini -m apt -a "name=git state=present" --become
```
```
web-server | CHANGED => {
    "changed": true,
    "msg": "git installed successfully"
}
```

**5. Copy a file to all servers**
```bash
echo "Hello from Ansible" > hello.txt
ansible all -i inventory.ini -m copy -a "src=hello.txt dest=/tmp/hello.txt"
```
```
web-server | CHANGED => { "changed": true, "dest": "/tmp/hello.txt" }
app-server | CHANGED => { "changed": true, "dest": "/tmp/hello.txt" }
db-server  | CHANGED => { "changed": true, "dest": "/tmp/hello.txt" }
```

**6. Verify the file was copied**
```bash
ansible all -i inventory.ini -m command -a "cat /tmp/hello.txt"
```
```
web-server | CHANGED | rc=0 >>
Hello from Ansible
```

### What does `--become` do?

`--become` tells Ansible to escalate privileges on the managed node (like running `sudo`) before executing the task. It's needed whenever a task requires root permissions — installing packages, managing services, editing system files, etc. Without it, tasks that need elevated privileges will fail with a permission-denied error.

---

## Task 6: Inventory Groups and Patterns

**Group of groups**, added to `inventory.ini`:
```ini
[application:children]
web
app

[all_servers:children]
application
db
```

**Running against groups:**
```bash
ansible application -i inventory.ini -m ping     # web + app servers
ansible db -i inventory.ini -m ping              # only db server
ansible all_servers -i inventory.ini -m ping     # everything
```

**Using patterns:**
```bash
ansible 'web:app' -i inventory.ini -m ping       # OR: web or app
ansible 'all:!db' -i inventory.ini -m ping       # NOT: all except db
```

**`ansible.cfg`** to avoid repeating `-i inventory.ini`:
```ini
[defaults]
inventory = inventory.ini
host_key_checking = False
remote_user = ubuntu
private_key_file = ~/devops-key.pem
```

With this in place in the project directory, the shorter form works:
```bash
ansible all -m ping
```

**Verification:** Yes — `ansible all -m ping` succeeds without specifying `-i inventory.ini`, since `ansible.cfg` in the current directory is picked up automatically before `~/.ansible.cfg` or `/etc/ansible/ansible.cfg`.

---

## `command` vs `shell` Module

| Aspect | `command` | `shell` |
|---|---|---|
| Shell processing | No — runs the binary directly | Yes — runs through `/bin/sh` |
| Pipes (`\|`), redirects (`>`), env vars (`$VAR`) | ❌ Not supported | ✅ Supported |
| Security | Safer — avoids shell injection risks | Riskier — full shell interpretation |
| Use case | Simple, single commands (`uptime`, `df -h`) | Commands needing pipes, chaining, or shell features (`ps aux \| grep nginx`) |

**Rule of thumb:** default to `command` unless the task specifically needs shell features — then use `shell`.

---

## Summary

| Item | Status |
|---|---|
| Ansible installed on control node | ✅ |
| 3 EC2 managed nodes reachable via SSH | ✅ |
| `inventory.ini` with grouped hosts | ✅ |
| `ansible all -m ping` → all green | ✅ |
| Ad-hoc commands (uptime, free, df, install pkg, copy file, verify) | ✅ |
| Nested groups (`:children`) and patterns (`:`, `!`) | ✅ |
| `ansible.cfg` for default inventory | ✅ |

---

**Key takeaway:** Ansible needs zero agents on managed nodes — just SSH and Python. With a single inventory file and one-line ad-hoc commands, you can check status, install packages, and push files across an entire fleet of servers from one control node.

`#90DaysOfDevOps` `#DevOpsKaJosh` `#TrainWithShubham`
```

The downloadable file is already available above. Remember to swap in your real EC2 IPs and actual command outputs (plus a screenshot of `ansible all -m ping`) before committing it to `2026/day-68/` in your fork.