Here is the complete **Day 39 – What is CI/CD?** in your GitHub README format, focused specifically on **Jenkins CI/CD concepts** so it aligns with your upcoming Jenkins learning journey.

# 🚀 Day 39 – What is CI/CD?

## 📌 Introduction

Before building Jenkins Pipelines, GitHub Actions workflows, or GitLab CI/CD jobs, it's important to understand **why CI/CD exists** and what problems it solves.

CI/CD is the foundation of modern DevOps practices. It helps teams automate software delivery, reduce manual effort, catch bugs early, and deploy applications faster and more reliably.

Today I learned:

* What is CI/CD?
* Why CI/CD is important?
* Continuous Integration (CI)
* Continuous Delivery (CD)
* Continuous Deployment (CD)
* Pipeline Components
* Jenkins CI/CD Workflow

---

# 🎯 Objectives

By the end of this lab, you will understand:

✅ Problems with Manual Deployment

✅ Continuous Integration

✅ Continuous Delivery

✅ Continuous Deployment

✅ Jenkins Pipeline Components

✅ CI/CD Workflow

---

# 🛠️ Task 1 – The Problem

## Scenario

Imagine a team of 5 developers working on the same application.

```text
Developer 1
Developer 2
Developer 3
Developer 4
Developer 5

        ↓

     Git Repository

        ↓

 Manual Build & Deployment

        ↓

 Production Server
```

---

## What Can Go Wrong?

### 1. Code Conflicts

Multiple developers modify the same files.

```text
Developer A changes login page

Developer B changes login page

Both push code
```

Result:

```text
Merge Conflicts
Application Errors
```

---

### 2. Human Errors

Manual deployment may cause:

* Wrong configuration
* Missing files
* Incorrect commands
* Wrong server deployment

---

### 3. No Automated Testing

Applications may reach production without testing.

Result:

```text
Production Bugs
Customer Impact
```

---

### 4. Slow Releases

Every deployment requires manual effort.

Result:

```text
Long Release Cycles
```

---

## What Does "It Works On My Machine" Mean?

The application works perfectly on the developer's laptop but fails on:

* QA Environment
* Staging Server
* Production Server

Reasons:

* Different OS versions
* Missing dependencies
* Different package versions
* Configuration mismatch

---

## Why Is It A Real Problem?

Because applications should behave consistently across all environments.

Without consistency:

```text
Development ✅

Testing ❌

Production ❌
```

---

## How Many Times Can A Team Safely Deploy Manually?

Usually:

```text
1-2 Deployments Per Day
```

More deployments increase:

* Human errors
* Downtime risks
* Failed releases

This led to the adoption of CI/CD.

---

# 🛠️ Task 2 – CI vs CD

---

# Continuous Integration (CI)

## Definition

Continuous Integration is the practice of automatically building and testing code whenever developers push changes.

Every commit triggers:

```text
Code Push
     ↓
Build
     ↓
Test
     ↓
Feedback
```

---

## Benefits

* Detect bugs early
* Faster integration
* Better code quality

---

## Example

Developer pushes code to GitHub.

Jenkins automatically:

* Pulls code
* Builds application
* Runs tests

If tests fail:

```text
Build Failed ❌
```

Deployment stops.

---

# Continuous Delivery (CD)

## Definition

Continuous Delivery automatically prepares applications for deployment.

Applications are always production-ready but require manual approval.

---

## Workflow

```text
Build
 ↓
Test
 ↓
Deploy To Staging
 ↓
Manual Approval
 ↓
Production
```

---

## Example

Banking Applications

Reason:

Production deployment requires approval from release managers.

---

# Continuous Deployment

## Definition

Continuous Deployment automatically deploys every successful change to production.

No manual approval required.

---

## Workflow

```text
Code Push
 ↓
Build
 ↓
Test
 ↓
Deploy Production
```

---

## Example

Netflix

Spotify

Facebook

These companies deploy automatically after successful testing.

---

# CI vs Delivery vs Deployment

| Feature           | CI | Continuous Delivery | Continuous Deployment |
| ----------------- | -- | ------------------- | --------------------- |
| Build             | ✅  | ✅                   | ✅                     |
| Test              | ✅  | ✅                   | ✅                     |
| Staging Deploy    | ❌  | ✅                   | ✅                     |
| Production Deploy | ❌  | Manual              | Automatic             |

---

# 🛠️ Task 3 – Pipeline Anatomy

A Jenkins Pipeline consists of several components.

---

# Trigger

Starts the pipeline.

Examples:

```text
Git Push

Pull Request

Webhook

Manual Trigger

Schedule
```

---

# Stage

Logical section of the pipeline.

Examples:

```text
Build

Test

Deploy
```

---

# Job

A collection of steps.

Example:

```text
Build Job

Unit Test Job

Security Scan Job
```

---

# Step

Actual command execution.

Example:

```bash
mvn clean package

docker build

kubectl apply
```

---

# Runner / Agent

Machine executing pipeline tasks.

Examples:

* Jenkins Agent
* GitHub Runner
* GitLab Runner

---

# Artifact

Output generated by the pipeline.

Examples:

```text
JAR File

WAR File

Docker Image

Reports
```

---

# Pipeline Hierarchy

```text
Trigger
   ↓
Stage
   ↓
Job
   ↓
Step
```

---

# 🛠️ Task 4 – Draw a Pipeline

## Scenario

Developer pushes code to GitHub.

Application should:

* Build
* Test
* Create Docker Image
* Deploy to Staging

---

# Jenkins CI/CD Pipeline

```text
Developer
    |
    | Git Push
    ↓
 GitHub Repository
    ↓
 Jenkins Trigger
    ↓
+--------------------+
| Build Stage        |
| Maven Build        |
+--------------------+
    ↓
+--------------------+
| Test Stage         |
| Unit Tests         |
+--------------------+
    ↓
+--------------------+
| Docker Stage       |
| Build Image        |
+--------------------+
    ↓
+--------------------+
| Deploy Stage       |
| Staging Server     |
+--------------------+
```

---

# Real-World DevOps Pipeline

```text
Developer
      ↓
GitHub
      ↓
Jenkins
      ↓
Build
      ↓
Unit Test
      ↓
Code Quality Scan
      ↓
Docker Build
      ↓
Push Docker Image
      ↓
Deploy To Staging
      ↓
Approval
      ↓
Production
```

---

# 🛠️ Task 5 – Explore Open Source Workflow

## Repository Selected

Kubernetes GitHub Repository

```text
https://github.com/kubernetes/kubernetes
```

---

## Workflow Folder

```text
.github/workflows/
```

Contains multiple workflow files.

Example:

```text
ci.yml
```

---

## Trigger

```yaml
on:
  push:
  pull_request:
```

Runs when:

* Code pushed
* Pull Request created

---

## Jobs

Examples:

```text
Build

Test

Validation

Security Checks
```

---

## Purpose

The workflow:

* Builds Kubernetes code
* Runs tests
* Validates changes
* Ensures release quality

---

# Why Jenkins Became Popular?

Before CI/CD:

```text
Manual Builds

Manual Testing

Manual Deployments
```

After Jenkins:

```text
Automated Builds

Automated Testing

Automated Deployments
```

Benefits:

* Faster Releases
* Improved Quality
* Reduced Human Errors
* Better Reliability

---

# Popular CI/CD Tools

| Tool           | Purpose             |
| -------------- | ------------------- |
| Jenkins        | CI/CD Automation    |
| GitHub Actions | GitHub Native CI/CD |
| GitLab CI/CD   | GitLab Pipelines    |
| CircleCI       | Cloud CI/CD         |
| Azure DevOps   | Microsoft CI/CD     |
| ArgoCD         | GitOps Deployments  |

---

# 📝 What I Learned

### 1. CI/CD Is A Practice

CI/CD is not a tool.

It is a software delivery methodology.

---

### 2. Automation Improves Reliability

Automated builds and tests reduce production issues.

---

### 3. Faster Deployments

Organizations can safely deploy multiple times per day.

---

# 💡 Interview Questions

## What Is CI?

Continuous Integration automatically builds and tests code whenever developers commit changes.

---

## What Is Continuous Delivery?

Applications are always ready for production deployment but require manual approval.

---

## What Is Continuous Deployment?

Applications are automatically deployed to production after successful testing.

---

## Difference Between Delivery And Deployment?

Continuous Delivery:

* Manual Approval Required

Continuous Deployment:

* Fully Automated

---

## What Is A Pipeline?

A pipeline is an automated workflow that builds, tests, and deploys software.

---

## Why Do We Need Jenkins?

Jenkins automates:

* Build
* Test
* Package
* Deploy

This reduces manual effort and improves software quality.

---

# 🏁 Conclusion

Today I learned the fundamentals of CI/CD and Jenkins Pipeline concepts.

Key Takeaways:

✅ Continuous Integration

✅ Continuous Delivery

✅ Continuous Deployment

✅ Pipeline Components

✅ Jenkins Architecture Basics

✅ Build-Test-Deploy Workflow

These concepts form the foundation for upcoming topics:

* Jenkins Installation
* Jenkins Freestyle Jobs
* Jenkins Pipelines
* Jenkins Agents
* GitHub Integration
* Docker Integration
* Kubernetes Deployments

---
