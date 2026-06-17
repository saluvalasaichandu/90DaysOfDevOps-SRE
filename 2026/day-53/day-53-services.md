# 🚀 Day 53 - Kubernetes Services

## 📌 Objective

Learn how Kubernetes Services provide stable networking and load balancing for Pods.

---

# 🧠 Theory

## Why Services?

Pods are ephemeral.

Problems:

* Pod IP changes after restart.
* Deployments run multiple Pods.
* Clients cannot reliably connect to Pod IPs.

Service provides:

* Stable IP
* Stable DNS Name
* Load Balancing

```text
Client
   |
Service
 / | \
Pod Pod Pod
```

---

# Service Types

| Type         | Access           | Use Case                 |
| ------------ | ---------------- | ------------------------ |
| ClusterIP    | Internal Cluster | Pod-to-Pod Communication |
| NodePort     | NodeIP:Port      | Testing & Development    |
| LoadBalancer | Public IP        | Production Access        |

---

# Kubernetes DNS

Every Service gets a DNS name:

```text
<service-name>.<namespace>.svc.cluster.local
```

Example:

```text
web-app-clusterip.default.svc.cluster.local
```

---

# Endpoints

Endpoints are Pod IPs behind a Service.

Check:

```bash
kubectl get endpoints
```

Example:

```text
web-app-clusterip
10.244.0.5
10.244.0.6
10.244.0.7
```

---

# 🛠 Practical Implementation

## Deployment

### app-deployment.yaml

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: web-app
  template:
    metadata:
      labels:
        app: web-app
    spec:
      containers:
      - name: nginx
        image: nginx:1.25
        ports:
        - containerPort: 80
```

Deploy:

```bash
kubectl apply -f app-deployment.yaml

kubectl get pods -o wide
```
<img width="1366" height="617" alt="image" src="https://github.com/user-attachments/assets/6fb96dbc-be71-4183-8e12-0c5aad14b816" />

---

## ClusterIP Service

### clusterip-service.yaml

```yaml
apiVersion: v1
kind: Service
metadata:
  name: web-app-clusterip
spec:
  type: ClusterIP
  selector:
    app: web-app
  ports:
  - port: 80
    targetPort: 80
```

Apply:

```bash
kubectl apply -f clusterip-service.yaml

kubectl get svc
```

Test:

```bash
kubectl run test-client \
--image=busybox \
--rm -it \
--restart=Never -- sh

wget -qO- http://web-app-clusterip
```

---

## NodePort Service

### nodeport-service.yaml

```yaml
apiVersion: v1
kind: Service
metadata:
  name: web-app-nodeport
spec:
  type: NodePort
  selector:
    app: web-app
  ports:
  - port: 80
    targetPort: 80
    nodePort: 30080
```

Apply:

```bash
kubectl apply -f nodeport-service.yaml

kubectl get svc
```

Access:

```bash
http://<NodeIP>:30080
```

---

## LoadBalancer Service

### loadbalancer-service.yaml

```yaml
apiVersion: v1
kind: Service
metadata:
  name: web-app-loadbalancer
spec:
  type: LoadBalancer
  selector:
    app: web-app
  ports:
  - port: 80
    targetPort: 80
```

Apply:

```bash
kubectl apply -f loadbalancer-service.yaml

kubectl get svc
```

Local Cluster:

```text
EXTERNAL-IP = <pending>
```

Minikube:

```bash
minikube tunnel
```

---

# Verification Commands

```bash
kubectl get pods

kubectl get svc

kubectl get endpoints

kubectl describe svc web-app-loadbalancer
```

---

# Key Learning

✅ Services provide stable networking for Pods

✅ ClusterIP enables internal communication

✅ NodePort exposes applications via Node IP

✅ LoadBalancer provides external access in cloud

✅ Kubernetes DNS enables service discovery

✅ Endpoints show actual Pods receiving traffic

---

# Cleanup

```bash
kubectl delete -f app-deployment.yaml

kubectl delete -f clusterip-service.yaml

kubectl delete -f nodeport-service.yaml

kubectl delete -f loadbalancer-service.yaml
```

Verify:

```bash
kubectl get pods

kubectl get svc
```

---

# Interview Questions

### Why do we need Kubernetes Services?

Services provide stable IP addresses, DNS names, and load balancing for Pods whose IPs change frequently.

### Difference between ClusterIP, NodePort and LoadBalancer?

* ClusterIP → Internal Access
* NodePort → External Access via Node IP
* LoadBalancer → External Access via Cloud Load Balancer

### What are Endpoints?

Endpoints are the actual Pod IPs behind a Service.

### How does Kubernetes DNS work?

Each Service automatically gets a DNS name which resolves to the Service ClusterIP.

---
