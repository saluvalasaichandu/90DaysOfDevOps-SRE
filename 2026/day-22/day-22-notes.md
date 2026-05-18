# 🚀 Day 22 – Introduction to Git: Your First Repository

# 📌 Introduction

Git is one of the most important tools for every DevOps Engineer, SRE, Cloud Engineer, and Software Developer.

Modern DevOps workflows depend heavily on:

* Version control
* Collaboration
* CI/CD pipelines
* Infrastructure as Code
* Code reviews
* Change tracking

Git helps teams:

* Track code changes
* Collaborate efficiently
* Roll back mistakes
* Maintain project history

In today’s hands-on challenge, I focused on:
✅ Installing and configuring Git
✅ Creating my first Git repository
✅ Understanding Git workflow
✅ Staging and committing changes
✅ Exploring Git history
✅ Building a personal Git command reference

---

# 🧠 What is Git?

Git is a distributed version control system used to track changes in files and source code.

It allows developers and DevOps engineers to:

* Maintain code history
* Collaborate with teams
* Track modifications
* Restore previous versions
* Work safely on production code

---

# 🚀 Why Git Matters in DevOps

Git is the backbone of:

* CI/CD pipelines
* GitOps workflows
* Infrastructure as Code
* Kubernetes manifests
* Terraform projects
* Jenkins pipelines
* Cloud automation

Without Git:

* Tracking changes becomes difficult
* Collaboration becomes risky
* Rollbacks become hard
* Automation pipelines fail

---

# ⚙️ Task 1 – Install and Configure Git

# 📌 Verify Git Installation

## Command

```bash id="jlym502"
git --version
```

---

# 🔹 Example Output

```text id="jlym503"
git version 2.43.0
```

---

# 📌 Configure Git Username

## Command

```bash id="jlym504"
git config --global user.name "Saichandu Saluvala"
```

---

# 📌 Configure Git Email

## Command

```bash id="jlym505"
git config --global user.email "saluvalasaichandu@gmail.com"
```

---

# 📌 Verify Git Configuration

## Command

```bash id="jlym506"
git config --list
```

---

# 🔹 Example Output

```text id="jlym507"
user.name=Saichandu Saluvala
user.email=saluvalasaichandu@gmail.com
```

---

# 📌 Why Git Configuration Matters

Git uses:

* Username
* Email

to identify who made commits.

Every commit stores author information.

---

# 📁 Task 2 – Create Your Git Project

# 📌 Create Project Directory

## Command

```bash id="jlym508"
mkdir devops-git-practice
```

---

# 📌 Navigate into Directory

## Command

```bash id="jlym509"
cd devops-git-practice
```

---

# 📌 Initialize Git Repository

## Command

```bash id="jlym510"
git init
```

---

# 🔹 Example Output

```text id="jlym511"
Initialized empty Git repository
```

---

# 📌 What is `git init`?

`git init` creates a hidden `.git/` directory.

This directory stores:

* Commit history
* Branches
* Configuration
* Staging information
* Repository metadata

---

# 📌 Check Git Status

## Command

```bash id="jlym512"
git status
```

---

# 🔹 Example Output

```text id="jlym513"
On branch main

No commits yet
nothing to commit
```

---

# 📌 Why `git status` is Important

`git status` shows:

* Modified files
* Untracked files
* Staged files
* Current branch

This is one of the most frequently used Git commands.

---

# 📌 Explore Hidden `.git/` Directory

## Command

```bash id="jlym514"
ls -la
```

---

# 🔹 Example Output

```text id="jlym515"
.git/
```

---

# 📌 Explore `.git` Contents

## Command

```bash id="jlym516"
ls -la .git
```

---

# 🔹 Important Files Inside `.git`

| File/Folder | Purpose                |
| ----------- | ---------------------- |
| `HEAD`      | Current branch pointer |
| `config`    | Git configuration      |
| `objects`   | Commit objects         |
| `refs`      | Branch references      |
| `hooks`     | Git hooks              |

---

# 📝 Task 3 – Create Git Commands Reference

# 📌 Create `git-commands.md`

## Command

```bash id="jlym517"
touch git-commands.md
```

---

# 📌 Edit File

## Command

```bash id="jlym518"
vim git-commands.md
```

---

# 🔹 Example Content

```markdown id="jlym519"
# Git Commands Cheat Sheet

## Setup & Config

git --version
Checks installed Git version

git config --global user.name "Name"
Configures Git username

git config --global user.email "email@example.com"
Configures Git email

## Basic Workflow

git init
Initializes Git repository

git status
Shows repository status

git add filename
Stages file

git commit -m "message"
Creates commit

## Viewing Changes

git log
Shows commit history

git log --oneline
Compact commit history
```

---

# 📌 Why Build a Git Reference?

A personal Git cheat sheet helps:

* Improve productivity
* Remember commands quickly
* Speed up troubleshooting
* Prepare for interviews

---

# 📦 Task 4 – Stage and Commit Changes

# 📌 Stage File

## Command

```bash id="jlym520"
git add git-commands.md
```

---

# 📌 Check Staged Files

## Command

```bash id="jlym521"
git status
```

---

# 🔹 Example Output

```text id="jlym522"
Changes to be committed:
new file: git-commands.md
```

---

# 📌 What is `git add`?

`git add` moves files into the staging area.

Files are prepared for commit but not yet saved permanently.

---

# 📌 Commit Changes

## Command

```bash id="jlym523"
git commit -m "Added initial Git commands reference"
```

---

# 🔹 Example Output

```text id="jlym524"
1 file changed
```

---

# 📌 What is `git commit`?

`git commit` permanently saves staged changes into repository history.

Commits act like snapshots.

---

# 📜 Task 5 – Build Git History

# 📌 Modify File

## Command

```bash id="jlym525"
vim git-commands.md
```

Add more commands:

* git diff
* git branch
* git checkout
* git restore

---

# 📌 Check Changes

## Command

```bash id="jlym526"
git diff
```

---

# 📌 Stage Updated File

## Command

```bash id="jlym527"
git add git-commands.md
```

---

# 📌 Commit Again

## Command

```bash id="jlym528"
git commit -m "Updated Git commands cheat sheet"
```

---

# 📌 Repeat Multiple Commits

Example commit history:

```text id="jlym529"
Added initial Git commands reference
Updated Git commands cheat sheet
Added Git diff examples
Added Git branch commands
```

---

# 📌 View Commit History

## Command

```bash id="jlym530"
git log
```

---

# 📌 Compact History

## Command

```bash id="jlym531"
git log --oneline
```

---

# 🔹 Example Output

```text id="jlym532"
a1b2c3d Added Git branch commands
e4f5g6h Updated Git commands cheat sheet
```

---

# 📌 Why Commit History Matters

Commit history helps:

* Track project evolution
* Identify changes
* Debug issues
* Roll back mistakes
* Audit production changes

---

# 🔍 Task 6 – Understanding Git Workflow

# 📌 1. Difference Between `git add` and `git commit`

| Command      | Purpose                   |
| ------------ | ------------------------- |
| `git add`    | Stages changes            |
| `git commit` | Saves changes permanently |

---

# 📌 2. What is the Staging Area?

The staging area acts like a preparation zone.

It allows developers to:

* Review changes
* Select files carefully
* Organize commits properly

Without staging:

* Every small change would be committed immediately.

---

# 📌 3. What Does `git log` Show?

`git log` displays:

* Commit IDs
* Commit messages
* Author details
* Commit dates
* Branch history

---

# 📌 4. What is the `.git/` Folder?

`.git/` stores:

* Repository history
* Commit metadata
* Branch information
* Staging details

If deleted:

* Repository history is lost
* Git tracking stops

---

# 📌 5. Git Workflow Components

| Component         | Purpose               |
| ----------------- | --------------------- |
| Working Directory | Current project files |
| Staging Area      | Prepared changes      |
| Repository        | Permanent Git history |

---

# 🔄 Complete Git Workflow

```text id="jlym533"
Working Directory
       ↓
git add
       ↓
Staging Area
       ↓
git commit
       ↓
Git Repository
```

---

# 🛠️ Common Git Commands Practiced

| Command             | Purpose                |
| ------------------- | ---------------------- |
| `git init`          | Initialize repository  |
| `git status`        | Show repository status |
| `git add`           | Stage changes          |
| `git commit`        | Save changes           |
| `git log`           | View history           |
| `git diff`          | Compare changes        |
| `git config`        | Configure Git          |
| `git log --oneline` | Compact history        |

---

# 🚨 Real-World DevOps Use Cases

Git is heavily used in:

* GitHub repositories
* GitOps workflows
* Kubernetes manifests
* Terraform projects
* Jenkins pipelines
* Infrastructure automation
* CI/CD deployments

Examples:

* Version controlling Kubernetes YAML files
* Tracking Terraform infrastructure changes
* Managing CI/CD pipeline configurations
* Collaborating across DevOps teams

---

# 🎯 What I Learned

✅ Installing and configuring Git
✅ Creating local Git repositories
✅ Understanding Git workflow
✅ Staging and committing changes
✅ Exploring commit history
✅ Understanding `.git/` internals
✅ Building a personal Git command reference

---

# 🏁 Conclusion

Git is the foundation of modern DevOps workflows.

Understanding:

* Repositories
* Commits
* Staging
* Version control
* History tracking

