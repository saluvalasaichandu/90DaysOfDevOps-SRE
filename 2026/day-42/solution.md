# Task 3: Configure and Scale Jenkins Agents/Nodes

## Objective

Configure Jenkins Controller and Jenkins Agent on separate EC2 instances and execute builds on remote agents using labels.

---

# Architecture

```text
AWS Cloud

┌─────────────────────────────┐
│ Jenkins Controller          │
│ Amazon Linux EC2            │
│ User: ec2-user              │
└──────────────┬──────────────┘
               │ SSH
               │
┌──────────────▼──────────────┐
│ Jenkins Agent              │
│ Ubuntu EC2                 │
│ User: ubuntu               │
└────────────────────────────┘
```

---

# Prerequisites

## Jenkins Controller

```bash
Amazon Linux EC2

Jenkins Installed

Java Installed

Git Installed
```

Verify:

```bash
java -version

git --version

systemctl status jenkins
```

---

## Jenkins Agent

Launch Ubuntu EC2.

Connect:

```bash
ssh -i key.pem ubuntu@AGENT-IP
```

Install Java:

```bash
sudo apt update

sudo apt install openjdk-17-jdk -y

java -version
```

Install Git:

```bash
sudo apt install git -y

git --version
```

---

# Step 1: Create SSH Key for Jenkins

On Jenkins Controller:

```bash
sudo su -

ssh-keygen
```

Press Enter for all prompts.

Generated files:

```text
/root/.ssh/id_rsa

/root/.ssh/id_rsa.pub
```

---

# Step 2: Copy Public Key to Agent

Display key:

```bash
cat ~/.ssh/id_rsa.pub
```

Copy output.

---

On Ubuntu Agent:

```bash
mkdir -p ~/.ssh

vi ~/.ssh/authorized_keys
```

Paste public key.

Set permissions:

```bash
chmod 700 ~/.ssh

chmod 600 ~/.ssh/authorized_keys
```

---

# Step 3: Test SSH Connectivity

From Jenkins Controller:

```bash
ssh ubuntu@AGENT-IP
```

Expected:

```text
Welcome to Ubuntu
```

No password should be requested.

---

# Step 4: Add Agent in Jenkins

Navigate:

```text
Dashboard
     ↓
Manage Jenkins
     ↓
Nodes
     ↓
New Node
```

---

Node Name:

```text
ubuntu-agent
```

Type:

```text
Permanent Agent
```

Click Create.

---

# Step 5: Configure Agent

Node Configuration:

```text
Name:
ubuntu-agent

Remote Root Directory:
/home/ubuntu/jenkins

Labels:
linux ubuntu

Usage:
Use this node as much as possible
```

---

Launch Method:

```text
Launch agents via SSH
```

Host:

```text
AGENT-IP
```

Credentials:

```text
SSH Username with private key

Username:
ubuntu

Private Key:
Paste Jenkins Controller private key
```

Save.

---

# Step 6: Verify Agent Connection

Navigate:

```text
Manage Jenkins
      ↓
Nodes
```

Expected:

```text
ubuntu-agent

Status : Connected
```

---

# Step 7: Verify Label

Node should contain:

```text
linux

ubuntu
```

---

# Step 8: Create Jenkins Pipeline

Create:

```text
New Item
    ↓
Pipeline
    ↓
agent-demo
```

---

Pipeline Script

```groovy
pipeline {

    agent {
        label 'linux'
    }

    stages {

        stage('Node Details') {

            steps {

                sh 'hostname'

                sh 'whoami'

                sh 'uname -a'
            }
        }

        stage('Java Version') {

            steps {

                sh 'java -version'
            }
        }

        stage('Git Version') {

            steps {

                sh 'git --version'
            }
        }
    }
}
```

Save.

---

# Step 9: Run Pipeline

Click:

```text
Build Now
```

Expected Output:

```text
Running on ubuntu-agent

hostname

ip-172-31-xx-xx

whoami

ubuntu

java -version

openjdk 17

git --version

git version 2.x
```

---

# Step 10: Parallel Jobs Example

```groovy
pipeline {

    agent none

    stages {

        stage('Parallel Execution') {

            parallel {

                stage('Controller Job') {

                    agent any

                    steps {

                        sh 'echo Running on Controller'

                        sh 'hostname'
                    }
                }

                stage('Agent Job') {

                    agent {

                        label 'linux'
                    }

                    steps {

                        sh 'echo Running on Ubuntu Agent'

                        sh 'hostname'
                    }
                }
            }
        }
    }
}
```

---

# Expected Output

```text
Parallel Execution

├── Controller Job
│   Running on Controller
│
└── Agent Job
    Running on Ubuntu Agent
```

Both stages run simultaneously.

---

# Verification

## Verify Agent Status

```text
Manage Jenkins
     ↓
Nodes

ubuntu-agent

Connected
```

---

## Verify Build Logs

```text
Running on ubuntu-agent

java -version

git --version

hostname
```

---

## Verify Executor Usage

Navigate:

```text
Dashboard
     ↓
Build Executor Status
```

Expected:

```text
Jenkins Controller : Busy

ubuntu-agent : Busy
```

---

# Benefits of Distributed Builds

## Faster Builds

Jobs run on multiple machines simultaneously.

---

## Better Resource Utilization

Build workload is distributed.

---

## Scalability

Additional agents can be added easily.

---

## Isolation

Build failures on one node do not affect others.

---

# Challenges

## Agent Connectivity

SSH failures can disconnect agents.

---

## Tool Versions

Different Java or Git versions may cause issues.

---

## Resource Monitoring

CPU and memory usage should be monitored.

---

# Interview Question 1

## What are the benefits and challenges of using distributed agents in Jenkins?

### Answer

Benefits:

* Faster execution
* Parallel builds
* Better scalability
* Workload distribution

Challenges:

* SSH connectivity issues
* Version mismatches
* Agent maintenance
* Resource monitoring

---

# Interview Question 2

## How can you ensure jobs are assigned to the correct agent?

### Answer

Use labels.

Example:

```groovy
agent {
    label 'linux'
}
```

Jenkins automatically runs the job on nodes having the matching label.

---

# Conclusion

Successfully configured:

```text
Amazon Linux EC2
        ↓
Jenkins Controller
        ↓
SSH Connection
        ↓
Ubuntu EC2 Agent
        ↓
Pipeline Execution
```

Verified agent connectivity, label-based scheduling, and distributed build execution.
