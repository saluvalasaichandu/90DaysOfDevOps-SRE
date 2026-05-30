# Task 1: Create a Jenkins Pipeline Job for CI/CD

## Objective

Create a Jenkins Declarative Pipeline that automates Build → Test → Deploy for a sample application.

---

# Step 1: Create Jenkins Pipeline Job

Jenkins Dashboard → New Item → Pipeline → Enter Name → OK

Select:

```text
Pipeline Definition: Pipeline script
```

Paste the Jenkinsfile below.

---

# Jenkinsfile

```groovy
pipeline {
    agent any

    stages {

        stage('Build') {
            steps {
                echo 'Building Application...'
            }
        }

        stage('Test') {
            steps {
                echo 'Running Tests...'
            }
        }

        stage('Deploy') {
            steps {
                sh 'docker run -d --name myapp -p 8080:80 nginx'
            }
        }
    }
}
```

---

# Step 2: Run Pipeline

Click:

```text
Build Now
```

Expected Stages:

```text
Build     ✅
Test      ✅
Deploy    ✅
```

---

# Step 3: Verify Pipeline

Check Console Output:

```text
Building Application...
Running Tests...
Deploying Application...
```

Verify Container:

```bash
docker ps
```

Output:

```text
CONTAINER ID   IMAGE   STATUS
xxxxx          nginx   Up
```

Access Application:

```text
http://<server-ip>:8080
```

Nginx Welcome Page should appear.

---

# Stage Explanation

## Build Stage

```groovy
stage('Build')
```

Purpose:

* Compile application
* Package code
* Create artifacts

---

## Test Stage

```groovy
stage('Test')
```

Purpose:

* Run unit tests
* Validate code quality
* Detect bugs early

---

## Deploy Stage

```groovy
stage('Deploy')
```

Purpose:

* Deploy application
* Start container/service
* Make application available

---

# Issues Faced & Resolution

### Issue 1: Docker Command Not Found

Error:

```text
docker: command not found
```

Solution:

```bash
sudo apt install docker.io -y
```

---

### Issue 2: Permission Denied

Error:

```text
permission denied while connecting to Docker daemon
```

Solution:

```bash
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins
```

---

### Issue 3: Container Name Already Exists

Error:

```text
Conflict. Container name already in use
```

Solution:

```bash
docker rm -f myapp
```

---

# Interview Questions

## 1. How do Declarative Pipelines streamline CI/CD compared to Scripted Pipelines?

| Declarative Pipeline  | Scripted Pipeline       |
| --------------------- | ----------------------- |
| Simple Syntax         | Complex Groovy Code     |
| Easy to Read          | Flexible but Harder     |
| Built-in Structure    | Manual Structure        |
| Recommended for CI/CD | Used for Advanced Logic |

Declarative pipelines are easier to maintain, standardize, and troubleshoot.

---

## 2. Benefits of Breaking Pipeline into Stages?

* Better visibility of execution flow
* Easier troubleshooting
* Faster issue identification
* Supports parallel execution
* Improves maintainability

Example:

```text
Build → Test → Deploy
```

If Test fails, Deploy will not run, preventing bad code from reaching production.

---