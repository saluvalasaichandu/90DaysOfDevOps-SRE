# 🚀 Day 37 – Docker Revision & Cheat Sheet

# 📌 Goal

Today was focused on revising Docker concepts from Days 29–36 and creating a practical Docker cheat sheet for quick reference.

---

# ✅ Docker Self-Assessment Checklist

| Topic                      | Status |
| -------------------------- | ------ |
| Run containers             | ✅      |
| Manage images & containers | ✅      |
| Dockerfile creation        | ✅      |
| CMD vs ENTRYPOINT          | ✅      |
| Volumes & bind mounts      | ✅      |
| Docker networking          | ✅      |
| Docker Compose             | ✅      |
| Environment variables      | ✅      |
| Multi-stage builds         | ✅      |
| Docker Hub push/pull       | ✅      |
| Healthchecks               | ✅      |

---

# 📌 Quick-Fire Answers

## 1. Image vs Container

* Image → Blueprint/template
* Container → Running instance of image

---

## 2. What happens when container is removed?

Container data is lost unless volumes are used.

---

## 3. Container Communication

Containers on same custom network communicate using container/service names.

---

## 4. `docker compose down -v`

Removes:

* Containers
* Networks
* Volumes

---

## 5. Why Multi-Stage Builds?

* Smaller images
* Better security
* Faster deployment

---

## 6. COPY vs ADD

| COPY             | ADD                     |
| ---------------- | ----------------------- |
| Simple file copy | Copy + extract URLs/tar |

---

## 7. `-p 8080:80`

* Host Port → 8080
* Container Port → 80

---

## 8. Docker Disk Usage

```bash
docker system df
```

---

# 📌 Docker Cheat Sheet

# 🐳 Container Commands

```bash
docker run nginx
docker run -it ubuntu
docker run -d nginx
docker ps
docker ps -a
docker stop <id>
docker rm <id>
docker logs <id>
docker exec -it <id> sh
```

---

# 🐳 Image Commands

```bash
docker pull nginx
docker build -t myapp:v1 .
docker images
docker rmi <image>
docker tag image user/app:v1
docker push user/app:v1
```

---

# 🐳 Volume Commands

```bash
docker volume create mysql-data
docker volume ls
docker volume inspect mysql-data
docker volume rm mysql-data
```

---

# 🐳 Network Commands

```bash
docker network ls
docker network create app-net
docker network inspect app-net
```

---

# 🐳 Docker Compose Commands

```bash
docker-compose up -d
docker-compose down
docker-compose ps
docker-compose logs -f
docker-compose up --build
```

---

# 🐳 Cleanup Commands

```bash
docker system prune -a
docker container prune
docker image prune
docker volume prune
docker system df
```

---

# 🐳 Important Dockerfile Instructions

| Instruction | Purpose               |
| ----------- | --------------------- |
| FROM        | Base image            |
| RUN         | Execute commands      |
| COPY        | Copy files            |
| WORKDIR     | Set working directory |
| EXPOSE      | Expose ports          |
| CMD         | Default command       |
| ENTRYPOINT  | Fixed executable      |

---

# 📌 Weak Areas Revisited

## 1. Docker Networking

* Created custom bridge network
* Connected multiple containers

## 2. Multi-Stage Builds

* Reduced image size significantly
* Improved security

---

# 📌 What I Learned

✅ Docker containers are ephemeral
✅ Volumes are critical for persistence
✅ Docker Compose simplifies multi-container setups
✅ Multi-stage builds optimize images
✅ Healthchecks improve reliability
✅ Docker networking enables service communication

---

# 📌 Why Docker Matters in DevOps

Docker helps:

* Standardize deployments
* Build scalable applications
* Simplify CI/CD
* Improve portability
* Enable Kubernetes orchestration

---

# 🏁 Conclusion

Day 37 helped reinforce all core Docker concepts including:

* Containers
* Images
* Dockerfiles
* Compose
* Networking
* Volumes
* Multi-stage builds
* Docker Hub


