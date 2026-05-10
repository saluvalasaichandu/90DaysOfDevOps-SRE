# 🚀 Day 11 – File Ownership Challenge (chown & chgrp)

# 📌 Introduction

Linux File Ownership is one of the most important concepts in Linux Administration, DevOps, and Cloud Engineering.

In production environments, DevOps Engineers constantly manage:

* Application files
* Deployment directories
* Shared team folders
* Log files
* CI/CD artifacts
* Container volumes

Linux ownership helps control:

* Who owns files
* Which group can access them
* Who can modify applications and logs

In today’s hands-on challenge, I practiced:
✅ Understanding file ownership
✅ Changing file owners using `chown`
✅ Changing file groups using `chgrp`
✅ Managing ownership recursively
✅ Setting ownership for shared team projects
✅ Real-world DevOps ownership scenarios

---

# 📂 Understanding Linux File Ownership

Every file and directory in Linux has:

* Owner (User)
* Group

---

# 🔍 View Ownership Information

## Command

```bash id="jlwm104"
ls -l
```

## Example Output

```text id="jlwm105"
-rw-r--r-- 1 ubuntu ubuntu 0 May 10 devops-file.txt
```

---

# 📌 Ownership Breakdown

| Section           | Meaning          |
| ----------------- | ---------------- |
| `-rw-r--r--`      | File permissions |
| `ubuntu`          | Owner            |
| `ubuntu`          | Group            |
| `0`               | File size        |
| `devops-file.txt` | File name        |

---

# 📌 Difference Between Owner and Group

| Owner                             | Group                          |
| --------------------------------- | ------------------------------ |
| Individual user who owns the file | Collection of users            |
| Has primary control over file     | Shared access control          |
| Can modify ownership              | Users in group may access file |

---

# 🛠️ Task 1 – Understanding Ownership

# 🔹 Check Ownership in Home Directory

## Command

```bash id="jlwm106"
ls -l ~
```

### Observation

Files are owned by current logged-in user and default group.

---

# 🔹 Identify Owner & Group

## Example

```text id="jlwm107"
-rw-r--r-- 1 ubuntu ubuntu
```

| Owner  | Group  |
| ------ | ------ |
| ubuntu | ubuntu |

---

# 🔧 Task 2 – Basic chown Operations

# 📌 What is chown?

`chown` = Change Owner

Used to:

* Transfer file ownership
* Assign files to application users
* Manage deployment ownership

---

# 🔹 Create File

## Command

```bash id="jlwm108"
touch devops-file.txt
```

---

# 🔹 Check Current Owner

## Command

```bash id="jlwm109"
ls -l devops-file.txt
```

---

# 🔹 Create Users (if not existing)

## Commands

```bash id="jlwm110"
sudo useradd -m tokyo
sudo useradd -m berlin
```

---

# 🔹 Change Owner to tokyo

## Command

```bash id="jlwm111"
sudo chown tokyo devops-file.txt
```

---

# 🔹 Verify Ownership

## Command

```bash id="jlwm112"
ls -l devops-file.txt
```

## Example Output

```text id="jlwm113"
-rw-r--r-- 1 tokyo ubuntu
```

---

# 🔹 Change Owner to berlin

## Command

```bash id="jlwm114"
sudo chown berlin devops-file.txt
```

---

# 🔹 Verify Again

## Command

```bash id="jlwm115"
ls -l devops-file.txt
```

---

# 👥 Task 3 – Basic chgrp Operations

# 📌 What is chgrp?

`chgrp` = Change Group

Used to:

* Assign shared group ownership
* Enable team collaboration
* Manage shared application access

---

# 🔹 Create File

## Command

```bash id="jlwm116"
touch team-notes.txt
```

---

# 🔹 Create Group

## Command

```bash id="jlwm117"
sudo groupadd heist-team
```

---

# 🔹 Change Group Ownership

## Command

```bash id="jlwm118"
sudo chgrp heist-team team-notes.txt
```

---

# 🔹 Verify Group Change

## Command

```bash id="jlwm119"
ls -l team-notes.txt
```

## Example Output

```text id="jlwm120"
-rw-r--r-- 1 ubuntu heist-team
```

---

# 🔧 Task 4 – Change Owner and Group Together

# 📌 Syntax

```bash id="jlwm121"
sudo chown owner:group filename
```

---

# 🔹 Create YAML File

## Command

```bash id="jlwm122"
touch project-config.yaml
```

---

# 🔹 Create User professor

## Command

```bash id="jlwm123"
sudo useradd -m professor
```

---

# 🔹 Change Owner & Group Together

## Command

```bash id="jlwm124"
sudo chown professor:heist-team project-config.yaml
```

---

# 🔹 Verify Ownership

## Command

```bash id="jlwm125"
ls -l project-config.yaml
```

## Example Output

```text id="jlwm126"
-rw-r--r-- 1 professor heist-team
```

---

# 🔹 Create Directory

## Command

```bash id="jlwm127"
mkdir app-logs
```

---

# 🔹 Assign Ownership

## Command

```bash id="jlwm128"
sudo chown berlin:heist-team app-logs
```

---

# 🔹 Verify Directory Ownership

## Command

```bash id="jlwm129"
ls -ld app-logs
```

---

# 🔄 Task 5 – Recursive Ownership

# 📌 Why Recursive Ownership Matters

Applications often contain:

* Multiple directories
* Config files
* Logs
* Scripts

Recursive ownership simplifies management.

---

# 🔹 Create Directory Structure

## Commands

```bash id="jlwm130"
mkdir -p heist-project/vault
mkdir -p heist-project/plans

touch heist-project/vault/gold.txt
touch heist-project/plans/strategy.conf
```

---

# 🔹 Create planners Group

## Command

```bash id="jlwm131"
sudo groupadd planners
```

---

# 🔹 Recursive Ownership Change

## Command

```bash id="jlwm132"
sudo chown -R professor:planners heist-project/
```

---

# 🔹 Verify Recursive Ownership

## Command

```bash id="jlwm133"
ls -lR heist-project/
```

## Observation

All files and directories changed successfully.

---

# 🧪 Task 6 – Real-World Practice Challenge

# 📌 Scenario

Create team-based project ownership.

---

# 🔹 Create Users

## Commands

```bash id="jlwm134"
sudo useradd -m tokyo
sudo useradd -m berlin
sudo useradd -m nairobi
```

---

# 🔹 Create Groups

## Commands

```bash id="jlwm135"
sudo groupadd vault-team
sudo groupadd tech-team
```

---

# 🔹 Create Project Directory

## Command

```bash id="jlwm136"
mkdir bank-heist
```

---

# 🔹 Create Project Files

## Commands

```bash id="jlwm137"
touch bank-heist/access-codes.txt
touch bank-heist/blueprints.pdf
touch bank-heist/escape-plan.txt
```

---

# 🔹 Assign Different Ownerships

## Commands

```bash id="jlwm138"
sudo chown tokyo:vault-team bank-heist/access-codes.txt

sudo chown berlin:tech-team bank-heist/blueprints.pdf

sudo chown nairobi:vault-team bank-heist/escape-plan.txt
```

---

# 🔹 Verify Ownerships

## Command

```bash id="jlwm139"
ls -l bank-heist/
```

## Example Output

```text id="jlwm140"
-rw-r--r-- 1 tokyo   vault-team access-codes.txt
-rw-r--r-- 1 berlin  tech-team  blueprints.pdf
-rw-r--r-- 1 nairobi vault-team escape-plan.txt
```

---

# 🔍 Understanding Recursive Ownership

# Without `-R`

```bash id="jlwm141"
sudo chown professor heist-project/
```

Changes only parent directory ownership.

---

# With `-R`

```bash id="jlwm142"
sudo chown -R professor:planners heist-project/
```

Changes:

* Parent directory
* Subdirectories
* All files recursively

---

# 🚨 Troubleshooting Scenario

# Problem

Application cannot write logs.

---

# Step 1 – Check Ownership

```bash id="jlwm143"
ls -ld /var/log/myapp
```

---

# Step 2 – Fix Ownership

```bash id="jlwm144"
sudo chown -R appuser:appgroup /var/log/myapp
```

---

# Step 3 – Verify

```bash id="jlwm145"
ls -ld /var/log/myapp
```

---

# 🎯 Real-World DevOps Use Cases

Ownership management is heavily used in:

* Docker containers
* Kubernetes volumes
* Jenkins workspaces
* CI/CD pipelines
* Shared deployment directories
* Log file management
* Application deployments

Examples:

* Nginx owns web files
* Jenkins owns build directories
* Docker volumes require proper ownership

---

# 🎯 What I Learned

✅ Difference between owner and group
✅ How `chown` works
✅ How `chgrp` works
✅ Recursive ownership management
✅ Shared team ownership setup
✅ Real-world DevOps permission management

---

# ✅ Commands Practiced Today

```bash id="jlwm146"
ls -l
chown
chgrp
chown owner:group
chown -R
groupadd
useradd -m
mkdir -p
touch
ls -lR
```

---

# 🏁 Conclusion

Linux File Ownership is a foundational concept for every DevOps and SRE Engineer.

Understanding:

* File ownership
* Group ownership
* Recursive permissions
* Shared access management

