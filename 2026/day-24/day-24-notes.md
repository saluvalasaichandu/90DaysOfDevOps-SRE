# 🚀 Day 24 – Advanced Git: Merge, Rebase, Stash & Cherry Pick

# 📌 Introduction

As Git workflows become larger and more collaborative, developers and DevOps engineers must understand how to:

* Combine branches safely
* Maintain clean commit history
* Handle work-in-progress changes
* Move commits selectively

These concepts are heavily used in:

* CI/CD pipelines
* GitOps workflows
* Kubernetes deployments
* Infrastructure as Code repositories
* Production hotfixes

In today’s hands-on challenge, I focused on:
✅ Git Merge
✅ Git Rebase
✅ Squash Merge
✅ Git Stash
✅ Cherry Pick
✅ Merge Conflicts
✅ Git History Visualization

---

# 🌳 Why Advanced Git Matters in DevOps

Advanced Git workflows help teams:

* Collaborate safely
* Maintain readable history
* Deploy features independently
* Handle production hotfixes quickly
* Reduce merge conflicts

These workflows are heavily used in:

* GitHub Actions
* Jenkins pipelines
* Kubernetes GitOps
* Terraform repositories
* Enterprise DevOps environments

---

# 🔀 Task 1 – Git Merge Hands-On

# 📌 What is Git Merge?

Git merge combines changes from one branch into another.

Usually:

```text id="jlym564"
feature branch → main branch
```

---

# 📌 Create Feature Branch

## Command

```bash id="jlym565"
git switch main
git switch -c feature-login
```

---

# 📌 Add Changes

## Command

```bash id="jlym566"
echo "Login feature added" >> app.txt
git add .
git commit -m "Added login feature"
```

---

# 📌 Add Another Commit

```bash id="jlym567"
echo "Login validation added" >> app.txt
git add .
git commit -m "Added login validation"
```

---

# 📌 Switch Back to Main

```bash id="jlym568"
git switch main
```

---

# 📌 Merge Feature Branch

```bash id="jlym569"
git merge feature-login
```

---

# 📌 Fast-Forward Merge

If `main` has no new commits:

* Git moves pointer forward
* No merge commit created

Example:

```text id="jlym570"
main → feature-login
```

---

# 📌 Create Another Branch

```bash id="jlym571"
git switch -c feature-signup
```

---

# 📌 Add Commits

```bash id="jlym572"
echo "Signup page added" >> app.txt
git add .
git commit -m "Added signup feature"
```

---

# 📌 Move Main Ahead

```bash id="jlym573"
git switch main

echo "Main branch update" >> app.txt
git add .
git commit -m "Updated main branch"
```

---

# 📌 Merge Again

```bash id="jlym574"
git merge feature-signup
```

---

# 📌 Merge Commit

This time:

* Git creates merge commit
* History branches merge together

because:

```text id="jlym575"
main and feature branch diverged
```

---

# 📌 Visualize Git History

```bash id="jlym576"
git log --oneline --graph --all
```

---

# 📌 Example Output

```text id="jlym577"
* Merge branch 'feature-signup'
|\
| * Added signup feature
* | Updated main branch
|/
```

---

# ⚠️ What is a Merge Conflict?

A merge conflict occurs when:

* Same line of same file
* Modified differently on two branches

Git cannot decide which version to keep.

---

# 📌 Create Merge Conflict

## Main Branch

```bash id="jlym578"
echo "Version A" > app.txt
```

## Feature Branch

```bash id="jlym579"
echo "Version B" > app.txt
```

Merge branches → conflict occurs.

---

# 📌 Resolve Conflict

Edit file manually:

```text id="jlym580"
<<<<<<< HEAD
Version A
=======
Version B
>>>>>>> feature-branch
```

Choose correct content → save → commit.

---

# 🔄 Task 2 – Git Rebase

# 📌 What is Rebase?

Rebase:

* Moves commits
* Replays commits on top of another branch

Creates cleaner linear history.

---

# 📌 Create Feature Branch

```bash id="jlym581"
git switch main
git switch -c feature-dashboard
```

---

# 📌 Add Commits

```bash id="jlym582"
echo "Dashboard feature" >> dashboard.txt
git add .
git commit -m "Added dashboard"
```

---

# 📌 Add Another Commit

```bash id="jlym583"
echo "Dashboard charts" >> dashboard.txt
git add .
git commit -m "Added charts"
```

---

# 📌 Move Main Ahead

```bash id="jlym584"
git switch main

echo "Main improvement" >> app.txt
git add .
git commit -m "Main branch improvement"
```

---

# 📌 Rebase Feature Branch

```bash id="jlym585"
git switch feature-dashboard

git rebase main
```

---

# 📌 What Rebase Does

Git:

1. Temporarily removes commits
2. Moves branch to latest main
3. Replays commits again

---

# 📌 Rebase vs Merge History

## Merge History

```text id="jlym586"
main ---- merge commit
```

## Rebase History

```text id="jlym587"
main ---- clean linear commits
```

---

# 📌 Why Not Rebase Shared Commits?

Never rebase commits already pushed/shared because:

* Commit hashes change
* Other developers’ history breaks
* Causes collaboration problems

---

# 📌 When to Use Rebase vs Merge

| Rebase             | Merge                 |
| ------------------ | --------------------- |
| Clean history      | Preserve full history |
| Local branches     | Shared branches       |
| Small feature work | Team collaboration    |

---

# 🧩 Task 3 – Squash Merge

# 📌 What is Squash Merge?

Squash merge:

* Combines multiple commits
* Into single commit

Useful for:

* Cleaning noisy history

---

# 📌 Create Branch

```bash id="jlym588"
git switch -c feature-profile
```

---

# 📌 Add Multiple Small Commits

```bash id="jlym589"
git commit -m "Fixed typo"
git commit -m "Updated spacing"
git commit -m "Minor formatting"
```

---

# 📌 Squash Merge

```bash id="jlym590"
git switch main

git merge --squash feature-profile
```

---

# 📌 Commit Squashed Changes

```bash id="jlym591"
git commit -m "Added profile feature"
```

---

# 📌 Result

Instead of:

```text id="jlym592"
4-5 small commits
```

Git creates:

```text id="jlym593"
1 clean commit
```

---

# 📌 Regular Merge

```bash id="jlym594"
git merge feature-settings
```

Preserves all commits individually.

---

# 📌 Squash vs Regular Merge

| Squash Merge  | Regular Merge         |
| ------------- | --------------------- |
| Clean history | Full detailed history |
| One commit    | Multiple commits      |
| Simpler logs  | Detailed logs         |

---

# 📌 Trade-Off of Squashing

You lose:

* Detailed commit history
* Intermediate commit visibility

---

# 📦 Task 4 – Git Stash

# 📌 What is Git Stash?

Git stash temporarily saves:

* Uncommitted changes

without committing them.

---

# 📌 Modify File Without Commit

```bash id="jlym595"
echo "Temporary work" >> app.txt
```

---

# 📌 Try Switching Branch

```bash id="jlym596"
git switch main
```

Git may block switching if changes conflict.

---

# 📌 Save Work Using Stash

```bash id="jlym597"
git stash
```

---

# 📌 Stash with Message

```bash id="jlym598"
git stash push -m "Work in progress"
```

---

# 📌 View Stashes

```bash id="jlym599"
git stash list
```

---

# 📌 Apply Stash

```bash id="jlym600"
git stash apply
```

---

# 📌 Pop Stash

```bash id="jlym601"
git stash pop
```

---

# 📌 Difference Between Apply vs Pop

| Command           | Behavior                   |
| ----------------- | -------------------------- |
| `git stash apply` | Applies stash but keeps it |
| `git stash pop`   | Applies and removes stash  |

---

# 📌 Apply Specific Stash

```bash id="jlym602"
git stash apply stash@{1}
```

---

# 📌 Real-World Stash Use Case

Used when:

* Urgent production issue appears
* Need quick branch switching
* Work is incomplete

---

# 🍒 Task 5 – Cherry Pick

# 📌 What is Cherry Pick?

Cherry-pick copies:

* Specific commit
* From one branch to another

---

# 📌 Create Hotfix Branch

```bash id="jlym603"
git switch -c feature-hotfix
```

---

# 📌 Add Multiple Commits

```bash id="jlym604"
git commit -m "Hotfix 1"
git commit -m "Hotfix 2"
git commit -m "Hotfix 3"
```

---

# 📌 Find Commit Hash

```bash id="jlym605"
git log --oneline
```

---

# 📌 Cherry Pick Specific Commit

```bash id="jlym606"
git switch main

git cherry-pick <commit-hash>
```

---

# 📌 Verify Commit Applied

```bash id="jlym607"
git log --oneline
```

Only selected commit appears.

---

# 📌 When to Use Cherry Pick?

Useful for:

* Production hotfixes
* Selective feature transfer
* Applying urgent fixes

---

# ⚠️ Risks of Cherry Picking

Can cause:

* Duplicate commits
* Merge conflicts
* Confusing history

if overused.

---

# 🔄 Advanced Git Workflow

```text id="jlym608"
Feature Branch
      ↓
Merge/Rebase
      ↓
Main Branch
      ↓
Push to GitHub
      ↓
CI/CD Pipeline
```

---

# 🛠️ Important Git Commands Practiced

| Command              | Purpose              |
| -------------------- | -------------------- |
| `git merge`          | Merge branches       |
| `git rebase`         | Reapply commits      |
| `git merge --squash` | Squash commits       |
| `git stash`          | Save temporary work  |
| `git stash list`     | View stashes         |
| `git stash pop`      | Apply & remove stash |
| `git cherry-pick`    | Copy specific commit |
| `git log --graph`    | Visualize history    |

---

# 🚨 Real-World DevOps Use Cases

Advanced Git workflows are heavily used in:

* GitHub Actions
* Jenkins pipelines
* Kubernetes GitOps
* Terraform repositories
* Infrastructure deployments
* Production hotfix workflows

Examples:

* Rebase feature branches before merging
* Use stash during incident handling
* Cherry-pick hotfixes into production
* Squash commits before release deployment

---

# 🎯 What I Learned

✅ Understanding fast-forward merge
✅ Understanding merge commits
✅ Resolving merge conflicts
✅ Using Git rebase
✅ Understanding squash merge
✅ Using Git stash effectively
✅ Using cherry-pick for selective commits
✅ Visualizing Git history

---

# 🏁 Conclusion

Advanced Git workflows are essential for modern DevOps engineering.

Understanding:

* Merge
* Rebase
* Squash
* Stash
* Cherry-pick
