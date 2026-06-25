# 🚀 Day 59 – Helm: Kubernetes Package Manager

## 📌 Objective

Learn Helm, the Kubernetes Package Manager, to simplify application deployment using reusable Charts. Deploy applications, customize configurations, perform upgrades & rollbacks, and create your own Helm Chart.

---

# 📖 What is Helm?

Helm is the **Package Manager for Kubernetes**.

Instead of writing multiple YAML files manually, Helm packages them into a reusable **Chart**.

Example:

```
Without Helm

Deployment.yaml
Service.yaml
ConfigMap.yaml
Secret.yaml
Ingress.yaml
PVC.yaml
HPA.yaml

↓

Many YAML Files
```

```
With Helm

Helm Chart
     │
     ▼
helm install
     │
     ▼
All Kubernetes Resources Created
```

Similar to:

```
APT      → Ubuntu

YUM      → RHEL

Helm     → Kubernetes
```

---

# Why Helm?

Without Helm

```
Deployment
Service
ConfigMap
Secret
PVC
Ingress
HPA

Manage Separately
```

With Helm

```
One Chart

↓

Everything Managed Together
```

Benefits

* Reusable
* Version Controlled
* Easy Upgrade
* Easy Rollback
* Environment Specific Configurations
* Production Standard

---

# Helm Architecture

```
Developer

     │

helm install

     │

Helm Client

     │

Chart Templates

     │

Values.yaml

     │

Kubernetes API

     │

Cluster Resources
```

---

# Helm Core Concepts

## 1. Chart

A package containing Kubernetes manifests.

Example

```
Chart

Deployment

Service

ConfigMap

Secret

Ingress

PVC
```

---

## 2. Release

An installed instance of a Chart.

Example

```
Chart

bitnami/nginx

↓

helm install my-nginx

↓

Release

my-nginx
```

---

## 3. Repository

A collection of Charts.

Example

```
Bitnami

ArtifactHub

Internal Helm Repo
```

---

# Install Helm

### Linux

```bash
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
```

### Verify Installation

```bash
helm version
```

Expected

```text
version.BuildInfo{
Version:"v3.x.x"
}
```

Check Environment

```bash
helm env
```

---

# Helm Repository

Add Bitnami Repository

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
```

Update Repository

```bash
helm repo update
```

List Repositories

```bash
helm repo list
```

Output

```
NAME        URL

bitnami     https://charts.bitnami.com/bitnami
```

---

# Search Charts

Search Nginx

```bash
helm search repo nginx
```

Search All Bitnami Charts

```bash
helm search repo bitnami
```

Search MySQL

```bash
helm search repo mysql
```

---

# Install Nginx Chart

```bash
helm install my-nginx bitnami/nginx
```

Verify Release

```bash
helm list
```

Output

```
NAME

my-nginx
```

---

Check Status

```bash
helm status my-nginx
```

---

View Kubernetes Resources

```bash
kubectl get all
```

Expected

```
Deployment

ReplicaSet

Pods

Service
```

---

View Rendered YAML

```bash
helm get manifest my-nginx
```

---

# Customize Helm Values

See Default Values

```bash
helm show values bitnami/nginx
```

Install with Overrides

```bash
helm install nginx-prod bitnami/nginx \
--set replicaCount=3 \
--set service.type=NodePort
```

Verify

```bash
kubectl get pods

kubectl get svc
```

Expected

```
3 Pods Running

Service = NodePort
```

---

# Create custom-values.yaml

```yaml
replicaCount: 3

service:
  type: NodePort

resources:
  requests:
    cpu: 100m
    memory: 128Mi

  limits:
    cpu: 500m
    memory: 512Mi
```

Install Using Values File

```bash
helm install nginx-custom bitnami/nginx \
-f custom-values.yaml
```

Verify

```bash
helm get values nginx-custom
```

Expected

```text
replicaCount: 3

service:
  type: NodePort
```

---

# Upgrade Release

Increase Replicas

```bash
helm upgrade my-nginx bitnami/nginx \
--set replicaCount=5
```

Verify

```bash
kubectl get pods
```

Expected

```
5 Pods Running
```

---

# Rollback Release

Check History

```bash
helm history my-nginx
```

Output

```
REVISION

1 Install

2 Upgrade
```

Rollback

```bash
helm rollback my-nginx 1
```

Verify

```bash
helm history my-nginx
```

Expected

```
Revision 1 Install

Revision 2 Upgrade

Revision 3 Rollback
```

---

# Important Helm Commands

```bash
helm version

helm env

helm repo add

helm repo update

helm repo list

helm search repo

helm install

helm list

helm status

helm get values

helm get manifest

helm upgrade

helm rollback

helm history

helm uninstall
```
---

# 🛠 Part 2 – Create Your Own Helm Chart

## Step 1: Create a Chart

```bash
helm create my-app
```

Folder Structure

```text
my-app/

├── Chart.yaml
├── values.yaml
├── .helmignore
├── charts/

└── templates/
    ├── deployment.yaml
    ├── service.yaml
    ├── serviceaccount.yaml
    ├── ingress.yaml
    ├── hpa.yaml
    ├── _helpers.tpl
    ├── NOTES.txt
```

---

# Chart.yaml

```yaml
apiVersion: v2
name: my-app
description: A sample Helm Chart for Kubernetes
type: application

version: 0.1.0

appVersion: "1.25"
```

Explanation

```text
apiVersion → Helm API Version

name → Chart Name

description → Chart Description

type → application

version → Chart Version

appVersion → Application Version
```

---

# values.yaml

```yaml
replicaCount: 3

image:
  repository: nginx
  pullPolicy: IfNotPresent
  tag: "1.25"

service:
  type: ClusterIP
  port: 80

resources:

  requests:
    cpu: 100m
    memory: 128Mi

  limits:
    cpu: 500m
    memory: 512Mi

autoscaling:

  enabled: false

serviceAccount:
  create: true

ingress:
  enabled: false
```

---

# deployment.yaml

```yaml
apiVersion: apps/v1
kind: Deployment

metadata:
  name: {{ .Release.Name }}

spec:
  replicas: {{ .Values.replicaCount }}

  selector:
    matchLabels:
      app: {{ .Release.Name }}

  template:

    metadata:
      labels:
        app: {{ .Release.Name }}

    spec:

      containers:

      - name: nginx

        image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"

        imagePullPolicy: {{ .Values.image.pullPolicy }}

        ports:

        - containerPort: 80

        resources:

          {{- toYaml .Values.resources | nindent 10 }}
```

---

# service.yaml

```yaml
apiVersion: v1
kind: Service

metadata:
  name: {{ .Release.Name }}

spec:

  selector:

    app: {{ .Release.Name }}

  type: {{ .Values.service.type }}

  ports:

  - port: {{ .Values.service.port }}

    targetPort: 80
```

---

# serviceaccount.yaml

```yaml
{{- if .Values.serviceAccount.create }}

apiVersion: v1

kind: ServiceAccount

metadata:

  name: {{ .Release.Name }}

{{- end }}
```

---

# ingress.yaml

```yaml
{{- if .Values.ingress.enabled }}

apiVersion: networking.k8s.io/v1

kind: Ingress

metadata:

  name: {{ .Release.Name }}

spec:

  rules:

  - http:

      paths:

      - path: /

        pathType: Prefix

        backend:

          service:

            name: {{ .Release.Name }}

            port:

              number: 80

{{- end }}
```

---

# hpa.yaml

```yaml
{{- if .Values.autoscaling.enabled }}

apiVersion: autoscaling/v2

kind: HorizontalPodAutoscaler

metadata:

  name: {{ .Release.Name }}

spec:

  scaleTargetRef:

    apiVersion: apps/v1

    kind: Deployment

    name: {{ .Release.Name }}

  minReplicas: 2

  maxReplicas: 10

  metrics:

  - type: Resource

    resource:

      name: cpu

      target:

        type: Utilization

        averageUtilization: 50

{{- end }}
```

---

# _helpers.tpl

```yaml
{{- define "my-app.name" -}}

{{ .Chart.Name }}

{{- end }}

{{- define "my-app.fullname" -}}

{{ .Release.Name }}

{{- end }}
```

---

# NOTES.txt

```text
Application Installed Successfully!

Check Pods

kubectl get pods

Check Service

kubectl get svc

Port Forward

kubectl port-forward svc/{{ .Release.Name }} 8080:80

Open Browser

http://localhost:8080
```

---

# Validate Chart

```bash
helm lint my-app
```

Expected

```text
1 chart(s) linted

0 chart(s) failed
```

---

# Preview Templates

Without Installing

```bash
helm template my-release ./my-app
```

This generates Kubernetes YAML locally.

---

# Install Chart

```bash
helm install my-release ./my-app
```

Verify

```bash
helm list

kubectl get pods

kubectl get svc
```

Expected

```text
NAME

my-release
```

```text
3 Pods Running
```

---

# Upgrade Chart

Increase Replicas

```bash
helm upgrade my-release ./my-app \
--set replicaCount=5
```

Verify

```bash
kubectl get pods
```

Expected

```text
5 Pods Running
```

---

# Upgrade Image Version

```bash
helm upgrade my-release ./my-app \
--set image.tag=1.26
```

Verify

```bash
kubectl describe deployment my-release
```

Image

```text
nginx:1.26
```

---

# Change Service Type

```bash
helm upgrade my-release ./my-app \
--set service.type=NodePort
```

Verify

```bash
kubectl get svc
```

Expected

```text
TYPE

NodePort
```

---

# Render Values

```bash
helm get values my-release
```

Output

```text
replicaCount: 5

service:

type: NodePort
```

---

# Helm Templating Examples

Replica Count

```yaml
replicas: {{ .Values.replicaCount }}
```

Image

```yaml
image:

{{ .Values.image.repository }}:{{ .Values.image.tag }}
```

Release Name

```yaml
{{ .Release.Name }}
```

Chart Name

```yaml
{{ .Chart.Name }}
```

Resources

```yaml
{{- toYaml .Values.resources | nindent 10 }}
```

---
# 🚀 Part 3 – Helm Lifecycle, Rollback, Best Practices & Interview Preparation

---

# Helm Release Lifecycle

```text
Developer

     │

helm install

     │

Release v1

     │

helm upgrade

     │

Release v2

     │

helm upgrade

     │

Release v3

     │

helm rollback

     │

Release v4 (Rollback to v2)
```

Every upgrade creates a **new revision**.

Rollback **never deletes history**.

---

# Helm History

View Release History

```bash
helm history my-release
```

Example

```text
REVISION    STATUS

1           deployed

2           superseded

3           deployed
```

---

# Rollback Release

Rollback to Revision 1

```bash
helm rollback my-release 1
```

Verify

```bash
helm history my-release
```

Output

```text
Revision 1 → Install

Revision 2 → Upgrade

Revision 3 → Rollback
```

Check Deployment

```bash
kubectl get pods
```

---

# Helm Commands Cheat Sheet

## Repository

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami

helm repo update

helm repo list

helm search repo nginx
```

---

## Install

```bash
helm install my-release bitnami/nginx
```

---

## List Releases

```bash
helm list
```

---

## Status

```bash
helm status my-release
```

---

## Values

```bash
helm get values my-release

helm get values my-release --all
```

---

## Manifest

```bash
helm get manifest my-release
```

---

## Upgrade

```bash
helm upgrade my-release ./my-app

helm upgrade my-release ./my-app \
--set replicaCount=5
```

---

## Rollback

```bash
helm rollback my-release 1
```

---

## History

```bash
helm history my-release
```

---

## Validate

```bash
helm lint my-app
```

---

## Preview YAML

```bash
helm template my-release ./my-app
```

---

## Uninstall

```bash
helm uninstall my-release
```

---

# Helm vs kubectl

| kubectl             | Helm                 |
| ------------------- | -------------------- |
| Deploys YAML files  | Deploys Charts       |
| Manual Management   | Package Management   |
| No Version History  | Release History      |
| Manual Rollback     | One Command Rollback |
| Multiple YAML Files | Single Chart         |

---

# Helm Chart Workflow

```text
Create Chart

↓

Edit values.yaml

↓

Edit Templates

↓

helm lint

↓

helm template

↓

helm install

↓

helm upgrade

↓

helm rollback

↓

helm uninstall
```

---

# Production Best Practices

## Use values.yaml

Avoid hardcoding values.

✅ Good

```yaml
replicaCount: 3
```

❌ Bad

```yaml
replicas: 3
```

inside deployment.yaml

---

## Validate Before Deploying

```bash
helm lint my-app
```

---

## Preview YAML

```bash
helm template my-release ./my-app
```

Never install without checking rendered manifests.

---

## Use Git

Store Helm Charts in GitHub.

```text
Git

↓

CI/CD

↓

Helm

↓

Kubernetes
```

---

## Use Versioning

Example

```text
Chart Version

0.1.0

↓

0.2.0

↓

1.0.0
```

---

## Store Secrets Securely

Don't store passwords inside values.yaml.

Use

* Kubernetes Secrets
* External Secrets
* HashiCorp Vault

---

## Keep Charts Modular

Separate

* Deployment
* Service
* ConfigMap
* Secret
* Ingress
* HPA

---

# Real Production Workflow

```text
Developer

↓

Git Push

↓

Jenkins

↓

Docker Build

↓

DockerHub

↓

Helm Upgrade

↓

Kubernetes Cluster
```

---

# Interview Questions

## What is Helm?

Helm is the package manager for Kubernetes that simplifies application deployment using reusable Charts.

---

## What is a Chart?

A Helm Chart is a package containing Kubernetes templates such as Deployments, Services, ConfigMaps, Secrets, PVCs, and Ingress.

---

## What is a Release?

A Release is a deployed instance of a Helm Chart.

Example

```text
Chart

↓

bitnami/nginx

↓

Release

my-nginx
```

---

## Difference Between Chart and Release

| Chart     | Release             |
| --------- | ------------------- |
| Blueprint | Installed Instance  |
| Template  | Running Application |
| Reusable  | Unique Deployment   |

---

## What is values.yaml?

A configuration file used to customize Helm Charts without modifying templates.

---

## What is helm upgrade?

Updates an existing release with new configurations.

Example

```bash
helm upgrade my-release ./my-app \
--set replicaCount=5
```

---

## What is helm rollback?

Reverts a release to a previous revision.

```bash
helm rollback my-release 1
```

---

## What is helm template?

Generates Kubernetes YAML without deploying.

```bash
helm template my-release ./my-app
```

---

## What is helm lint?

Checks a Helm Chart for syntax and structural errors.

```bash
helm lint my-app
```

---

## Why use Helm?

* Faster Deployments
* Reusable Templates
* Easy Rollback
* Version Control
* Environment-specific Configurations
* Production Ready

---

# Cleanup

List Releases

```bash
helm list
```

Remove Releases

```bash
helm uninstall my-release

helm uninstall my-nginx

helm uninstall nginx-prod

helm uninstall nginx-custom
```

Verify

```bash
helm list
```

Expected

```text
No Releases Found
```

Delete Chart

```bash
rm -rf my-app

rm custom-values.yaml
```

---
