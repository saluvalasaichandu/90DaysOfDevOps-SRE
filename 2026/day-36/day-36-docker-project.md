# 🚀 Day 36 – Docker Project: Dockerize a Full Application

# 📌 Project Overview

In this project, I Dockerized a complete Flask + MySQL application using:

* Docker
* Docker Compose
* Multi-container architecture
* Healthchecks
* Volumes
* Environment Variables
* Docker Hub

---

# 🏗️ Project Architecture

```text id="d36a01"
User Browser
      ↓
 Flask App Container
      ↓
 MySQL Database Container
```

---

# 📂 Project Structure

```text id="d36a02"
day-36-project/
│
├── app/
│   ├── app.py
│   ├── requirements.txt
│   ├── Dockerfile
│   └── .dockerignore
│
├── docker-compose.yml
├── .env
└── README.md
```

---

# 📌 Step 1 – Create Project Folder

```bash id="d36a03"
mkdir day-36-project
cd day-36-project

mkdir app
cd app
```

---

# 📌 Step 2 – Create Flask Application

# 📄 File: `app/app.py`

```python id="d36a04"
from flask import Flask
import mysql.connector
import os

app = Flask(__name__)

db = mysql.connector.connect(
    host=os.getenv("MYSQL_HOST"),
    user=os.getenv("MYSQL_USER"),
    password=os.getenv("MYSQL_PASSWORD"),
    database=os.getenv("MYSQL_DATABASE")
)

@app.route('/')
def home():
    return "🚀 Flask App Connected to MySQL Successfully!"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
```

---

# 📌 Step 3 – Requirements File

# 📄 File: `app/requirements.txt`

```text id="d36a05"
flask
mysql-connector-python
```

---

# 📌 Step 4 – Create Dockerfile

# 📄 File: `app/Dockerfile`

```dockerfile id="d36a06"
FROM python:3.11-alpine

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY . .

RUN adduser -D appuser

USER appuser

EXPOSE 5000

CMD ["python","app.py"]
```

---

# 📌 Dockerfile Explanation

| Instruction | Purpose              |
| ----------- | -------------------- |
| `FROM`      | Base image           |
| `WORKDIR`   | Working directory    |
| `COPY`      | Copy files           |
| `RUN`       | Install dependencies |
| `USER`      | Non-root security    |
| `EXPOSE`    | Application port     |
| `CMD`       | Start application    |

---

# 📌 Step 5 – Create .dockerignore

# 📄 File: `app/.dockerignore`

```text id="d36a07"
__pycache__
*.pyc
.git
.env
README.md
```

---

# 📌 Step 6 – Create Environment Variables

# 📄 File: `.env`

```text id="d36a08"
MYSQL_ROOT_PASSWORD=root
MYSQL_DATABASE=devopsdb
MYSQL_USER=devopsuser
MYSQL_PASSWORD=devopspass
MYSQL_HOST=db
```

---

# 📌 Step 7 – Create Docker Compose File

# 📄 File: `docker-compose.yml`

```yaml id="d36a09"
services:

  app:
    build: ./app
    container_name: flask-app

    ports:
      - "5000:5000"

    environment:
      MYSQL_HOST: db
      MYSQL_USER: ${MYSQL_USER}
      MYSQL_PASSWORD: ${MYSQL_PASSWORD}
      MYSQL_DATABASE: ${MYSQL_DATABASE}

    depends_on:
      db:
        condition: service_healthy

    networks:
      - devops-network

  db:
    image: mysql:8

    container_name: mysql-db

    restart: always

    environment:
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
      MYSQL_DATABASE: ${MYSQL_DATABASE}
      MYSQL_USER: ${MYSQL_USER}
      MYSQL_PASSWORD: ${MYSQL_PASSWORD}

    volumes:
      - mysql-data:/var/lib/mysql

    healthcheck:
      test: ["CMD","mysqladmin","ping","-h","localhost"]
      interval: 10s
      timeout: 5s
      retries: 5

    networks:
      - devops-network

volumes:
  mysql-data:

networks:
  devops-network:
```

---

# 📌 Step 8 – Build & Run Project

```bash id="d36a10"
docker compose up -d --build
```

---

# 📌 Verify Running Containers

```bash id="d36a11"
docker ps
```

---

# 📌 Access Application

Open browser:

```text id="d36a12"
http://localhost:5000
```

Expected Output:

```text id="d36a13"
🚀 Flask App Connected to MySQL Successfully!
```

---

# 📌 Check Logs

## App Logs

```bash id="d36a14"
docker logs flask-app
```

## Database Logs

```bash id="d36a15"
docker logs mysql-db
```

---

# 📌 Check Volumes

```bash id="d36a16"
docker volume ls
```

---

# 📌 Check Networks

```bash id="d36a17"
docker network ls
```

---

# 📌 Step 9 – Push Image to Docker Hub

# 📌 Login

```bash id="d36a18"
docker login
```

---

# 📌 Tag Image

```bash id="d36a19"
docker tag day-36-project-app username/flask-mysql-app:v1
```

---

# 📌 Push Image

```bash id="d36a20"
docker push username/flask-mysql-app:v1
```

---

# 📌 Pull Image Anywhere

```bash id="d36a21"
docker pull username/flask-mysql-app:v1
```

---

# 📌 Cleanup Test

## Stop Everything

```bash id="d36a22"
docker compose down
```

---

# 📌 Remove Images

```bash id="d36a23"
docker rmi $(docker images -q)
```

---

# 📌 Run Again Fresh

```bash id="d36a24"
docker compose up -d
```

---

# 📌 Important Docker Compose Commands

| Command                     | Purpose            |
| --------------------------- | ------------------ |
| `docker compose up -d`      | Start services     |
| `docker compose down`       | Stop services      |
| `docker compose ps`         | Running containers |
| `docker compose logs`       | View logs          |
| `docker compose up --build` | Rebuild images     |

---

# 📌 Challenges Faced

| Challenge             | Solution           |
| --------------------- | ------------------ |
| App started before DB | Used healthchecks  |
| DB connection failed  | Added depends_on   |
| Large image size      | Used alpine image  |
| Permission issues     | Used non-root user |

---

# 📌 What I Learned

✅ Dockerizing real applications
✅ Flask + MySQL multi-container setup
✅ Docker Compose networking
✅ Persistent storage using volumes
✅ Environment variables
✅ Healthchecks & dependencies
✅ Docker Hub image management

---

# 📌 Real-World DevOps Importance

This project simulates real production environments:

* Microservices architecture
* Container orchestration basics
* CI/CD deployment workflows
* Persistent databases
* Secure container practices

These concepts are foundational before learning:

* Kubernetes
* Helm
* GitOps
* CI/CD pipelines

---

# 📌 Final Output

| Component        | Technology     |
| ---------------- | -------------- |
| Backend          | Flask          |
| Database         | MySQL          |
| Containerization | Docker         |
| Orchestration    | Docker Compose |
| Image Registry   | Docker Hub     |

---

# 🏁 Conclusion

Today’s project helped me understand how to:

* Dockerize full-stack applications
* Connect services using Docker Compose
* Persist database data
* Push images to Docker Hub
* Build production-ready containerized applications

