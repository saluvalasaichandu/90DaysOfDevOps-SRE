# Task 6: Integrate Vulnerability Scanning with Trivy

## Objective

Integrate Trivy vulnerability scanning into Jenkins CI/CD pipeline to identify security vulnerabilities in Docker images before deployment.

---

# Architecture

```text
Developer
    │
    ▼
GitHub
    │
    ▼
Jenkins Pipeline
    │
    ├── Build
    ├── Test
    ├── Docker Build
    ├── Trivy Scan
    └── Deploy
```

---

# Why Trivy?

Trivy is an open-source vulnerability scanner that scans:

* Docker Images
* Kubernetes Clusters
* File Systems
* Git Repositories

It identifies:

```text
Critical
High
Medium
Low
Unknown
```

security vulnerabilities.

---

# Step 1: Install Trivy on Jenkins Server

## Amazon Linux

```bash
curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sudo sh -s -- -b /usr/local/bin

```

Verify:

```bash
trivy --version
```

Expected:

```text
Version: 0.xx.x
```

---

# Step 2: Build Docker Image

Example:

```bash
docker build -t saichandu/sample-app:v1.0 .
```

Verify:

```bash
docker images
```

Output:

```text
REPOSITORY            TAG
saichandu/sample-app  v1.0
```

---

# Step 3: Jenkinsfile with Trivy Scan

```groovy
pipeline {

    agent any

    environment {

        IMAGE_NAME = "saichandu/sample-app:v1.0"

    }

    stages {

        stage('Build') {

            steps {

                sh 'docker build -t $IMAGE_NAME .'

            }
        }

        stage('Vulnerability Scan') {

            steps {

                sh 'trivy image $IMAGE_NAME'

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

---

# Step 4: Fail Build for Critical Vulnerabilities

```groovy
stage('Vulnerability Scan') {

    steps {

        sh '''
        trivy image \
        --severity CRITICAL,HIGH \
        --exit-code 1 \
        saichandu/sample-app:v1.0
        '''
    }
}
```

Explanation:

```text
--severity CRITICAL,HIGH
Scan only critical and high issues

--exit-code 1
Fail pipeline if vulnerabilities found
```

---

# Complete Jenkinsfile

```groovy
pipeline {

    agent any

    environment {

        IMAGE_NAME = "saichandu/sample-app:v1.0"

    }

    stages {

        stage('Build') {

            steps {

                sh 'docker build -t $IMAGE_NAME .'

            }
        }

        stage('Trivy Scan') {

            steps {

                sh '''
                trivy image \
                --severity HIGH,CRITICAL \
                --exit-code 1 \
                $IMAGE_NAME
                '''
            }
        }

        stage('Deploy') {

            steps {

                echo "Deployment Successful"

            }
        }
    }
}
```

---

# Sample Scan Output

```text
Report Summary

Total Vulnerabilities: 15

CRITICAL : 2

HIGH     : 4

MEDIUM   : 6

LOW      : 3
```

Example:

```text
openssl

Severity : CRITICAL

Installed Version : 1.1.1

Fixed Version : 1.1.1w
```

---

# Remediation Steps

## Update Base Image

Bad:

```dockerfile
FROM ubuntu:18.04
```

Good:

```dockerfile
FROM ubuntu:24.04
```

---

## Update Packages

```dockerfile
RUN apt-get update && apt-get upgrade -y
```

---

## Use Minimal Images

Bad:

```dockerfile
FROM ubuntu
```

Good:

```dockerfile
FROM alpine
```

or

```dockerfile
FROM python:3.11-alpine
```

---

## Remove Unused Packages

Smaller images reduce attack surface.

---

# Verification

## Successful Scan

```text
Build
Success

Trivy Scan
Success

Deploy
Success
```

---

## Failed Scan

```text
Build
Success

Trivy Scan
Failed

CRITICAL Vulnerability Found

Pipeline Aborted
```

Deployment will not start.

---

# Benefits of Automated Security Scanning

### Early Detection

Detect vulnerabilities before production deployment.

---

### Shift Left Security

Security checks become part of CI/CD.

---

### Compliance

Helps meet organizational security standards.

---

### Reduced Risk

Prevents vulnerable images from reaching production.

---

# Interview Question 1

## Why is integrating vulnerability scanning into a CI/CD pipeline important?

### Answer

Integrating vulnerability scanning into CI/CD ensures that insecure code and vulnerable Docker images are identified early in the software development lifecycle. It prevents vulnerable applications from being deployed to production and improves overall security posture.

---

# Interview Question 2

## How does Trivy improve Docker image security?

### Answer

Trivy scans Docker images for known vulnerabilities in operating system packages and application dependencies. It provides severity ratings, remediation guidance, and can fail CI/CD pipelines automatically when critical vulnerabilities are detected.

---

# Real-Time DevOps Use Case

```text
Developer Commit
        ↓
GitHub
        ↓
Jenkins Build
        ↓
Docker Build
        ↓
Trivy Scan
        ↓
Pass
        ↓
Deploy
```

If Trivy finds:

```text
CRITICAL Vulnerability
```

Pipeline:

```text
FAILED
```

Deployment:

```text
BLOCKED
```

---

# Conclusion

Successfully integrated Trivy vulnerability scanning into Jenkins CI/CD pipeline.

## Workflow

```text
GitHub
   ↓
Jenkins
   ↓
Build
   ↓
Docker Build
   ↓
Trivy Scan
   ↓
Deploy
```

This ensures only secure Docker images are deployed to production environments.
