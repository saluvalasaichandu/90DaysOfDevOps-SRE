# 🚀 Day 25 – Git Reset vs Revert & Branching Strategies

# 📌 Introduction

Mistakes are normal in software development and DevOps workflows.

The important skill is not avoiding mistakes completely — it is knowing:

* How to recover safely
* How to undo changes correctly
* How to maintain clean Git history
* How teams organize development workflows

In today’s hands-on challenge, I focused on:
✅ Git Reset
✅ Git Revert
✅ Git Reflog
✅ Safe undo operations
✅ Branching strategies used by real engineering teams
✅ GitFlow vs GitHub Flow vs Trunk-Based Development

These concepts are critical for:

* CI/CD pipelines
* GitOps workflows
* Infrastructure as Code
* Kubernetes deployments
* Production incident recovery

---

# 🔄 Why Undo Operations Matter in DevOps

In real production environments:

* Wrong commits happen
* Broken code gets pushed
* Bad configurations get deployed
* Rollbacks become necessary

Git provides multiple ways to recover safely:

* Reset
* Revert
* Reflog

Choosing the correct approach is extremely important.

---

# 📌 Task 1 – Git Reset Hands-On

# 🔹 What is Git Reset?

`git reset` moves the current branch pointer (`HEAD`) to another commit.

It can:

* Keep changes
* Unstage changes
* Completely delete changes

depending on the mode used.

---

# 📌 Create Sample Commits

## Command

```bash id="g25a01"
echo "Commit A" > app.txt
git add .
git commit -m "Commit A"

echo "Commit B" >> app.txt
git add .
git commit -m "Commit B"

echo "Commit C" >> app.txt
git add .
git commit -m "Commit C"
```

---

# 📌 View Commit History

```bash id="g25a02"
git log --oneline
```

---

# 🔹 Example Output

```text id="g25a03"
c3d4e5f Commit C
b2c3d4e Commit B
a1b2c3d Commit A
```

---

# 📌 Git Reset --soft

## Command

```bash id="g25a04"
git reset --soft HEAD~1
```

---

# 📌 What Happens?

Git:

* Removes latest commit
* Keeps changes staged

Example:

```text id="g25a05"
Commit removed
Changes still in staging area
```

---

# 📌 Check Status

```bash id="g25a06"
git status
```

---

# 🔹 Observation

Files remain:

```text id="g25a07"
staged for commit
```

---

# 📌 Recommit Changes

```bash id="g25a08"
git commit -m "Recommitted changes"
```

---

# 📌 Git Reset --mixed

## Command

```bash id="g25a09"
git reset --mixed HEAD~1
```

---

# 📌 What Happens?

Git:

* Removes latest commit
* Keeps file changes
* Unstages changes

---

# 📌 Check Status

```bash id="g25a10"
git status
```

---

# 🔹 Observation

Files become:

```text id="g25a11"
modified but unstaged
```

---

# 📌 Git Reset --hard

## Command

```bash id="g25a12"
git reset --hard HEAD~1
```

---

# 📌 What Happens?

Git:

* Removes commit
* Deletes changes permanently
* Resets working directory

---

# ⚠️ Why --hard is Dangerous

`--hard` is destructive because:

* Changes are permanently removed
* Uncommitted work is lost

---

# 📌 Difference Between Reset Modes

| Mode      | Commit Removed | Changes Kept | Staged |
| --------- | -------------- | ------------ | ------ |
| `--soft`  | Yes            | Yes          | Yes    |
| `--mixed` | Yes            | Yes          | No     |
| `--hard`  | Yes            | No           | No     |

---

# 📌 When to Use Each Reset Mode

| Mode      | Use Case                       |
| --------- | ------------------------------ |
| `--soft`  | Rewrite commit message/history |
| `--mixed` | Unstage files                  |
| `--hard`  | Discard unwanted changes       |

---

# ⚠️ Should You Reset Pushed Commits?

Avoid resetting commits already pushed/shared because:

* Commit history changes
* Other developers’ branches break
* Collaboration becomes difficult

---

# 🔄 Task 2 – Git Revert Hands-On

# 🔹 What is Git Revert?

`git revert` creates:

* A new commit
* That reverses previous changes

Unlike reset:

* History is preserved

---

# 📌 Create Sample Commits

```bash id="g25a13"
echo "Feature X" >> app.txt
git add .
git commit -m "Commit X"

echo "Feature Y" >> app.txt
git add .
git commit -m "Commit Y"

echo "Feature Z" >> app.txt
git add .
git commit -m "Commit Z"
```

---

# 📌 View Commit History

```bash id="g25a14"
git log --oneline
```

---

# 📌 Revert Middle Commit

```bash id="g25a15"
git revert <commit-hash-of-Y>
```

---

# 📌 What Happens?

Git:

* Keeps commit history
* Adds new revert commit

---

# 📌 Check Git Log

```bash id="g25a16"
git log --oneline
```

---

# 🔹 Example Output

```text id="g25a17"
Revert "Commit Y"
Commit Z
Commit Y
Commit X
```

---

# 📌 Is Commit Y Still Present?

Yes.

Git does NOT delete history.

Instead:

* It creates opposite changes

---

# 📌 Reset vs Revert

| Feature                  | Reset | Revert |
| ------------------------ | ----- | ------ |
| Removes commit history   | Yes   | No     |
| Safe for shared branches | No    | Yes    |
| Rewrites history         | Yes   | No     |
| Creates new commit       | No    | Yes    |

---

# 📌 Why Revert is Safer

Revert is safer because:

* Shared history remains unchanged
* Other developers are unaffected
* Easier collaboration

---

# 📌 When to Use Reset vs Revert

| Use Case                   | Recommended |
| -------------------------- | ----------- |
| Local cleanup              | Reset       |
| Shared branch rollback     | Revert      |
| Undo production deployment | Revert      |
| Rewrite local history      | Reset       |

---

# 🛟 Git Reflog – Your Safety Net

# 📌 What is Git Reflog?

`git reflog` tracks:

* Every Git HEAD movement

Even after:

* Hard resets
* Deleted branches

---

# 📌 View Reflog

```bash id="g25a18"
git reflog
```

---

# 🔹 Example Output

```text id="g25a19"
HEAD@{0}: reset: moving to HEAD~1
HEAD@{1}: commit: Commit C
```

---

# 📌 Recover Lost Commit

```bash id="g25a20"
git reset --hard HEAD@{1}
```

---

# 📌 Why Reflog Matters

Reflog can recover:

* Lost commits
* Deleted branches
* Accidental resets

Very useful during production incidents.

---

# 🌳 Task 4 – Branching Strategies

# 📌 Why Branching Strategies Matter

Branching strategies help teams:

* Organize development
* Manage releases
* Handle hotfixes
* Improve collaboration

Different teams use different workflows.

---

# 🔷 1. GitFlow

# 📌 Structure

```text id="g25a21"
main
develop
feature/*
release/*
hotfix/*
```

---

# 📌 How GitFlow Works

* `main` → production code
* `develop` → active development
* `feature/*` → new features
* `release/*` → release preparation
* `hotfix/*` → urgent production fixes

---

# 📌 Pros

✅ Structured workflow
✅ Good for enterprise releases
✅ Supports multiple environments

---

# 📌 Cons

❌ Complex
❌ Too many long-lived branches

---

# 📌 Best Used For

* Large enterprises
* Scheduled release cycles
* Complex DevOps environments

---

# 🔷 2. GitHub Flow

# 📌 Structure

```text id="g25a22"
main
feature branches
```

---

# 📌 Workflow

1. Create feature branch
2. Commit changes
3. Create pull request
4. Merge into main

---

# 📌 Pros

✅ Simple
✅ Fast deployments
✅ Easy collaboration

---

# 📌 Cons

❌ Less structured for large releases

---

# 📌 Best Used For

* Startups
* Continuous deployment
* Agile teams

---

# 🔷 3. Trunk-Based Development

# 📌 Structure

```text id="g25a23"
main/trunk only
short-lived branches
```

---

# 📌 Workflow

* Developers commit frequently
* Small short-lived branches
* Frequent merges into main

---

# 📌 Pros

✅ Fast integration
✅ Reduces merge conflicts
✅ Excellent for CI/CD

---

# 📌 Cons

❌ Requires strong testing automation

---

# 📌 Best Used For

* High-speed DevOps teams
* CI/CD-heavy environments
* Cloud-native organizations

---

# 📌 Which Strategy for Startup?

Best choice:

```text id="g25a24"
GitHub Flow
```

because:

* Simple
* Fast
* Supports rapid deployment

---

# 📌 Which Strategy for Large Enterprise?

Best choice:

```text id="g25a25"
GitFlow
```

because:

* Better release management
* Structured workflows
* Easier hotfix handling

---

# 📌 Which Strategy Does Kubernetes Use?

Kubernetes primarily uses:

```text id="g25a26"
GitHub Flow + release branches
```

---

# 🛠️ Important Git Commands Practiced

| Command             | Purpose                    |
| ------------------- | -------------------------- |
| `git reset --soft`  | Remove commit, keep staged |
| `git reset --mixed` | Remove commit, unstage     |
| `git reset --hard`  | Remove commit completely   |
| `git revert`        | Safely undo commit         |
| `git reflog`        | View Git history movements |
| `git log --oneline` | Compact history            |
| `git branch`        | Manage branches            |

---

# 🚨 Real-World DevOps Use Cases

Advanced Git recovery workflows are heavily used in:

* Production incident recovery
* CI/CD rollback strategies
* GitOps workflows
* Kubernetes deployments
* Infrastructure as Code repositories

Examples:

* Reverting bad production deployments
* Resetting local experimental work
* Recovering deleted commits using reflog
* Managing release branches

---

# 🎯 What I Learned

✅ Understanding Git reset modes
✅ Understanding Git revert
✅ Understanding destructive vs safe operations
✅ Recovering changes using reflog
✅ Learning Git branching strategies
✅ Understanding GitFlow vs GitHub Flow
✅ Understanding trunk-based development

---

# 🏁 Conclusion

Understanding:

* Reset
* Revert
* Reflog
* Branching strategies

