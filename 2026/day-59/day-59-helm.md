# 🚀 Day 59 - Helm: Kubernetes Package Manager

## 📌 Objective

Learn Helm, deploy applications using Charts, customize configurations, perform upgrades/rollbacks, and create your own Helm Chart.

---

# 🧠 Theory

## What is Helm?

Helm is the package manager for Kubernetes.

Like:

```text
APT → Ubuntu
YUM → RHEL
HELM → Kubernetes
```

Helm helps manage multiple Kubernetes YAML files using a single package called a Chart.

---

## Core Concepts

### Chart

Collection of Kubernetes templates.

```text
Deployment
Service
ConfigMap
Secret
PVC
Ingress
```

---

### Release

An installed instance of a Chart.

Example:

```text
Chart: nginx

Release: my-nginx
```

---

### Repository

Collection of Helm Charts.

Example:

```text
Bitnami Repository
```

---

# Helm Architecture

```text
Helm Client
      ↓
Helm Chart
      ↓
Kubernetes API
      ↓
Cluster Resources
```

---

# 🛠 Practical Implementation

## Step 1: Install Helm

Verify Installation:

```bash
helm version

helm env
```

Expected:

```text
Version v3.x.x
```

---

## Step 2: Add Bitnami Repository

Add Repository:

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
```

Update Repository:

```bash
helm repo update
```

Search Charts:

```bash
helm search repo nginx

helm search repo bitnami
```

---

## Step 3: Install Nginx Chart

Install:

```bash
helm install my-nginx bitnami/nginx
```

Verify:

```bash
helm list

helm status my-nginx

kubectl get all
```

View Manifest:

```bash
helm get manifest my-nginx
```

---

## Step 4: Customize Using Values

View Default Values:

```bash
helm show values bitnami/nginx
```

Install With Overrides:

```bash
helm install nginx-prod bitnami/nginx \
--set replicaCount=3 \
--set service.type=NodePort
```

---

### custom-values.yaml

```yaml
replicaCount: 3

service:
  type: NodePort

resources:
  limits:
    cpu: 500m
    memory: 512Mi
```

Install Using Values File:

```bash
helm install nginx-custom bitnami/nginx \
-f custom-values.yaml
```

Verify:

```bash
helm get values nginx-custom
```

---

## Step 5: Upgrade Release

Scale Replicas:

```bash
helm upgrade my-nginx bitnami/nginx \
--set replicaCount=5
```

Verify:

```bash
kubectl get pods
```

---

## Step 6: Rollback Release

Check History:

```bash
helm history my-nginx
```

Rollback:

```bash
helm rollback my-nginx 1
```

Verify:

```bash
helm history my-nginx
```

Expected:

```text
Revision 1 → Install

Revision 2 → Upgrade

Revision 3 → Rollback
```

---

## Step 7: Create Custom Chart

Generate Chart:

```bash
helm create my-app
```

Chart Structure:

```text
my-app/

├── Chart.yaml
├── values.yaml
└── templates/
    ├── deployment.yaml
    ├── service.yaml
    └── ingress.yaml
```

---

### Update values.yaml

```yaml
replicaCount: 3

image:
  repository: nginx
  tag: "1.25"
```

---

### Validate Chart

```bash
helm lint my-app
```

---

### Preview Templates

```bash
helm template my-release ./my-app
```

---

### Install Chart

```bash
helm install my-release ./my-app
```

Verify:

```bash
kubectl get pods
```

Expected:

```text
3 Replicas Running
```

---

### Upgrade Chart

```bash
helm upgrade my-release ./my-app \
--set replicaCount=5
```

Verify:

```bash
kubectl get pods
```

Expected:

```text
5 Replicas Running
```

---

# Go Template Examples

Helm uses Go Templates.

Replica Count:

```yaml
replicas: {{ .Values.replicaCount }}
```

Chart Name:

```yaml
{{ .Chart.Name }}
```

Release Name:

```yaml
{{ .Release.Name }}
```

Image Repository:

```yaml
{{ .Values.image.repository }}
```

---

# Important Commands

```bash
helm version

helm repo add

helm repo update

helm search repo

helm install

helm list

helm status

helm get values

helm get manifest

helm upgrade

helm rollback

helm history

helm lint

helm template

helm uninstall
```

---

# Interview Questions

## What is Helm?

Helm is a Kubernetes package manager used to deploy and manage applications using reusable Charts.

---

## Difference Between Chart and Release?

| Chart     | Release             |
| --------- | ------------------- |
| Blueprint | Installed Instance  |
| Template  | Running Application |

---

## What is values.yaml?

Used to customize chart configurations without modifying templates.

---

## What is Helm Rollback?

Reverts an application to a previous release revision.

---

## What is helm template?

Renders Kubernetes YAML locally without deploying.

---

# Key Learnings

✅ Installed Helm

✅ Added Bitnami Repository

✅ Installed Nginx Chart

✅ Customized Values

✅ Performed Upgrade

✅ Performed Rollback

✅ Created Custom Chart

✅ Used Go Templates

✅ Learned Release Management

---

# Cleanup

```bash
helm uninstall my-nginx

helm uninstall nginx-prod

helm uninstall nginx-custom

helm uninstall my-release
```

Verify:

```bash
helm list
```

Expected:

```text
No Releases Found
```

---

# Conclusion

Today I learned Helm, the Kubernetes Package Manager. I deployed applications using Charts, customized configurations with values.yaml, performed upgrades and rollbacks, and created my own Helm Chart from scratch.

Helm simplifies Kubernetes application deployment by replacing dozens of YAML files with a single reusable and version-controlled package.

