# 🚀 Day 56 – Kubernetes StatefulSets

## 🎯 Objective

Learn how StatefulSets provide **stable identity, persistent storage, and ordered deployment** for stateful applications such as MySQL, PostgreSQL, MongoDB, Kafka, and Elasticsearch.

---

# 🧠 Why StatefulSets?

Deployments work well for stateless applications but not for databases.

| Feature   | Deployment | StatefulSet               |
| --------- | ---------- | ------------------------- |
| Pod Names | Random     | Stable (`web-0`, `web-1`) |
| DNS       | Dynamic    | Stable                    |
| Storage   | Shared     | Dedicated PVC per Pod     |
| Startup   | Parallel   | Ordered                   |
| Use Case  | Web Apps   | Databases                 |

---

# Architecture

```text
Headless Service
        │
 ┌──────┼──────┐
 │      │      │
web-0  web-1  web-2
 │      │      │
PVC    PVC    PVC
 │      │      │
PV     PV     PV
```

---

# Task 1: Deployment Limitation

Create Deployment:

```bash
kubectl create deployment nginx --image=nginx --replicas=3
kubectl get pods
```

Observation:

```text
nginx-abc123
nginx-def456
nginx-xyz789
```
<img width="937" height="180" alt="image" src="https://github.com/user-attachments/assets/fc32aad2-5944-427b-85c3-86bd414c76bf" />

Pod names change after recreation ❌

---

# Task 2: Headless Service

```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-headless
spec:
  clusterIP: None
  selector:
    app: nginx
  ports:
  - port: 80
```

Apply:

```bash
kubectl apply -f headless-service.yaml
kubectl get svc
```

Output:

```text
CLUSTER-IP: None
```
<img width="879" height="362" alt="image" src="https://github.com/user-attachments/assets/2040a6ea-63bc-4bd0-9471-9dc21d6e49f1" />

---

# Task 3: StatefulSet

```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: web
spec:
  serviceName: nginx-headless
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
        image: nginx
        volumeMounts:
        - name: web-data
          mountPath: /usr/share/nginx/html

  volumeClaimTemplates:
  - metadata:
      name: web-data
    spec:
      accessModes:
      - ReadWriteOnce
      resources:
        requests:
          storage: 100Mi
```

Deploy:

```bash
kubectl apply -f statefulset.yaml
kubectl get pods
kubectl get pvc
```

Output:

```text
web-0
web-1
web-2
```

PVCs:

```text
web-data-web-0
web-data-web-1
web-data-web-2
```
<img width="1366" height="725" alt="image" src="https://github.com/user-attachments/assets/7c7a5a87-560a-40cf-ae7f-09e2f6114e5a" />
<img width="1366" height="278" alt="image" src="https://github.com/user-attachments/assets/82435277-f562-46d7-947f-243c82ee0bbf" />

---

# Task 4: Stable DNS

DNS Format:

```text
<pod-name>.<service-name>.default.svc.cluster.local
```

Example:

```bash
nslookup web-0.nginx-headless.default.svc.cluster.local
```

Verify:

```bash
kubectl get pods -o wide
```

DNS always resolves to the correct Pod IP ✅

---

# Task 5: Persistent Storage

Write Data:

```bash
kubectl exec web-0 -- sh -c \
"echo 'Persistent Data' > /usr/share/nginx/html/index.html"
```

Delete Pod:

```bash
kubectl delete pod web-0
```

Verify:

```bash
kubectl exec web-0 -- cat /usr/share/nginx/html/index.html
```

Result:

```text
Persistent Data
```

Data survives because the same PVC is reattached ✅
<img width="884" height="165" alt="image" src="https://github.com/user-attachments/assets/20b8a873-bcf0-4ec1-a013-7da9bc283dc4" />

---

# Task 6: Ordered Scaling

Scale Up:

```bash
kubectl scale sts web --replicas=5
```

Pods Created:

```text
web-3
web-4
```

Scale Down:

```bash
kubectl scale sts web --replicas=3
```

Pods Removed:

```text
web-4
web-3
```

PVCs remain intact ✅

---

# Important Commands

```bash
kubectl get sts
kubectl get pods
kubectl get pvc
kubectl get pv
kubectl describe sts web
kubectl scale sts web --replicas=5
kubectl delete pod web-0
```

---

# Interview Questions

### What is StatefulSet?

A Kubernetes workload used for stateful applications requiring stable identity and persistent storage.

### Why not use Deployment for databases?

Deployments provide random Pod names and no dedicated storage, making them unsuitable for clustered databases.

### What is a Headless Service?

A Service with `clusterIP: None` that provides DNS records for individual StatefulSet Pods.

### What happens if a StatefulSet Pod is deleted?

The Pod is recreated with the same name and attached to the same PVC.

### Do PVCs get deleted when StatefulSet is deleted?

No. PVCs remain to prevent accidental data loss.

---

# Key Learnings

✅ Stable Pod Names

✅ Stable DNS Records

✅ Dedicated PVC per Pod

✅ Ordered Pod Creation & Deletion

✅ Persistent Data Across Restarts

✅ Ideal for Databases & Stateful Applications

---

# Conclusion

StatefulSets solve the challenges of running stateful workloads in Kubernetes by providing stable network identity, persistent storage, and predictable scaling behavior.

Examples:

* MySQL
* PostgreSQL
* MongoDB
* Kafka
* Elasticsearch
* Cassandra

