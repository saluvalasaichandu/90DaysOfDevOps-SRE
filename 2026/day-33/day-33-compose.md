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
docker-compose version
```
<img width="957" height="161" alt="image" src="https://github.com/user-attachments/assets/0f8c7336-509d-4bd7-904c-3cc8f16fdfcc" />

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
<img width="1366" height="470" alt="image" src="https://github.com/user-attachments/assets/df411f53-52dc-45b9-87e6-d333259a6021" />

---

# 📌 Start Compose

```bash id="d33a06"
docker compose up -d
```
<img width="1193" height="730" alt="image" src="https://github.com/user-attachments/assets/cbbf8f6a-7342-4d1b-b77d-02f536ddaacf" />

Open:

```text id="d33a07"
http://localhost:8080
```
<img width="1360" height="395" alt="image" src="https://github.com/user-attachments/assets/58db000e-ef85-408c-9f7d-4e5b9b6c0f36" />
<img width="1366" height="203" alt="image" src="https://github.com/user-attachments/assets/1cfec997-f4b9-4622-b762-fa729026fd47" />


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
<img width="924" height="729" alt="image" src="https://github.com/user-attachments/assets/7a58b400-5814-40ca-8a39-cb3cb27da520" />
<img width="1041" height="724" alt="image" src="https://github.com/user-attachments/assets/ba079e7f-1dde-4b03-8de7-18e55cdaf1da" />


---

# 📌 Start Services

```bash id="d33a10"
docker compose up -d
```

Open:

```text id="d33a11"
http://localhost:8080
```
<img width="1366" height="532" alt="image" src="https://github.com/user-attachments/assets/b3eec2d3-a506-4b8d-8c1c-1ffe79766d24" />
<img width="1366" height="588" alt="image" src="https://github.com/user-attachments/assets/1c27df26-11ef-466f-9385-8fee599e753d" />


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
