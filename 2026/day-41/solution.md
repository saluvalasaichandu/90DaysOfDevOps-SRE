# Task 2: Build a Multi-Branch Pipeline for a Microservices Application

---

## 📋 Scenario

You have a microservices-based application with multiple components stored in separate Git repositories. The goal is to create a **multi-branch pipeline** that builds, tests, and deploys each service **concurrently**.

---

## 🗂️ Repository Structure

```
microservices-app/
├── user-service/
│   ├── src/
│   ├── tests/
│   ├── Dockerfile
│   └── Jenkinsfile
├── order-service/
│   ├── src/
│   ├── tests/
│   ├── Dockerfile
│   └── Jenkinsfile
├── payment-service/
│   ├── src/
│   ├── tests/
│   ├── Dockerfile
│   └── Jenkinsfile
└── solution.md
```

---

## ⚙️ Step 1: Set Up a Multi-Branch Pipeline Job in Jenkins

### Prerequisites
- Jenkins 2.x+ with the following plugins installed:
  - **Pipeline Multibranch Plugin**
  - **Git Plugin**
  - **Blue Ocean** (optional, for better UI)
  - **GitHub Branch Source Plugin** (for PR support)

### Jenkins Configuration

1. Open Jenkins → **New Item**
2. Enter a name (e.g., `microservices-pipeline`) → select **Multibranch Pipeline** → click **OK**
3. Under **Branch Sources**, add your Git/GitHub repository URL
4. Set **Discover Branches** and **Discover Pull Requests** strategies
5. Set **Scan Repository Triggers** to poll every 1 minute (or use webhooks)
6. Click **Save** → Jenkins will auto-scan and detect all branches

```
Jenkins → New Item → Multibranch Pipeline
  └── Branch Sources: GitHub / Git Repo URL
  └── Behaviors: Discover branches, Discover PRs
  └── Build Configuration: by Jenkinsfile (path: Jenkinsfile)
  └── Scan Triggers: 1 min interval or webhook
```

---

## 📄 Step 2: Jenkinsfile for Each Service

All services share a similar pipeline structure. Below are the Jenkinsfiles for each.

---

### `user-service/Jenkinsfile`

```groovy
pipeline {
    agent any

    environment {
        SERVICE_NAME = "user-service"
        DOCKER_IMAGE = "myrepo/user-service:${env.BUILD_NUMBER}"
        DEPLOY_ENV   = "${env.BRANCH_NAME == 'main' ? 'production' : 'staging'}"
    }

    stages {

        stage('Checkout') {
            steps {
                echo "Checking out ${SERVICE_NAME} on branch: ${env.BRANCH_NAME}"
                checkout scm
            }
        }

        stage('Build') {
            steps {
                dir('user-service') {
                    echo "Building ${SERVICE_NAME}..."
                    sh 'docker build -t ${DOCKER_IMAGE} .'
                }
            }
        }

        stage('Test') {
            parallel {
                stage('Unit Tests') {
                    steps {
                        dir('user-service') {
                            sh 'npm install && npm run test:unit'
                        }
                    }
                }
                stage('Integration Tests') {
                    steps {
                        dir('user-service') {
                            sh 'npm run test:integration'
                        }
                    }
                }
                stage('Lint') {
                    steps {
                        dir('user-service') {
                            sh 'npm run lint'
                        }
                    }
                }
            }
        }

        stage('Push Image') {
            when {
                anyOf {
                    branch 'main'
                    branch 'develop'
                }
            }
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'docker-hub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push ${DOCKER_IMAGE}
                    '''
                }
            }
        }

        stage('Deploy') {
            when {
                anyOf {
                    branch 'main'
                    branch 'develop'
                }
            }
            steps {
                echo "Deploying ${SERVICE_NAME} to ${DEPLOY_ENV}..."
                sh '''
                    kubectl set image deployment/user-service \
                        user-service=${DOCKER_IMAGE} \
                        --namespace=${DEPLOY_ENV}
                '''
            }
        }
    }

    post {
        success {
            echo "${SERVICE_NAME} pipeline completed successfully on ${env.BRANCH_NAME}"
        }
        failure {
            echo "${SERVICE_NAME} pipeline FAILED on ${env.BRANCH_NAME}"
            mail to: 'devops-team@example.com',
                 subject: "FAILED: ${SERVICE_NAME} - ${env.BRANCH_NAME}",
                 body: "Build #${env.BUILD_NUMBER} failed. Check Jenkins for details."
        }
        always {
            cleanWs()
        }
    }
}
```

---

### `order-service/Jenkinsfile`

```groovy
pipeline {
    agent any

    environment {
        SERVICE_NAME = "order-service"
        DOCKER_IMAGE = "myrepo/order-service:${env.BUILD_NUMBER}"
        DEPLOY_ENV   = "${env.BRANCH_NAME == 'main' ? 'production' : 'staging'}"
    }

    stages {

        stage('Checkout') {
            steps {
                echo "Checking out ${SERVICE_NAME} on branch: ${env.BRANCH_NAME}"
                checkout scm
            }
        }

        stage('Build') {
            steps {
                dir('order-service') {
                    sh 'mvn clean package -DskipTests'
                    sh 'docker build -t ${DOCKER_IMAGE} .'
                }
            }
        }

        stage('Test') {
            parallel {
                stage('Unit Tests') {
                    steps {
                        dir('order-service') {
                            sh 'mvn test'
                        }
                    }
                    post {
                        always {
                            junit 'order-service/target/surefire-reports/*.xml'
                        }
                    }
                }
                stage('Code Coverage') {
                    steps {
                        dir('order-service') {
                            sh 'mvn jacoco:report'
                        }
                    }
                }
            }
        }

        stage('Push Image') {
            when { branch 'main' }
            steps {
                sh 'docker push ${DOCKER_IMAGE}'
            }
        }

        stage('Deploy') {
            when { branch 'main' }
            steps {
                echo "Deploying ${SERVICE_NAME} to production..."
                sh '''
                    kubectl set image deployment/order-service \
                        order-service=${DOCKER_IMAGE} \
                        --namespace=production
                '''
            }
        }
    }

    post {
        always { cleanWs() }
    }
}
```

---

### `payment-service/Jenkinsfile`

```groovy
pipeline {
    agent any

    environment {
        SERVICE_NAME = "payment-service"
        DOCKER_IMAGE = "myrepo/payment-service:${env.BUILD_NUMBER}"
        DEPLOY_ENV   = "${env.BRANCH_NAME == 'main' ? 'production' : 'staging'}"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                dir('payment-service') {
                    sh 'pip install -r requirements.txt'
                    sh 'docker build -t ${DOCKER_IMAGE} .'
                }
            }
        }

        stage('Test') {
            parallel {
                stage('Unit Tests') {
                    steps {
                        dir('payment-service') {
                            sh 'pytest tests/unit --junitxml=reports/unit.xml'
                        }
                    }
                }
                stage('Security Scan') {
                    steps {
                        dir('payment-service') {
                            sh 'bandit -r src/ -f xml -o reports/security.xml || true'
                        }
                    }
                }
                stage('Integration Tests') {
                    steps {
                        dir('payment-service') {
                            sh 'pytest tests/integration --junitxml=reports/integration.xml'
                        }
                    }
                }
            }
        }

        stage('Push Image') {
            when {
                anyOf { branch 'main'; branch 'develop' }
            }
            steps {
                sh 'docker push ${DOCKER_IMAGE}'
            }
        }

        stage('Deploy') {
            when { branch 'main' }
            steps {
                sh '''
                    kubectl set image deployment/payment-service \
                        payment-service=${DOCKER_IMAGE} \
                        --namespace=production
                '''
            }
        }
    }

    post {
        always { cleanWs() }
    }
}
```

---

## 🔀 Step 3: Simulate a Merge (Feature Branch + PR Workflow)

### Branch Strategy

```
main            ──●────────────────────────────●──  (production)
                  │                            ↑
develop         ──●──────────────●─────────────●──  (staging)
                                 ↑
feature/add-auth  ──●──●──●──────●                  (feature branch)
```

### Simulating the PR Workflow

```bash
# 1. Create a feature branch
git checkout -b feature/add-auth

# 2. Make changes to user-service
echo "// auth logic" >> user-service/src/auth.js
git add .
git commit -m "feat: add authentication to user-service"
git push origin feature/add-auth

# 3. Open a Pull Request (GitHub/GitLab UI)
#    feature/add-auth → develop

# 4. Jenkins auto-detects the PR via webhook
#    Runs: Checkout → Build → Test (parallel) → (no deploy for PRs)

# 5. On PR approval & merge → Jenkins runs full pipeline on 'develop'
#    Runs: Checkout → Build → Test → Push Image → Deploy to staging

# 6. After QA sign-off, merge develop → main
#    Runs: Checkout → Build → Test → Push Image → Deploy to production
```

### Jenkins PR Detection (Jenkinsfile snippet)

```groovy
stage('Deploy') {
    when {
        // Only deploy on main or develop, NOT on feature branches or PRs
        anyOf {
            branch 'main'
            branch 'develop'
        }
    }
    steps {
        // deployment steps
    }
}
```

---

## 📝 solution.md

````markdown
# Solution: Multi-Branch Pipeline for Microservices

## Jenkinsfiles Used

| Service          | File Location                   | Language   |
|------------------|---------------------------------|------------|
| user-service     | user-service/Jenkinsfile        | Node.js    |
| order-service    | order-service/Jenkinsfile       | Java/Maven |
| payment-service  | payment-service/Jenkinsfile     | Python     |

## Pipeline Design

Each Jenkinsfile follows the same 5-stage pattern:

1. **Checkout** – Pull source code via `checkout scm` (auto-configured by Jenkins multibranch)
2. **Build** – Compile/package the service and build a Docker image tagged with the build number
3. **Test** – Run unit, integration, and service-specific tests **in parallel** to reduce total pipeline time
4. **Push Image** – Push the Docker image to the registry (only on `main` or `develop`)
5. **Deploy** – Rolling update via `kubectl set image` (only on `main` → production, `develop` → staging)

### Branch-Based Deployment Rules

| Branch               | Build | Test | Push Image | Deploy         |
|----------------------|-------|------|------------|----------------|
| `main`               | ✅    | ✅   | ✅         | ✅ Production  |
| `develop`            | ✅    | ✅   | ✅         | ✅ Staging     |
| `feature/*`          | ✅    | ✅   | ❌         | ❌             |
| Pull Requests        | ✅    | ✅   | ❌         | ❌             |

## How Multi-Branch Pipelines Help in Production

- **Isolation**: Each branch gets its own pipeline run — feature work never interferes with production
- **Automatic discovery**: Jenkins scans the repo and creates pipelines for new branches automatically
- **PR validation**: Code is built and tested before merging, catching bugs early
- **Parallel services**: All three services run their pipelines concurrently, cutting total CI time
- **Traceability**: Every deployment is tied to a specific branch, commit, and build number
````

---

## ❓ Interview Questions & Answers

### Q1: How does a multi-branch pipeline improve continuous integration for microservices?

> **Answer:** A multi-branch pipeline automatically creates an isolated CI pipeline for every branch in your repository. For microservices, this means:
> - **Independent testing**: Each service's feature branch is tested without impacting `main`
> - **Parallel execution**: Multiple services and their branches are built concurrently, dramatically reducing feedback time
> - **Branch-specific behavior**: `main` deploys to production, `develop` to staging, and `feature/*` branches only run build + test — all defined in the same Jenkinsfile using `when { branch '...' }` conditions
> - **Automatic cleanup**: When a branch is deleted (after PR merge), Jenkins removes the corresponding pipeline automatically

---

### Q2: What challenges might you face when merging feature branches in a multi-branch pipeline?

> **Answer:** Key challenges include:
>
> | Challenge | Description | Mitigation |
> |-----------|-------------|------------|
> | **Merge conflicts** | Two feature branches modifying the same service file | Short-lived branches + frequent rebasing on `develop` |
> | **Environment drift** | Staging doesn't perfectly mirror production | Use Docker + K8s manifests to keep envs in sync |
> | **Flaky tests** | Tests pass on feature branch but fail after merge | Run full integration test suite on `develop` post-merge |
> | **Pipeline queue buildup** | Many PRs triggering simultaneous builds | Use Jenkins agent pools and resource limits |
> | **Secrets management** | Different credentials needed per environment | Use Jenkins credentials store with environment-scoped bindings |
> | **Database migrations** | Schema changes in one service breaking others | Contract testing (e.g., Pact) between services |

---

## 🛠️ Tools & Plugins Reference

| Tool / Plugin | Purpose |
|---|---|
| Jenkins Multibranch Pipeline | Auto-detect and manage branch pipelines |
| GitHub Branch Source Plugin | Discover branches and PRs from GitHub |
| Docker Pipeline Plugin | Build and push Docker images |
| Kubernetes CLI Plugin | `kubectl` commands inside pipeline |
| Blue Ocean | Visual pipeline UI |
| JUnit Plugin | Publish test reports |
| Mail Extension Plugin | Email notifications on failure |

---

## 📊 Pipeline Flow Diagram

```
         Git Push / PR Open
               │
               ▼
     Jenkins Branch Scanner
               │
      ┌────────┴────────┐
      │                 │
  feature/*           main / develop
      │                 │
  ┌───▼───┐         ┌───▼───┐
  │Checkout│        │Checkout│
  └───┬───┘         └───┬───┘
      │                 │
  ┌───▼───┐         ┌───▼───┐
  │ Build │         │ Build │
  └───┬───┘         └───┬───┘
      │                 │
  ┌───▼──────────┐  ┌───▼──────────┐
  │ Test (parallel)│  │ Test (parallel)│
  │ - Unit         │  │ - Unit         │
  │ - Integration  │  │ - Integration  │
  │ - Lint/Security│  │ - Lint/Security│
  └───┬───────────┘  └───┬───────────┘
      │                  │
      ▼                  ▼
  (no deploy)       Push Docker Image
                         │
                    ┌────▼────┐
                    │ Deploy  │
                    │staging /│
                    │  prod   │
                    └─────────┘
```

---

*Built with Jenkins Multibranch Pipeline | Docker | Kubernetes*