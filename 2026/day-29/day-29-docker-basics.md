# 🚀 Day 29 – Introduction to Docker

# 📌 Introduction

Modern applications require:

* Fast deployments
* Scalability
* Portability
* Consistent environments

Traditional deployment methods often caused:

* “It works on my machine” problems
* Dependency conflicts
* Environment inconsistencies

Docker solved this problem using **containers**.

Today’s goal was to:
✅ Understand Docker fundamentals
✅ Learn containerization concepts
✅ Install Docker
✅ Run and manage containers
✅ Explore Docker architecture
✅ Deploy first containerized applications

---

# 🌍 What is Docker?

Docker is an open-source containerization platform used to:

* Build
* Package
* Ship
* Run applications

inside lightweight containers.

Docker ensures applications run consistently across:

* Developer laptops
* Test servers
* Production environments
* Cloud platforms

---

# 📦 What is a Container?

A container is a lightweight, isolated package containing:

* Application code
* Runtime
* Libraries
* Dependencies
* Configurations

Containers share the host OS kernel but run independently.

---

# 📌 Why Do We Need Containers?

Before containers:

* Applications worked differently across environments
* Dependency issues were common
* Deployments were slow
* Scaling applications was difficult

Containers solve these problems by providing:
✅ Portability
✅ Isolation
✅ Faster deployment
✅ Better scalability
✅ Consistent environments

---

# 🖥️ Containers vs Virtual Machines

| Containers             | Virtual Machines           |
| ---------------------- | -------------------------- |
| Lightweight            | Heavy                      |
| Share host OS kernel   | Separate guest OS          |
| Fast startup           | Slow startup               |
| Less resource usage    | High resource usage        |
| Best for microservices | Best for full OS isolation |

---

# 📌 Virtual Machine Architecture

```text id="d29a01"
Hardware
   ↓
Hypervisor
   ↓
Guest OS
   ↓
Applications
```

---

# 📌 Container Architecture

```text id="d29a02"
Hardware
   ↓
Host OS
   ↓
Docker Engine
   ↓
Containers
```

---

# ⚙️ Docker Architecture

Docker follows a client-server architecture.

---

# 📌 Main Components

| Component         | Purpose                  |
| ----------------- | ------------------------ |
| Docker Client     | Sends commands           |
| Docker Daemon     | Runs containers          |
| Docker Images     | Templates for containers |
| Docker Containers | Running instances        |
| Docker Registry   | Stores images            |

---

# 📌 Docker Workflow

```text id="d29a03"
Docker Client
      ↓
Docker Daemon
      ↓
Docker Hub / Registry
      ↓
Images
      ↓
Containers
```

---

# 📌 Docker Client

The Docker client is the command-line interface.

Example:

```bash id="d29a04"
docker ps
docker run nginx
```

---

# 📌 Docker Daemon

Docker daemon:

* Builds images
* Runs containers
* Manages networking
* Handles storage

Runs in the background as a service.

---

# 📌 Docker Images

Images are:

* Read-only templates
* Used to create containers

Example:

```text id="d29a05"
nginx image
ubuntu image
mysql image
```

---

# 📌 Docker Containers

Containers are:

* Running instances of images

Example:

```text id="d29a06"
docker run nginx
```

creates a container from nginx image.

---

# 📌 Docker Registry

Docker Registry stores Docker images.

Most popular:

```text id="d29a07"
Docker Hub
```

---

# 🛠️ Task 2 – Install Docker

# 📌 Install Docker on Ubuntu

## Update Packages

```bash id="d29a08"
sudo apt update
```

---

# 📌 Install Docker

```bash id="d29a09"
sudo apt install docker.io -y
```
<img width="1366" height="728" alt="image" src="https://github.com/user-attachments/assets/d189fa37-2397-4aa5-8925-50a6a4ef3612" />

---

# 📌 Start Docker Service

```bash id="d29a10"
sudo systemctl start docker
sudo systemctl enable docker
```

---

# 📌 Verify Docker Installation

```bash id="d29a11"
docker --version
```

---

# 🔹 Example Output

```text id="d29a12"
Docker version 24.x.x
```

---

# 📌 Check Docker Service

```bash id="d29a13"
sudo systemctl status docker
```
<img width="1366" height="720" alt="image" src="https://github.com/user-attachments/assets/df10438b-da0a-4b72-b87a-87820a999171" />

---

# 🐳 Run First Docker Container

# 📌 Run hello-world Container

```bash id="d29a14"
sudo docker run hello-world
```
<img width="1366" height="326" alt="image" src="https://github.com/user-attachments/assets/f6e5a7b7-492c-482b-bdd8-4c9fef7551bb" />

---

# 📌 What Happens Internally?

Docker:

1. Checks local image
2. Pulls image from Docker Hub
3. Creates container
4. Runs container
5. Displays output

---

# 🔹 Example Output

```text id="d29a15"
Hello from Docker!
This message shows that your installation appears to be working correctly.
```
<img width="1366" height="127" alt="image" src="https://github.com/user-attachments/assets/9521ae7c-4a59-4205-888f-cf44ed9d0ef2" />

---

# 🌐 Task 3 – Run Real Containers

# 📌 Run Nginx Container

```bash id="d29a16"
sudo docker run -d -p 80:80 nginx
```

---

# 📌 Explanation

| Option | Meaning       |
| ------ | ------------- |
| `-d`   | Detached mode |
| `-p`   | Port mapping  |

---

# 📌 Verify Running Containers

```bash id="d29a17"
docker ps
```

---

# 🔹 Example Output

```text id="d29a18"
CONTAINER ID   IMAGE   STATUS
abcd1234       nginx   Up
```

---

# 📌 Access Nginx in Browser

Open:

```text id="d29a19"
http://<server-ip>
```

You should see:

```text id="d29a20"
Welcome to nginx!
```

---

# 🐧 Run Ubuntu Container

# 📌 Interactive Mode

```bash id="d29a21"
docker run -it ubuntu bash
```

---

# 📌 Explanation

| Option | Meaning     |
| ------ | ----------- |
| `-i`   | Interactive |
| `-t`   | Terminal    |

---

# 📌 Explore Ubuntu Container

Inside container:

```bash id="d29a22"
ls
pwd
apt update
cat /etc/os-release
```

---

# 📌 Exit Container

```bash id="d29a23"
exit
```

---

# 📌 List Running Containers

```bash id="d29a24"
docker ps
```

---

# 📌 List All Containers

```bash id="d29a25"
docker ps -a
```

---

# 📌 Stop Container

```bash id="d29a26"
docker stop <container-id>
```

---

# 📌 Remove Container

```bash id="d29a27"
docker rm <container-id>
```

---

# 🔍 Task 4 – Explore Docker Features

# 📌 Detached Mode

Run container in background:

```bash id="d29a28"
docker run -d nginx
```

---

# 📌 Custom Container Name

```bash id="d29a29"
docker run -d --name my-nginx nginx
```

---

# 📌 Port Mapping

```bash id="d29a30"
docker run -d -p 8080:80 nginx
```

---

# 📌 Meaning

| Host Port | Container Port |
| --------- | -------------- |
| 8080      | 80             |

Access:

```text id="d29a31"
http://localhost:8080
```

---

# 📌 Check Container Logs

```bash id="d29a32"
docker logs my-nginx
```

---

# 📌 Execute Commands Inside Running Container

```bash id="d29a33"
docker exec -it my-nginx bash
```

---

# 📌 Useful Docker Commands

| Command         | Purpose            |
| --------------- | ------------------ |
| `docker ps`     | Running containers |
| `docker ps -a`  | All containers     |
| `docker images` | List images        |
| `docker pull`   | Download image     |
| `docker run`    | Run container      |
| `docker stop`   | Stop container     |
| `docker rm`     | Remove container   |
| `docker logs`   | View logs          |
| `docker exec`   | Access container   |

---

# 🏗️ Docker Lifecycle

```text id="d29a34"
Docker Image
      ↓
docker run
      ↓
Container Created
      ↓
Running Container
      ↓
Stop / Remove
```

---

# 🚨 Real-World DevOps Importance

Docker is heavily used in:

* CI/CD pipelines
* Kubernetes
* Microservices
* Cloud deployments
* GitOps
* DevSecOps
* Application packaging

Examples:

* Deploying applications consistently
* Running Jenkins agents
* Kubernetes pods
* Containerized monitoring stacks

---

# 📌 Benefits of Docker

✅ Faster deployments
✅ Environment consistency
✅ Lightweight applications
✅ Better scalability
✅ Easy rollback
✅ Isolation between applications

---

# 📌 Challenges with Docker

⚠️ Container security
⚠️ Networking complexity
⚠️ Persistent storage management
⚠️ Monitoring containers

---

# 🎯 What I Learned

✅ Understanding containers
✅ Difference between containers and VMs
✅ Docker architecture
✅ Installing Docker
✅ Running first containers
✅ Managing containers
✅ Port mapping and logs
✅ Interactive container access

---

# 🏁 Conclusion

Docker is one of the most important technologies in modern DevOps.

Today’s hands-on practice helped me understand:

* Why containers exist
* How Docker works internally
* How to deploy containerized applications
* How modern infrastructure is built

This is the foundation for upcoming topics like:

* Docker Images
* Dockerfiles
* Docker Compose
* Kubernetes
* CI/CD pipelines
