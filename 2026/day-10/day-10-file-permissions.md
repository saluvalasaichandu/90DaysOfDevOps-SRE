# 🚀 Day 10 – File Permissions & File Operations Challenge

# 📌 Introduction

Linux File Permissions are one of the most important security concepts for DevOps and SRE Engineers.

In real-world production environments, DevOps Engineers constantly work with:

* Configuration files
* Shell scripts
* Deployment files
* Logs
* Application binaries

Understanding Linux permissions helps:

* Secure systems
* Control access
* Prevent unauthorized modifications
* Manage shared environments safely

In today’s hands-on challenge, I practiced:
✅ Creating files and directories
✅ Reading files using Linux commands
✅ Understanding Linux permissions
✅ Modifying permissions using `chmod`
✅ Executing shell scripts
✅ Testing permission-related errors

---

# 📂 What are Linux File Permissions?

Linux permissions define:

* Who can access files
* What actions they can perform

Linux permissions are divided into:

* Owner
* Group
* Others

---

# 🔍 Permission Format

Example:

```text id="xv6vbd"
-rwxr-xr--
```

---

# 📌 Permission Breakdown

| Symbol | Meaning       |
| ------ | ------------- |
| r      | Read          |
| w      | Write         |
| x      | Execute       |
| -      | No Permission |

---

# 📌 Permission Sections

```text id="e8nk4r"
-rwxr-xr--
```

| Section | Meaning            |
| ------- | ------------------ |
| -       | File type          |
| rwx     | Owner permissions  |
| r-x     | Group permissions  |
| r--     | Others permissions |

---

# 📌 Numeric Permission Values

| Permission | Value |
| ---------- | ----- |
| r          | 4     |
| w          | 2     |
| x          | 1     |

Examples:

| Numeric | Meaning   |
| ------- | --------- |
| 777     | rwxrwxrwx |
| 755     | rwxr-xr-x |
| 644     | rw-r--r-- |
| 640     | rw-r----- |

---

# 🛠️ Task 1 – Create Files

# 🔹 Create Empty File

## Command

```bash id="6h4eqw"
touch devops.txt
```
<img width="782" height="141" alt="image" src="https://github.com/user-attachments/assets/cdb72893-cc6f-40e6-821c-244831ad5065" />

### Purpose

Creates an empty file.

---

# 🔹 Verify File

## Command

```bash id="jlwmzm"
ls -l devops.txt
```

### Example Output

```text id="jlwmzn"
-rw-rw-r-- 1 ubuntu ubuntu 0 May 10 devops.txt
```

---

# 🔹 Create notes.txt with Content

## Command

```bash id="jlwmzo"
echo "Linux permissions are important in DevOps." > notes.txt
```

---

# 🔹 Verify Content

## Command

```bash id="jlwmzp"
cat notes.txt
```

### Output

```text id="jlwmzq"
Linux permissions are important in DevOps.
```

---

# 🔹 Create Shell Script using vim

## Command

```bash id="jlwmzr"
vim script.sh
```

## Script Content

```bash id="jlwmzs"
echo "Hello DevOps"
```

---

# 🔹 Verify Files

## Command

```bash id="jlwmzt"
ls -l
```

---

# 📖 Task 2 – Read Files

# 🔹 Read File using cat

## Command

```bash id="jlwmzu"
cat notes.txt
```

### Purpose

Displays complete file content.

---

# 🔹 Open File in Read-Only Mode

## Command

```bash id="jlwmzv"
vim -R script.sh
```

### Purpose

Opens file in read-only mode.

---

# 🔹 View First 5 Lines

## Command

```bash id="jlwmzw"
head -n 5 /etc/passwd
```
<img width="773" height="197" alt="image" src="https://github.com/user-attachments/assets/fc5be6b6-45a4-4eea-bcbf-9da01df9ab47" />

### Purpose

Displays first 5 lines of file.

---

# 🔹 View Last 5 Lines

## Command

```bash id="jlwmzx"
tail -n 5 /etc/passwd
```

### Purpose

Displays last 5 lines.

---

# 🔍 Task 3 – Understand Permissions

# 🔹 Check File Permissions

## Command

```bash id="jlwmzy"
ls -l devops.txt notes.txt script.sh
```

## Example Output

```text id="jlwmzz"
-rw-rw-r-- devops.txt
-rw-rw-r-- notes.txt
-rw-rw-r-- script.sh
```

---

# 📌 Permission Analysis

| File       | Owner      | Group      | Others |
| ---------- | ---------- | ---------- | ------ |
| devops.txt | read/write | read/write | read   |
| notes.txt  | read/write | read/write | read   |
| script.sh  | read/write | read/write | read   |

---

# 📌 Important Observation

`script.sh` is not executable yet because execute permission (`x`) is missing.

---

# 🔧 Task 4 – Modify Permissions

# 🔹 Make Script Executable

## Command

```bash id="jlym013"
chmod +x script.sh
```

---

# 🔹 Verify Permissions

## Command

```bash id="jlym014"
ls -l script.sh
```

## Example Output

```text id="jlym015"
-rwxrwxr-x
```

---

# 🔹 Execute Script

## Command

```bash id="jlym016"
./script.sh
```

## Output

```text id="jlym017"
Hello DevOps
```

---

# 🔹 Make devops.txt Read-Only

## Command

```bash id="jlym018"
chmod a-w devops.txt
```
<img width="825" height="163" alt="image" src="https://github.com/user-attachments/assets/3281050f-a6ef-49c2-95d0-adbbba05c85a" />

### Purpose

Removes write permission for everyone.
<img width="775" height="119" alt="image" src="https://github.com/user-attachments/assets/44d269f6-4005-42d2-ad9b-7c1dd035dcd7" />

---

# 🔹 Verify Permissions

## Command

```bash id="jlym019"
ls -l devops.txt
```

## Example Output

```text id="jlym020"
-r--r--r--
```

---

# 🔹 Set notes.txt to 640

## Command

```bash id="jlym021"
chmod 640 notes.txt
```

---

# 🔹 Verify Permissions

## Command

```bash id="jlym022"
ls -l notes.txt
```

## Example Output

```text id="jlym023"
-rw-r-----
```

---

# 🔹 Create Project Directory

## Command

```bash id="jlym024"
mkdir project
```

---

# 🔹 Set Directory Permission to 755

## Command

```bash id="jlym025"
chmod 755 project
```

---

# 🔹 Verify Directory Permissions

## Command

```bash id="jlym026"
ls -ld project
```

## Example Output

```text id="jlym027"
drwxr-xr-x
```

---

# 🧪 Task 5 – Test Permissions

# 🔹 Try Writing to Read-Only File

## Command

```bash id="jlym028"
echo "New Data" >> devops.txt
```

## Error

```text id="jlym029"
Permission denied
```

---

# 🔹 Remove Execute Permission

## Command

```bash id="jlym030"
chmod -x script.sh
```

---

# 🔹 Try Executing Script Again

## Command

```bash id="jlym031"
./script.sh
```

## Error

```text id="jlym032"
Permission denied
```

---

# 📌 Understanding chmod

# Symbolic Method

| Command   | Purpose               |
| --------- | --------------------- |
| chmod +x  | Add execute           |
| chmod -w  | Remove write          |
| chmod u+x | Add execute for owner |

---

# Numeric Method

| Command   | Meaning   |
| --------- | --------- |
| chmod 755 | rwxr-xr-x |
| chmod 644 | rw-r--r-- |
| chmod 640 | rw-r----- |

---

# 🚨 Real-World DevOps Use Cases

Linux permissions are heavily used in:

* Shell scripts
* CI/CD pipelines
* Deployment automation
* Kubernetes configs
* SSH keys
* Docker volumes
* Application logs

Examples:

* Scripts require execute permission
* Config files should not be world writable
* SSH keys require secure permissions

---

# 🔍 Troubleshooting Scenario

# Problem

Shell script is not executing.

---

# Step 1 – Check Permissions

```bash id="jlym033"
ls -l script.sh
```

---

# Step 2 – Add Execute Permission

```bash id="jlym034"
chmod +x script.sh
```

---

# Step 3 – Execute Script

```bash id="jlym035"
./script.sh
```

---

# 🎯 What I Learned

✅ How Linux permissions work
✅ Difference between owner, group, and others
✅ How to modify permissions using chmod
✅ How execute permissions affect scripts
✅ Understanding symbolic and numeric permissions
✅ Real-world security best practices

---

# ✅ Commands Practiced Today

```bash id="jlym036"
touch
echo
cat
vim
vim -R
head -n
tail -n
ls -l
chmod +x
chmod -w
chmod 640
chmod 755
mkdir
./script.sh
```

---

# 🏁 Conclusion

Linux File Permissions are a foundational security concept for every DevOps and SRE Engineer.

Understanding:

* File permissions
* Directory permissions
* chmod
* Read/write/execute access

helps engineers securely manage production environments and automation workflows.

The stronger your Linux permission management skills become, the easier infrastructure security and DevOps automation will feel.
