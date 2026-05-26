# 🚀 Day 33 – Docker Compose: Multi-Container Basics

# 📌 Introduction

Managing multiple containers manually is difficult.
Docker Compose helps us define and run multi-container applications using a single YAML file.

Today’s goal:
✅ Learn Docker Compose
✅ Run multi-container apps
✅ Use volumes & networking automatically
✅ Manage services with simple commands
✅ Use environment variables

---

# 🐳 What is Docker Compose?

Docker Compose is a tool used to define and run multi-container Docker applications.

Instead of:

```text id="d33a01"
docker run ...
docker network create ...
docker volume create ...
```

We use one file:

```text id="d33a02"
docker-compose.yml
```

---

# 📌 Task 1 – Verify Docker Compose

# 📌 Check Version

```bash id="d33a03"
docker compose version
```

---

# 📂 Task 2 – First Compose File

# 📌 Create Project Folder

```bash id="d33a04"
mkdir compose-basics
cd compose-basics
```

---

# 📌 docker-compose.yml

```yaml id="d33a05"
services:
  nginx:
    image: nginx
    ports:
      - "8080:80"
```

---

# 📌 Start Compose

```bash id="d33a06"
docker compose up -d
```

Open:

```text id="d33a07"
http://localhost:8080
```

---

# 📌 Stop Compose

```bash id="d33a08"
docker compose down
```

---

# 🌐 Task 3 – WordPress + MySQL Setup

# 📌 docker-compose.yml

```yaml id="d33a09"
services:

  db:
    image: mysql:5.7
    environment:
      MYSQL_ROOT_PASSWORD: root
      MYSQL_DATABASE: wordpress
    volumes:
      - mysql-data:/var/lib/mysql

  wordpress:
    image: wordpress
    ports:
      - "8080:80"
    environment:
      WORDPRESS_DB_HOST: db
      WORDPRESS_DB_USER: root
      WORDPRESS_DB_PASSWORD: root
      WORDPRESS_DB_NAME: wordpress

volumes:
  mysql-data:
```

---

# 📌 Start Services

```bash id="d33a10"
docker compose up -d
```

Open:

```text id="d33a11"
http://localhost:8080
```

---

# 📌 Why It Works?

Docker Compose automatically:
✅ Creates network
✅ Connects containers
✅ Enables DNS communication
✅ Manages volumes

WordPress connects to MySQL using:

```text id="d33a12"
db
```

(service name)

---

# 📌 Data Persistence

Stop & restart:

```bash id="d33a13"
docker compose down
docker compose up -d
```

Data still exists because:

```text id="d33a14"
Named Volume
```

is used.

---

# ⚙️ Task 4 – Compose Commands

# 📌 Detached Mode

```bash id="d33a15"
docker compose up -d
```

---

# 📌 Running Services

```bash id="d33a16"
docker compose ps
```

---

# 📌 View Logs

```bash id="d33a17"
docker compose logs
```

---

# 📌 Real-Time Logs

```bash id="d33a18"
docker compose logs -f
```

---

# 📌 Specific Service Logs

```bash id="d33a19"
docker compose logs wordpress
```

---

# 📌 Stop Services

```bash id="d33a20"
docker compose stop
```

---

# 📌 Remove Everything

```bash id="d33a21"
docker compose down
```

---

# 📌 Rebuild Images

```bash id="d33a22"
docker compose up --build
```

---

# 🌍 Task 5 – Environment Variables

# 📌 Using Variables in Compose

```yaml id="d33a23"
environment:
  MYSQL_ROOT_PASSWORD: root
```

---

# 📌 Using .env File

## .env

```text id="d33a24"
MYSQL_PASSWORD=root
```

---

# 📌 docker-compose.yml

```yaml id="d33a25"
environment:
  MYSQL_ROOT_PASSWORD: ${MYSQL_PASSWORD}
```

---

# 📌 Verify Variables

```bash id="d33a26"
docker compose config
```

---

# 🛠️ Important Docker Compose Commands

| Command                  | Purpose          |
| ------------------------ | ---------------- |
| `docker compose up`      | Start services   |
| `docker compose down`    | Remove services  |
| `docker compose ps`      | List containers  |
| `docker compose logs`    | View logs        |
| `docker compose stop`    | Stop services    |
| `docker compose restart` | Restart services |

---

# 🚀 Real-World DevOps Importance

Docker Compose is widely used for:

* Local development
* Microservices testing
* CI/CD environments
* Full-stack applications
* Dev environments

---

# 🎯 What I Learned

✅ Docker Compose basics
✅ Multi-container applications
✅ Automatic networking
✅ Named volumes
✅ Service-to-service communication
✅ Environment variables in Compose

---

# 🏁 Conclusion

Today’s hands-on practice helped me understand:

* How to manage multiple containers easily
* Docker Compose YAML structure
* Persistent storage with volumes
* Networking between services
* Environment variable management

These concepts are essential before learning:

* Kubernetes
* Docker Swarm
* Production container orchestration
