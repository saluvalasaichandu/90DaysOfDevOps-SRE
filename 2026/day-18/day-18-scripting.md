# Day 18 – Shell Scripting: Functions & Intermediate Concepts

> **#90DaysOfDevOps | #DevOpsKaJosh | #TrainWithShubham**

---

## 📋 Table of Contents

- [Overview](#overview)
- [Task 1: Basic Functions](#task-1-basic-functions)
- [Task 2: Functions with Return Values](#task-2-functions-with-return-values)
- [Task 3: Strict Mode — set -euo pipefail](#task-3-strict-mode--set--euo-pipefail)
- [Task 4: Local Variables](#task-4-local-variables)
- [Task 5: System Info Reporter](#task-5-system-info-reporter)
- [Key Learnings](#key-learnings)

---

## Overview

In Day 18, we level up our Bash scripting by learning how to write **clean, reusable, and safe scripts** using functions, strict mode, and real-world patterns.

**Skills covered:**
- Writing and calling functions
- Using `set -euo pipefail` for safer scripts
- Working with return values and local variables
- Building a full System Info Reporter script

---

## Task 1: Basic Functions

### 📄 Script: `functions.sh`

```bash
#!/bin/bash
# functions.sh — Basic function definitions and calls

# Function to greet a user
greet() {
    local name="$1"
    echo "Hello, ${name}!"
}

# Function to add two numbers
add() {
    local num1="$1"
    local num2="$2"
    local result=$(( num1 + num2 ))
    echo "Sum of ${num1} and ${num2} = ${result}"
}

# --- Main ---
greet "Saichandu"
greet "DevOps Engineer"

add 10 25
add 100 250
```

### ▶️ Output

```
Hello, saichandu!
Hello, DevOps Engineer!
Sum of 10 and 25 = 35
Sum of 100 and 250 = 350
```
<img width="901" height="732" alt="image" src="https://github.com/user-attachments/assets/33f6262c-4c55-4cdf-9798-5ed434d32460" />

### 💡 Explanation

| Concept | Detail |
|--------|--------|
| `greet()` | Takes `$1` (first argument) and prints a greeting |
| `add()` | Takes `$1` and `$2`, computes sum using `$(( ))` arithmetic |
| Calling functions | Just use the function name followed by arguments |

---

## Task 2: Functions with Return Values

### 📄 Script: `disk_check.sh`

```bash
#!/bin/bash
# disk_check.sh — Check disk and memory usage using functions

# Function to check disk usage of root partition
check_disk() {
    echo "===== Disk Usage (/) ====="
    df -h /
    echo ""
}

# Function to check free memory
check_memory() {
    echo "===== Memory Usage ====="
    free -h
    echo ""
}

# --- Main ---
check_disk
check_memory
```
<img width="1243" height="624" alt="image" src="https://github.com/user-attachments/assets/1e64b39f-1f83-465e-a1b0-f58fa88ecfa4" />

### ▶️ Output

```
===== Disk Usage (/) =====
Filesystem      Size  Used Avail Use% Mounted on
/dev/xvda1       20G  6.2G   14G  32% /

===== Memory Usage =====
               total        used        free      shared  buff/cache   available
Mem:           3.8Gi       1.2Gi       1.5Gi        45Mi       1.1Gi       2.4Gi
Swap:          2.0Gi          0B       2.0Gi
```

### 💡 Explanation

- Functions in Bash **don't return values** like in other languages — they print output via `echo` or `printf`
- The caller captures output using `$(function_name)` if needed, or lets it print directly to stdout
- Each function handles one responsibility (Single Responsibility Principle)

---

## Task 3: Strict Mode — `set -euo pipefail`

### 📄 Script: `strict_demo.sh`

```bash
#!/bin/bash
set -euo pipefail
# strict_demo.sh — Demonstrates behavior of strict mode flags

echo "=== Testing set -u (undefined variable) ==="
# Uncomment below to trigger set -u error:
# echo "Undefined: $UNDEFINED_VAR"
# ↑ Without set -u, this silently prints blank.
# With set -u, the script EXITS with:
# bash: UNDEFINED_VAR: unbound variable

echo "=== Testing set -e (command failure) ==="
# Uncomment below to trigger set -e exit:
# ls /nonexistent_directory
# ↑ Without set -e, script continues even after failure.
# With set -e, the script EXITS immediately on non-zero exit code.

echo "=== Testing set -o pipefail (pipe failure) ==="
# Uncomment below to trigger pipefail:
# cat /nonexistent_file | grep "something"
# ↑ Without pipefail, only the last command's exit code matters.
# grep sees no input but exits 0 — hiding the failure of cat.
# With pipefail, the PIPE's exit code = rightmost non-zero command.

echo "All tests passed (no errors triggered)."
```

### 🔍 What Each Flag Does

| Flag | Meaning | Behavior Without It | Behavior With It |
|------|---------|--------------------|--------------------|
| `set -e` | **Exit on error** | Script continues after failed commands | Script exits immediately on any non-zero exit code |
| `set -u` | **Treat unset variables as errors** | Silently expands unset vars to empty string | Script exits with `unbound variable` error |
| `set -o pipefail` | **Pipe failure propagation** | Only last command in pipe is checked | Any failed command in a pipeline causes failure |

### 📝 Demonstration

```bash
# Without set -u:
echo $UNDEFINED     # Prints: (blank — dangerous!)

# With set -u:
echo $UNDEFINED     # Exits: bash: UNDEFINED: unbound variable

# Without set -e:
ls /fake && echo "Next step"   # Prints error but continues

# With set -e:
ls /fake && echo "Next step"   # Exits at ls, never reaches echo

# Without pipefail:
cat /fake | grep "data"        # grep returns 0, hides cat's failure

# With pipefail:
cat /fake | grep "data"        # Returns non-zero — cat failed!
```
<img width="946" height="386" alt="image" src="https://github.com/user-attachments/assets/4e9e7c08-ff99-42d0-bb85-fe91b59cfc65" />

> **Best Practice:** Always start scripts with `#!/bin/bash` followed by `set -euo pipefail` for production-grade safety.

---

## Task 4: Local Variables

### 📄 Script: `local_demo.sh`

```bash
#!/bin/bash
# local_demo.sh — Demonstrate local vs global variable scope

#!/bin/bash

global_var="Global"

demo_function() {

    local local_var="Local"

    echo "Inside Function:"
    echo $local_var
    echo $global_var
}

demo_function

echo "Outside Function:"
echo $global_var

echo $local_var

### ▶️ Output

Inside Function:
Local
Global

Outside Function:
Global

### 💡 Key Takeaways

- **`local` keyword** restricts a variable to the function scope — it doesn't bleed out
- Without `local`, any variable set inside a function **modifies the global scope**
- This is a common source of subtle bugs — always use `local` inside functions unless you explicitly need global mutation
<img width="861" height="594" alt="image" src="https://github.com/user-attachments/assets/88325e5b-a8c4-47d5-b688-ffafee649661" />

---

## Task 5: System Info Reporter

### 📄 Script: `system_info.sh`

```bash
#!/bin/bash
set -euo pipefail
# system_info.sh — Modular system information reporter

# ─────────────────────────────────────────────
# Helper: Print a section header
# ─────────────────────────────────────────────
print_header() {
    local title="$1"
    echo ""
    echo "════════════════════════════════════════"
    echo "  ${title}"
    echo "════════════════════════════════════════"
}

# ─────────────────────────────────────────────
# Function 1: Hostname and OS Info
# ─────────────────────────────────────────────
get_system_info() {
    print_header "🖥️  System Information"
    echo "  Hostname   : $(hostname)"
    echo "  OS         : $(grep PRETTY_NAME /etc/os-release | cut -d= -f2 | tr -d '"')"
    echo "  Kernel     : $(uname -r)"
    echo "  Architecture: $(uname -m)"
}

# ─────────────────────────────────────────────
# Function 2: Uptime
# ─────────────────────────────────────────────
get_uptime() {
    print_header "⏱️  System Uptime"
    echo "  $(uptime -p)"
    echo "  Since: $(uptime -s)"
}

# ─────────────────────────────────────────────
# Function 3: Disk Usage (Top 5 by size)
# ─────────────────────────────────────────────
get_disk_usage() {
    print_header "💾 Disk Usage (Top 5 Mounts by Use%)"
    df -h --output=source,fstype,size,used,avail,pcent,target \
        | grep -v tmpfs \
        | sort -rk6 \
        | head -6
}

# ─────────────────────────────────────────────
# Function 4: Memory Usage
# ─────────────────────────────────────────────
get_memory_usage() {
    print_header "🧠 Memory Usage"
    free -h
}

# ─────────────────────────────────────────────
# Function 5: Top 5 CPU-Consuming Processes
# ─────────────────────────────────────────────
get_top_processes() {
    print_header "🔥 Top 5 CPU-Consuming Processes"
    printf "  %-8s %-10s %-6s %-6s %s\n" "PID" "USER" "%CPU" "%MEM" "COMMAND"
    echo "  ──────────────────────────────────────────────"
    ps aux --sort=-%cpu \
        | awk 'NR>1 {printf "  %-8s %-10s %-6s %-6s %s\n", $2, $1, $3, $4, $11}' \
        | head -5
}

# ─────────────────────────────────────────────
# Main Function
# ─────────────────────────────────────────────
main() {
    echo ""
    echo "╔══════════════════════════════════════════╗"
    echo "║        SYSTEM INFO REPORTER              ║"
    echo "║    Generated: $(date '+%Y-%m-%d %H:%M:%S')       ║"
    echo "╚══════════════════════════════════════════╝"

    get_system_info
    get_uptime
    get_disk_usage
    get_memory_usage
    get_top_processes

    echo ""
    echo "════════════════════════════════════════"
    echo "  ✅ Report Complete"
    echo "════════════════════════════════════════"
    echo ""
}

# ─────────────────────────────────────────────
# Entry Point
# ─────────────────────────────────────────────
main
```

### ▶️ Sample Output

```
╔══════════════════════════════════════════╗
║        SYSTEM INFO REPORTER              ║
║    Generated: 2026-05-13 10:32:47       ║
╚══════════════════════════════════════════╝

════════════════════════════════════════
  🖥️  System Information
════════════════════════════════════════
  Hostname   : devops-server-01
  OS         : Ubuntu 22.04.3 LTS
  Kernel     : 5.15.0-91-generic
  Architecture: x86_64

════════════════════════════════════════
  ⏱️  System Uptime
════════════════════════════════════════
  up 3 days, 4 hours, 12 minutes
  Since: 2026-05-10 06:20:35

════════════════════════════════════════
  💾 Disk Usage (Top 5 Mounts by Use%)
════════════════════════════════════════
Filesystem     Type   Size  Used Avail Use% Mounted on
/dev/xvda1     ext4    20G  6.2G   14G  32% /
/dev/xvdb1     ext4   100G   45G   55G  45% /data

════════════════════════════════════════
  🧠 Memory Usage
════════════════════════════════════════
               total        used        free      shared  buff/cache   available
Mem:           3.8Gi       1.2Gi       1.5Gi        45Mi       1.1Gi       2.4Gi
Swap:          2.0Gi          0B       2.0Gi

════════════════════════════════════════
  🔥 Top 5 CPU-Consuming Processes
════════════════════════════════════════
  PID      USER       %CPU   %MEM   COMMAND
  ──────────────────────────────────────────────
  1532     ubuntu     12.3   2.1    /usr/bin/python3
  894      root       5.4    0.8    /usr/sbin/dockerd
  2210     ubuntu     3.2    1.5    node
  1843     ubuntu     1.1    0.4    bash
  402      root       0.9    0.2    /usr/lib/systemd/systemd

════════════════════════════════════════
  ✅ Report Complete
════════════════════════════════════════
```
<img width="1273" height="624" alt="image" src="https://github.com/user-attachments/assets/bcf02f42-18ee-45ee-a452-46309b943f45" />
<img width="613" height="163" alt="image" src="https://github.com/user-attachments/assets/8de9c1ae-734d-4cca-8a8d-6a85e4c86c74" />

---

## 📖 Key Learnings

### 1. 🔧 Functions make scripts modular and reusable
Functions in Bash follow the principle of **Do One Thing Well**. By separating concerns into named functions (`get_disk_usage`, `get_memory_usage`, etc.), scripts become easier to read, test, and maintain. Arguments are passed positionally (`$1`, `$2`) and should always be captured into named `local` variables immediately.

```bash
my_function() {
    local arg1="$1"
    local arg2="$2"
    # work with arg1, arg2
}
```

### 2. 🛡️ `set -euo pipefail` is your safety net
Without strict mode, Bash silently swallows errors — unset variables expand to empty strings, failed commands are ignored, and piped errors vanish. Always include this at the top of every production script:

```bash
#!/bin/bash
set -euo pipefail
```

| Flag | What It Guards Against |
|------|------------------------|
| `-e` | Script continuing after a failed command |
| `-u` | Silent use of uninitialized/mistyped variable names |
| `-o pipefail` | Hidden failures in the middle of a pipe chain |

### 3. 🧩 `local` variables prevent hard-to-debug side effects
In Bash, variables are **global by default** — a function can silently overwrite a variable in the calling scope. Using `local` ensures your function's internal state stays encapsulated:

```bash
# Without local — dangerous!
set_name() { NAME="modified" }

# With local — safe
set_name() { local NAME="modified" }
```

---

## 📁 File Structure

```
2026/day-18/
├── functions.sh          # Task 1: Basic functions
├── disk_check.sh         # Task 2: Functions with return values
├── strict_demo.sh        # Task 3: Strict mode demo
├── local_demo.sh         # Task 4: Local variable scope
├── system_info.sh        # Task 5: Full system info reporter
└── day-18-scripting.md  # This documentation file
```

---

## 🚀 How to Run

```bash
# Clone your fork and navigate to day-18
cd 2026/day-18/

# Make all scripts executable
chmod +x *.sh

# Run each script
./functions.sh
./disk_check.sh
./strict_demo.sh
./local_demo.sh
./system_info.sh
```

---

## 📚 Quick Reference

```bash
# Function syntax
function_name() {
    local VAR="$1"
    echo "Result: ${VAR}"
}

# Call a function
function_name "argument"

# Strict mode (always at top)
set -euo pipefail

# Capture function output
result=$(function_name "arg")

# Exit code of last command
echo "Exit: $?"
```

---

