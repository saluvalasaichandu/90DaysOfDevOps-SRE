# Day 55 – Kubernetes Persistent Volumes (PV) & Persistent Volume Claims (PVC)

## Objective

Learn why container storage is ephemeral and how Kubernetes Persistent Volumes (PV) and Persistent Volume Claims (PVC) provide persistent storage for applications like databases.

---

## Why Persistent Storage?

Containers are **ephemeral**.

```text
Pod Deleted
     ↓
Data Lost ❌
```

Applications such as MySQL, PostgreSQL, MongoDB, and Jenkins require data persistence.

Kubernetes solves this using:

```text
PersistentVolume (PV)
        ↓
PersistentVolumeClaim (PVC)
        ↓
Pod
```

---

## Key Concepts

### Persistent Volume (PV)

A cluster storage resource created by an administrator.

### Persistent Volume Claim (PVC)

A storage request made by a Pod.

### StorageClass

Automates PV creation through Dynamic Provisioning.

---

## Access Modes

| Mode | Description                 |
| ---- | --------------------------- |
| RWO  | ReadWriteOnce (Single Node) |
| ROX  | ReadOnlyMany                |
| RWX  | ReadWriteMany               |

---

# Task 1: Ephemeral Storage Demo

### Pod with emptyDir

```yaml
volumes:
- name: data
  emptyDir: {}
```

Create file:

```bash
echo "Hello Kubernetes" > /data/message.txt
```

Delete Pod → Recreate Pod

Result:

```text
Data Lost ❌
```

---

# Task 2: Create Persistent Volume

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: my-pv
spec:
  capacity:
    storage: 1Gi
  accessModes:
  - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  hostPath:
    path: /tmp/k8s-pv-data
```

Apply:

```bash
kubectl apply -f pv.yaml
kubectl get pv
```

Status:

```text
Available
```
<img width="1366" height="457" alt="image" src="https://github.com/user-attachments/assets/e3ec5b55-c60b-47ba-83bc-7e1da4528acf" />

---

# Task 3: Create PVC

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: my-pvc
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 500Mi
```

Apply:

```bash
kubectl apply -f pvc.yaml
```

Verify:

```bash
kubectl get pvc
kubectl get pv
```

Status:

```text
Bound ✅
```

---

# Task 4: Use PVC in Pod

```yaml
volumes:
- name: storage
  persistentVolumeClaim:
    claimName: my-pvc
```

Write data:

```bash
echo "Persistent Data" > /data/message.txt
```

Delete Pod → Recreate Pod

Verify:

```bash
cat /data/message.txt
```

Result:

```text
Data Still Exists ✅
```

---

# Task 5: StorageClass

Check StorageClasses:

```bash
kubectl get storageclass
kubectl describe storageclass
```

Purpose:

```text
PVC Created
      ↓
StorageClass
      ↓
PV Created Automatically
```

---

# Task 6: Dynamic Provisioning

PVC:

```yaml
spec:
  storageClassName: standard
```

Apply:

```bash
kubectl apply -f dynamic-pvc.yaml
```

Verify:

```bash
kubectl get pv
```

Result:

```text
PV Created Automatically ✅
```

---

# Static vs Dynamic Provisioning

| Static            | Dynamic               |
| ----------------- | --------------------- |
| Admin creates PV  | Kubernetes creates PV |
| Manual process    | Automatic process     |
| Used for learning | Used in production    |

---

# Reclaim Policies

| Policy | Behavior      |
| ------ | ------------- |
| Retain | Keep Data     |
| Delete | Remove Volume |

Example:

```yaml
persistentVolumeReclaimPolicy: Retain
```

---

# Useful Commands

```bash
kubectl get pv
kubectl get pvc

kubectl describe pv my-pv
kubectl describe pvc my-pvc

kubectl get storageclass
```

---

# Interview Questions

### What is a Persistent Volume?

A PV is cluster storage that exists independently of Pods.

### What is a PVC?

A PVC is a request for storage by a Pod.

### Difference Between PV and PVC?

PV provides storage, PVC consumes storage.

### What is Dynamic Provisioning?

Automatic PV creation using StorageClasses.

### Why use PVC instead of hostPath?

PVC provides portable, scalable, and production-ready storage.

---

# Key Takeaways

✅ Containers are ephemeral

✅ PV provides persistent storage

✅ PVC requests storage from PV

✅ StorageClasses enable Dynamic Provisioning

✅ Data survives Pod deletion

✅ Reclaim policies control volume lifecycle

✅ Essential for databases, Jenkins, and stateful applications
