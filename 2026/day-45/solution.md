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
<img width="1366" height="725" alt="image" src="https://github.com/user-attachments/assets/29e39121-972f-44a1-8ea9-153ef38cd823" />

Verify:

```bash
trivy --version
```
<img width="1366" height="724" alt="image" src="https://github.com/user-attachments/assets/0ed8f451-665f-4b1e-ad45-5e8f1e753e17" />

Expected:

```text
Version: 0.xx.x
```
<img width="1366" height="730" alt="image" src="https://github.com/user-attachments/assets/c9714b72-76f9-434f-983f-8216ac67599c" />

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
<img width="1366" height="263" alt="image" src="https://github.com/user-attachments/assets/d59c8487-9e8b-4847-bfa2-cc2147424a4c" />

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
<img width="1366" height="616" alt="image" src="https://github.com/user-attachments/assets/6bb9ae5b-b361-43d9-a51c-df3dd4241e04" />

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
<img width="1365" height="685" alt="image" src="https://github.com/user-attachments/assets/e52d9a7f-6702-493d-ac86-c6186f043b0f" />
<img width="1366" height="668" alt="image" src="https://github.com/user-attachments/assets/82ddc5e0-fcd6-46ea-aff7-74902d0fa419" />

---

# Complete Jenkinsfile

```groovy
pipeline {

    agent any

    environment {

        IMAGE_NAME = "saichandu27/sample-app"
        IMAGE_TAG  = "v1.0"

    }

    stages {

        stage('Pull Docker Image') {

            steps {

                sh '''
                docker pull ${IMAGE_NAME}:${IMAGE_TAG}
                '''
            }
        }

        stage('Trivy Vulnerability Scan') {

            steps {

                sh '''
                trivy image \
                --severity HIGH,CRITICAL \
                --exit-code 0 \
                ${IMAGE_NAME}:${IMAGE_TAG}
                '''
            }
        }

        stage('Deploy Container') {

            steps {

                sh '''
                docker rm -f flask-app || true

                docker run -d \
                --name flask-app \
                -p 5000:5000 \
                ${IMAGE_NAME}:${IMAGE_TAG}
                '''
            }
        }

        stage('Verify Deployment') {

            steps {

                sh 'docker ps'

                sh 'curl -I http://localhost:5000'
            }
        }
    }

    post {

        success {

            echo 'Application Deployed Successfully'
        }

        failure {

            echo 'Pipeline Failed'
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
<img width="1366" height="603" alt="image" src="https://github.com/user-attachments/assets/168ac54b-98ff-4fac-8c58-6f82299f96a5" />
<img width="1366" height="239" alt="image" src="https://github.com/user-attachments/assets/5d429c1b-3f73-401a-acfa-2c8114222512" />

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
