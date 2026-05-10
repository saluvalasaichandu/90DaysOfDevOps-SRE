# 🚀 Day 09 – Linux User & Group Management Challenge

# 📌 Introduction

User and Group Management is one of the most important Linux administration skills for DevOps and SRE Engineers.

In real-world production environments, DevOps Engineers manage:

* Multiple users
* Team-based access control
* Shared directories
* Permissions
* Security and access management

Linux uses:

* Users → individual accounts
* Groups → collection of users
* Permissions → access control mechanism

In today’s hands-on challenge, I practiced:
✅ Creating Linux users
✅ Setting passwords
✅ Creating groups
✅ Assigning users to groups
✅ Managing shared directories
✅ Configuring Linux permissions
✅ Testing real-world team collaboration setup

---

# 👤 What is a User in Linux?

A user is an individual account that can:

* Login to Linux
* Access files
* Run commands
* Execute applications

Each user has:

* Username
* UID (User ID)
* Home directory
* Default shell

---

# 👥 What is a Group in Linux?

A group is a collection of users.

Groups help:

* Manage permissions
* Share access
* Control resources efficiently

Example:

* Developers team
* Admin team
* DevOps team

---

# 🔍 Important Linux Files

| File          | Purpose             |
| ------------- | ------------------- |
| `/etc/passwd` | User information    |
| `/etc/shadow` | Encrypted passwords |
| `/etc/group`  | Group information   |

---

# 🛠️ Task 1 – Create Users

# 📌 Objective

Create users:

* tokyo
* berlin
* professor

Each user should have:

* Home directory
* Password

---

# 🔹 Create User `tokyo`

## Command

```bash id="swyqdn"
sudo useradd -m tokyo
```
<img width="684" height="102" alt="image" src="https://github.com/user-attachments/assets/ba5586c0-0b00-4b30-bbde-33ee5285cf65" />

### Purpose

Creates user with home directory.

---

# 🔹 Set Password

## Command

```bash id="sck5ai"
sudo passwd tokyo
```
<img width="1366" height="159" alt="image" src="https://github.com/user-attachments/assets/fb374118-322c-4a14-807a-458d7cb6bc24" />

<img width="968" height="86" alt="image" src="https://github.com/user-attachments/assets/be4fb961-6631-4911-9751-ff8a6ee8f942" />

### Observation

Password set successfully.

---

# 🔹 Create Remaining Users

## Commands

```bash id="jlwmzc"
sudo useradd -m berlin
sudo passwd berlin

sudo useradd -m professor
sudo passwd professor
```

---

# 🔹 Verify Users

## Check `/etc/passwd`

```bash id="jlwmzd"
cat /etc/passwd | grep -E 'tokyo|berlin|professor'
```

## Example Output

```text id="jlwmze"
tokyo:x:1001:1001::/home/tokyo:/bin/sh
berlin:x:1002:1002::/home/berlin:/bin/sh
professor:x:1003:1003::/home/professor:/bin/sh
```

---

# 🔹 Verify Home Directories

## Command

```bash id="jlwmzf"
ls -l /home
```
<img width="963" height="192" alt="image" src="https://github.com/user-attachments/assets/2b4f0fc7-42dd-4c38-8830-a14e4f60d20e" />

### Observation

```text id="jlwmzg"
tokyo
berlin
professor
```

Home directories created successfully.

---

# 👥 Task 2 – Create Groups

# 📌 Objective

Create:

* developers
* admins

---

# 🔹 Create Groups

## Commands

```bash id="jlwmzh"
sudo groupadd developers
sudo groupadd admins
```
<img width="731" height="87" alt="image" src="https://github.com/user-attachments/assets/e2eb6e2f-0584-43ab-bf4a-978b12f7099c" />

---

# 🔹 Verify Groups

## Command

```bash id="jlwmzi"
cat /etc/group | grep -E 'developers|admins'
```
<img width="1060" height="120" alt="image" src="https://github.com/user-attachments/assets/1713ff87-a947-47b9-a747-849360f1ac93" />

## Example Output

```text id="jlwmzj"
developers:x:1004:
admins:x:1005:
```

---

# 👤 Task 3 – Assign Users to Groups

# 📌 Objective

| User      | Groups             |
| --------- | ------------------ |
| tokyo     | developers         |
| berlin    | developers, admins |
| professor | admins             |

---

# 🔹 Add `tokyo` to developers

## Command

```bash id="jlwmzk"
sudo usermod -aG developers tokyo
```
<img width="951" height="60" alt="image" src="https://github.com/user-attachments/assets/a94de3c4-3c36-4cd7-868c-d7f6c7fa1586" />

---

# 🔹 Add `berlin` to developers & admins

## Command

```bash id="jlwmzl"
sudo usermod -aG developers,admins berlin
```

---

# 🔹 Add `professor` to admins

## Command

```bash id="jlwmzm"
sudo usermod -aG admins professor
```

---

# 🔹 Verify Group Membership

## Commands

```bash id="jlwmzn"
groups tokyo
groups berlin
groups professor
```

## Example Output

```text id="jlwmzo"
tokyo : tokyo developers
berlin : berlin developers admins
professor : professor admins
```
<img width="1079" height="140" alt="image" src="https://github.com/user-attachments/assets/075b19ef-422e-4e55-ad9a-c08efad6cf82" />

---

# 📂 Task 4 – Shared Directory Setup

# 📌 Objective

Create shared project directory:

```text id="jlwmzp"
/opt/dev-project
```

Accessible by developers group.

---

# 🔹 Create Directory

## Command

```bash id="jlwmzq"
sudo mkdir -p /opt/dev-project
```
<img width="829" height="55" alt="image" src="https://github.com/user-attachments/assets/cbbd51ac-43f6-458d-8ba5-767a3c3d910a" />

---

# 🔹 Change Group Ownership

## Command

```bash id="jlwmzr"
sudo chgrp developers /opt/dev-project
```

---

# 🔹 Set Permissions

## Command

```bash id="jlwmzs"
sudo chmod 775 /opt/dev-project
```

## Permission Meaning

| Permission | Meaning |
| ---------- | ------- |
| 7          | rwx     |
| 7          | rwx     |
| 5          | r-x     |

---

# 🔹 Verify Permissions

## Command

```bash id="jlwmzt"
ls -ld /opt/dev-project
```

## Example Output

```text id="jlwmzu"
drwxrwxr-x 2 root developers 4096
```
<img width="1008" height="97" alt="image" src="https://github.com/user-attachments/assets/5529fdbe-eedf-4d9e-a369-88a8faaee85f" />

---

# 🔹 Test File Creation as tokyo

## Command

```bash id="jlwmzv"
sudo -u tokyo touch /opt/dev-project/tokyo-file.txt
```

---

# 🔹 Test File Creation as berlin

## Command

```bash id="jlwmzw"
sudo -u berlin touch /opt/dev-project/berlin-file.txt
```

---

# 🔹 Verify Files

## Command

```bash id="jlwmzx"
ls -l /opt/dev-project
```
<img width="1132" height="149" alt="image" src="https://github.com/user-attachments/assets/22bbea34-36a8-499b-978d-fe9304039867" />

---

# 👨‍💻 Task 5 – Team Workspace Challenge

# 📌 Objective

Create collaborative workspace for project-team.

---

# 🔹 Create User `nairobi`

## Command

```bash id="jlwmzy"
sudo useradd -m nairobi
sudo passwd nairobi
```

---

# 🔹 Create Group

## Command

```bash id="jlwmzz"
sudo groupadd project-team
```

---

# 🔹 Add Users to Group

## Command

```bash id="jlym001"
sudo usermod -aG project-team nairobi
sudo usermod -aG project-team tokyo
```

---

# 🔹 Create Workspace Directory

## Command

```bash id="jlym002"
sudo mkdir -p /opt/team-workspace
```

---

# 🔹 Assign Group Ownership

## Command

```bash id="jlym003"
sudo chgrp project-team /opt/team-workspace
```

---

# 🔹 Set Permissions

## Command

```bash id="jlym004"
sudo chmod 775 /opt/team-workspace
```

---

# 🔹 Test File Creation

## Command

```bash id="jlym005"
sudo -u nairobi touch /opt/team-workspace/nairobi.txt
```

---

# 🔹 Verify Workspace

## Command

```bash id="jlym006"
ls -ld /opt/team-workspace
ls -l /opt/team-workspace
```
<img width="1187" height="417" alt="image" src="https://github.com/user-attachments/assets/0a43b564-76d4-4d27-813f-50d79efa5cb6" />

---

# 🔍 Understanding Linux Permissions

## Permission Format

```text id="jlym007"
drwxrwxr-x
```

| Section | Meaning            |
| ------- | ------------------ |
| d       | directory          |
| rwx     | owner permissions  |
| rwx     | group permissions  |
| r-x     | others permissions |

---

# 🚨 Troubleshooting Scenario

# Problem

User unable to access shared directory.

---

# Step 1 – Verify Group Membership

```bash id="jlym008"
groups tokyo
```

---

# Step 2 – Verify Directory Permissions

```bash id="jlym009"
ls -ld /opt/dev-project
```

---

# Step 3 – Verify Group Ownership

```bash id="jlym010"
ls -ld /opt/dev-project
```

---

# Step 4 – Fix Permissions

```bash id="jlym011"
sudo chmod 775 /opt/dev-project
```

---

# 🎯 Real-World DevOps Use Cases

Linux users and groups are heavily used in:

* Kubernetes nodes
* CI/CD servers
* Jenkins agents
* Shared deployments
* Team-based access management
* Production server security

Examples:

* Developers access logs
* Admins restart services
* Teams share deployment directories

---

# 🎯 What I Learned

✅ How Linux users work
✅ How Linux groups manage permissions
✅ How to configure shared directories
✅ How to assign users to multiple groups
✅ Understanding Linux permissions model
✅ Real-world team collaboration setup

---

# ✅ Commands Practiced Today

```bash id="jlym012"
useradd -m
passwd
groupadd
usermod -aG
groups
cat /etc/passwd
cat /etc/group
mkdir -p
chgrp
chmod 775
ls -ld
sudo -u username command
```

---

# 🏁 Conclusion

Linux User and Group Management is a foundational skill for every DevOps and SRE Engineer.

Understanding:

* Users
* Groups
* Permissions
* Shared directories
* Access control

