# 🚀 Day 26 – GitHub CLI (`gh`): Manage GitHub from Your Terminal

# 📌 Introduction

Modern DevOps engineers spend a huge amount of time working with:

* GitHub repositories
* Pull Requests
* Issues
* CI/CD workflows
* Releases
* Automation pipelines

Switching constantly between:

* Terminal
* Browser
* GitHub UI

can slow productivity and break focus.

GitHub CLI (`gh`) solves this problem by allowing engineers to manage GitHub directly from the terminal.

In today’s hands-on challenge, I focused on:
✅ Installing GitHub CLI
✅ Authenticating with GitHub
✅ Managing repositories from terminal
✅ Creating and managing issues
✅ Creating Pull Requests using terminal
✅ Exploring GitHub Actions via CLI
✅ Using advanced `gh` commands

---

# 🌍 What is GitHub CLI (`gh`)?

GitHub CLI is an official command-line tool provided by GitHub.

It allows developers and DevOps engineers to:

* Manage repositories
* Create pull requests
* Handle issues
* Trigger workflows
* Manage releases
* Interact with GitHub APIs

without leaving the terminal.

---

# 🚀 Why GitHub CLI Matters in DevOps

GitHub CLI is heavily used in:

* CI/CD automation
* GitOps workflows
* Kubernetes deployments
* Infrastructure automation
* PR review pipelines
* DevOps scripting

Benefits:

* Faster workflows
* Better automation
* Reduced context switching
* Easier scripting

---

# ⚙️ Task 1 – Install and Authenticate GitHub CLI

# 📌 Install GitHub CLI on Ubuntu

## Command

```bash id="g26a01"
sudo apt update
sudo apt install gh -y
```

---

# 📌 Verify Installation

## Command

```bash id="g26a02"
gh --version
```

---

# 🔹 Example Output

```text id="g26a03"
gh version 2.x.x
```

---

# 📌 Authenticate with GitHub

## Command

```bash id="g26a04"
gh auth login
```

---

# 📌 Authentication Flow

GitHub CLI asks:

* GitHub.com or Enterprise
* HTTPS or SSH
* Browser login or token

---

# 📌 Verify Authentication

## Command

```bash id="g26a05"
gh auth status
```

---

# 🔹 Example Output

```text id="g26a06"
Logged in to github.com as saichandu
```

---

# 📌 Supported Authentication Methods

GitHub CLI supports:

* Browser authentication
* Personal Access Token (PAT)
* SSH authentication
* GitHub Enterprise authentication

---

# 📂 Task 2 – Working with Repositories

# 📌 Create Repository from Terminal

## Command

```bash id="g26a07"
gh repo create devops-gh-cli-demo --public --clone
```

---

# 📌 What Happens?

GitHub CLI:

* Creates repository
* Clones repository locally
* Adds README if requested

---

# 📌 Clone Repository Using gh

## Command

```bash id="g26a08"
gh repo clone cli/cli
```

---

# 📌 View Repository Details

## Command

```bash id="g26a09"
gh repo view
```

---

# 🔹 Example Output

```text id="g26a10"
Repository: saichandu/devops-gh-cli-demo
Visibility: Public
```

---

# 📌 List Your Repositories

## Command

```bash id="g26a11"
gh repo list
```

---

# 📌 Open Repository in Browser

## Command

```bash id="g26a12"
gh repo view --web
```

---

# 📌 Delete Repository

⚠️ Be careful with this command.

## Command

```bash id="g26a13"
gh repo delete devops-gh-cli-demo
```

---

# 📌 Why GitHub CLI Repo Management Matters

Useful for:

* Automation scripts
* Infrastructure repositories
* CI/CD management
* Large-scale repo operations

---

# 🐞 Task 3 – GitHub Issues

# 📌 Create GitHub Issue

## Command

```bash id="g26a14"
gh issue create \
--title "Fix deployment issue" \
--body "Deployment pipeline failing in production" \
--label "bug"
```

---

# 📌 List Open Issues

## Command

```bash id="g26a15"
gh issue list
```

---

# 📌 View Specific Issue

## Command

```bash id="g26a16"
gh issue view 1
```

---

# 📌 Close Issue

## Command

```bash id="g26a17"
gh issue close 1
```

---

# 📌 Real-World DevOps Use Case for gh issue

Can be automated for:

* Incident tracking
* CI/CD failures
* Monitoring alerts
* Infrastructure issues

Example:

* Automatically create GitHub issue if deployment fails.

---

# 🔀 Task 4 – Pull Requests

# 📌 Create Feature Branch

## Command

```bash id="g26a18"
git switch -c feature-ci-update
```

---

# 📌 Make Changes

```bash id="g26a19"
echo "CI pipeline update" >> README.md
git add .
git commit -m "Updated CI pipeline"
```

---

# 📌 Push Branch

```bash id="g26a20"
git push -u origin feature-ci-update
```

---

# 📌 Create Pull Request from Terminal

## Command

```bash id="g26a21"
gh pr create --fill
```

---

# 📌 What Does --fill Do?

Automatically fills:

* PR title
* PR description

using commit messages.

---

# 📌 List Open PRs

## Command

```bash id="g26a22"
gh pr list
```

---

# 📌 View PR Details

## Command

```bash id="g26a23"
gh pr view
```

---

# 📌 Merge Pull Request

## Command

```bash id="g26a24"
gh pr merge
```

---

# 📌 Merge Methods Supported

| Merge Method | Purpose           |
| ------------ | ----------------- |
| Merge Commit | Preserves history |
| Squash Merge | Combines commits  |
| Rebase Merge | Linear history    |

---

# 📌 Review Someone Else’s PR

## Command

```bash id="g26a25"
gh pr checkout 15
```

This:

* Checks out PR locally
* Allows testing and reviewing

---

# ⚙️ Task 5 – GitHub Actions & Workflows

# 📌 List Workflow Runs

## Command

```bash id="g26a26"
gh run list
```

---

# 📌 View Workflow Run Details

## Command

```bash id="g26a27"
gh run view <run-id>
```

---

# 📌 Useful CI/CD Use Cases

GitHub CLI can:

* Trigger workflows
* Monitor deployments
* View CI/CD failures
* Automate rollback scripts

Very useful for:

* DevOps automation
* Incident management
* GitOps pipelines

---

# 🛠️ Task 6 – Useful GitHub CLI Tricks

# 📌 Raw GitHub API Calls

## Command

```bash id="g26a28"
gh api repos/cli/cli
```

---

# 📌 Create GitHub Gist

## Command

```bash id="g26a29"
gh gist create notes.txt
```

---

# 📌 Create GitHub Release

## Command

```bash id="g26a30"
gh release create v1.0
```

---

# 📌 Create Custom Alias

## Command

```bash id="g26a31"
gh alias set prlist "pr list"
```

---

# 📌 Search GitHub Repositories

## Command

```bash id="g26a32"
gh search repos kubernetes
```

---

# 📌 Why These Commands Matter

Useful for:

* Automation scripts
* GitOps workflows
* CI/CD pipelines
* Infrastructure management
* Platform engineering

---

# 🔄 GitHub CLI Workflow

```text id="g26a33"
Create Branch
      ↓
Push Changes
      ↓
Create PR
      ↓
Review PR
      ↓
Merge PR
      ↓
Trigger CI/CD
```

---

# 🛠️ Important GitHub CLI Commands Practiced

| Command           | Purpose             |
| ----------------- | ------------------- |
| `gh auth login`   | Authenticate GitHub |
| `gh repo create`  | Create repository   |
| `gh repo list`    | List repositories   |
| `gh issue create` | Create issue        |
| `gh issue list`   | List issues         |
| `gh pr create`    | Create pull request |
| `gh pr merge`     | Merge PR            |
| `gh run list`     | List workflow runs  |
| `gh api`          | Access GitHub API   |

---

# 🚨 Real-World DevOps Use Cases

GitHub CLI is heavily used in:

* CI/CD automation
* GitOps pipelines
* Kubernetes deployments
* Infrastructure automation
* Platform engineering
* SRE workflows

Examples:

* Automating PR creation
* Monitoring GitHub Actions
* Managing releases
* Creating deployment issues automatically
* Scripting repository management

---

# 🎯 What I Learned

✅ Installing GitHub CLI
✅ Authenticating GitHub from terminal
✅ Managing repositories using `gh`
✅ Creating and managing issues
✅ Creating pull requests from terminal
✅ Understanding GitHub workflow automation
✅ Exploring GitHub Actions via CLI
✅ Using advanced GitHub CLI commands

---

# 🏁 Conclusion

GitHub CLI (`gh`) is a powerful tool for modern DevOps engineers.

Understanding:

* Repository management
* Pull request automation
* Issue management
* Workflow monitoring
* GitHub API automation

helps engineers:

* Work faster
* Automate workflows
* Reduce manual effort
* Improve CI/CD efficiency
