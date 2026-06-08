# Task 9: Troubleshooting, Monitoring & Advanced Debugging in Jenkins

## Objective

Learn how to troubleshoot Jenkins pipeline failures, monitor Jenkins health, and use advanced debugging techniques to maintain reliable CI/CD pipelines.

---

# Architecture

```text
Developer
    |
GitHub Commit
    |
Jenkins Pipeline
    |
Build → Test → Deploy
    |
Monitoring & Debugging
```

---

# Step 1: Simulate a Pipeline Failure

Create a pipeline with an intentional error.

```groovy
pipeline {
    agent any

    stages {

        stage('Build') {
            steps {
                echo 'Building Application'
            }
        }

        stage('Test') {
            steps {
                sh 'invalid-command'
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying Application'
            }
        }
    }
}
```

### Build Result

```text
Build Stage  -> SUCCESS
Test Stage   -> FAILED
Deploy Stage -> SKIPPED
```

---

# Step 2: Troubleshooting Process

## Check Console Output

```text
Jenkins Dashboard
    ↓
Job
    ↓
Build Number
    ↓
Console Output
```

Error:

```bash
invalid-command: command not found
```

Root Cause:

```text
Incorrect shell command used in Test stage.
```

Fix:

```groovy
sh 'echo Running Tests'
```

---

# Step 3: Check Jenkins Logs

## Jenkins Service Logs

Amazon Linux:

```bash
sudo journalctl -u jenkins -f
```

Ubuntu:

```bash
sudo tail -f /var/log/jenkins/jenkins.log
```

---

# Step 4: Troubleshoot Docker-Based Builds

Check Running Containers

```bash
docker ps
```

Check Container Logs

```bash
docker logs <container-id>
```

Example:

```bash
docker logs flask-app
```

---

# Step 5: Add Debugging Statements

Print Environment Variables

```groovy
stage('Debug') {
    steps {
        sh 'env'
    }
}
```

Print Current Directory

```groovy
sh 'pwd'
```

List Files

```groovy
sh 'ls -lrt'
```

Print Build Information

```groovy
echo "Build Number: ${BUILD_NUMBER}"
echo "Workspace: ${WORKSPACE}"
```

---

# Step 6: Use Replay Feature

Navigate:

```text
Job
 ↓
Build
 ↓
Replay
```

Benefits:

* Modify Jenkinsfile temporarily
* Test changes quickly
* No Git commit required

Example:

```groovy
echo "Testing Replay Feature"
```

---

# Step 7: Monitoring Jenkins

## Build History

```text
Dashboard → Build History
```

Track:

* Failed Builds
* Successful Builds
* Build Duration

---

## Executor Status

```text
Dashboard → Build Executor Status
```

Monitor:

* Busy Agents
* Idle Agents
* Queue Length

---

## System Information

```text
Manage Jenkins
    ↓
System Information
```

Check:

* Java Version
* Jenkins Version
* Environment Variables

---

# Jenkins Monitoring Plugins

## Monitoring Plugin

Shows:

* CPU Usage
* Memory Usage
* Thread Usage

Install:

```text
Manage Jenkins
    ↓
Plugins
    ↓
Available Plugins
    ↓
Monitoring
```

---

## Prometheus Plugin

Expose Metrics:

```text
http://JENKINS-IP:8080/prometheus
```

Integrate With:

* Prometheus
* Grafana

---

# Advanced Debugging Example

```groovy
pipeline {

    agent any

    stages {

        stage('Debug') {

            steps {

                echo "Build Number: ${BUILD_NUMBER}"

                sh 'pwd'

                sh 'ls -lrt'

                sh 'env'
            }
        }

        stage('Build') {

            steps {

                echo 'Application Build Successful'
            }
        }
    }
}
```

---

# Verification

## Failed Build

```text
Console Output shows exact error.
```

## Docker Logs

```bash
docker logs flask-app
```

## Jenkins Logs

```bash
journalctl -u jenkins -f
```

## Replay Feature

```text
Pipeline executes modified code successfully.
```

---

# Benefits

* Faster Root Cause Analysis
* Reduced Downtime
* Better Pipeline Reliability
* Easier Production Support
* Faster Incident Resolution

---

# Interview Questions

## 1. How would you approach troubleshooting a failing Jenkins pipeline?

### Answer

1. Check Console Output.
2. Identify failed stage.
3. Review Jenkins logs.
4. Verify agent connectivity.
5. Check Docker/container logs.
6. Add debugging statements.
7. Re-run build and validate fix.

---

## 2. What are effective strategies for monitoring Jenkins?

### Answer

* Monitor Jenkins logs.
* Use Monitoring Plugin.
* Integrate Prometheus & Grafana.
* Monitor build success rate.
* Track CPU, Memory, Disk Usage.
* Monitor Jenkins agents and queue length.

---

