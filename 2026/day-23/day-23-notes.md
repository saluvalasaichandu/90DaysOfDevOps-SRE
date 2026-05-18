# 🚀 Day 23 – Git Branching & Working with GitHub

# 📌 Introduction

Branching is one of the most powerful features in Git.

In real-world DevOps and software engineering environments, teams never work directly on the `main` branch for every change.

Instead, developers create separate branches for:

* Features
* Bug fixes
* Experiments
* Hotfixes
* Releases

This allows teams to:

* Work safely in isolation
* Avoid breaking production code
* Collaborate efficiently
* Maintain clean workflows

In today’s hands-on challenge, I focused on:
✅ Understanding Git branches
✅ Creating and switching branches
✅ Working with GitHub repositories
✅ Pushing branches to GitHub
✅ Understanding clone vs fork
✅ Learning remote repository workflows

---

# 🌳 What is a Branch in Git?

A branch is an independent line of development in Git.

Branches allow developers to:

* Work on new features safely
* Test code changes
* Avoid affecting the main project

By default, Git repositories usually contain:

```bash id="jlym534"
main
```

or

```bash id="jlym535"
master
```

branch.

---

# 🚀 Why Branching Matters in DevOps

Branching is heavily used in:

* CI/CD workflows
* GitOps pipelines
* Kubernetes deployments
* Infrastructure as Code
* Team collaboration

Without branching:

* Production code becomes unstable
* Collaboration becomes risky
* Deployments become difficult

---

# 📌 Task 1 – Understanding Branches

# 🔹 1. What is a Branch?

A branch is a separate working environment inside a Git repository.

Each branch can contain:

* Different commits
* Different code
* Different features

without affecting other branches.

---

# 🔹 2. Why Use Branches Instead of Working Directly on Main?

Using branches helps:

* Protect production code
* Isolate development work
* Enable parallel development
* Simplify testing and code review

---

# 🔹 3. What is HEAD in Git?

`HEAD` is a pointer that refers to:

* The current branch
* The latest commit on that branch

Example:

```bash id="jlym536"
HEAD -> main
```

means you are currently on the `main` branch.

---

# 🔹 4. What Happens When You Switch Branches?

When switching branches:

* Git updates your working directory
* Files change to match branch content
* Different commits become visible

---

# ⚙️ Task 2 – Branching Commands Hands-On

# 📌 List All Branches

## Command

```bash id="jlym537"
git branch
```

---

# 🔹 Example Output

```text id="jlym538"
* main
```

`*` indicates the current branch.

---

# 📌 Create New Branch

## Command

```bash id="jlym539"
git branch feature-1
```

---

# 📌 Switch to Branch

## Command

```bash id="jlym540"
git checkout feature-1
```

OR modern method:

```bash id="jlym541"
git switch feature-1
```

---

# 📌 Create and Switch in One Command

## Command

```bash id="jlym542"
git checkout -b feature-2
```

OR modern method:

```bash id="jlym543"
git switch -c feature-2
```

---

# 📌 Difference Between `git switch` and `git checkout`

| Command        | Purpose                                           |
| -------------- | ------------------------------------------------- |
| `git checkout` | Older command used for multiple operations        |
| `git switch`   | Modern command focused only on switching branches |

`git switch` is safer and easier to understand.

---

# 📌 Make Changes on Feature Branch

## Edit File

```bash id="jlym544"
vim git-commands.md
```

Add:

* Branching commands
* Remote commands

---

# 📌 Stage Changes

## Command

```bash id="jlym545"
git add git-commands.md
```

---

# 📌 Commit Changes

## Command

```bash id="jlym546"
git commit -m "Added Git branching commands"
```

---

# 📌 Switch Back to Main

## Command

```bash id="jlym547"
git switch main
```

---

# 📌 Verify Feature Commit is Missing

## Command

```bash id="jlym548"
git log --oneline
```

You will notice:

* Feature branch commit does not exist on `main`

because branches are isolated.

---

# 📌 Delete Unused Branch

## Command

```bash id="jlym549"
git branch -d feature-2
```

---

# 📌 Why Branch Isolation Matters

Branch isolation helps:

* Protect production code
* Test safely
* Build CI/CD pipelines
* Support team collaboration

---

# ☁️ Task 3 – Push to GitHub

# 📌 Create Repository on GitHub

Create repository:

```text id="jlym550"
devops-git-practice
```

⚠️ Do NOT initialize with README.

---

# 📌 Connect Local Repo to GitHub

## Command

```bash id="jlym551"
git remote add origin https://github.com/username/devops-git-practice.git
```

---

# 📌 Verify Remote

## Command

```bash id="jlym552"
git remote -v
```

---

# 🔹 Example Output

```text id="jlym553"
origin  https://github.com/username/devops-git-practice.git
```

---

# 📌 Push Main Branch

## Command

```bash id="jlym554"
git push -u origin main
```

---

# 📌 Push Feature Branch

## Command

```bash id="jlym555"
git push -u origin feature-1
```

---

# 📌 Verify Branches on GitHub

After pushing:

* Both branches become visible on GitHub

---

# 📌 What is `origin`?

`origin` refers to:

* Default remote repository

Usually:

```text id="jlym556"
GitHub repository
```

---

# 📌 What is `upstream`?

`upstream` refers to:

* Original repository you forked from

Common in open-source workflows.

---

# 🔄 Task 4 – Pull Changes from GitHub

# 📌 Make Change Directly on GitHub

Edit:

```text id="jlym557"
README.md
```

using GitHub web editor.

---

# 📌 Pull Changes Locally

## Command

```bash id="jlym558"
git pull origin main
```

---

# 📌 What is `git pull`?

`git pull`:

1. Fetches latest changes
2. Merges them into local branch

---

# 📌 Difference Between `git fetch` and `git pull`

| Command     | Purpose                    |
| ----------- | -------------------------- |
| `git fetch` | Downloads changes only     |
| `git pull`  | Downloads + merges changes |

---

# 🌍 Task 5 – Clone vs Fork

# 📌 Clone Repository

## Command

```bash id="jlym559"
git clone https://github.com/user/repository.git
```

---

# 📌 What is Clone?

Cloning:

* Downloads repository locally
* Creates working copy on your machine

---

# 📌 What is Fork?

Forking:

* Creates your own copy of repository on GitHub

Used heavily in:

* Open-source contributions
* Team collaboration

---

# 📌 Difference Between Clone and Fork

| Clone               | Fork                             |
| ------------------- | -------------------------------- |
| Local copy          | GitHub copy                      |
| Git operation       | GitHub operation                 |
| Used for local work | Used for ownership/collaboration |

---

# 📌 When to Use Clone?

Use clone when:

* Working on your own repo
* Downloading repositories locally

---

# 📌 When to Use Fork?

Use fork when:

* Contributing to external projects
* Working with open-source repositories

---

# 📌 Keep Fork Updated

## Add Upstream Remote

```bash id="jlym560"
git remote add upstream https://github.com/original/repo.git
```

---

# 📌 Fetch Upstream Changes

## Command

```bash id="jlym561"
git fetch upstream
```

---

# 📌 Merge Upstream Changes

## Command

```bash id="jlym562"
git merge upstream/main
```

---

# 🔄 Git Branch Workflow

```text id="jlym563"
main branch
    ↓
Create feature branch
    ↓
Make changes
    ↓
Commit changes
    ↓
Push to GitHub
    ↓
Merge into main
```

---

# 🛠️ Common Git Commands Practiced

| Command           | Purpose                |
| ----------------- | ---------------------- |
| `git branch`      | List branches          |
| `git switch`      | Switch branches        |
| `git checkout -b` | Create & switch branch |
| `git branch -d`   | Delete branch          |
| `git remote -v`   | View remotes           |
| `git push`        | Push changes           |
| `git pull`        | Pull changes           |
| `git fetch`       | Download changes       |
| `git clone`       | Clone repository       |

---

# 🚨 Real-World DevOps Use Cases

Git branching workflows are heavily used in:

* GitHub Actions
* Jenkins pipelines
* Kubernetes GitOps
* Terraform repositories
* Infrastructure automation
* CI/CD deployments

Examples:

* Creating feature branches for deployments
* Using GitOps workflows in Kubernetes
* Maintaining separate production/staging branches
* Collaborating across DevOps teams

---

# 🎯 What I Learned

✅ Understanding Git branches
✅ Creating and switching branches
✅ Using GitHub remotes
✅ Pushing branches to GitHub
✅ Understanding clone vs fork
✅ Understanding `origin` and `upstream`
✅ Learning Git collaboration workflows

---

# 🏁 Conclusion

Git branching is one of the most important concepts in modern DevOps workflows.

Understanding:

* Branches
* Remotes
* GitHub workflows
* Clone vs fork
* Pull and fetch


