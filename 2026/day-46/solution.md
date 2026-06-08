# Task 7: Dynamic Pipeline Parameterization

## Objective

Implement a Jenkins Pipeline that accepts runtime parameters such as Environment, Application Version, and Deployment Action, allowing flexible deployments without modifying pipeline code.

---

# Why Parameterization?

Instead of hardcoding values:

```text
Deploy Version 1.0.0 to Staging
```

Users can select values during pipeline execution:

```text
Version: 2.0.0

Environment: Production

Action: Deploy
```

This makes the pipeline reusable and production-ready.

---

# Jenkins Pipeline

```groovy
pipeline {

    agent any

    parameters {

        choice(
            name: 'TARGET_ENV',
            choices: ['dev', 'staging', 'prod'],
            description: 'Select Deployment Environment'
        )

        string(
            name: 'APP_VERSION',
            defaultValue: '1.0.0',
            description: 'Application Version'
        )

        booleanParam(
            name: 'DEPLOY_APP',
            defaultValue: true,
            description: 'Deploy Application?'
        )
    }

    stages {

        stage('Build') {

            steps {

                echo "Building Version: ${params.APP_VERSION}"

            }
        }

        stage('Test') {

            steps {

                echo "Running Tests"

            }
        }

        stage('Deploy') {

            when {

                expression {
                    return params.DEPLOY_APP
                }
            }

            steps {

                echo "Deploying Version ${params.APP_VERSION} to ${params.TARGET_ENV}"

            }
        }
    }
}
```

---

# Create Jenkins Job

```text
Dashboard
    ↓
New Item
    ↓
Pipeline
    ↓
Parameterized-Pipeline
```

Paste Jenkinsfile and Save.

---

# Build with Parameters

Click:

```text
Build with Parameters
```

Example 1:

```text
TARGET_ENV = dev

APP_VERSION = 1.0.0

DEPLOY_APP = true
```

Output:

```text
Building Version: 1.0.0

Running Tests

Deploying Version 1.0.0 to dev
```

---

Example 2:

```text
TARGET_ENV = prod

APP_VERSION = 2.5.0

DEPLOY_APP = true
```

Output:

```text
Building Version: 2.5.0

Running Tests

Deploying Version 2.5.0 to prod
```

---

Example 3:

```text
TARGET_ENV = staging

APP_VERSION = 3.0.0

DEPLOY_APP = false
```

Output:

```text
Building Version: 3.0.0

Running Tests

Deploy Stage Skipped
```

---

# Real-Time DevOps Use Case

A single pipeline can deploy:

```text
Dev Environment
```

```text
Staging Environment
```

```text
Production Environment
```

without creating multiple Jenkins jobs.

Example:

```text
Deploy App v1.0.0 → Dev

Deploy App v2.0.0 → Staging

Deploy App v3.0.0 → Production
```

using the same Jenkins pipeline.

---

# Benefits of Parameterized Pipelines

### Reusability

One pipeline serves multiple environments.

### Flexibility

Deploy different application versions dynamically.

### Reduced Maintenance

No need to create separate Jenkins jobs.

### Faster Releases

Users choose deployment options at runtime.

### Better Governance

Production deployments can be controlled through parameters.

---

# Verification

Pipeline Console Output:

```text
Building Version: 2.0.0

Running Tests

Deploying Version 2.0.0 to prod
```

---

# Interview Question 1

## How does pipeline parameterization improve CI/CD flexibility?

### Answer

Pipeline parameterization allows users to provide runtime values such as environment, version, and deployment actions. This eliminates hardcoded configurations and enables the same pipeline to be reused across multiple deployment scenarios.

---

# Interview Question 2

## Provide a scenario where dynamic parameters are critical.

### Answer

In production deployments, teams often deploy different application versions to different environments. Using parameters, users can select the version and target environment at runtime without modifying the Jenkinsfile, reducing errors and improving deployment efficiency.

---

# Conclusion

Successfully implemented a Parameterized Jenkins Pipeline.

## Workflow

```text
User Input
     ↓
Build with Parameters
     ↓
Build
     ↓
Test
     ↓
Deploy
     ↓
Selected Environment
```

Parameterized pipelines are widely used in enterprise CI/CD environments for flexible and controlled deployments.
