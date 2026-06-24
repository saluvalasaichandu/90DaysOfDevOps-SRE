# 🚀 Day 58 - Kubernetes Metrics Server & Horizontal Pod Autoscaler (HPA)

## 📌 Objective

Learn how Kubernetes automatically scales applications based on CPU utilization using Metrics Server and HPA.

---

# 🧠 Theory

## What is Metrics Server?

Metrics Server collects CPU and Memory usage metrics from Kubernetes Nodes and Pods.

Used by:

* `kubectl top`
* Horizontal Pod Autoscaler (HPA)

Architecture:

```text
User
 ↓
kubectl top
 ↓
Metrics Server
 ↓
Kubelet
 ↓
Node Metrics
```

---

## What is HPA?

Horizontal Pod Autoscaler (HPA) automatically increases or decreases Pod replicas based on resource utilization.

Example:

```text
1 Pod
 ↓ High CPU
3 Pods
 ↓ High CPU
5 Pods
```

Benefits:

* Auto Scaling
* High Availability
* Better Performance
* Cost Optimization

---

## HPA Formula

```text
Desired Replicas =
ceil(Current Replicas × Current CPU / Target CPU)
```

Example:

```text
Current Replicas = 2
Current CPU = 80%
Target CPU = 50%

Desired Replicas =
2 × (80/50)
= 3.2
= 4 Pods
```

---

# 🛠 Practical Implementation

## Step 1: Install Metrics Server

### Minikube

```bash
minikube addons enable metrics-server
```

Verify:

```bash
kubectl get pods -n kube-system

kubectl top nodes

kubectl top pods -A
```

---

## Step 2: Create Deployment

### deployment.yaml

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: php-apache
spec:
  replicas: 1
  selector:
    matchLabels:
      app: php-apache
  template:
    metadata:
      labels:
        app: php-apache
    spec:
      containers:
      - name: php-apache
        image: registry.k8s.io/hpa-example
        ports:
        - containerPort: 80
        resources:
          requests:
            cpu: 200m
```

Apply:

```bash
kubectl apply -f deployment.yaml
```

Expose Service:

```bash
kubectl expose deployment php-apache --port=80
```

Verify:

```bash
kubectl get pods
kubectl get svc
```

---

## Step 3: Create HPA (Imperative)

```bash
kubectl autoscale deployment php-apache \
--cpu-percent=50 \
--min=1 \
--max=10
```

Verify:

```bash
kubectl get hpa

kubectl describe hpa php-apache
```

Expected:

```text
TARGETS 0%/50%
```

---

## Step 4: Generate Load

```bash
kubectl run load-generator \
--image=busybox:1.36 \
--restart=Never \
-- /bin/sh -c \
"while true; do wget -q -O- http://php-apache; done"
```

Watch HPA:

```bash
kubectl get hpa -w
```

Watch Pods:

```bash
kubectl get pods -w
```

Expected:

```text
1 Pod
 ↓
3 Pods
 ↓
5 Pods
```

---

## Step 5: Create HPA using YAML

### hpa.yaml

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: php-apache
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: php-apache

  minReplicas: 1
  maxReplicas: 10

  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 50

  behavior:
    scaleUp:
      stabilizationWindowSeconds: 0

    scaleDown:
      stabilizationWindowSeconds: 300
```

Apply:

```bash
kubectl apply -f hpa.yaml
```

Verify:

```bash
kubectl describe hpa php-apache
```

---

# HPA Workflow

```text
User Traffic
      ↓
Application
      ↓
CPU Usage Increases
      ↓
Metrics Server
      ↓
HPA
      ↓
Scale Pods
      ↓
Application Stable
```

---

# Important Commands

```bash
kubectl top nodes

kubectl top pods -A

kubectl get hpa

kubectl describe hpa

kubectl get pods -w

kubectl get svc
```

---

# Interview Questions

### What is Metrics Server?

Metrics Server collects CPU and Memory metrics from Nodes and Pods and provides them to Kubernetes components like HPA.

### Why does HPA need CPU Requests?

HPA calculates CPU utilization as a percentage of requested CPU. Without CPU requests, HPA cannot calculate scaling targets.

### Difference Between HPA v1 and HPA v2?

| HPA v1        | HPA v2                       |
| ------------- | ---------------------------- |
| CPU Only      | CPU, Memory & Custom Metrics |
| Basic Scaling | Advanced Scaling Policies    |

### What can HPA scale?

* Deployments
* StatefulSets
* ReplicaSets

---

# Key Learnings

✅ Installed Metrics Server

✅ Used kubectl top

✅ Created CPU-based HPA

✅ Generated Load

✅ Observed Auto Scaling

✅ Learned HPA Formula

✅ Implemented HPA using YAML

✅ Explored autoscaling/v2

---

# Cleanup

```bash
kubectl delete hpa php-apache

kubectl delete deployment php-apache

kubectl delete svc php-apache

kubectl delete pod load-generator
```

---

# Conclusion

Today I learned how Kubernetes automatically scales applications using Metrics Server and HPA. By monitoring real-time CPU utilization, Kubernetes can dynamically increase or decrease Pod replicas to handle production workloads efficiently.
