# Day 51 – Kubernetes Manifests and Your First Pods

## 🎯 Objective

Learn Kubernetes manifests, create Pods from YAML files, explore running containers, understand imperative vs declarative approaches, and work with labels.

---

# What is a Pod?

A Pod is the smallest deployable unit in Kubernetes.

A Pod can contain:

* One Container (Most Common)
* Multiple Containers (Sidecar Pattern)

```text
Pod
 └── Container
       └── Application
```

---

# Kubernetes Manifest Structure

Every Kubernetes resource contains four mandatory fields:

| Field      | Purpose                 |
| ---------- | ----------------------- |
| apiVersion | Kubernetes API version  |
| kind       | Resource type           |
| metadata   | Name, labels, namespace |
| spec       | Desired configuration   |

Example:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
spec:
  containers:
  - name: nginx
    image: nginx
```

---

# Pod 1: Nginx Pod

## nginx-pod.yaml

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
  labels:
    app: nginx
spec:
  containers:
  - name: nginx
    image: nginx:latest
    ports:
    - containerPort: 80
```

## Deploy Pod

```bash
kubectl apply -f nginx-pod.yaml
```

## Verify

```bash
kubectl get pods
kubectl get pods -o wide
```

## Inspect Pod

```bash
kubectl describe pod nginx-pod
kubectl logs nginx-pod
kubectl exec -it nginx-pod -- /bin/bash
```

Inside Pod:

```bash
curl localhost:80
```

Expected Output:

```text
Welcome to nginx!
```

---

# Pod 2: BusyBox Pod

## busybox-pod.yaml

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: busybox-pod
  labels:
    app: busybox
    environment: dev
spec:
  containers:
  - name: busybox
    image: busybox:latest
    command: ["sh","-c","echo Hello from BusyBox && sleep 3600"]
```

## Deploy

```bash
kubectl apply -f busybox-pod.yaml
```

## Verify

```bash
kubectl get pods
kubectl logs busybox-pod
```

Expected:

```text
Hello from BusyBox
```

### Why command is required?

BusyBox does not run a server process.

Without a long-running command:

```text
Container Exits
      ↓
Pod Fails
      ↓
CrashLoopBackOff
```

---

# Pod 3: Custom Pod with Multiple Labels

## devops-pod.yaml

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: devops-pod
  labels:
    app: apache
    environment: dev
    team: platform
spec:
  containers:
  - name: apache
    image: httpd:latest
    ports:
    - containerPort: 80
```

Deploy:

```bash
kubectl apply -f devops-pod.yaml
```

---

# Imperative vs Declarative

## Imperative Approach

Create resources directly from command line.

```bash
kubectl run redis-pod --image=redis:latest
```

Advantages:

* Fast
* Useful for testing

Disadvantages:

* Not version controlled
* Not reusable

---

## Declarative Approach

Create resources using YAML files.

```bash
kubectl apply -f nginx-pod.yaml
```

Advantages:

* Reusable
* Version controlled
* Production standard

---

# Generate YAML Using Dry Run

Generate Manifest:

```bash
kubectl run test-pod \
--image=nginx \
--dry-run=client -o yaml
```

Save to file:

```bash
kubectl run test-pod \
--image=nginx \
--dry-run=client -o yaml > test-pod.yaml
```

---

# Validate Manifest Before Deployment

Client Validation:

```bash
kubectl apply -f nginx-pod.yaml --dry-run=client
```

Server Validation:

```bash
kubectl apply -f nginx-pod.yaml --dry-run=server
```

Example Error:

```text
spec.containers[0].image: Required value
```

Occurs when image field is missing.

---

# Working with Labels

## View Labels

```bash
kubectl get pods --show-labels
```

Example:

```text
NAME          LABELS
nginx-pod     app=nginx
busybox-pod   app=busybox,environment=dev
```

---

## Filter by Label

```bash
kubectl get pods -l app=nginx

kubectl get pods -l environment=dev

kubectl get pods -l team=platform
```

---

## Add Label

```bash
kubectl label pod nginx-pod environment=production
```

Verify:

```bash
kubectl get pods --show-labels
```

---

## Remove Label

```bash
kubectl label pod nginx-pod environment-
```

---

# Screenshot

## Running Pods

```text
[Screenshot Here]
```

Command:

```bash
kubectl get pods
```

Example:

```text
NAME          READY   STATUS
nginx-pod     1/1     Running
busybox-pod   1/1     Running
devops-pod    1/1     Running
```

---

# Delete Pods

Delete Individual Pods:

```bash
kubectl delete pod nginx-pod

kubectl delete pod busybox-pod

kubectl delete pod redis-pod

kubectl delete pod devops-pod
```

Delete Using YAML:

```bash
kubectl delete -f nginx-pod.yaml
```

Verify:

```bash
kubectl get pods
```

---

# What Happens When a Standalone Pod is Deleted?

```text
Pod Deleted
     ↓
Gone Forever
```

Reason:

* No Deployment
* No ReplicaSet
* No Controller

Kubernetes will NOT recreate it automatically.

---

# Key Learnings

✅ Learned Kubernetes Manifest Structure

✅ Created Nginx Pod

✅ Created BusyBox Pod

✅ Created Custom Pod

✅ Used kubectl apply

✅ Used kubectl logs

✅ Used kubectl exec

✅ Used Labels and Selectors

✅ Learned Imperative vs Declarative Approach

✅ Generated YAML using Dry Run

✅ Validated Manifests

✅ Deleted Pods

---

# Interview Questions

### What are the four mandatory fields in a Kubernetes Manifest?

* apiVersion
* kind
* metadata
* spec

### What is a Pod?

The smallest deployable unit in Kubernetes that runs one or more containers.

### Difference between kubectl run and kubectl apply?

| kubectl run | kubectl apply |
| ----------- | ------------- |
| Imperative  | Declarative   |
| CLI Based   | YAML Based    |
| Temporary   | Reusable      |
| Testing     | Production    |

### What does kubectl logs do?

Displays container stdout and stderr logs.

### What happens if a standalone Pod is deleted?

It is permanently removed because no controller exists to recreate it.

---
