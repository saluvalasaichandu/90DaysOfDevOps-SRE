# 🚀 Day 28 – Revision Day (Day 1 to Day 27)

Today was a complete revision and self-assessment day for all the concepts learned during the first 27 days of the #90DaysOfDevOps challenge. 

# 📌 Introduction

Over the last 27 days, I learned:

* Linux fundamentals
* Networking
* Shell scripting
* Git & GitHub
* GitHub CLI
* DevOps troubleshooting
* Cloud basics
* LVM
* File permissions
* Git workflows
* Developer branding

Today’s goal was:
✅ Revise all concepts
✅ Identify weak areas
✅ Re-practice important topics
✅ Strengthen fundamentals
✅ Organize GitHub repositories

---

# 📚 Topics Revised

| Days      | Topics                      |
| --------- | --------------------------- |
| Day 1     | DevOps & Cloud Basics       |
| Day 2–7   | Linux Fundamentals          |
| Day 8     | Cloud Server Setup          |
| Day 9–11  | Users, Groups & Permissions |
| Day 13    | LVM                         |
| Day 14–15 | Networking                  |
| Day 16–21 | Shell Scripting             |
| Day 22–26 | Git & GitHub                |
| Day 27    | GitHub Branding             |

---

# 🐧 Linux Revision

## ✅ Commands Revised

```bash
ls
cd
pwd
mkdir
rm
cp
mv
touch
cat
top
ps
kill
df -h
free -h
du -sh
chmod
chown
systemctl
journalctl
```

---

# 📌 Key Linux Concepts Revised

## 🔹 Linux File System

| Directory | Purpose               |
| --------- | --------------------- |
| `/`       | Root directory        |
| `/etc`    | Configuration files   |
| `/var`    | Logs & variable data  |
| `/home`   | User home directories |
| `/tmp`    | Temporary files       |

---

## 🔹 Process vs Service

| Process          | Service                    |
| ---------------- | -------------------------- |
| Running program  | Background managed process |
| Temporary        | Long-running               |
| Managed manually | Managed by systemd         |

---

# 📌 Process Management Commands

```bash
ps -ef
top
htop
kill -9 PID
```

---

# 📌 Service Management

```bash
systemctl status nginx
systemctl start nginx
systemctl stop nginx
systemctl restart nginx
```

---

# 🔐 User & Permission Revision

# 📌 User Management

```bash
useradd devops
passwd devops
groupadd developers
usermod -aG developers devops
```

---

# 📌 File Permissions

## 🔹 chmod

```bash
chmod 755 script.sh
```

### Meaning

| Permission | Value |
| ---------- | ----- |
| Read       | 4     |
| Write      | 2     |
| Execute    | 1     |

`755` means:

* Owner → rwx
* Group → r-x
* Others → r-x

---

# 📌 Ownership Commands

```bash
chown user:file app.txt
chgrp developers app.txt
```

---

# 💾 LVM Revision

# 📌 LVM Components

| Component | Description     |
| --------- | --------------- |
| PV        | Physical Volume |
| VG        | Volume Group    |
| LV        | Logical Volume  |

---

# 📌 Important Commands

```bash
pvcreate /dev/sdb
vgcreate devops-vg /dev/sdb
lvcreate -L 2G -n mylv devops-vg
mkfs.ext4 /dev/devops-vg/mylv
mount /dev/devops-vg/mylv /data
```

---

# 🌐 Networking Revision

# 📌 Commands Practiced

```bash
ping google.com
curl -I google.com
dig google.com
ss -tulpn
netstat -tulpn
ip addr show
```

---

# 📌 DNS Revision

DNS converts:

```text
Domain Name → IP Address
```

Example:

```text
google.com → 142.250.x.x
```

---

# 📌 Common Ports

| Port | Service |
| ---- | ------- |
| 22   | SSH     |
| 80   | HTTP    |
| 443  | HTTPS   |
| 53   | DNS     |
| 3306 | MySQL   |

---

# 📌 Find Process Using Port 8080

```bash
ss -tulpn | grep 8080
```

---

# 🐚 Shell Scripting Revision

# 📌 Topics Revised

✅ Variables
✅ Loops
✅ Functions
✅ If-Else
✅ Arguments
✅ Error Handling
✅ Cron Jobs

---

# 📌 Variables Example

```bash
NAME="Saichandu"
echo $NAME
```

---

# 📌 If-Else Example

```bash
if [ -f file.txt ]; then
  echo "File exists"
else
  echo "File not found"
fi
```

---

# 📌 Loop Example

```bash
for i in 1 2 3
do
  echo $i
done
```

---

# 📌 Function Example

```bash
greet() {
  echo "Hello DevOps"
}

greet
```

---

# 📌 set -euo pipefail

```bash
set -euo pipefail
```

| Flag       | Meaning                    |
| ---------- | -------------------------- |
| `-e`       | Exit if command fails      |
| `-u`       | Exit if variable undefined |
| `pipefail` | Catch pipe errors          |

---

# 📌 Schedule Script at 3 AM

```bash
0 3 * * * /home/ubuntu/backup.sh
```

---

# 🔀 Git & GitHub Revision

# 📌 Git Commands Revised

```bash
git init
git status
git add .
git commit -m "message"
git push
git pull
git fetch
git branch
git checkout
git switch
git merge
git rebase
git stash
git revert
git reset
```

---

# 📌 git fetch vs git pull

| git fetch         | git pull           |
| ----------------- | ------------------ |
| Downloads changes | Downloads + merges |
| Safer             | Faster             |

---

# 📌 git reset vs git revert

| git reset       | git revert             |
| --------------- | ---------------------- |
| Removes history | Keeps history          |
| Dangerous       | Safe                   |
| Local cleanup   | Shared branch rollback |

---

# 📌 git stash

Temporarily saves uncommitted changes.

Useful when:

* Switching branches quickly
* Handling urgent fixes

---

# 📌 Branching Strategies Revised

| Strategy    | Best For         |
| ----------- | ---------------- |
| GitFlow     | Enterprise teams |
| GitHub Flow | Startups         |
| Trunk-Based | Fast CI/CD teams |

---

# 🧠 Self-Assessment

# ✅ Confident Areas

* Linux commands
* Git basics
* Networking basics
* Shell scripting fundamentals
* GitHub workflows

---

# 🔄 Areas to Revisit

* Advanced awk/sed
* Git rebase conflicts
* Complex shell scripting
* LVM advanced management

---

# 📌 Re-Practiced Topics

## 1. Git Rebase

Practiced:

```bash
git rebase main
```

Learned:

* How commit history changes
* Conflict resolution basics

---

## 2. Shell Error Handling

Practiced:

```bash
set -euo pipefail
```

Learned:

* Safer automation scripting

---

## 3. Networking Troubleshooting

Practiced:

```bash
curl
ping
ss -tulpn
```

Learned:

* Faster troubleshooting workflow

---

# 👨‍🏫 Teach It Back

# 📌 What is Git Branching?

Git branching allows developers to work on new features separately without affecting the main codebase.

Example:

* `main` → stable production code
* `feature-login` → new feature branch

Benefits:

* Safe experimentation
* Better collaboration
* Easier code reviews
* Cleaner workflows

---

# 📂 Repository Organization Review

Checked:
✅ All daily submissions pushed
✅ README files updated
✅ GitHub profile improved
✅ Shell scripting cheat sheet completed
✅ Git commands reference updated

---

# 🚀 Real-World DevOps Importance

These fundamentals are heavily used in:

* Linux administration
* Kubernetes troubleshooting
* CI/CD pipelines
* Cloud deployments
* Infrastructure automation
* SRE operations
* Production debugging

---

# 🎯 What I Learned

✅ Importance of revision
✅ Strengthened Linux fundamentals
✅ Improved Git confidence
✅ Better understanding of shell scripting
✅ Better troubleshooting workflow
✅ Improved GitHub organization

---

# 🏁 Conclusion

Revision is one of the most important parts of learning DevOps.

The first 27 days built a strong foundation in:

* Linux
* Networking
* Shell scripting
* Git & GitHub
* Cloud basics
