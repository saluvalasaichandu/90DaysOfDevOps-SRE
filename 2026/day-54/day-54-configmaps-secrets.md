# Day 54 – Kubernetes ConfigMaps & Secrets

## 📌 Objective

Learn how Kubernetes manages application configuration and sensitive data without rebuilding container images.

---

# What are ConfigMaps?

A **ConfigMap** stores **non-sensitive configuration data** as key-value pairs.

Examples:

* Application Environment
* Feature Flags
* Port Numbers
* Nginx Configurations

```text
Application
     │
     ▼
 ConfigMap
     │
 ┌───┼────┐
 │   │    │
ENV PORT DEBUG
```

### Benefits

* Decouples configuration from application code
* No need to rebuild images
* Easy updates

---

# What are Secrets?

A **Secret** stores **sensitive information** such as:

* Database Passwords
* API Keys
* Tokens
* Certificates

```text
Application
      │
      ▼
    Secret
      │
 ┌────┼────┐
 │         │
User    Password
```

### Benefits

* RBAC-controlled access
* Mounted securely inside Pods
* Supports encryption at rest (if enabled)

---

# ConfigMap vs Secret

| Feature  | ConfigMap          | Secret          |
| -------- | ------------------ | --------------- |
| Purpose  | Non-sensitive data | Sensitive data  |
| Storage  | Plain Text         | Base64 Encoded  |
| Example  | APP_ENV            | DB_PASSWORD     |
| Security | No                 | RBAC Controlled |

---

# Task 1: Create ConfigMap from Literals

```bash
kubectl create configmap app-config \
--from-literal=APP_ENV=production \
--from-literal=APP_DEBUG=false \
--from-literal=APP_PORT=8080
```

Verify:

```bash
kubectl describe configmap app-config
```

```bash
kubectl get configmap app-config -o yaml
```

Expected:

```yaml
data:
  APP_ENV: production
  APP_DEBUG: "false"
  APP_PORT: "8080"
```
<img width="1366" height="723" alt="image" src="https://github.com/user-attachments/assets/7cb862cc-081c-4779-901d-3dff6c9cd608" />

---

# Task 2: Create ConfigMap from File

## Create Nginx Configuration

### default.conf

```nginx
server {
    listen 80;

    location /health {
        return 200 "healthy";
    }
}
```

Create ConfigMap:

```bash
kubectl create configmap nginx-config \
--from-file=default.conf=default.conf
```

Verify:

```bash
kubectl get configmap nginx-config -o yaml
```

Expected:

```yaml
data:
  default.conf: |
    server {
      listen 80;
      location /health {
        return 200 "healthy";
      }
    }
```

---

# Task 3: Use ConfigMap in Pod

## Method 1: Environment Variables

### configmap-env-pod.yaml

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: config-env-pod
spec:
  containers:
  - name: busybox
    image: busybox
    command:
    - sh
    - -c
    - |
      env
      sleep 3600
    envFrom:
    - configMapRef:
        name: app-config
```

Apply:

```bash
kubectl apply -f configmap-env-pod.yaml
```

Verify:

```bash
kubectl logs config-env-pod
```

Output:

```text
APP_ENV=production
APP_DEBUG=false
APP_PORT=8080
```

---

## Method 2: Volume Mount

### nginx-pod.yaml

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-config-pod
spec:
  containers:
  - name: nginx
    image: nginx
    volumeMounts:
    - name: nginx-config
      mountPath: /etc/nginx/conf.d
  volumes:
  - name: nginx-config
    configMap:
      name: nginx-config
```

Apply:

```bash
kubectl apply -f nginx-pod.yaml
```

Verify:

```bash
kubectl exec nginx-config-pod -- curl -s http://localhost/health
```

Output:

```text
healthy
```

---

# Task 4: Create Secret

Create Secret:

```bash
kubectl create secret generic db-credentials \
--from-literal=DB_USER=admin \
--from-literal=DB_PASSWORD=s3cureP@ssw0rd
```

Verify:

```bash
kubectl get secret db-credentials -o yaml
```

Output:

```yaml
data:
  DB_USER: YWRtaW4=
  DB_PASSWORD: czNjdXJlUEBzc3cwcmQ=
```

---

# Base64 Decode

Decode Username:

```bash
echo YWRtaW4= | base64 --decode
```

Output:

```text
admin
```

Decode Password:

```bash
echo czNjdXJlUEBzc3cwcmQ= | base64 --decode
```

Output:

```text
s3cureP@ssw0rd
```

### Important

```text
Base64 = Encoding ❌

Base64 ≠ Encryption
```

Anyone can decode it.

---

# Task 5: Use Secret in Pod

### secret-pod.yaml

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: secret-pod
spec:
  containers:
  - name: busybox
    image: busybox
    command:
    - sh
    - -c
    - sleep 3600

    env:
    - name: DB_USER
      valueFrom:
        secretKeyRef:
          name: db-credentials
          key: DB_USER

    volumeMounts:
    - name: secret-volume
      mountPath: /etc/db-credentials
      readOnly: true

  volumes:
  - name: secret-volume
    secret:
      secretName: db-credentials
```

Apply:

```bash
kubectl apply -f secret-pod.yaml
```

Verify:

```bash
kubectl exec secret-pod -- env | grep DB_USER
```

Output:

```text
DB_USER=admin
```

Check Mounted Files:

```bash
kubectl exec secret-pod -- ls /etc/db-credentials
```

Output:

```text
DB_USER
DB_PASSWORD
```

Read File:

```bash
kubectl exec secret-pod -- cat /etc/db-credentials/DB_PASSWORD
```

Output:

```text
s3cureP@ssw0rd
```

### Mounted Secret Files are Plain Text

```text
Inside Secret YAML = Base64

Inside Pod Volume = Plain Text
```

---

# Task 6: ConfigMap Live Update

Create ConfigMap:

```bash
kubectl create configmap live-config \
--from-literal=message=hello
```

### live-config-pod.yaml

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: live-config-pod
spec:
  containers:
  - name: busybox
    image: busybox
    command:
    - sh
    - -c
    - |
      while true
      do
        cat /config/message
        sleep 5
      done

    volumeMounts:
    - name: config-volume
      mountPath: /config

  volumes:
  - name: config-volume
    configMap:
      name: live-config
```

Apply:

```bash
kubectl apply -f live-config-pod.yaml
```

Check Logs:

```bash
kubectl logs -f live-config-pod
```

Output:

```text
hello
hello
hello
```

---

## Update ConfigMap

```bash
kubectl patch configmap live-config \
--type merge \
-p '{"data":{"message":"world"}}'
```

Wait ~30 seconds.

Logs:

```text
world
world
world
```

### Observation

| Method                | Auto Updates |
| --------------------- | ------------ |
| Environment Variables | ❌ No         |
| Volume Mounts         | ✅ Yes        |

---

# Environment Variables vs Volume Mounts

| Feature      | Environment Variable | Volume Mount |
| ------------ | -------------------- | ------------ |
| Small Config | ✅                    | ❌            |
| Config Files | ❌                    | ✅            |
| Auto Refresh | ❌                    | ✅            |
| Easy Access  | ✅                    | ❌            |

---

# Useful Commands

View ConfigMap:

```bash
kubectl get cm
```

Describe ConfigMap:

```bash
kubectl describe cm app-config
```

View Secret:

```bash
kubectl get secret
```

Decode Secret:

```bash
kubectl get secret db-credentials \
-o jsonpath='{.data.DB_PASSWORD}' | base64 --decode
```

---

# Interview Questions

### What is a ConfigMap?

A ConfigMap stores non-sensitive application configuration separately from container images.

---

### What is a Secret?

A Secret stores sensitive information like passwords, tokens, and certificates.

---

### Difference Between ConfigMap and Secret?

ConfigMaps store normal configuration data, whereas Secrets store sensitive data and support RBAC restrictions.

---

### Why is Base64 not Encryption?

Base64 only converts data into another format. Anyone can decode it back to plaintext.

---

### Why use Volume Mounts instead of Environment Variables?

Volume-mounted ConfigMaps and Secrets update automatically without restarting Pods, whereas environment variables require Pod restart.

---

### How do ConfigMap updates propagate?

```text
ConfigMap Updated
        ↓
Mounted Volume Updated
        ↓
Pod Reads New Value
```

No Pod restart required.

---

# Cleanup

```bash
kubectl delete pod config-env-pod
kubectl delete pod nginx-config-pod
kubectl delete pod secret-pod
kubectl delete pod live-config-pod

kubectl delete configmap app-config
kubectl delete configmap nginx-config
kubectl delete configmap live-config

kubectl delete secret db-credentials
```

---

# Key Takeaways

✅ ConfigMaps store non-sensitive configuration

✅ Secrets store sensitive data

✅ Base64 encoding is not encryption

✅ Environment variables do not auto-refresh

✅ Volume-mounted ConfigMaps/Secrets auto-update

✅ ConfigMaps and Secrets help separate configuration from application code

✅ Widely used in production Kubernetes environments for secure and flexible application deployment 🚀
