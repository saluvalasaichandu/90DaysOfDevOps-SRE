# 🚀 Day 17 – Shell Scripting: Loops, Arguments & Error Handling

# 📌 Introduction

Shell scripting is one of the most powerful skills for every DevOps and SRE Engineer.

As infrastructure grows, engineers cannot manually perform repetitive tasks repeatedly.

Shell scripting helps automate:

* Server administration
* Package installation
* Monitoring
* Backup operations
* Deployment workflows
* CI/CD automation
* Kubernetes operations

In today’s hands-on challenge, I focused on:
✅ For loops
✅ While loops
✅ Command-line arguments
✅ Package installation automation
✅ Error handling in scripts
✅ Root user validation

---

# 🐚 Why Shell Scripting Matters in DevOps

Shell scripting is heavily used in:

* CI/CD pipelines
* Infrastructure automation
* Kubernetes administration
* Jenkins automation
* Monitoring systems
* Cloud provisioning
* Server management

Without scripting:

* Operations become repetitive
* Human errors increase
* Automation becomes difficult

---

# 🔁 Task 1 – For Loop

# 📌 What is a For Loop?

A `for` loop repeats commands for multiple items.

Used heavily in:

* Iterating servers
* Processing files
* Installing packages
* Kubernetes automation

---

# 🔹 Create `for_loop.sh`

## Command

```bash id="jlym373"
vim for_loop.sh
```

---

# 🔹 Script Content

```bash id="jlym374"
#!/bin/bash

for fruit in Apple Mango Banana Orange Grapes
do
    echo "Fruit: $fruit"
done
```

---

# 🔹 Make Script Executable

```bash id="jlym375"
chmod +x for_loop.sh
```

---

# 🔹 Execute Script

```bash id="jlym376"
./for_loop.sh
```
<img width="713" height="505" alt="image" src="https://github.com/user-attachments/assets/aad22ba5-17a3-45a2-90d8-cb81c45d319c" />

---

# 🔹 Output

```text id="jlym377"
Fruit: Apple
Fruit: Mango
Fruit: Banana
Fruit: Orange
Fruit: Grapes
```

---

# 🔢 Create `count.sh`

## Script Content

```bash id="jlym378"
#!/bin/bash

for i in {1..10}
do
    echo $i
done
```

---

# 🔹 Execute Script

```bash id="jlym379"
chmod +x count.sh
./count.sh
```
<img width="683" height="599" alt="image" src="https://github.com/user-attachments/assets/d66e2397-6db5-4407-9a97-e61ead1249b5" />

---

# 🔹 Output

```text id="jlym380"
1
2
3
4
5
6
7
8
9
10
```

---

# 🔄 Task 2 – While Loop

# 📌 What is a While Loop?

A `while` loop runs continuously while a condition is true.

Used heavily in:

* Monitoring scripts
* Infinite loops
* Health checks
* Automation polling

---

# 🔹 Create `countdown.sh`

## Command

```bash id="jlym381"
vim countdown.sh
```

---

# 🔹 Script Content

```bash id="jlym382"
#!/bin/bash

read -p "Enter a number: " NUM

while [ $NUM -ge 0 ]
do
    echo $NUM
    NUM=$((NUM-1))
done

echo "Done!"
```

---

# 🔹 Execute Script

```bash id="jlym383"
chmod +x countdown.sh
./countdown.sh
```
<img width="626" height="555" alt="image" src="https://github.com/user-attachments/assets/aaf613ff-f1cf-4673-98e2-e28c3849136d" />

---

# 🔹 Example Output

```text id="jlym384"
Enter a number: 5

5
4
3
2
1
0

Done!
```

---

# 📥 Task 3 – Command-Line Arguments

# 📌 What are Arguments?

Arguments allow users to pass values while running scripts.

Examples:

* Server names
* Environment names
* File paths
* Deployment versions

---

# 🔹 Understanding Special Variables

| Variable | Meaning         |
| -------- | --------------- |
| `$0`     | Script name     |
| `$1`     | First argument  |
| `$2`     | Second argument |
| `$#`     | Total arguments |
| `$@`     | All arguments   |

---

# 🔹 Create `greet.sh`

## Command

```bash id="jlym385"
vim greet.sh
```

---

# 🔹 Script Content

```bash id="jlym386"
#!/bin/bash

if [ -z "$1" ]
then
    echo "Usage: ./greet.sh <name>"

else
    echo "Hello, $1!"
fi
```

---

# 🔹 Execute Script

```bash id="jlym387"
chmod +x greet.sh
./greet.sh Saichandu
```

---

# 🔹 Output

```text id="jlym388"
Hello, Saichandu!
```
<img width="825" height="272" alt="image" src="https://github.com/user-attachments/assets/8b51e177-1fa9-4009-a00d-dcba1629c171" />

---

# 🔹 Run Without Argument

```bash id="jlym389"
./greet.sh
```

---

# 🔹 Output

```text id="jlym390"
Usage: ./greet.sh <name>
```

---

# 🔹 Create `args_demo.sh`

## Script Content

```bash id="jlym391"
#!/bin/bash

echo "Script Name: $0"
echo "Total Arguments: $#"
echo "All Arguments: $@"
```

---

# 🔹 Execute Script

```bash id="jlym392"
chmod +x args_demo.sh
./args_demo.sh DevOps AWS Kubernetes
```
<img width="932" height="430" alt="image" src="https://github.com/user-attachments/assets/203e1c1f-8504-4fb2-8141-46a96718db62" />

---

# 🔹 Output

```text id="jlym393"
Script Name: ./args_demo.sh
Total Arguments: 3
All Arguments: DevOps AWS Kubernetes
```

---

# 📦 Task 4 – Install Packages via Script

# 📌 Why Package Automation Matters

In DevOps environments, package installation is automated using scripts.

Examples:

* Installing Docker
* Installing monitoring agents
* Configuring Kubernetes nodes

---

# 🔹 Create `install_packages.sh`

## Command

```bash id="jlym394"
vim install_packages.sh
```

---

# 🔹 Script Content

```bash id="jlym395"
#!/bin/bash

if [ "$EUID" -ne 0 ]
then
    echo "Please run as root"
    exit 1
fi

PACKAGES="nginx curl wget"

for pkg in $PACKAGES
do

    if rpm -q $pkg &> /dev/null
    then
        echo "$pkg is already installed"

    else
        echo "Installing $pkg..."

        yum install -y $pkg

        echo "$pkg installed successfully"
    fi

done
```

---

# 🔹 Execute Script

```bash id="jlym396"
chmod +x install_packages.sh
sudo ./install_packages.sh
```
<img width="774" height="731" alt="image" src="https://github.com/user-attachments/assets/8274bc20-dce0-404f-a1cb-30621ea3ccce" />

---

# 🔹 Example Output

```text id="jlym397"
nginx is already installed
curl is already installed
Installing wget...
wget installed successfully
```
<img width="1362" height="723" alt="image" src="https://github.com/user-attachments/assets/49eb886d-d5c6-4ffe-92c4-d14c8d9b26f3" />

---

# 🚨 Task 5 – Error Handling

# 📌 Why Error Handling Matters

Error handling prevents scripts from continuing after failures.

Used heavily in:

* Production automation
* CI/CD pipelines
* Deployment scripts
* Infrastructure provisioning

---

# 🔹 What is `set -e`?

```bash id="jlym398"
set -e
```

Stops script execution immediately if any command fails.

---

# 🔹 Create `safe_script.sh`

## Command

```bash id="jlym399"
vim safe_script.sh
```

---

# 🔹 Script Content

```bash id="jlym400"
#!/bin/bash

set -e

mkdir /tmp/devops-test || echo "Directory already exists"

cd /tmp/devops-test || echo "Failed to enter directory"

touch demo.txt || echo "Failed to create file"

echo "Script executed successfully"
```

---

# 🔹 Execute Script

```bash id="jlym401"
chmod +x safe_script.sh
./safe_script.sh
```
<img width="1366" height="595" alt="image" src="https://github.com/user-attachments/assets/f2acfb0f-0527-4af6-a42b-37e2e92b1c89" />

---

# 🔹 Example Output

```text id="jlym402"
Script executed successfully
```

---

# 🔍 Understanding Important Shell Concepts

# 📌 For Loop Syntax

```bash id="jlym403"
for item in list
do
    commands
done
```

---

# 📌 While Loop Syntax

```bash id="jlym404"
while [ condition ]
do
    commands
done
```

---

# 📌 Root User Check

```bash id="jlym405"
if [ "$EUID" -ne 0 ]
```

Ensures script runs with administrative privileges.

---

# 📌 Error Handling using `||`

```bash id="jlym406"
mkdir test || echo "Error"
```

Runs right-side command if left-side fails.

---

# 🚨 Real-World DevOps Use Cases

Shell scripting is heavily used in:

* Jenkins pipelines
* Kubernetes automation
* AWS EC2 bootstrap scripts
* Monitoring scripts
* Backup automation
* Docker management
* Linux administration

Examples:

* Automatically install required packages
* Monitor disk usage
* Restart failed services
* Automate deployments

---

# 🎯 What I Learned

✅ Using for loops and while loops
✅ Working with command-line arguments
✅ Automating package installation
✅ Handling script errors safely
✅ Root privilege validation
✅ Writing reusable automation scripts

---

# ✅ Scripts Practiced Today

```bash id="jlym407"
for_loop.sh
count.sh
countdown.sh
greet.sh
args_demo.sh
install_packages.sh
safe_script.sh
```

---

# 🏁 Conclusion

Shell scripting is a foundational DevOps skill that enables automation, consistency, and operational efficiency.

Understanding:

* Loops
* Arguments
* Error handling
* Automation scripting
