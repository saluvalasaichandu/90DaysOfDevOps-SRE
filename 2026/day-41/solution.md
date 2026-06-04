# Task 2: Build a Multi-Branch Pipeline for a Microservices Application

## Objective

Learn how Jenkins Multi-Branch Pipelines automatically discover branches and create separate pipelines for each branch.

For this demo, instead of creating multiple real microservices, we will use a simple GitHub repository with multiple branches to understand the concept.

---

# Architecture

```text
GitHub Repository

jenkins-multibranch-demo

├── main
└── feature-login
```

Jenkins automatically creates separate pipelines for each branch.

---

# Step 1: Create GitHub Repository

Create a repository:

```text
jenkins-multibranch-demo
```

Repository Structure:

```text
jenkins-multibranch-demo

├── Jenkinsfile
└── index.html
```

---

## index.html

```html
<h1>Hello Jenkins MultiBranch Pipeline</h1>
```

Push the code to GitHub.

---

# Step 2: Create Feature Branch

Create a new branch:

```bash
git checkout -b feature-login
```

Modify the file:

```html
<h1>Hello Feature Login Branch</h1>
```

Commit and Push:

```bash
git add .

git commit -m "Added feature-login branch"

git push origin feature-login
```

Now GitHub contains:

```text
main
feature-login
```

---

# Step 3: Create Jenkinsfile

Add the following Jenkinsfile to the repository root.

```groovy
pipeline {

    agent any

    stages {

        stage('Checkout') {
            steps {
                echo 'Checkout Completed'
            }
        }

        stage('Build') {
            steps {
                echo 'Building Application'
            }
        }

        stage('Test') {

            parallel {

                stage('Unit Test') {
                    steps {
                        echo 'Running Unit Tests'
                    }
                }

                stage('Code Scan') {
                    steps {
                        echo 'Running Code Scan'
                    }
                }
            }
        }

        stage('Deploy') {

            when {
                branch 'main'
            }

            steps {
                echo 'Deploying Application'
            }
        }
    }
}
```
<img width="1364" height="393" alt="image" src="https://github.com/user-attachments/assets/70099d1d-a28c-473b-a327-3610b50b3dd2" />

<img width="1366" height="671" alt="image" src="https://github.com/user-attachments/assets/25137fa8-a1b3-47cf-8980-d9174e8e059d" />

---

# Step 4: Create Multi-Branch Pipeline in Jenkins

Navigate to:

```text
Jenkins Dashboard
        ↓
New Item
        ↓
Multibranch Pipeline
        ↓
microservice-demo
```

Click OK.

---

# Step 5: Configure GitHub Repository

Under Branch Sources:

```text
GitHub
```

Repository URL:

```text
https://github.com/<your-username>/jenkins-multibranch-demo.git
```

Add GitHub credentials if required.

Enable:

```text
✓ Discover Branches

✓ Discover Pull Requests
```

Save the configuration.

---

# Step 6: Scan Repository

Click:

```text
Scan Repository Now
```

Jenkins automatically discovers branches.

Expected Result:

```text
microservice-demo

├── main
└── feature-login
```

Separate pipelines are created automatically.

---

# Step 7: Run Pipeline

### Build Main Branch

Stages Executed:

```text
Checkout
Build
Unit Test
Code Scan
Deploy
```
<img width="1364" height="603" alt="image" src="https://github.com/user-attachments/assets/6c0c61ab-bcd3-4d1d-96cf-c9f8ab302864" />

---

### Build Feature Branch

Stages Executed:

```text
Checkout
Build
Unit Test
Code Scan
```

Deploy stage is skipped because:

```groovy
when {
    branch 'main'
}
```

Only the main branch is allowed to deploy.

---

# Step 8: Simulate Pull Request Workflow

Workflow:

```text
Developer
     ↓

feature-login Branch
     ↓

Jenkins Validation
     ↓

Pull Request
     ↓

Merge to Main
     ↓

Main Pipeline Runs
     ↓

Deploy
```

This is similar to how real organizations validate code before deployment.

---

# Pipeline Design Explanation

## Checkout Stage

Retrieves source code from GitHub.

```groovy
echo 'Checkout Completed'
```
<img width="1366" height="611" alt="image" src="https://github.com/user-attachments/assets/497f8fa6-64e3-4e82-aa5a-bea1b143792f" />

---

## Build Stage

Simulates application build.

```groovy
echo 'Building Application'
```

---

## Test Stage

Runs multiple test activities in parallel.

```groovy
parallel
```

Benefits:

* Faster execution
* Reduced pipeline time
* Early issue detection

---

## Deploy Stage

Runs only for the main branch.

```groovy
when {
 branch 'main'
}
```

Prevents accidental deployments from feature branches.

---

# Verification

## Verify Branch Discovery

Jenkins Dashboard:

```text
microservice-demo

├── main
├── feature-login
```

---

## Verify Build Logs

Expected Output:

```text
Checkout Completed

Building Application

Running Unit Tests

Running Code Scan

Deploying Application
```

---

# Benefits of Multi-Branch Pipelines

### Automatic Branch Discovery

No need to create separate Jenkins jobs manually.

### Better Continuous Integration

Every branch is tested automatically.

### Pull Request Validation

Code quality is verified before merge.

### Faster Feedback

Developers quickly know if changes break the build.

### Safer Deployments

Only approved branches can deploy.

---

# Interview Questions

## 1. How does a Multi-Branch Pipeline improve Continuous Integration for Microservices?

### Answer

A Multi-Branch Pipeline automatically discovers branches and creates separate pipelines for each branch. This allows developers to build and test code independently before merging changes into the main branch, reducing integration issues.

---

## 2. What challenges might you face when merging feature branches in a Multi-Branch Pipeline?

### Answer

Common challenges include:

* Merge conflicts
* Failed tests after merge
* Dependency version conflicts
* Environment configuration differences
* Deployment failures

These can be reduced through automated testing, code reviews, and branch protection rules.

---

# Conclusion

Successfully implemented a Jenkins Multi-Branch Pipeline.

## Workflow

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

Deploy (Main Branch Only)

