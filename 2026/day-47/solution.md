# Task 8: Integrate Email Notifications for Build Events

## Objective

Configure Jenkins to automatically send email notifications for build success, failure, or unstable pipeline executions.

---

# Architecture

```text
Developer Commit
        ↓
GitHub
        ↓
Jenkins Pipeline
        ↓
Build/Test/Deploy
        ↓
Email Notification
        ↓
Developers & DevOps Team
```

---

# Prerequisites

Install Jenkins Plugin:

```text
Manage Jenkins
    ↓
Plugins
    ↓
Email Extension Plugin
```

Install and Restart Jenkins.

---

# Step 1: Configure SMTP

Navigate:

```text
Manage Jenkins
    ↓
Configure System
    ↓
Extended E-mail Notification
```

Example Gmail SMTP:

```text
SMTP Server : smtp.gmail.com

SMTP Port   : 587

Use SMTP Authentication : Yes

Username    : sai@gmail.com

Password    : Gmail App Password

Use SSL     : No

Use TLS     : Yes
```

Save Configuration.

---

# Test SMTP

Click:

```text
Test Configuration
```

Expected:

```text
Email Sent Successfully
```

---

# Step 2: Jenkinsfile

## Success & Failure Notifications

```groovy
pipeline {

    agent any

    stages {

        stage('Build') {
            steps {
                echo "Building Application..."
            }
        }

        stage('Test') {
            steps {
                echo "Testing Application..."
            }
        }

        stage('Deploy') {
            steps {
                echo "Deploying Application..."
            }
        }
    }

    post {

        success {
            emailext(
                subject: "Build Success",
                body: "Pipeline executed successfully.\nBuild URL: ${BUILD_URL}",
                to: "your-email@gmail.com"
            )
        }

        failure {
            emailext(
                subject: "Build Failed",
                body: "Pipeline execution failed.\nCheck: ${BUILD_URL}",
                to: "your-email@gmail.com"
            )
        }
    }
}
```

---

# Alternative Notify Stage

```groovy
stage('Notify') {

    steps {

        emailext(
            subject: "Build Notification: ${env.JOB_NAME}",
            body: "Build Completed: ${env.BUILD_URL}",
            to: "sai@gmail.com"
        )
    }
}
```

---

# Sample Success Email

```text
Subject:
SUCCESS: Sample-Pipeline #15

Body:

Build Successful

Job: Sample-Pipeline
Build Number: 15

URL:
http://jenkins:8080/job/Sample-Pipeline/15/
```

---

# Sample Failure Email

```text
Subject:
FAILED: Sample-Pipeline #16

Body:

Build Failed

Check Build Logs:

http://jenkins:8080/job/Sample-Pipeline/16/
```

---

# Verification

Run Pipeline:

```text
Build Now
```

Expected:

```text
Build Success
```

Email:

```text
Received Successfully
```

---

# Common Issues

### Authentication Failed

Use Gmail App Password instead of normal password.

---

### Connection Timeout

Verify:

```bash
telnet smtp.gmail.com 587
```

---

### Email Not Received

Check:

```text
Manage Jenkins
    ↓
System Log
```

for SMTP errors.

---

# Benefits of Email Notifications

### Faster Response

Teams immediately know build status.

### Reduced Downtime

Failures are detected quickly.

### Better Collaboration

Developers and DevOps receive updates automatically.

### Audit Trail

Email history provides deployment records.

---

# Interview Question 1

## What are the advantages of automating email notifications in CI/CD?

### Answer

Automated notifications provide immediate feedback on build and deployment status, reduce manual monitoring, improve collaboration, and help teams quickly resolve issues before they impact production.

---

# Interview Question 2

## How would you troubleshoot email notification failures?

### Answer

1. Verify SMTP configuration.
2. Test SMTP connectivity.
3. Check Jenkins system logs.
4. Validate credentials/App Password.
5. Review Email Extension Plugin configuration.
6. Test email manually from Jenkins.

---

# Real-Time DevOps Use Case

```text
Developer Push
      ↓
Jenkins Build
      ↓
Build Failed
      ↓
Automatic Email
      ↓
Developer Fixes Issue
```

Without notifications:

```text
Failure May Go Unnoticed
```

With notifications:

```text
Immediate Alert
```

---

# Conclusion

Successfully integrated Jenkins Email Notifications using the Email Extension Plugin.

## Workflow

```text
GitHub
   ↓
Jenkins Pipeline
   ↓
Build/Test/Deploy
   ↓
Email Notification
   ↓
Developers
```

This ensures teams are automatically informed about CI/CD pipeline events and can react quickly to failures.
