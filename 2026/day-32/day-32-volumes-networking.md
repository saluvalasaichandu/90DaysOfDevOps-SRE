# 🚀 Day 32 – Docker Volumes & Networking

# 📌 Introduction

Containers are temporary by default:

* Data gets deleted when containers are removed
* Containers cannot communicate easily without networking

Today’s goal:
✅ Learn Docker Volumes
✅ Understand Data Persistence
✅ Learn Bind Mounts
✅ Understand Docker Networking
✅ Enable Container-to-Container Communication

---

# 💾 Task 1 – Problem Without Volumes

# 📌 Run MySQL Container

```bash id="d32a01"
docker run -d --name mysql-db -e MYSQL_ROOT_PASSWORD=root mysql
```

---

# 📌 Create Data

```bash id="d32a02"
docker exec -it mysql-db bash
```

Create tables/data inside DB.

---

# 📌 Remove Container

```bash id="d32a03"
docker stop mysql-db
docker rm mysql-db
```

Run new container → Data is lost ❌

### Why?

Containers are ephemeral (temporary).

---

# 📦 Task 2 – Named Volumes

# 📌 Create Volume

```bash id="d32a04"
docker volume create mysql-data
```

---

# 📌 Attach Volume

```bash id="d32a05"
docker run -d \
--name mysql-db \
-v mysql-data:/var/lib/mysql \
-e MYSQL_ROOT_PASSWORD=root \
mysql
```

---

# 📌 Verify Volumes

```bash id="d32a06"
docker volume ls
docker volume inspect mysql-data
```

---

# 📌 Result

Delete container → Run again with same volume → Data still exists ✅

---

# 📂 Task 3 – Bind Mounts

# 📌 Create Local Folder

```bash id="d32a07"
mkdir website
echo "<h1>Docker Bind Mount</h1>" > website/index.html
```

---

# 📌 Run Nginx with Bind Mount

```bash id="d32a08"
docker run -d -p 8080:80 \
-v $(pwd)/website:/usr/share/nginx/html \
nginx
```

Open:

```text id="d32a09"
http://localhost:8080
```

---

# 📌 Difference

| Named Volume       | Bind Mount             |
| ------------------ | ---------------------- |
| Managed by Docker  | Uses local host path   |
| Better for DB data | Better for development |
| Portable           | Direct host access     |

---

# 🌐 Task 4 – Docker Networking Basics

# 📌 List Networks

```bash id="d32a10"
docker network ls
```

---

# 📌 Inspect Bridge Network

```bash id="d32a11"
docker network inspect bridge
```

---

# 📌 Run Containers

```bash id="d32a12"
docker run -dit --name c1 ubuntu
docker run -dit --name c2 ubuntu
```

---

# 📌 Ping by IP

```bash id="d32a13"
docker inspect c2
docker exec -it c1 ping <container-ip>
```

Works ✅

---

# 📌 Ping by Name on Default Bridge

Usually fails ❌

---

# 🔗 Task 5 – Custom Networks

# 📌 Create Custom Network

```bash id="d32a14"
docker network create my-app-net
```

---

# 📌 Run Containers on Custom Network

```bash id="d32a15"
docker run -dit --name app1 --network my-app-net ubuntu
docker run -dit --name app2 --network my-app-net ubuntu
```

---

# 📌 Ping by Name

```bash id="d32a16"
docker exec -it app1 ping app2
```

Works ✅

---

# 📌 Why Custom Network Works?

Docker custom bridge networks provide:

* Automatic DNS resolution
* Name-based communication
* Better isolation

---

# 🏗️ Task 6 – Combine Volumes + Networking

# 📌 Create Network

```bash id="d32a17"
docker network create project-net
```

---

# 📌 Run Database Container

```bash id="d32a18"
docker run -d \
--name mysql-db \
--network project-net \
-v mysql-data:/var/lib/mysql \
-e MYSQL_ROOT_PASSWORD=root \
mysql
```

---

# 📌 Run App Container

```bash id="d32a19"
docker run -dit \
--name app \
--network project-net \
ubuntu
```

---

# 📌 Verify Communication

```bash id="d32a20"
docker exec -it app ping mysql-db
```

Success ✅

---

# 🛠️ Important Commands

| Command                 | Purpose                       |
| ----------------------- | ----------------------------- |
| `docker volume create`  | Create volume                 |
| `docker volume ls`      | List volumes                  |
| `docker network ls`     | List networks                 |
| `docker network create` | Create network                |
| `docker inspect`        | View details                  |
| `docker exec`           | Run commands inside container |

---

# 🚀 Real-World DevOps Importance

Volumes & Networking are heavily used in:

* Kubernetes Persistent Volumes
* Microservices communication
* Databases
* CI/CD pipelines
* Docker Compose
* Production container deployments

---

# 🎯 What I Learned

✅ Containers lose data without volumes
✅ Named volumes persist data
✅ Bind mounts connect host files
✅ Docker networking basics
✅ Custom bridge networking
✅ Container-to-container communication

---

# 🏁 Conclusion

Today’s hands-on practice helped me understand:

* Data persistence in Docker
* Docker storage concepts
* Networking between containers
* Real microservice-style communication

These concepts are essential before learning:

* Docker Compose
* Kubernetes networking
* Persistent Volumes
* Multi-container applications