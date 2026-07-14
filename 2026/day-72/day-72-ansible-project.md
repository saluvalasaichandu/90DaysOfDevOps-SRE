# Day 72 - Ansible Project: Automate Docker & Nginx Deployment

## 📌 Project Overview

After learning Ansible fundamentals over the previous days—including inventory management, playbooks, variables, handlers, roles, templates, Ansible Galaxy, and Vault—it's time to build a real-world automation project.

In this project, Ansible automates an entire server deployment from scratch.

With a single command, the playbook will:

- Install Docker
- Install Docker Compose
- Pull a Docker image from Docker Hub
- Run a Docker container
- Install and configure Nginx
- Configure Nginx as a Reverse Proxy
- Secure Docker Hub credentials using Ansible Vault
- Deploy everything using reusable Ansible Roles

---

# 🏗️ Project Architecture

```
                    Ansible Controller
                           │
                     SSH (Port 22)
                           │
                           ▼
                ┌────────────────────┐
                │   Managed Server   │
                │                    │
                │  Nginx (Port 80)   │
                │         │          │
                │         ▼          │
                │ Docker Container   │
                │    (Port 8080)     │
                └────────────────────┘
                           │
                           ▼
                     End Users
```

---

# 📂 Project Structure

```
ansible-docker-project/

├── ansible.cfg
├── inventory.ini
├── site.yml
│
├── group_vars/
│   ├── all.yml
│   └── web/
│       ├── vars.yml
│       └── vault.yml
│
├── roles/
│   ├── common/
│   │   └── tasks/
│   │       └── main.yml
│   │
│   ├── docker/
│   │   ├── defaults/
│   │   ├── handlers/
│   │   ├── tasks/
│   │   └── templates/
│   │
│   └── nginx/
│       ├── defaults/
│       ├── handlers/
│       ├── tasks/
│       └── templates/
│
└── README.md
```

---

# ⚙️ Prerequisites

- AWS Account
- Two Amazon Linux 2 EC2 Instances
- Security Group allowing:
  - SSH (22)
  - HTTP (80)
  - Application Port (8080)
- Ansible Installed
- Passwordless SSH Configured
- Docker Hub Account

---

# 🚀 Step 1: Launch EC2 Instances

Create two EC2 instances.

| Server | Purpose |
|----------|----------|
| ansible-controller | Control Node |
| web-server | Managed Node |

---

# 🚀 Step 2: Install Ansible

```bash
sudo yum update -y
sudo amazon-linux-extras enable ansible2
sudo yum install ansible -y
```

Verify installation:

```bash
ansible --version
```

---

# 🚀 Step 3: Configure Passwordless SSH

Generate SSH Key

```bash
ssh-keygen
```

Copy Public Key

```bash
ssh-copy-id ec2-user@<Managed-Node-IP>
```

Test

```bash
ssh ec2-user@<Managed-Node-IP>
```

---

# 🚀 Step 4: Create Project Directory

```bash
mkdir ansible-docker-project
cd ansible-docker-project
```

---

# 🚀 Step 5: Generate Ansible Roles

```bash
mkdir roles

ansible-galaxy init roles/common

ansible-galaxy init roles/docker

ansible-galaxy init roles/nginx
```

---

# 🚀 Step 6: Configure Inventory

Create `inventory.ini`

```ini
[web]
<Managed-Node-IP> ansible_user=ec2-user
```

Verify connectivity

```bash
ansible all -m ping
```

Expected Output

```
SUCCESS
```

---

# 🚀 Step 7: Configure ansible.cfg

```ini
[defaults]
inventory=inventory.ini
host_key_checking=False
remote_user=ec2-user
roles_path=roles
vault_password_file=.vault_pass
```

---

# 🚀 Step 8: Create Common Variables

Create

```
group_vars/all.yml
```

Example

```yaml
timezone: Asia/Kolkata

project_name: devops-app

app_env: development

common_packages:
  - git
  - wget
  - curl
  - unzip
  - vim
  - tree
  - jq
```

---

# 🚀 Step 9: Install Docker Collection

```bash
ansible-galaxy collection install community.docker
```

---

# 🚀 Step 10: Build Common Role

The Common role performs:

- System Update
- Install Common Packages
- Configure Timezone
- Configure Hostname
- Create Deploy User

---

# 🚀 Step 11: Build Docker Role

Docker Role performs:

- Install Docker
- Enable Docker Service
- Install Docker Compose
- Login to Docker Hub
- Pull Docker Image
- Run Docker Container
- Perform Health Check

Default Container

```
Image : nginx

Container Port : 80

Host Port : 8080
```

---

# 🚀 Step 12: Build Nginx Role

Nginx Role performs:

- Install Nginx
- Configure Reverse Proxy
- Validate Configuration
- Reload Service

Traffic Flow

```
Browser

↓

Port 80

↓

Nginx

↓

Docker Container

↓

Port 8080
```

---

# 🚀 Step 13: Secure Credentials Using Ansible Vault

Create Vault File

```bash
ansible-vault create group_vars/web/vault.yml
```

Example

```yaml
vault_docker_username: your_username

vault_docker_password: your_password
```

Create Password File

```bash
echo "YourVaultPassword" > .vault_pass
```

Secure It

```bash
chmod 600 .vault_pass
```

Ignore Password File

```
.vault_pass
```

---

# 🚀 Step 14: Master Playbook

Run Complete Deployment

```bash
ansible-playbook site.yml
```

Dry Run

```bash
ansible-playbook site.yml --check --diff
```

---

# 🚀 Step 15: Execute Individual Roles

Run Docker Only

```bash
ansible-playbook site.yml --tags docker
```

Run Nginx Only

```bash
ansible-playbook site.yml --tags nginx
```

Skip Common Tasks

```bash
ansible-playbook site.yml --skip-tags common
```

---

# 🚀 Step 16: Verify Deployment

Verify Docker

```bash
docker ps
```

Verify Container

```bash
curl http://localhost:8080
```

Verify Reverse Proxy

```bash
curl http://localhost
```

Or open in browser

```
http://<EC2-Public-IP>
```

Expected Page

```
Welcome to nginx!
```

---

# 🚀 Step 17: Verify Idempotency

Run Playbook Again

```bash
ansible-playbook site.yml
```

Expected Output

```
ok=xx

changed=0
```

---

# 🚀 Step 18: Deploy Another Docker Image

Example

```bash
ansible-playbook site.yml \
-e "docker_app_image=httpd docker_app_tag=latest docker_app_name=apache-app"
```

Verify

```bash
docker ps
```
---

# 📚 Key Concepts Covered

- Inventory
- Playbooks
- Roles
- Variables
- Templates
- Handlers
- Docker Modules
- Nginx Reverse Proxy
- Docker Compose
- Ansible Galaxy
- Ansible Vault
- Tags
- Idempotency

---

# 🛠️ Technologies Used

- AWS EC2
- Amazon Linux 2
- Ansible
- Docker
- Docker Compose
- Nginx
- YAML
- Ansible Galaxy
- Ansible Vault

---
