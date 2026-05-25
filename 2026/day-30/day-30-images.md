# 🚀 Day 30 – Docker Images & Container Lifecycle

# 📌 Introduction

Docker containers are created from Docker images.
Understanding:

* Images
* Layers
* Container lifecycle
* Logs
* Cleanup

is essential for DevOps engineers working with:

* Kubernetes
* CI/CD
* Cloud deployments
* Microservices

---

# 🐳 What is a Docker Image?

A Docker image is a lightweight, read-only template used to create containers.

Examples:

```text id="d30a01"
nginx
ubuntu
alpine
mysql
```

---

# 📦 What is a Container?

A container is a running instance of a Docker image.

```text id="d30a02"
Image → Container
```

---

# 🖼️ Task 1 – Docker Images

# 📌 Pull Images

```bash id="d30a03"
docker pull nginx
docker pull ubuntu
docker pull alpine
```

---

# 📌 List Images

```bash id="d30a04"
docker images
```

---

# 📌 Ubuntu vs Alpine

| Image  | Size       |
| ------ | ---------- |
| Ubuntu | Large      |
| Alpine | Very Small |

### Why Alpine is Smaller?

* Minimal Linux distribution
* Fewer packages
* Lightweight for containers

---

# 📌 Inspect Image

```bash id="d30a05"
docker inspect nginx
```

### Information Available

* Image ID
* Layers
* Environment variables
* Architecture
* Creation date

---

# 📌 Remove Image

```bash id="d30a06"
docker rmi ubuntu
```

---

# 🏗️ Task 2 – Docker Image Layers

# 📌 View Image History

```bash id="d30a07"
docker image history nginx
```

---

# 📌 What are Layers?

Docker images are built in layers.

Each layer:

* Stores changes
* Is reusable
* Improves caching

---

# 📌 Why Docker Uses Layers

✅ Faster builds
✅ Reduced storage usage
✅ Layer reuse
✅ Efficient image downloads

---

# 📌 Example Layer Flow

```text id="d30a08"
Base OS Layer
    ↓
Package Layer
    ↓
Application Layer
    ↓
Config Layer
```

---

# 🔄 Task 3 – Container Lifecycle

# 📌 Create Container

```bash id="d30a09"
docker create --name mynginx nginx
```

---

# 📌 Start Container

```bash id="d30a10"
docker start mynginx
```

---

# 📌 Pause Container

```bash id="d30a11"
docker pause mynginx
```

---

# 📌 Unpause Container

```bash id="d30a12"
docker unpause mynginx
```

---

# 📌 Stop Container

```bash id="d30a13"
docker stop mynginx
```

---

# 📌 Restart Container

```bash id="d30a14"
docker restart mynginx
```

---

# 📌 Kill Container

```bash id="d30a15"
docker kill mynginx
```

---

# 📌 Remove Container

```bash id="d30a16"
docker rm mynginx
```

---

# 📌 Check Container States

```bash id="d30a17"
docker ps -a
```

---

# 📌 Container Lifecycle Flow

```text id="d30a18"
Create
  ↓
Start
  ↓
Running
  ↓
Pause/Unpause
  ↓
Stop/Kill
  ↓
Remove
```

---

# 🔍 Task 4 – Working with Running Containers

# 📌 Run Nginx in Detached Mode

```bash id="d30a19"
docker run -d --name webserver -p 8080:80 nginx
```

---

# 📌 View Logs

```bash id="d30a20"
docker logs webserver
```

---

# 📌 Real-Time Logs

```bash id="d30a21"
docker logs -f webserver
```

---

# 📌 Exec Into Container

```bash id="d30a22"
docker exec -it webserver bash
```

---

# 📌 Run Single Command Inside Container

```bash id="d30a23"
docker exec webserver ls /
```

---

# 📌 Inspect Container

```bash id="d30a24"
docker inspect webserver
```

### Information Available

* IP address
* Port mappings
* Mounts
* Network settings

---

# 🧹 Task 5 – Docker Cleanup

# 📌 Stop All Running Containers

```bash id="d30a25"
docker stop $(docker ps -q)
```

---

# 📌 Remove All Stopped Containers

```bash id="d30a26"
docker container prune -f
```

---

# 📌 Remove Unused Images

```bash id="d30a27"
docker image prune -a
```

---

# 📌 Check Docker Disk Usage

```bash id="d30a28"
docker system df
```

---

# 📌 Full Cleanup

```bash id="d30a29"
docker system prune -a
```

---

# 🛠️ Important Docker Commands

| Command          | Purpose                       |
| ---------------- | ----------------------------- |
| `docker images`  | List images                   |
| `docker pull`    | Download image                |
| `docker run`     | Run container                 |
| `docker create`  | Create container              |
| `docker start`   | Start container               |
| `docker stop`    | Stop container                |
| `docker logs`    | View logs                     |
| `docker exec`    | Run commands inside container |
| `docker inspect` | Detailed container info       |

---

# 🚀 Real-World DevOps Importance

Docker image & lifecycle knowledge is heavily used in:

* Kubernetes pods
* CI/CD pipelines
* GitOps workflows
* Cloud-native applications
* Monitoring stacks
* Microservices architecture

---

# 🎯 What I Learned

✅ Docker images vs containers
✅ Image layers & caching
✅ Container lifecycle management
✅ Running containers in detached mode
✅ Viewing logs & inspecting containers
✅ Docker cleanup & storage management

---

# 🏁 Conclusion

Docker images and containers are the foundation of modern DevOps.

Today’s hands-on practice helped me understand:

* How containers work internally
* How Docker manages images
* Container lifecycle states
* Logs, exec, inspect, and cleanup operations
