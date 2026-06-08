# Task 5: Develop and Integrate a Jenkins Shared Library

## Objective

Create a Jenkins Shared Library to reuse common pipeline code across multiple Jenkins jobs.

---

# Architecture

```text
GitHub

jenkins-shared-library
        │
        ▼

Jenkins
        │
        ▼

Pipeline Jobs
```
<img width="1365" height="486" alt="image" src="https://github.com/user-attachments/assets/649bfd77-29ba-4b19-82e8-a36b03f9ed19" />

---

# Why Shared Library?

Without Shared Library:

```text
Pipeline-1
  Build
  Test
  Deploy

Pipeline-2
  Build
  Test
  Deploy
```

Same code repeated everywhere.

With Shared Library:

```text
Shared Library
     │
     ▼

Pipeline-1
Pipeline-2
Pipeline-3
```

Reusable code from one location.

---

# Step 1: Create GitHub Repository

Create repository:

```text
jenkins-shared-library
```

Repository Structure:

```text
jenkins-shared-library

├── vars
│   ├── buildApp.groovy
│   ├── testApp.groovy
│   └── deployApp.groovy
```
<img width="1356" height="603" alt="image" src="https://github.com/user-attachments/assets/020b98a5-75d7-493b-a2ea-0669c3d90ac3" />
<img width="1366" height="617" alt="image" src="https://github.com/user-attachments/assets/d95ec75e-8a06-4cd8-a52b-03aa691035fa" />


---

# Step 2: Create Shared Functions

## vars/buildApp.groovy

```groovy
def call() {

    echo "Building Application..."

}
```

---

## vars/testApp.groovy

```groovy
def call() {

    echo "Running Tests..."

}
```

---

## vars/deployApp.groovy

```groovy
def call() {

    echo "Deploying Application..."

}
```

---

# Step 3: Configure Library in Jenkins

Navigate:

```text
Manage Jenkins
      ↓
System
      ↓
Global Pipeline Libraries
      ↓
Add
```

Configuration:

```text
Library Name:
my-shared-library

Default Version:
main

Retrieval Method:
Modern SCM

Source Code:
Git

Repository URL:
https://github.com/<your-username>/jenkins-shared-library.git
```

Save.

---

# Step 4: Create Jenkins Pipeline

## Jenkinsfile

```groovy
@Library('my-shared-library') _

pipeline {

    agent any

    stages {

        stage('Build') {

            steps {

                buildApp()

            }
        }

        stage('Test') {

            steps {

                testApp()

            }
        }

        stage('Deploy') {

            steps {

                deployApp()

            }
        }
    }
}
```
<img width="1364" height="613" alt="image" src="https://github.com/user-attachments/assets/76cab346-a8c0-4dfc-b3b4-d4844746f4d7" />

---

# Expected Output

```text
Build Stage

Building Application...

Test Stage

Running Tests...

Deploy Stage

Deploying Application...
```
<img width="1366" height="555" alt="image" src="https://github.com/user-attachments/assets/8628bf88-e0a0-44d0-a167-fcca99ce6472" />

---

# Verification

Build Console:

```text
Started by user admin

Building Application...

Running Tests...

Deploying Application...

Finished: SUCCESS
```

---

# Benefits of Shared Libraries

### Code Reuse

Write once and use in multiple pipelines.

---

### Easy Maintenance

Update code in one location.

---

### Standardization

All pipelines follow the same process.

---

### Reduced Errors

Avoid duplicate pipeline code.

---

# Example Real-World Functions

Common functions stored in Shared Library:

```text
Build Application

Run Unit Tests

SonarQube Scan

Trivy Security Scan

Docker Build

Docker Push

Slack Notification

Email Notification

Kubernetes Deployment
```

---

# Interview Question 1

## How do Shared Libraries improve maintainability?

### Answer

Shared Libraries centralize reusable pipeline code. Instead of updating multiple Jenkinsfiles, changes are made once in the library and automatically used by all pipelines. This improves consistency, maintainability, and reduces duplication.

---

# Interview Question 2

## Give an example of an ideal Shared Library function.

### Answer

Example:

```groovy
def call() {

    sh 'docker build -t app .'

}
```

Benefits:

* Reusable across projects
* Consistent Docker build process
* Easier maintenance
* Reduced coding effort

---

# Conclusion

Successfully implemented Jenkins Shared Library.

## Workflow

```text
GitHub Shared Library
        ↓
Jenkins
        ↓
Build Function
        ↓
Test Function
        ↓
Deploy Function
```

This approach enables reusable, maintainable, and scalable CI/CD pipelines.
