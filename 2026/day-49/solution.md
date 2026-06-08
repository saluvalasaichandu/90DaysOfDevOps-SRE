# Jenkins Cheat Sheet - Solution.md

# Jenkins Architecture

```text
Developer
    |
GitHub
    |
Jenkins Controller
    |
-------------------------
|           |           |
Linux     Ubuntu     Docker
Agent      Agent      Agent
    |
Build → Test → Scan → Deploy
```

---

# Important Jenkins Commands

## Jenkins Service

```bash
sudo systemctl start jenkins
sudo systemctl stop jenkins
sudo systemctl restart jenkins
sudo systemctl status jenkins
```

---

# Jenkins Logs

```bash
sudo journalctl -u jenkins -f
```

---

# Docker Commands

```bash
docker build -t app:v1 .
docker run -d -p 5000:5000 app:v1
docker images
docker ps
docker logs container-id
```

---

# Git Commands

```bash
git clone <repo>
git add .
git commit -m "commit"
git push origin main
```

---

# Pipeline Structure

```groovy
pipeline {
 agent any

 stages {

  stage('Build'){
   steps{
    echo 'Build'
   }
  }

  stage('Test'){
   steps{
    echo 'Test'
   }
  }

  stage('Deploy'){
   steps{
    echo 'Deploy'
   }
  }
 }
}
```

---

# Agent Labels

Linux:

```groovy
agent {
 label 'linux'
}
```

Ubuntu:

```groovy
agent {
 label 'ubuntu'
}
```

---

# Parallel Execution

```groovy
parallel {

 stage('Build'){
 }

 stage('Test'){
 }
}
```

---

# Shared Library

```groovy
@Library('shared-lib') _
```

Function:

```groovy
buildApp()
```

---

# Trivy Scan

```groovy
sh 'trivy image sample-app:v1.0'
```

Fail Build:

```groovy
sh 'trivy image --exit-code 1 sample-app:v1.0'
```

---

# Docker Hub Push

```bash
docker login

docker tag sample-app:v1.0 saichandu27/sample-app:v1.0

docker push saichandu27/sample-app:v1.0
```

---

# Email Notification

```groovy
post {

 success {

  emailext(
   to: 'sai@gmail.com',
   subject: 'Build Success',
   body: 'Pipeline Passed'
  )
 }

 failure {

  emailext(
   to: 'sai@gmail.com',
   subject: 'Build Failed',
   body: 'Pipeline Failed'
  )
 }
}
```

---

# Top Jenkins Interview Questions

## What is Jenkins?

Open-source CI/CD automation server used to automate Build, Test and Deployment.

---

## Difference Between Freestyle and Pipeline?

Freestyle:

* GUI Based

Pipeline:

* Code Based
* Version Controlled
* Reusable

---

## What is Jenkinsfile?

Pipeline-as-Code file stored inside Git repository.

---

## What is Jenkins Agent?

Remote machine that executes Jenkins jobs.

---

## What is Shared Library?

Reusable Groovy code shared across multiple pipelines.

---

## What is Multi-Branch Pipeline?

Automatically creates pipelines for every branch.

---

## What is RBAC?

Role Based Access Control used to restrict user permissions.

---

## What is Trivy?

Container vulnerability scanner.

---

# Scenario-Based Questions

## Scenario 1

Pipeline suddenly failed after deployment.

How do you troubleshoot?

### Answer

1. Check Console Output
2. Verify Build Logs
3. Check Docker Logs
4. Verify Agent Connectivity
5. Check Jenkins Logs
6. Re-run Build

---

## Scenario 2

Docker build works locally but fails in Jenkins.

### Answer

* Verify Docker Installation
* Check Jenkins User Permissions
* Add Jenkins User to Docker Group

```bash
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins
```

---

## Scenario 3

GitHub Push not triggering Jenkins.

### Answer

* Verify Webhook
* Verify GitHub Token
* Check Jenkins Logs
* Check Firewall Rules

---

## Scenario 4

Agent is Offline.

### Answer

* Check SSH Connectivity
* Verify Java Installation
* Verify Credentials
* Reconnect Agent

---

## Scenario 5

Trivy reports Critical Vulnerabilities.

### Answer

* Upgrade Base Image
* Remove Vulnerable Packages
* Rebuild Image
* Re-run Scan

---

# Production Best Practices

* Store Secrets in Jenkins Credentials
* Use Shared Libraries
* Enable RBAC
* Use Agents for Scalability
* Integrate SonarQube
* Integrate Trivy
* Enable Monitoring
* Backup Jenkins Home
* Use Pipeline as Code
* Use GitOps Principles

---

# Conclusion

This Jenkins Cheat Sheet covers:

* Jenkins Fundamentals
* Pipelines
* Multi-Branch Pipelines
* Agents
* RBAC
* Shared Libraries
* Docker
* Trivy
* Email Notifications
* Monitoring
* Troubleshooting
* Interview Preparation
* Production Best Practices
