# 🚀 Day 06 – Linux Fundamentals: Read and Write Text Files

# 📌 Introduction

Reading and writing text files are fundamental Linux skills for every DevOps and SRE Engineer.

Almost everything in Linux is stored as text:

* Configuration files
* Application logs
* Shell scripts
* YAML manifests
* Environment files
* Monitoring outputs

As DevOps Engineers, we frequently:

* Read logs
* Edit configuration files
* Create scripts
* Append data
* Monitor log outputs

Today’s hands-on practice focused on:
✅ Creating files
✅ Writing content to files
✅ Appending data
✅ Reading files
✅ Viewing partial content
✅ Using Linux redirection operators

---

# 📂 What is File I/O in Linux?

File I/O means:

* Reading files
* Writing files
* Updating files
* Appending content

Linux provides multiple commands for handling text files efficiently.

---

# 🛠️ Create a File

## 🔹 touch Command

The `touch` command creates an empty file.

## Command

```bash id="6u6fef"
touch notes.txt
```

## Purpose

Creates:

```text
notes.txt
```

### Verification

```bash id="7lw3h0"
ls -l
```

### Observation

The file was created successfully.

---

# ✍️ Write Data to File

Linux uses redirection operators:

* `>` → overwrite content
* `>>` → append content

---

# 🔹 Write First Line Using `>`

## Command

```bash id="k4iybo"
echo "Linux is the foundation of DevOps." > notes.txt
```

## Purpose

Writes first line into file.

⚠️ `>` overwrites existing content.

---

# 🔹 Append Second Line Using `>>`

## Command

```bash id="a5n2gk"
echo "DevOps Engineers work extensively with Linux." >> notes.txt
```

## Purpose

Appends new line without deleting old content.

---

# 🔹 Append Third Line Using `tee`

## Command

```bash id="9chcah"
echo "Logs and configuration files are text-based." | tee -a notes.txt
```

## Purpose

* Displays output on screen
* Appends output to file simultaneously

---

# 📖 Read File Content

## 🔹 Read Entire File Using `cat`

## Command

```bash id="1pxmv9"
cat notes.txt
```

## Example Output

```text
Linux is the foundation of DevOps.
DevOps Engineers work extensively with Linux.
Logs and configuration files are text-based.
```

## Purpose

Displays complete file content.

---

# 📌 Read Partial File Content

Sometimes files become very large, especially logs.

Linux provides commands to read specific sections.

---

# 🔹 Read First Few Lines Using `head`

## Command

```bash id="g02jgb"
head -n 2 notes.txt
```

## Purpose

Displays first 2 lines.

## Example Output

```text
Linux is the foundation of DevOps.
DevOps Engineers work extensively with Linux.
```

---

# 🔹 Read Last Few Lines Using `tail`

## Command

```bash id="50jux9"
tail -n 2 notes.txt
```

## Purpose

Displays last 2 lines.

## Example Output

```text
DevOps Engineers work extensively with Linux.
Logs and configuration files are text-based.
```

---

# 🧪 Additional Practice

## 🔹 Append More Lines

```bash id="sijvq5"
echo "Kubernetes runs on Linux." >> notes.txt
echo "Monitoring and logging are critical in production." >> notes.txt
```

---

# 🔹 View File in Real Time

```bash id="r11wlu"
tail -f notes.txt
```

## Purpose

Monitors file updates live.

Very useful for:

* Application logs
* Monitoring logs
* Debugging production systems

---

# 📜 Final File Content

## Command

```bash id="h1rb2g"
cat notes.txt
```

## Example Output

```text
Linux is the foundation of DevOps.
DevOps Engineers work extensively with Linux.
Logs and configuration files are text-based.
Kubernetes runs on Linux.
Monitoring and logging are critical in production.
```

---

# 🔍 Understanding Redirection Operators

| Operator | Purpose                |             |
| -------- | ---------------------- | ----------- |
| `>`      | Overwrite file         |             |
| `>>`     | Append to file         |             |
| `        | `                      | Pipe output |
| `tee`    | Write + display output |             |

---

# 🚨 Real-Time DevOps Use Cases

These commands are heavily used in:

* Reading application logs
* Updating configuration files
* Writing shell scripts
* Monitoring production logs
* Managing YAML manifests
* Debugging services

Examples:

* `/var/log/syslog`
* `/etc/nginx/nginx.conf`
* `/etc/docker/daemon.json`
* Kubernetes YAML files

---

# 🎯 Why This Matters for DevOps

File handling is a daily DevOps activity.

DevOps Engineers constantly:

* Read logs
* Edit configs
* Create automation scripts
* Append monitoring data
* Analyze system output

Strong Linux file handling skills improve:

* Troubleshooting speed
* Automation capabilities
* Production debugging efficiency

---

# ✅ Commands Practiced Today

```bash id="yked7z"
touch notes.txt
echo "text" > notes.txt
echo "text" >> notes.txt
tee -a notes.txt
cat notes.txt
head -n 2 notes.txt
tail -n 2 notes.txt
tail -f notes.txt
ls -l
```

---

# 🏁 Conclusion

Linux file read/write operations are foundational skills for every DevOps and SRE Engineer.

The ability to quickly:

* Create files
* Read logs
* Append data
* Monitor outputs

helps engineers troubleshoot and automate systems efficiently in production environments.

The stronger your Linux fundamentals become, the easier advanced DevOps tools and automation will feel.

