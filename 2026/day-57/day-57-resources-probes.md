# 🚀 Day 57 – Kubernetes Resource Requests, Limits & Probes

## 🎯 Objective

Learn how Kubernetes manages CPU/Memory resources and uses Probes for application health checks and self-healing.

---

# 🧠 Why Resources & Probes?

Without resource limits:

* One Pod can consume all node resources
* Other applications may fail

Without probes:

* Kubernetes cannot detect unhealthy applications
* Traffic may be sent to broken Pods

---

# Resource Requests vs Limits

| Setting  | Purpose                      |
| -------- | ---------------------------- |
| Requests | Minimum resources guaranteed |
| Limits   | Maximum resources allowed    |

Example:

```yaml
resources:
  requests:
    cpu: "100m"
    memory: "128Mi"
  limits:
    cpu: "250m"
    memory: "256Mi"
```

Apply:

```bash
kubectl apply -f resource-pod.yaml
kubectl describe pod resource-pod
```

QoS Class:

```text
Guaranteed → Requests = Limits
Burstable  → Requests < Limits
BestEffort → No Requests/Limits
```

Result:

```text
QoS: Burstable
```

---

# Task 1: Resource Management

Verify:

```bash
kubectl describe pod resource-pod
```

Check:

```text
Requests
Limits
QoS Class
```
<img width="1366" height="726" alt="image" src="https://github.com/user-attachments/assets/7842977f-d84a-4633-b40f-d449930f899d" />
<img width="1366" height="723" alt="image" src="https://github.com/user-attachments/assets/538bd0bd-ed05-48f1-a0a9-4d5233348056" />

---

# Task 2: OOMKilled (Memory Exceeded)

Pod Manifest:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: stress-pod
spec:
  containers:
  - name: stress
    image: polinux/stress
    resources:
      limits:
        memory: "100Mi"
    command: ["stress"]
    args: ["--vm","1","--vm-bytes","200M","--vm-hang","1"]
```

Deploy:

```bash
kubectl apply -f stress-pod.yaml
kubectl describe pod stress-pod
```
<img width="1366" height="724" alt="image" src="https://github.com/user-attachments/assets/98670db6-0786-4e12-9ebb-248e9d130dfe" />
<img width="1366" height="726" alt="image" src="https://github.com/user-attachments/assets/3da30846-3606-4138-83b9-42d63eb2b467" />
<img width="1366" height="722" alt="image" src="https://github.com/user-attachments/assets/04f88eb3-76d4-4ef3-81ce-e72a49651f99" />

Output:

```text
Reason: OOMKilled
Exit Code: 137
```

💡 CPU is throttled, Memory is killed.

---

# Task 3: Pending Pod

Request huge resources:

```yaml
resources:
  requests:
    cpu: "100"
    memory: "128Gi"
```

Deploy:

```bash
kubectl apply -f pending-pod.yaml
kubectl describe pod pending-pod
```

Output:

```text
0/1 nodes available:
Insufficient CPU
Insufficient Memory
```

Result:

```text
STATUS = Pending
```
<img width="1366" height="731" alt="image" src="https://github.com/user-attachments/assets/efae442e-95e9-4d45-9b9f-6cea20608c46" />
<img width="1366" height="726" alt="image" src="https://github.com/user-attachments/assets/7a754073-f2e3-4bd9-a48c-731f36b5adbb" />

---

# Task 4: Liveness Probe

Purpose:

```text
Detect unhealthy container
Restart automatically
```

Example:

```yaml
livenessProbe:
  exec:
    command:
    - cat
    - /tmp/healthy
  periodSeconds: 5
  failureThreshold: 3
```

Verify:

```bash
kubectl get pod -w
```

Result:

```text
Container Restarted
```
<img width="1366" height="637" alt="image" src="https://github.com/user-attachments/assets/92cff5ee-bd52-4de9-a5f4-761a8d4e95eb" />

---

# Task 5: Readiness Probe

Purpose:

```text
Control traffic
No restart
```

Example:

```yaml
readinessProbe:
  httpGet:
    path: /
    port: 80
```

Create Service:

```bash
kubectl expose pod nginx --port=80 --name=readiness-svc
```

Check Endpoints:

```bash
kubectl get endpoints readiness-svc
```

Result:

```text
Pod Removed From Endpoints
Container Still Running
```
<img width="776" height="383" alt="image" src="https://github.com/user-attachments/assets/fd9c2a43-e2d9-45ed-82bc-f027615b040d" />


---

# Task 6: Startup Probe

Purpose:

```text
Give slow applications extra startup time
```

Example:

```yaml
startupProbe:
  exec:
    command:
    - cat
    - /tmp/started
  periodSeconds: 5
  failureThreshold: 12
```

Container:

```bash
sleep 20 && touch /tmp/started
```

Result:

```text
Startup Success
Then Liveness Starts
```

If:

```text
failureThreshold = 2
```

Container restarts before application starts.

---

# Probe Comparison

| Probe     | Purpose            | Action              |
| --------- | ------------------ | ------------------- |
| Liveness  | Is app alive?      | Restart Pod         |
| Readiness | Ready for traffic? | Remove from Service |
| Startup   | Has app started?   | Delay other probes  |

---

# Important Commands

```bash
kubectl get pods
kubectl describe pod <pod>
kubectl logs <pod>
kubectl get events
kubectl get endpoints
kubectl delete pod <pod>
```
<img width="829" height="721" alt="image" src="https://github.com/user-attachments/assets/e0e041e5-11b9-476e-9d1c-6bf2470c5273" />

---

# Key Learnings

✅ Resource Requests & Limits

✅ QoS Classes (Guaranteed, Burstable, BestEffort)

✅ OOMKilled & Exit Code 137

✅ Scheduler Pending Events

✅ Liveness Probe

✅ Readiness Probe

✅ Startup Probe

✅ Kubernetes Self-Healing

---

# Interview Questions

### What is the difference between Requests and Limits?

Requests are used by the scheduler to place Pods. Limits are enforced by Kubernetes during runtime.

### What happens when memory exceeds limit?

Container is terminated with:

```text
OOMKilled
Exit Code 137
```

### Difference between Liveness and Readiness?

Liveness restarts containers. Readiness removes Pods from Service endpoints.

### Why use Startup Probe?

To prevent slow-starting applications from being killed by liveness probes.

### What are Kubernetes QoS Classes?

```text
Guaranteed
Burstable
BestEffort
```

Used for resource prioritization during node pressure.

---

# Conclusion

Resource Requests & Limits ensure efficient cluster utilization, while Liveness, Readiness, and Startup Probes provide automated health monitoring and self-healing.

Together they make Kubernetes workloads reliable, scalable, and production-ready.

