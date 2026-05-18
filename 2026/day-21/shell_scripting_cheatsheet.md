# 🚀 Day 21 – Shell Scripting Cheat Sheet

# 📌 Introduction

This cheat sheet is a quick reference guide for Shell Scripting concepts used in real-world DevOps and SRE environments.

It covers:

* Shell scripting basics
* Variables and arguments
* Loops and conditionals
* Functions
* Text processing commands
* Error handling
* Useful automation one-liners

This document is designed to help during:

* Linux administration
* DevOps automation
* CI/CD pipelines
* Kubernetes operations
* Troubleshooting
* Interview preparation

---

# 📋 Quick Reference Table

| Topic        | Key Syntax               | Example                            |
| ------------ | ------------------------ | ---------------------------------- |
| Variable     | `VAR="value"`            | `NAME="DevOps"`                    |
| Argument     | `$1`, `$2`               | `./script.sh arg1`                 |
| If Condition | `if [ condition ]; then` | `if [ -f file ]; then`             |
| For Loop     | `for i in list; do`      | `for i in 1 2 3; do`               |
| Function     | `name() { ... }`         | `greet() { echo "Hi"; }`           |
| Grep         | `grep pattern file`      | `grep -i "error" log.txt`          |
| Awk          | `awk '{print $1}' file`  | `awk -F: '{print $1}' /etc/passwd` |
| Sed          | `sed 's/old/new/g' file` | `sed -i 's/foo/bar/g' config.txt`  |

---

# 🐚 Task 1 – Shell Scripting Basics

# 🔹 Shebang

Defines interpreter used by script.

```bash id="jlym440"
#!/bin/bash
```

---

# 🔹 Running a Script

## Make Executable

```bash id="jlym441"
chmod +x script.sh
```

## Execute Script

```bash id="jlym442"
./script.sh
```

OR

```bash id="jlym443"
bash script.sh
```

---

# 🔹 Comments

## Single-Line Comment

```bash id="jlym444"
# This is a comment
```

## Inline Comment

```bash id="jlym445"
echo "Hello" # Print message
```

---

# 🔹 Variables

## Declare Variable

```bash id="jlym446"
NAME="DevOps"
```

## Access Variable

```bash id="jlym447"
echo $NAME
```

---

# 🔹 Quotes

## Double Quotes

```bash id="jlym448"
echo "$NAME"
```

Variable expands.

---

## Single Quotes

```bash id="jlym449"
echo '$NAME'
```

Variable does not expand.

---

# 🔹 Read User Input

```bash id="jlym450"
read -p "Enter Name: " NAME
```

---

# 🔹 Command-Line Arguments

| Variable | Meaning         |
| -------- | --------------- |
| `$0`     | Script name     |
| `$1`     | First argument  |
| `$2`     | Second argument |
| `$#`     | Total arguments |
| `$@`     | All arguments   |
| `$?`     | Exit code       |

---

# 🧩 Task 2 – Operators & Conditionals

# 🔹 String Comparisons

```bash id="jlym451"
[ "$A" = "$B" ]
[ "$A" != "$B" ]
[ -z "$VAR" ]
[ -n "$VAR" ]
```

---

# 🔹 Integer Comparisons

```bash id="jlym452"
[ $A -eq $B ]
[ $A -ne $B ]
[ $A -lt $B ]
[ $A -gt $B ]
[ $A -le $B ]
[ $A -ge $B ]
```

---

# 🔹 File Test Operators

| Operator | Purpose               |
| -------- | --------------------- |
| `-f`     | File exists           |
| `-d`     | Directory exists      |
| `-e`     | File/directory exists |
| `-r`     | Read permission       |
| `-w`     | Write permission      |
| `-x`     | Execute permission    |
| `-s`     | File not empty        |

---

# 🔹 If-Else Syntax

```bash id="jlym453"
if [ condition ]; then

    echo "True"

elif [ another_condition ]; then

    echo "Another"

else

    echo "False"
fi
```

---

# 🔹 Logical Operators

## AND

```bash id="jlym454"
command1 && command2
```

## OR

```bash id="jlym455"
command1 || command2
```

## NOT

```bash id="jlym456"
! command
```

---

# 🔹 Case Statement

```bash id="jlym457"
case $VAR in

start)
    echo "Starting"
    ;;

stop)
    echo "Stopping"
    ;;

*)
    echo "Invalid Option"
    ;;
esac
```

---

# 🔁 Task 3 – Loops

# 🔹 For Loop

## List-Based Loop

```bash id="jlym458"
for fruit in Apple Mango Banana
do
    echo $fruit
done
```

---

## C-Style Loop

```bash id="jlym459"
for ((i=1; i<=5; i++))
do
    echo $i
done
```

---

# 🔹 While Loop

```bash id="jlym460"
COUNT=1

while [ $COUNT -le 5 ]
do
    echo $COUNT
    COUNT=$((COUNT+1))
done
```

---

# 🔹 Until Loop

```bash id="jlym461"
COUNT=1

until [ $COUNT -gt 5 ]
do
    echo $COUNT
    COUNT=$((COUNT+1))
done
```

---

# 🔹 Break & Continue

## Break

```bash id="jlym462"
break
```

Stops loop completely.

---

## Continue

```bash id="jlym463"
continue
```

Skips current iteration.

---

# 🔹 Loop Over Files

```bash id="jlym464"
for file in *.log
do
    echo $file
done
```

---

# 🔹 Loop Over Command Output

```bash id="jlym465"
cat users.txt | while read line
do
    echo $line
done
```

---

# ⚙️ Task 4 – Functions

# 🔹 Function Syntax

```bash id="jlym466"
greet() {

    echo "Hello"
}
```

---

# 🔹 Call Function

```bash id="jlym467"
greet
```

---

# 🔹 Function Arguments

```bash id="jlym468"
greet() {

    echo "Hello $1"
}

greet DevOps
```

---

# 🔹 Return Values

## Using return

```bash id="jlym469"
return 0
```

---

## Using echo

```bash id="jlym470"
echo "Success"
```

---

# 🔹 Local Variables

```bash id="jlym471"
my_function() {

    local VAR="local"
}
```

---

# 📝 Task 5 – Text Processing Commands

# 🔹 grep

## Search Pattern

```bash id="jlym472"
grep "error" app.log
```

## Useful Flags

| Flag | Purpose           |
| ---- | ----------------- |
| `-i` | Ignore case       |
| `-r` | Recursive search  |
| `-c` | Count matches     |
| `-n` | Show line numbers |
| `-v` | Invert match      |
| `-E` | Extended regex    |

---

# 🔹 awk

## Print First Column

```bash id="jlym473"
awk '{print $1}' file.txt
```

## Use Field Separator

```bash id="jlym474"
awk -F: '{print $1}' /etc/passwd
```

---

# 🔹 sed

## Replace Text

```bash id="jlym475"
sed 's/foo/bar/g' file.txt
```

## In-Place Edit

```bash id="jlym476"
sed -i 's/foo/bar/g' file.txt
```

---

# 🔹 cut

## Extract Column

```bash id="jlym477"
cut -d: -f1 /etc/passwd
```

---

# 🔹 sort

## Alphabetical Sort

```bash id="jlym478"
sort file.txt
```

## Numerical Sort

```bash id="jlym479"
sort -n numbers.txt
```

---

# 🔹 uniq

## Remove Duplicates

```bash id="jlym480"
uniq file.txt
```

## Count Occurrences

```bash id="jlym481"
uniq -c file.txt
```

---

# 🔹 tr

## Convert Lowercase to Uppercase

```bash id="jlym482"
echo "devops" | tr 'a-z' 'A-Z'
```

---

# 🔹 wc

## Count Lines, Words, Characters

```bash id="jlym483"
wc file.txt
```

---

# 🔹 head & tail

## First 10 Lines

```bash id="jlym484"
head file.txt
```

## Last 10 Lines

```bash id="jlym485"
tail file.txt
```

## Live Log Monitoring

```bash id="jlym486"
tail -f app.log
```

---

# 🚀 Task 6 – Useful One-Liners

# 🔹 Delete Files Older Than 7 Days

```bash id="jlym487"
find /tmp -type f -mtime +7 -delete
```

---

# 🔹 Count Lines in Log Files

```bash id="jlym488"
wc -l *.log
```

---

# 🔹 Replace String Across Files

```bash id="jlym489"
sed -i 's/old/new/g' *.txt
```

---

# 🔹 Check Service Status

```bash id="jlym490"
systemctl is-active nginx
```

---

# 🔹 Monitor Disk Usage

```bash id="jlym491"
df -h | grep '/$'
```

---

# 🔹 Real-Time Error Monitoring

```bash id="jlym492"
tail -f app.log | grep ERROR
```

---

# 🔹 Parse JSON using jq

```bash id="jlym493"
cat data.json | jq '.name'
```

---

# 🛡️ Task 7 – Error Handling & Debugging

# 🔹 Exit Codes

## Success

```bash id="jlym494"
exit 0
```

## Failure

```bash id="jlym495"
exit 1
```

---

# 🔹 Previous Command Exit Code

```bash id="jlym496"
echo $?
```

---

# 🔹 set -e

Exit script if command fails.

```bash id="jlym497"
set -e
```

---

# 🔹 set -u

Treat undefined variables as errors.

```bash id="jlym498"
set -u
```

---

# 🔹 set -o pipefail

Catch errors inside pipes.

```bash id="jlym499"
set -o pipefail
```

---

# 🔹 set -x

Enable debug tracing.

```bash id="jlym500"
set -x
```

---

# 🔹 Trap Cleanup

```bash id="jlym501"
trap 'cleanup' EXIT
```

Runs cleanup function when script exits.

---

# 🎯 Best Practices for Shell Scripting

✅ Use `set -euo pipefail` in production scripts
✅ Use meaningful variable names
✅ Always validate user input
✅ Use functions for reusable code
✅ Add comments for readability
✅ Handle errors properly
✅ Test scripts before production usage

---

# 🚨 Real-World DevOps Use Cases

Shell scripting is heavily used in:

* Kubernetes automation
* Jenkins pipelines
* Monitoring scripts
* Deployment automation
* AWS EC2 bootstrap scripts
* Backup operations
* Log analysis
* Linux administration

---

# 🏁 Conclusion

Shell scripting is a core DevOps skill that enables:

* Automation
* Scalability
* Operational efficiency
* Infrastructure management

Understanding:

* Variables
* Loops
* Functions
* Text processing
* Error handling
