# Day 52 – Kubernetes Namespaces and Deployments

## 🎯 Objective

Learn Kubernetes Namespaces for resource isolation and Deployments for self-healing, scaling, rolling updates, and rollbacks.

---

# What is a Namespace?

A Namespace is a logical partition inside a Kubernetes cluster used to organize and isolate resources.

### Benefits

* Environment Separation (Dev, Staging, Prod)
* Resource Organization
* Access Control
* Multi-Tenancy

---

# Default Namespaces

List namespaces:

```bash
kubectl get namespaces
```

Default namespaces:

| Namespace       | Purpose                    |
| --------------- | -------------------------- |
| default         | User resources             |
| kube-system     | Kubernetes components      |
| kube-public     | Public cluster information |
| kube-node-lease | Node heartbeat tracking    |

Check system pods:

```bash
kubectl get pods -n kube-system
```

---

# Create Custom Namespaces

## Imperative Method

```bash
kubectl create namespace dev

kubectl create namespace staging
```

Verify:

```bash
kubectl get ns
```
<img width="1168" height="339" alt="image" src="https://github.com/user-attachments/assets/3aa43c22-1ec6-41f3-8cf5-a2a92aca0cb9" />

---

## Declarative Method

### namespace.yaml

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: production
```

Apply:

```bash
kubectl apply -f namespace.yaml
```

---

# Deploy Pods into Namespaces

```bash
kubectl run nginx-dev \
--image=nginx \
-n dev
```

```bash
kubectl run nginx-staging \
--image=nginx \
-n staging
```

Verify:

```bash
kubectl get pods -A
```

---

# Why Deployments?

### Standalone Pod

```text
Pod Deleted
     ↓
Gone Forever
```

### Deployment

```text
Pod Deleted
     ↓
Deployment Detects
     ↓
New Pod Created
```

Deployment provides:

* Self-Healing
* Scaling
* Rolling Updates
* Rollbacks
* High Availability

---

# Deployment Manifest

## nginx-deployment.yaml

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  namespace: dev
  labels:
    app: nginx

spec:
  replicas: 3

  selector:
    matchLabels:
      app: nginx

  template:
    metadata:
      labels:
        app: nginx

    spec:
      containers:
      - name: nginx
        image: nginx:1.24
        ports:
        - containerPort: 80
```

---

# Deployment Components

| Section    | Purpose                 |
| ---------- | ----------------------- |
| apiVersion | Deployment API          |
| kind       | Deployment Resource     |
| metadata   | Name & Labels           |
| replicas   | Desired Pod Count       |
| selector   | Select Pods             |
| template   | Pod Blueprint           |
| containers | Container Configuration |

---

# Create Deployment

```bash
kubectl apply -f nginx-deployment.yaml
```

Verify:

```bash
kubectl get deployments -n dev

kubectl get pods -n dev
```

Expected:

```text
NAME               READY   UP-TO-DATE   AVAILABLE
nginx-deployment   3/3     3            3
```
<img width="1366" height="715" alt="image" src="https://github.com/user-attachments/assets/f82dfb2a-2019-44d0-8998-b656d460275e" />

---

# Deployment Output Explained

| Column     | Meaning                     |
| ---------- | --------------------------- |
| READY      | Running Pods / Desired Pods |
| UP-TO-DATE | Updated Pods                |
| AVAILABLE  | Healthy Pods Available      |

---

# View ReplicaSets

Deployments create ReplicaSets automatically.

```bash
kubectl get rs -n dev
```

Architecture:

```text
Deployment
     ↓
ReplicaSet
     ↓
Pods
```

---

# Self-Healing Demo

List Pods:

```bash
kubectl get pods -n dev
```

Delete one Pod:

```bash
kubectl delete pod <pod-name> -n dev
```

Check again:

```bash
kubectl get pods -n dev
```

Result:

```text
Desired Pods = 3
Current Pods = 2

Deployment Creates New Pod
```

### Observation

Replacement Pod gets a different name.

---

# Scaling Deployment

## Scale Up

```bash
kubectl scale deployment nginx-deployment \
--replicas=5 \
-n dev
```

Verify:

```bash
kubectl get pods -n dev
```

---

## Scale Down

```bash
kubectl scale deployment nginx-deployment \
--replicas=2 \
-n dev
```

Verify:

```bash
kubectl get pods -n dev
```

### What Happens?

```text
5 Pods
 ↓
Scale Down
 ↓
2 Pods

Extra Pods Terminated
```

---

# Declarative Scaling

Update YAML:

```yaml
replicas: 4
```

Apply:

```bash
kubectl apply -f nginx-deployment.yaml
```

---

# Rolling Update

Current Image:

```text
nginx:1.24
```

Update:

```bash
kubectl set image deployment/nginx-deployment \
nginx=nginx:1.25 \
-n dev
```

Monitor:

```bash
kubectl rollout status deployment/nginx-deployment -n dev
```

Result:

```text
Old Pods Removed One By One

New Pods Created One By One
```

Zero Downtime Deployment.

---

# Rollout History

```bash
kubectl rollout history deployment/nginx-deployment -n dev
```

Example:

```text
REVISION
1
2
```

---

# Rollback Deployment

Rollback:

```bash
kubectl rollout undo deployment/nginx-deployment -n dev
```

Monitor:

```bash
kubectl rollout status deployment/nginx-deployment -n dev
```

Verify:

```bash
kubectl describe deployment nginx-deployment -n dev | grep Image
```

Expected:

```text
Image: nginx:1.24
```

---

# Namespace Commands

Current Namespace Resources:

```bash
kubectl get pods -n dev
```

All Namespaces:

```bash
kubectl get pods -A
```

Deployments:

```bash
kubectl get deployments -A
```

---

# Screenshots

## Deployments

```bash
kubectl get deployments -A
```

📸 Add Screenshot Here

---

## Pods

```bash
kubectl get pods -A
```

📸 Add Screenshot Here

---

# Cleanup

Delete Deployment:

```bash
kubectl delete deployment nginx-deployment -n dev
```

Delete Pods:

```bash
kubectl delete pod nginx-dev -n dev

kubectl delete pod nginx-staging -n staging
```

Delete Namespaces:

```bash
kubectl delete ns dev staging production
```

Verify:

```bash
kubectl get ns

kubectl get pods -A
```

---

# Standalone Pod vs Deployment

| Feature          | Pod | Deployment |
| ---------------- | --- | ---------- |
| Self-Healing     | ❌   | ✅          |
| Scaling          | ❌   | ✅          |
| Rolling Update   | ❌   | ✅          |
| Rollback         | ❌   | ✅          |
| Production Ready | ❌   | ✅          |

---

# Interview Questions

### What is a Namespace?

A logical partition inside a Kubernetes cluster used to isolate resources.

---

### Why use Deployments instead of Pods?

Deployments provide self-healing, scaling, rolling updates, and rollback capabilities.

---

### What happens when a Deployment Pod is deleted?

Deployment automatically creates a replacement Pod.

---

### Difference Between ReplicaSet and Deployment?

ReplicaSet maintains Pod count.

Deployment manages ReplicaSets and provides rolling updates and rollback.

---

### What is a Rolling Update?

Updating application versions without downtime by replacing Pods gradually.

---

### What is Rollback?

Reverting to a previous application version if an update fails.

---

# Key Learnings

✅ Created Namespaces

✅ Deployed Pods in Different Namespaces

✅ Created Deployment

✅ Learned ReplicaSets

✅ Performed Self-Healing Test

✅ Scaled Deployment Up & Down

✅ Performed Rolling Update

✅ Performed Rollback

✅ Cleaned Resources

---

