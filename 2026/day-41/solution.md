# Task 2: Build a Multi-Branch Pipeline for a Microservices Application

## Objective

Implement a Jenkins Multi-Branch Pipeline for a microservices-based application where each service is stored in a separate Git repository. The pipeline should automatically discover branches, build applications, execute tests, create Docker images, and deploy services.

---

# Architecture

## Microservices Repositories

```text
GitHub

├── user-service
├── product-service
└── order-service
```

Each repository contains:

```text
user-service/
├── src/
├── Dockerfile
├── Jenkinsfile
└── pom.xml
```

---

# Step 1: Configure Multi-Branch Pipeline

## Create Pipeline

```text
Jenkins Dashboard
      ↓
New Item
      ↓
Multibranch Pipeline
      ↓
microservices-pipeline
```

---

## Configure GitHub Repository

Branch Source:

```text
GitHub
```

Repository URL:

```bash
https://github.com/your-org/user-service.git
```

Credentials:

```text
GitHub Personal Access Token
```

Branch Discovery:

```text
✓ Discover Branches

✓ Discover Pull Requests
```

Scan Repository:

```text
Periodically if not otherwise run
```

or

```text
GitHub Webhook
```

---

# Step 2: Jenkinsfile

## Jenkinsfile

```groovy
pipeline {

    agent any

    environment {
        IMAGE_NAME = "saichandu/user-service"
        BUILD_TAG = "${BUILD_NUMBER}"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Test') {
            parallel {

                stage('Unit Test') {
                    steps {
                        sh 'mvn test'
                    }
                }

                stage('Code Quality') {
                    steps {
                        echo 'Running SonarQube Scan'
                    }
                }

                stage('Security Scan') {
                    steps {
                        echo 'Running Trivy Scan'
                    }
                }
            }
        }

        stage('Docker Build') {
            steps {
                sh """
                docker build -t $IMAGE_NAME:$BUILD_TAG .
                """
            }
        }

        stage('Docker Push') {
            steps {
                sh """
                docker push $IMAGE_NAME:$BUILD_TAG
                """
            }
        }

        stage('Deploy') {
            when {
                branch 'main'
            }

            steps {
                echo 'Deploying to Kubernetes'
            }
        }
    }
}
```

---

# Pipeline Design

## Checkout Stage

Pulls source code from GitHub repository.

```groovy
checkout scm
```

---

## Build Stage

Compiles the application source code.

```bash
mvn clean package
```

---

## Test Stage

Runs multiple validation tasks in parallel:

* Unit Testing
* Code Quality Scan
* Security Scan

Benefits:

* Faster execution
* Reduced pipeline duration
* Early issue detection

---

## Docker Build Stage

Builds application Docker image.

```bash
docker build -t user-service:1.0 .
```

---

## Docker Push Stage

Pushes image to Docker Hub.

```bash
docker push user-service:1.0
```

---

## Deploy Stage

Deploys application only from:

```text
main branch
```

This prevents accidental deployment from feature branches.

---

# Step 3: Simulate Merge Scenario

## Create Feature Branch

```bash
git checkout -b feature-login
```

---

## Make Changes

```bash
git add .

git commit -m "Added Login Feature"
```

---

## Push Branch

```bash
git push origin feature-login
```

---

## Jenkins Automatic Detection

Jenkins scans repository and creates:

```text
feature-login
```

pipeline automatically.

---

## Pull Request Workflow

```text
feature-login
        ↓
Pull Request
        ↓
develop
        ↓
Jenkins Validation
        ↓
Merge
```

Pipeline executes:

```text
Checkout
Build
Test
Security Scan
```

before allowing merge.

---

# Verification

## Verify Branch Discovery

```text
Jenkins Dashboard

microservices-pipeline

├── main
├── develop
├── feature-login
└── feature-payment
```

---

## Verify Build Logs

```text
Build Successful

Tests Passed

Docker Image Created

Deployment Successful
```

---

## Verify Docker Images

```bash
docker images
```

Expected:

```text
user-service

product-service

order-service
```

---

## Verify Running Containers

```bash
docker ps
```

---

# How Multi-Branch Pipelines Help Microservices

## 1. Automatic Branch Discovery

Every branch automatically gets its own pipeline.

---

## 2. Independent Development

Teams can work on different services without affecting production.

---

## 3. Faster Feedback

Developers receive build and test results immediately.

---

## 4. PR Validation

Code quality is verified before merging.

---

## 5. Better Scalability

Supports hundreds of repositories and branches.

---

# Benefits in Production

* Faster releases
* Reduced deployment failures
* Improved developer productivity
* Automated testing
* Better code quality
* Parallel execution

---

# Interview Questions

## 1. How does a Multi-Branch Pipeline improve Continuous Integration for Microservices?

### Answer

Multi-Branch Pipelines automatically discover branches and create separate pipelines for each branch. This enables independent development, testing, and validation of microservices, ensuring faster feedback and reducing integration issues before code reaches production.

---

## 2. What challenges might you face when merging feature branches in a Multi-Branch Pipeline?

### Answer

Common challenges include:

* Merge conflicts
* Dependency version mismatches
* Failed integration tests
* Configuration drift
* Resource contention on Jenkins agents

These issues can be mitigated using automated testing, code reviews, branch protection rules, and proper version management.

---

# Conclusion

Successfully implemented a Jenkins Multi-Branch Pipeline for a Microservices Application.

### Workflow

```text
GitHub Branch
      ↓
Jenkins Multi-Branch Pipeline
      ↓
Checkout
      ↓
Build
      ↓
Parallel Testing
      ↓
Docker Build
      ↓
Docker Push
      ↓
Deploy
```

