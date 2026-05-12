# 🚀 Day 16 – Shell Scripting Basics

# 📌 Introduction

Shell scripting is one of the most important skills for every DevOps and SRE Engineer.

In real-world environments, DevOps engineers use shell scripts for:

* Automation
* Monitoring
* Deployments
* Backups
* Health checks
* CI/CD pipelines
* Kubernetes automation
* Infrastructure management

Shell scripting helps reduce:

* Manual work
* Human errors
* Repetitive tasks

In today’s hands-on challenge, I practiced:
✅ Shebang (`#!/bin/bash`)
✅ Variables
✅ User input using `read`
✅ `echo` statements
✅ If-Else conditions
✅ File existence checks
✅ Service status automation

---

# 🐚 What is Shell Scripting?

Shell scripting is the process of writing commands in a file and executing them automatically.

Instead of manually typing commands repeatedly, scripts automate tasks.

---

# 📌 Why Shell Scripting Matters in DevOps

Shell scripting is heavily used in:

* CI/CD pipelines
* Kubernetes automation
* Server monitoring
* Deployment automation
* Backup scripts
* Log analysis
* Cron jobs
* Infrastructure automation

---

# 🔰 Task 1 – Your First Script

# 📌 What is Shebang?

The shebang line:

```bash id="jlym299"
#!/bin/bash
```

tells Linux which interpreter should execute the script.

---

# 🔹 Create Script File

## Command

```bash id="jlym300"
vim hello.sh
```

---

# 🔹 Add Script Content

```bash id="jlym301"
#!/bin/bash

echo "Hello, DevOps!"
```

---

# 🔹 Make Script Executable

## Command

```bash id="jlym302"
chmod +x hello.sh
```

---

# 🔹 Execute Script

## Command

```bash id="jlym303"
./hello.sh
```

---

# 🔹 Output

```text id="jlym304"
Hello, DevOps!
```

---

# 📌 What Happens Without Shebang?

Without:

```bash id="jlym305"
#!/bin/bash
```

the system may:

* Use default shell
* Fail to interpret commands properly
* Produce syntax errors in some environments

---

# 🧩 Task 2 – Variables in Shell Scripting

# 📌 What are Variables?

Variables store data temporarily.

Examples:

* Names
* Server IPs
* Service names
* Environment values

---

# 🔹 Create variables.sh

## Command

```bash id="jlym306"
vim variables.sh
```

---

# 🔹 Script Content

```bash id="jlym307"
#!/bin/bash

NAME="Saichandu"
ROLE="DevOps Engineer"

echo "Hello, I am $NAME and I am a $ROLE"
```

---

# 🔹 Make Executable

```bash id="jlym308"
chmod +x variables.sh
```

---

# 🔹 Run Script

```bash id="jlym309"
./variables.sh
```

---

# 🔹 Output

```text id="jlym310"
Hello, I am Saichandu and I am a DevOps Engineer
```

---

# 📌 Single Quotes vs Double Quotes

# 🔹 Double Quotes

```bash id="jlym311"
echo "Hello $NAME"
```

### Output

```text id="jlym312"
Hello Saichandu
```

Variables expand properly.

---

# 🔹 Single Quotes

```bash id="jlym313"
echo 'Hello $NAME'
```

### Output

```text id="jlym314"
Hello $NAME
```

Variables do NOT expand.

---

# 🧑‍💻 Task 3 – User Input using read

# 📌 What is read?

`read` accepts user input dynamically.

Used heavily in:

* Automation scripts
* Deployment confirmations
* Monitoring tools

---

# 🔹 Create greet.sh

## Command

```bash id="jlym315"
vim greet.sh
```

---

# 🔹 Script Content

```bash id="jlym316"
#!/bin/bash

read -p "Enter your name: " NAME
read -p "Enter your favourite tool: " TOOL

echo "Hello $NAME, your favourite tool is $TOOL"
```

---

# 🔹 Make Executable

```bash id="jlym317"
chmod +x greet.sh
```

---

# 🔹 Run Script

```bash id="jlym318"
./greet.sh
```

---

# 🔹 Example Output

```text id="jlym319"
Enter your name: Saichandu
Enter your favourite tool: Kubernetes

Hello Saichandu, your favourite tool is Kubernetes
```

---

# 🔀 Task 4 – If-Else Conditions

# 📌 Why Conditions Matter

Conditions help scripts make decisions.

Used in:

* Health checks
* Monitoring
* Automation workflows
* CI/CD pipelines

---

# 🔹 Create check_number.sh

## Command

```bash id="jlym320"
vim check_number.sh
```

---

# 🔹 Script Content

```bash id="jlym321"
#!/bin/bash

read -p "Enter a number: " NUM

if [ $NUM -gt 0 ]; then
    echo "Positive Number"

elif [ $NUM -lt 0 ]; then
    echo "Negative Number"

else
    echo "Zero"
fi
```

---

# 🔹 Execute Script

```bash id="jlym322"
chmod +x check_number.sh
./check_number.sh
```

---

# 🔹 Example Output

```text id="jlym323"
Enter a number: 10
Positive Number
```

---

# 📂 File Existence Check

# 🔹 Create file_check.sh

## Command

```bash id="jlym324"
vim file_check.sh
```

---

# 🔹 Script Content

```bash id="jlym325"
#!/bin/bash

read -p "Enter filename: " FILE

if [ -f "$FILE" ]; then
    echo "File exists"

else
    echo "File does not exist"
fi
```

---

# 🔹 Run Script

```bash id="jlym326"
chmod +x file_check.sh
./file_check.sh
```

---

# 🔹 Example Output

```text id="jlym327"
Enter filename: hello.sh
File exists
```

---

# 🖥️ Task 5 – Combine Everything

# 📌 Real DevOps Automation Example

This script checks service status automatically.

---

# 🔹 Create server_check.sh

## Command

```bash id="jlym328"
vim server_check.sh
```

---

# 🔹 Script Content

```bash id="jlym329"
#!/bin/bash

SERVICE="nginx"

read -p "Do you want to check the status? (y/n): " OPTION

if [ "$OPTION" == "y" ]; then

    systemctl status $SERVICE

    if systemctl is-active --quiet $SERVICE; then
        echo "$SERVICE is active"

    else
        echo "$SERVICE is not active"
    fi

else
    echo "Skipped."
fi
```

---

# 🔹 Execute Script

```bash id="jlym330"
chmod +x server_check.sh
./server_check.sh
```

---

# 🔹 Example Output

```text id="jlym331"
Do you want to check the status? (y/n): y

nginx is active
```

---

# 🔍 Understanding Important Shell Concepts

# 📌 Variables

```bash id="jlym332"
NAME="Saichandu"
```

No spaces around `=`.

---

# 📌 Conditions

```bash id="jlym333"
if [ condition ]; then
```

Used for decision-making.

---

# 📌 File Check

```bash id="jlym334"
if [ -f filename ]
```

Checks whether file exists.

---

# 📌 Executable Permission

```bash id="jlym335"
chmod +x script.sh
```

Makes script executable.

---

# 🚨 Real-World DevOps Use Cases

Shell scripting is heavily used in:

* Kubernetes automation
* Jenkins pipelines
* Backup scripts
* Monitoring scripts
* Server health checks
* Log rotation
* Docker automation
* Deployment pipelines

Examples:

* Restart failed services automatically
* Monitor CPU and memory
* Automate deployments
* Rotate logs periodically

---

# 🎯 What I Learned

✅ Understanding shebang and interpreters
✅ Variables and string handling
✅ User input using `read`
✅ If-Else conditional logic
✅ File existence checks
✅ Basic service automation scripting

---

# ✅ Scripts Practiced Today

```bash id="jlym336"
hello.sh
variables.sh
greet.sh
check_number.sh
file_check.sh
server_check.sh
```

---

# 🏁 Conclusion

Shell scripting is one of the most powerful foundational skills for every DevOps and SRE Engineer.

Understanding:

* Variables
* User input
* Conditions
* File checks
* Service automation
