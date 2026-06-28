# 🚀 Day 60 - Kubernetes Capstone Project
# Deploy WordPress + MySQL on Kubernetes

## 📌 Objective

Build a production-style WordPress + MySQL application using all major Kubernetes concepts learned so far.

This project covers:

- Namespace
- Secrets
- ConfigMaps
- StatefulSets
- Deployments
- Headless Service
- NodePort Service
- Persistent Volumes
- Resource Requests & Limits
- Liveness Probe
- Readiness Probe
- Horizontal Pod Autoscaler (HPA)
- Helm Comparison

---

# Architecture

```

                    Internet
                        │
                NodePort Service
                        │
        ----------------------------
        │                          │
 WordPress Pod-1             WordPress Pod-2
        │                          │
        ------------Service---------
                    │
              ConfigMap
                    │
         Secret (DB Credentials)
                    │
         Headless Service (MySQL)
                    │
              MySQL StatefulSet
                    │
                 Persistent Volume
                    │
                Persistent Storage

```

---

# Project Workflow

```

User
   │
Browser
   │
NodePort Service
   │
WordPress Deployment
   │
ConfigMap + Secret
   │
Headless Service
   │
MySQL StatefulSet
   │
Persistent Volume

```

---

# Prerequisites

- Kubernetes Cluster (Minikube / Kind)
- kubectl
- StorageClass
- Metrics Server
- Docker Installed

Verify

```bash
kubectl cluster-info

kubectl get nodes

kubectl get storageclass
```

---

# Folder Structure

```

day-60/

│── namespace.yaml
│── mysql-secret.yaml
│── mysql-headless-service.yaml
│── mysql-statefulset.yaml
│── wordpress-configmap.yaml
│── wordpress-deployment.yaml
│── wordpress-service.yaml
│── wordpress-hpa.yaml
│── README.md

```

---

# Step 1: Create Namespace

Why Namespace?

Namespaces logically isolate applications inside a cluster.

Example

```

Development

Testing

Production

```

Create Namespace

### namespace.yaml

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: capstone
```

Apply

```bash
kubectl apply -f namespace.yaml
```

Verify

```bash
kubectl get ns
```

Expected

```
NAME
capstone
default
kube-system
```

Set Default Namespace

```bash
kubectl config set-context --current --namespace=capstone
```

Verify

```bash
kubectl config view --minify
```
<img width="1366" height="728" alt="image" src="https://github.com/user-attachments/assets/8c28befc-11b7-4f06-bc71-b2a4fd7fb3ac" />

---

# Step 2: Create MySQL Secret

Why Secret?

Secrets securely store sensitive information like:

- Passwords
- API Keys
- Tokens
- Certificates

Never hardcode passwords inside YAML.

---

### mysql-secret.yaml

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: mysql-secret
type: Opaque

stringData:
  MYSQL_ROOT_PASSWORD: root123
  MYSQL_DATABASE: wordpress
  MYSQL_USER: wpuser
  MYSQL_PASSWORD: wordpress123
```

Apply

```bash
kubectl apply -f mysql-secret.yaml
```

Verify

```bash
kubectl get secret

kubectl describe secret mysql-secret
```

Expected

```
mysql-secret
```
<img width="1366" height="726" alt="image" src="https://github.com/user-attachments/assets/b63688bf-13ce-4218-82a3-8b161adc790f" />

---

# Step 3: Create Headless Service

Why Headless Service?

StatefulSets require stable DNS.

Instead of

```
mysql-service
```

Each Pod gets

```
mysql-0.mysql

mysql-1.mysql

mysql-2.mysql
```

Perfect for databases.

---

### mysql-headless-service.yaml

```yaml
apiVersion: v1
kind: Service
metadata:
  name: mysql

spec:
  clusterIP: None

  selector:
    app: mysql

  ports:
  - port: 3306
    targetPort: 3306
```

Apply

```bash
kubectl apply -f mysql-headless-service.yaml
```

Verify

```bash
kubectl get svc
```

Expected

```
NAME      TYPE       CLUSTER-IP

mysql     ClusterIP  None
```
<img width="1366" height="505" alt="image" src="https://github.com/user-attachments/assets/d2e06fcc-e198-47b3-aa8d-1d5efcf04704" />

---

# Step 4: Deploy MySQL StatefulSet

Why StatefulSet?

Databases require:

- Stable Pod Names
- Stable Storage
- Stable Network Identity

Deployment ❌

```
mysql-abcd

mysql-xxyz
```

StatefulSet ✅

```
mysql-0

mysql-1

mysql-2
```

---

### mysql-statefulset.yaml

```yaml
apiVersion: apps/v1
kind: StatefulSet

metadata:
  name: mysql

spec:
  serviceName: mysql

  replicas: 1

  selector:
    matchLabels:
      app: mysql

  template:
    metadata:
      labels:
        app: mysql

    spec:
      containers:

      - name: mysql

        image: mysql:8.0

        ports:
        - containerPort: 3306

        envFrom:
        - secretRef:
            name: mysql-secret

        resources:
          requests:
            cpu: "250m"
            memory: "512Mi"

          limits:
            cpu: "500m"
            memory: "1Gi"

        volumeMounts:

        - name: mysql-storage

          mountPath: /var/lib/mysql

  volumeClaimTemplates:

  - metadata:
      name: mysql-storage

    spec:

      accessModes:

      - ReadWriteOnce

      resources:

        requests:

          storage: 1Gi
```

Apply

```bash
kubectl apply -f mysql-statefulset.yaml
```

---

# Verify StatefulSet

```bash
kubectl get sts

kubectl get pods

kubectl get pvc
```

Expected

```
mysql-0      Running

mysql-storage-mysql-0

Bound
```
<img width="1366" height="318" alt="image" src="https://github.com/user-attachments/assets/eccf3fc7-2c95-47a4-b7b8-bbb997de79b3" />

---

# Verify MySQL Database

Login

```bash
kubectl exec -it mysql-0 -- bash
```

Inside Container

```bash
mysql -u wpuser -p
```

Password

```
wordpress123
```

Check Database

```sql
SHOW DATABASES;
```

Expected

```
information_schema

mysql

performance_schema

wordpress
```

---

# Step 5: Create ConfigMap

## Why ConfigMap?

ConfigMaps store non-sensitive configuration such as:

- Database Host
- Database Name
- Environment Variables

Instead of hardcoding values inside the application.

---

## wordpress-configmap.yaml

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: wordpress-config

data:
  WORDPRESS_DB_HOST: mysql-0.mysql.capstone.svc.cluster.local:3306
  WORDPRESS_DB_NAME: wordpress
```

Apply

```bash
kubectl apply -f wordpress-configmap.yaml
```

Verify

```bash
kubectl get configmap

kubectl describe configmap wordpress-config
```
<img width="1366" height="726" alt="image" src="https://github.com/user-attachments/assets/1cf8e9db-d1b8-4652-9f04-1a5e22411724" />

---

# Step 6: Deploy WordPress

## Why Deployment?

Deployment provides

- Self-Healing
- Rolling Updates
- Rollback
- Scaling
- High Availability

---

## wordpress-deployment.yaml

```yaml
apiVersion: apps/v1
kind: Deployment

metadata:
  name: wordpress

spec:
  replicas: 2

  selector:
    matchLabels:
      app: wordpress

  template:

    metadata:
      labels:
        app: wordpress

    spec:

      containers:

      - name: wordpress

        image: wordpress:latest

        ports:
        - containerPort: 80

        envFrom:
        - configMapRef:
            name: wordpress-config

        env:

        - name: WORDPRESS_DB_USER
          valueFrom:
            secretKeyRef:
              name: mysql-secret
              key: MYSQL_USER

        - name: WORDPRESS_DB_PASSWORD
          valueFrom:
            secretKeyRef:
              name: mysql-secret
              key: MYSQL_PASSWORD

        resources:

          requests:
            cpu: "250m"
            memory: "256Mi"

          limits:
            cpu: "500m"
            memory: "512Mi"

        livenessProbe:

          httpGet:
            path: /wp-login.php
            port: 80

          initialDelaySeconds: 60
          periodSeconds: 10

        readinessProbe:

          httpGet:
            path: /wp-login.php
            port: 80

          initialDelaySeconds: 30
          periodSeconds: 5
```

Apply

```bash
kubectl apply -f wordpress-deployment.yaml
```

---

# Verify Deployment

```bash
kubectl get deployment

kubectl get pods
```

Expected

```
wordpress

READY 2/2

AVAILABLE 2
```

Check Logs

```bash
kubectl logs <wordpress-pod>
```

Describe Pod

```bash
kubectl describe pod <wordpress-pod>
```
<img width="987" height="501" alt="image" src="https://github.com/user-attachments/assets/1a667bae-2a6c-4766-929b-6fad71bcecd7" />

---

# Step 7: Expose WordPress

Applications running inside Kubernetes cannot be accessed directly.

NodePort exposes the application externally.

---

## wordpress-service.yaml

```yaml
apiVersion: v1
kind: Service

metadata:
  name: wordpress

spec:

  type: NodePort

  selector:
    app: wordpress

  ports:

  - port: 80

    targetPort: 80

    nodePort: 30080
```

Apply

```bash
kubectl apply -f wordpress-service.yaml
```

Verify

```bash
kubectl get svc
```

Expected

```
wordpress

NodePort

80:30080/TCP
```
<img width="846" height="208" alt="image" src="https://github.com/user-attachments/assets/c6ea2d3b-adde-4a95-b1e2-2730d53cde1b" />

---

# Step 8: Access WordPress

### Minikube

```bash
minikube service wordpress
```

### Kind

```bash
kubectl port-forward svc/wordpress 8080:80
```

Open Browser

```
http://localhost:8080
```

OR

```
http://<NodeIP>:30080
```

You should see

```
WordPress Installation Wizard
```

Complete

- Site Name
- Username
- Password
- Email

Click

```
Install WordPress
```
<img width="1366" height="277" alt="image" src="https://github.com/user-attachments/assets/7b5ad1cd-4f57-455d-81d7-117b3d91be85" />
<img width="1366" height="683" alt="image" src="https://github.com/user-attachments/assets/cb1bedf8-1f69-4bf4-9b38-0b71d375ebd3" />
<img width="1365" height="685" alt="image" src="https://github.com/user-attachments/assets/0d898b7c-8ad2-421d-8611-e857dcae0184" />

---

# Step 9: Verify Application

Pods

```bash
kubectl get pods
```

Deployment

```bash
kubectl get deployment
```

Services

```bash
kubectl get svc
```

PVC

```bash
kubectl get pvc
```

StatefulSet

```bash
kubectl get sts
```

Everything

```bash
kubectl get all
```

Expected

```
mysql-0

Running

wordpress-xxxxx

Running

wordpress-yyyyy

Running
```

---

# Resource Requests & Limits

| Resource | Request | Limit |
|----------|---------|-------|
| CPU | 250m | 500m |
| Memory | 256Mi | 512Mi |

Requests

✔ Scheduler uses this value.

Limits

✔ Kubernetes never allows usage beyond this.

---

# Liveness Probe

Purpose

Checks whether the application is alive.

```yaml
livenessProbe:
  httpGet:
    path: /wp-login.php
    port: 80
```

If probe fails

```
Restart Container
```

---

# Readiness Probe

Purpose

Checks whether application is ready to serve traffic.

```yaml
readinessProbe:
  httpGet:
    path: /wp-login.php
    port: 80
```

If failed

```
No Traffic

No Restart
```

---

# Verify Resources

```bash
kubectl describe pod <wordpress-pod>
```

Look for

```
Requests

Limits

Liveness

Readiness
```

---

# Verify Website

Browser

```
http://NodeIP:30080
```

Expected

```
WordPress Home Page
```

---

# Step 10: Test Self-Healing

## Why Self-Healing?

Kubernetes automatically recreates failed Pods to maintain the desired state.

### Delete a WordPress Pod

```bash
kubectl get pods

kubectl delete pod <wordpress-pod-name>
```

Verify

```bash
kubectl get pods -w
```

Expected

```
Old Pod → Terminating

New Pod → Running
```

Deployment automatically creates a new Pod.

---

# Test MySQL Recovery

Delete MySQL Pod

```bash
kubectl delete pod mysql-0
```

Verify

```bash
kubectl get pods -w
```

Expected

```
mysql-0

Running
```

StatefulSet recreates the Pod with the same identity.

---

# Verify Data Persistence

Login to WordPress

Create

- New Post
- New Page

Delete MySQL Pod

```bash
kubectl delete pod mysql-0
```

Wait until it becomes Running.

Refresh Browser.

Expected

```
Blog Post Still Exists
```

Reason

```
PVC stores MySQL data permanently.
```

---

# Verify Persistent Volume

```bash
kubectl get pvc

kubectl get pv
```

Expected

```
STATUS

Bound
```

---

# Step 11: Horizontal Pod Autoscaler (HPA)

## Why HPA?

Automatically scales Pods based on CPU usage.

```
High CPU

↓

Increase Pods

↓

Low CPU

↓

Decrease Pods
```

---

## wordpress-hpa.yaml

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler

metadata:
  name: wordpress-hpa

spec:

  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: wordpress

  minReplicas: 2
  maxReplicas: 10

  metrics:
  - type: Resource

    resource:
      name: cpu

      target:
        type: Utilization
        averageUtilization: 50
```

Apply

```bash
kubectl apply -f wordpress-hpa.yaml
```

Verify

```bash
kubectl get hpa
```

Expected

```
NAME

wordpress-hpa

MIN 2

MAX 10

TARGET 50%
```

---

# Generate Load

Create Load Generator

```bash
kubectl run load-generator \
--image=busybox \
--restart=Never \
-- /bin/sh -c "while true; do wget -q -O- http://wordpress; done"
```

Watch Scaling

```bash
kubectl get hpa -w

kubectl get pods -w
```

Stop Load

```bash
kubectl delete pod load-generator
```

---

# Step 12: Verify Complete Project

```bash
kubectl get all

kubectl get pvc

kubectl get pv

kubectl get configmap

kubectl get secret

kubectl get hpa
```

Expected

```
Namespace

Deployment

StatefulSet

Pods

Service

PVC

PV

ConfigMap

Secret

HPA
```

---

# Step 13: Helm Comparison

Install Bitnami WordPress

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami

helm repo update
```

Create Namespace

```bash
kubectl create ns helm-demo
```

Install

```bash
helm install wp-helm bitnami/wordpress -n helm-demo
```

Verify

```bash
helm list -n helm-demo

kubectl get all -n helm-demo
```

Delete

```bash
helm uninstall wp-helm -n helm-demo
```

---

# Manual vs Helm

| Manual YAML | Helm |
|-------------|------|
| Full Control | Faster Deployment |
| More YAML Files | Reusable Charts |
| Easy to Learn | Production Standard |
| Better for Learning | Better for Enterprise |

---

# Project Architecture

```
Browser
    │
NodePort Service
    │
WordPress Deployment
    │
ConfigMap + Secret
    │
Headless Service
    │
MySQL StatefulSet
    │
Persistent Volume Claim
    │
Persistent Volume
```

---

# Troubleshooting

## Pods Pending

```bash
kubectl describe pod <pod>
```

Check

- PVC
- StorageClass
- Resources

---

## PVC Pending

```bash
kubectl get storageclass

kubectl describe pvc
```

---

## MySQL Not Starting

```bash
kubectl logs mysql-0
```

---

## WordPress Cannot Connect Database

Check

```bash
kubectl describe configmap

kubectl describe secret
```

Verify

```
WORDPRESS_DB_HOST

MYSQL_USER

MYSQL_PASSWORD
```

---

## Service Not Accessible

```bash
kubectl get svc

kubectl describe svc wordpress
```

---

## HPA Not Scaling

```bash
kubectl top pods

kubectl top nodes

kubectl get hpa
```

Ensure Metrics Server is running.

---

# Important kubectl Commands

```bash
kubectl get all

kubectl get pods

kubectl get svc

kubectl get pvc

kubectl get pv

kubectl get hpa

kubectl logs <pod>

kubectl exec -it <pod> -- bash

kubectl describe pod <pod>

kubectl delete pod <pod>
```

---

# Interview Questions

## Why StatefulSet instead of Deployment for MySQL?

StatefulSets provide:

- Stable Pod Names
- Stable Storage
- Stable DNS
- Ordered Deployment

---

## Why ConfigMap?

Stores non-sensitive configuration.

---

## Why Secret?

Stores passwords and credentials securely.

---

## Difference between ConfigMap and Secret?

| ConfigMap | Secret |
|------------|---------|
| Plain Text | Base64 Encoded |
| Non-sensitive | Sensitive Data |

---

## Why Headless Service?

Provides stable DNS for StatefulSets.

---

## Why PVC?

Stores data permanently even after Pod deletion.

---

## Difference between Liveness and Readiness?

| Liveness | Readiness |
|-----------|-----------|
| Restarts Pod | Stops Traffic |
| Health Check | Availability Check |

---

## Why Resource Limits?

Prevent Pods from consuming excessive CPU and Memory.

---

## Why HPA?

Automatically scales application based on CPU utilization.

---

# Best Practices

- Use Namespaces
- Never hardcode passwords
- Store secrets in Secrets
- Store configs in ConfigMaps
- Use StatefulSets for databases
- Always use PVCs
- Configure Requests & Limits
- Enable Liveness & Readiness Probes
- Enable HPA
- Prefer Helm for production deployments

---

# Cleanup

```bash
kubectl delete hpa wordpress-hpa

kubectl delete deployment wordpress

kubectl delete statefulset mysql

kubectl delete svc wordpress mysql

kubectl delete configmap wordpress-config

kubectl delete secret mysql-secret

kubectl delete pvc --all

kubectl delete namespace capstone
```

Reset Namespace

```bash
kubectl config set-context --current --namespace=default
```

Verify

```bash
kubectl get ns
```

---

# Conclusion

In this capstone project, we successfully deployed a production-style **WordPress + MySQL** application on Kubernetes by combining all the core concepts learned during the Kubernetes journey. We implemented **Namespaces, ConfigMaps, Secrets, StatefulSets, Deployments, Services, Persistent Storage, Resource Management, Health Probes, and Horizontal Pod Autoscaler (HPA)** to build a scalable, self-healing, and resilient application.

This project demonstrates how Kubernetes manages application deployment, networking, storage, security, and automatic scaling in real-world production environments, making it an excellent hands-on project for DevOps engineers and Kubernetes interview preparation.
