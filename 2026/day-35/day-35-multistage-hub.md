# 🚀 Day 35 – Multi-Stage Builds & Docker Hub

# 📌 Introduction

Production Docker images should be:

* Small
* Secure
* Fast
* Optimized

Today’s goal:
✅ Learn Multi-Stage Builds
✅ Reduce Docker Image Size
✅ Push Images to Docker Hub
✅ Apply Docker Best Practices

---

# 🐳 What is a Multi-Stage Build?

Multi-stage builds allow us to:

* Build application in one stage
* Copy only required files to final image

Benefits:
✅ Smaller images
✅ Better security
✅ Faster deployments

---

# 📂 Task 1 – Single Stage Build

# 📌 Simple Node.js App

## app.js

```javascript id="d35a01"
console.log("Hello from Docker");
```
<img width="1201" height="732" alt="image" src="https://github.com/user-attachments/assets/58e1dc86-138a-426d-a197-a56d7f90b64f" />

---

# 📌 Single Stage Dockerfile

```dockerfile id="d35a02"
FROM node:18

WORKDIR /app

COPY . .

CMD ["node","app.js"]
```

---

# 📌 Build Image

```bash id="d35a03"
docker build -t node-single:v1 .
```
<img width="1364" height="715" alt="image" src="https://github.com/user-attachments/assets/87f83578-a627-4027-9b6f-84c4034805d1" />

---

# 📌 Check Image Size

```bash id="d35a04"
docker images
```

Image size is usually large because:

* Full Node.js runtime
* Build tools
* Extra dependencies

---

# ⚡ Task 2 – Multi-Stage Build

# 📌 Multi-Stage Dockerfile

```dockerfile id="d35a05"
FROM node:18 AS builder

WORKDIR /app

COPY . .

FROM alpine

WORKDIR /app

COPY --from=builder /app .

CMD ["node","app.js"]
```

---

# 📌 Build Optimized Image

```bash id="d35a06"
docker build -t node-multi:v1 .
```

---

# 📌 Compare Sizes

```bash id="d35a07"
docker images
```

---

# 📌 Why Smaller?

Multi-stage build removes:
❌ Build dependencies
❌ Extra packages
❌ Unnecessary files

Final image contains only:
✅ Application files
✅ Required runtime

---

# ☁️ Task 3 – Push to Docker Hub

# 📌 Login to Docker Hub

```bash id="d35a08"
docker login
```

---

# 📌 Tag Image

```bash id="d35a09"
docker tag node-multi:v1 username/node-multi:v1
```

---

# 📌 Push Image

```bash id="d35a10"
docker push username/node-multi:v1
```

---

# 📌 Verify by Pulling

```bash id="d35a11"
docker pull username/node-multi:v1
```

---

# 📌 Docker Hub Repository

Docker Hub stores:

* Images
* Tags
* Versions

Example:

```text id="d35a12"
username/app:v1
username/app:v2
username/app:latest
```

---

# 📌 latest vs Specific Tag

| Tag      | Meaning              |
| -------- | -------------------- |
| `latest` | Most recent version  |
| `v1`     | Fixed stable version |

Best Practice:
✅ Use version tags instead of latest.

---

# 🛡️ Task 5 – Docker Best Practices

# 📌 Use Minimal Base Image

```dockerfile id="d35a13"
FROM alpine
```

Smaller than Ubuntu.

---

# 📌 Avoid Root User

```dockerfile id="d35a14"
RUN adduser -D appuser
USER appuser
```

Improves security.

---

# 📌 Combine RUN Commands

❌ Bad:

```dockerfile id="d35a15"
RUN apt update
RUN apt install curl -y
```

✅ Good:

```dockerfile id="d35a16"
RUN apt update && apt install curl -y
```

Reduces image layers.

---

# 📌 Use Specific Tags

❌ Avoid:

```dockerfile id="d35a17"
FROM ubuntu:latest
```

✅ Use:

```dockerfile id="d35a18"
FROM ubuntu:22.04
```

Provides stability.

---

# 🛠️ Important Commands

| Command         | Purpose             |
| --------------- | ------------------- |
| `docker build`  | Build image         |
| `docker images` | List images         |
| `docker login`  | Login to Docker Hub |
| `docker tag`    | Tag image           |
| `docker push`   | Push image          |
| `docker pull`   | Pull image          |

---

# 🚀 Real-World DevOps Importance

Multi-stage builds are heavily used in:

* CI/CD pipelines
* Kubernetes deployments
* Cloud-native applications
* DevSecOps
* Microservices

Optimized images improve:
✅ Security
✅ Deployment speed
✅ Storage efficiency

---

# 🎯 What I Learned

✅ Single vs multi-stage builds
✅ Docker image optimization
✅ Docker Hub workflow
✅ Image tagging & versioning
✅ Security best practices
✅ Reducing image size

---

# 🏁 Conclusion

Today’s hands-on practice helped me understand:

* How production Docker images are built
* Why multi-stage builds matter
* Docker Hub image distribution
* Security & optimization best practices

These concepts are essential before moving into:

* Kubernetes
* CI/CD pipelines
* Container orchestration
* Production-grade deployments
