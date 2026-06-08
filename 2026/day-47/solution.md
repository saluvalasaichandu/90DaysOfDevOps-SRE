<img width="1363" height="617" alt="image" src="https://github.com/user-attachments/assets/8bdc91b5-9a65-4022-b400-74faa3b6cbf9" /># Task 8: Integrate Email Notifications for Build Events

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
<img width="1366" height="603" alt="image" src="https://github.com/user-attachments/assets/67f8fef1-9e41-40a7-a295-516887b6f6a5" />
<img width="1366" height="501" alt="image" src="https://github.com/user-attachments/assets/d6c3a48c-fe8f-413f-8293-b020e4598aaa" />

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
                to: "sai@gmail.com"
            )
        }

        failure {
            emailext(
                subject: "Build Failed",
                body: "Pipeline execution failed.\nCheck: ${BUILD_URL}",
                to: "sai@gmail.com"
            )
        }
    }
}
```
<img width="1363" height="617" alt="image" src="https://github.com/user-attachments/assets/114a9e26-631a-4a7e-a025-fa50ad82adad" />
<img width="1366" height="550" alt="image" src="https://github.com/user-attachments/assets/080ce185-bd53-44fe-8d12-7584a5f21d1c" />

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
<img width="1366" height="521" alt="image" src="https://github.com/user-attachments/assets/94934701-f419-41ac-b34c-da095da20b43" />
<img width="1366" height="520" alt="image" src="https://github.com/user-attachments/assets/35d5db26-e800-48ce-99d9-c4c04d979d3c" />
<img width="1366" height="441" alt="image" src="https://github.com/user-attachments/assets/488bfc87-60dd-4086-b0f6-fd92835a6f3c" />

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
