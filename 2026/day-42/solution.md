# Task 3: Configure and Scale Jenkins Agents/Nodes

## Objective

Configure multiple Jenkins agents (Linux and Windows) to distribute build workloads, execute jobs in parallel, and improve CI/CD pipeline scalability.

---

# Architecture

```text
                    Jenkins Controller
                           |
        -----------------------------------------
        |                                       |
   Linux Agent                           Windows Agent
(Label: linux)                       (Label: windows)
        |                                       |
 Build/Test Jobs                     Build/Test Jobs
```

---

# Prerequisites

* Jenkins Controller Installed
* Java Installed on Agents
* Jenkins Agent Port Enabled (50000)
* SSH Access for Linux Agent
* Windows Agent Service or Java Agent
* Git Installed
* Docker Installed (Optional)

---

# Step 1: Configure Linux Agent

## Create Linux VM

Example:

```bash
Ubuntu 22.04 EC2 Instance
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
```

---

## Add Linux Node in Jenkins

Navigate:

```text
Manage Jenkins
        ↓
Nodes
        ↓
New Node
```

Enter:

```text
Node Name : linux-agent

Type      : Permanent Agent
```

---

## Configure Node

```text
Remote Root Directory:
/home/jenkins

Labels:
linux

Usage:
Use this node as much as possible
```

Launch Method:

```text
Launch agents via SSH
```

Provide:

```text
Host IP
SSH Credentials
```

Save and Launch Agent.

---

## Verify Linux Agent

```text
Manage Jenkins
        ↓
Nodes
        ↓
linux-agent
```

Expected:

```text
Status : Connected
```

---

# Step 2: Configure Windows Agent

## Create Windows VM

Example:

```text
Windows Server 2022
```

Install:

```text
Java 17
Git
```

Verify:

```powershell
java -version

git --version
```

---

## Create Windows Node

```text
Manage Jenkins
        ↓
Nodes
        ↓
New Node
```

Name:

```text
windows-agent
```

Type:

```text
Permanent Agent
```

---

## Configure

```text
Remote Root Directory

C:\Jenkins
```

Label:

```text
windows
```

Launch Method:

```text
Launch agent by connecting it to controller
```

---

## Connect Agent

Download:

```text
agent.jar
```

Run:

```powershell
java -jar agent.jar `
-url http://JENKINS-IP:8080 `
-secret SECRET_KEY `
-name windows-agent `
-workDir "C:\Jenkins"
```

---

## Verify Windows Agent

Expected:

```text
windows-agent

Status : Connected
```

---

# Step 3: Verify Agent Labels

Navigate:

```text
Manage Jenkins
        ↓
Nodes
```

Verify:

```text
linux-agent

Labels:
linux
```

```text
windows-agent

Labels:
windows
```

---

# Step 4: Jenkinsfile Using Agent Labels

## Linux Build

```groovy
pipeline {

    agent none

    stages {

        stage('Linux Build') {

            agent {
                label 'linux'
            }

            steps {

                sh 'hostname'

                sh 'uname -a'
            }
        }

        stage('Windows Build') {

            agent {
                label 'windows'
            }

            steps {

                bat 'hostname'

                bat 'ver'
            }
        }
    }
}
```

---

# Step 5: Run Jobs in Parallel

## Parallel Execution Pipeline

```groovy
pipeline {

    agent none

    stages {

        stage('Parallel Build') {

            parallel {

                stage('Linux Job') {

                    agent {
                        label 'linux'
                    }

                    steps {

                        sh 'echo Running on Linux Agent'

                        sh 'sleep 10'
                    }
                }

                stage('Windows Job') {

                    agent {
                        label 'windows'
                    }

                    steps {

                        bat 'echo Running on Windows Agent'

                        bat 'timeout /t 10'
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
Parallel Build

├── Linux Job
│     Running on Linux Agent
│
└── Windows Job
      Running on Windows Agent
```

Both jobs execute simultaneously.

---

# Verification

## Verify Agent Allocation

Build Console Output:

Linux Stage:

```bash
Running on linux-agent
```

Windows Stage:

```text
Running on windows-agent
```

---

## Verify Node Usage

Navigate:

```text
Dashboard
      ↓
Build Executor Status
```

Expected:

```text
linux-agent     Busy

windows-agent   Busy
```

during execution.

---

# Benefits of Distributed Builds

## Faster Builds

Multiple jobs run simultaneously.

Example:

```text
Without Agents

Build 1 = 10 min
Build 2 = 10 min

Total = 20 min
```

```text
With Agents

Build 1 = 10 min
Build 2 = 10 min

Total = 10 min
```

---

## Better Resource Utilization

Workload distributed across multiple machines.

---

## Platform-Specific Testing

```text
Linux Application
```

runs on:

```text
Linux Agent
```

```text
Windows Application
```

runs on:

```text
Windows Agent
```

---

## Improved Reliability

If one agent fails, workloads can be shifted to another agent.

---

# Challenges of Distributed Agents

## Agent Connectivity Issues

Network failures can disconnect agents.

---

## Tool Version Differences

Example:

```text
Java 11 on Linux

Java 17 on Windows
```

may produce inconsistent builds.

---

## Resource Management

Agents require CPU, Memory, and Storage monitoring.

---

## Security Risks

Credentials must be securely managed across nodes.

---

# Interview Questions

## 1. What are the benefits and challenges of using distributed agents in Jenkins?

### Answer

Benefits:

* Faster pipeline execution
* Parallel builds
* Better scalability
* Platform-specific testing
* Improved reliability

Challenges:

* Agent maintenance
* Network issues
* Tool version mismatches
* Security management
* Resource monitoring

---

## 2. How can you ensure that jobs are assigned to the correct agent in a multi-platform environment?

### Answer

By assigning labels to agents and using those labels inside Jenkins pipelines.

Example:

```groovy
agent {
    label 'linux'
}
```

```groovy
agent {
    label 'windows'
}
```

Jenkins automatically schedules jobs on the matching node based on the label.

---

