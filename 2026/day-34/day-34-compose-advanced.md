# 🚀 Day 34 – Docker Compose: Real-World Multi-Container Apps

# 📌 Introduction

Real-world applications use multiple services together:

* Web Application
* Database
* Cache

Docker Compose helps manage all services using one YAML file.

Today’s goal:
✅ Build multi-container stack
✅ Use Dockerfiles with Compose
✅ Add healthchecks & dependencies
✅ Use restart policies
✅ Configure networks & volumes
✅ Understand scaling basics

---

# 🏗️ Task 1 – 3-Service Application Stack

# 📌 Project Structure

```text id="d34a01"
project/
 ├── app/
 │    ├── app.py
 │    ├── requirements.txt
 │    └── Dockerfile
 └── docker-compose.yml
```

---

# 📌 Simple Flask App

## app.py

```python id="d34a02"
from flask import Flask
app = Flask(__name__)

@app.route('/')
def home():
    return "Hello from Docker Compose"

app.run(host='0.0.0.0', port=5000)
```

---

# 📌 requirements.txt

```text id="d34a03"
flask
```
<img width="924" height="715" alt="image" src="https://github.com/user-attachments/assets/faddbbdc-c987-40b4-b7af-903f7c262fda" />

---

# 📌 Dockerfile

```dockerfile id="d34a04"
FROM python:3.10

WORKDIR /app

COPY . .

RUN pip install -r requirements.txt

CMD ["python","app.py"]
```

---

# 📌 docker-compose.yml

```yaml id="d34a05"
services:

  web:
    build: ./app
    ports:
      - "5000:5000"
    depends_on:
      db:
        condition: service_healthy

  db:
    image: postgres
    environment:
      POSTGRES_PASSWORD: root
    volumes:
      - postgres-data:/var/lib/postgresql/data
    restart: always

    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 10s
      timeout: 5s
      retries: 5

  redis:
    image: redis

volumes:
  postgres-data:
```

---

# 📌 Start Application Stack

```bash id="d34a06"
docker compose up -d
```

---

# 📌 Access Application

Open:

```text id="d34a07"
http://localhost:5000
```

---

# 🔗 Task 2 – depends_on & Healthchecks

# 📌 depends_on

```yaml id="d34a08"
depends_on:
  db:
    condition: service_healthy
```

---

# 📌 Why Healthchecks Matter?

Container may start before DB is ready.

Healthchecks ensure:
✅ Service readiness
✅ Better startup ordering
✅ Stable application startup

---

# 🔄 Task 3 – Restart Policies

# 📌 Restart Always

```yaml id="d34a09"
restart: always
```

If container crashes → Docker restarts automatically.

---

# 📌 Restart on Failure

```yaml id="d34a10"
restart: on-failure
```

Restarts only if container exits with error.

---

# 📌 Restart Policy Comparison

| Policy       | Usage                  |
| ------------ | ---------------------- |
| `always`     | Production DB/services |
| `on-failure` | Jobs/scripts           |
| `no`         | Temporary containers   |

---

# 🐳 Task 4 – Build Using Dockerfile

# 📌 Build from Dockerfile

```yaml id="d34a11"
build: ./app
```

---

# 📌 Rebuild After Code Changes

```bash id="d34a12"
docker compose up --build
```

---

# 🌐 Task 5 – Networks & Volumes

# 📌 Custom Network

```yaml id="d34a13"
networks:
  app-network:
```

---

# 📌 Named Volume

```yaml id="d34a14"
volumes:
  postgres-data:
```

---

# 📌 Labels Example

```yaml id="d34a15"
labels:
  project: devops
```

---

# 📌 Updated Compose Example

```yaml id="d34a16"
services:
  web:
    networks:
      - app-network

networks:
  app-network:
```

---

# ⚡ Task 6 – Scaling

# 📌 Scale Web Containers

```bash id="d34a17"
docker compose up --scale web=3
```

---

# 📌 What Breaks?

Port mapping conflict:

```text id="d34a18"
5000:5000
```

Multiple containers cannot bind same host port.

---

# 📌 Real Solution

Use:

* Load Balancer
* Reverse Proxy
* Kubernetes Service

---

# 🛠️ Important Commands

| Command                     | Purpose              |
| --------------------------- | -------------------- |
| `docker compose up -d`      | Start services       |
| `docker compose down`       | Stop/remove services |
| `docker compose ps`         | Running services     |
| `docker compose logs`       | View logs            |
| `docker compose up --build` | Rebuild images       |
| `docker compose up --scale` | Scale containers     |

---

# 🚀 Real-World DevOps Importance

Docker Compose concepts are heavily used in:

* Local development
* CI/CD testing
* Microservices
* Dev environments
* Production simulations

These concepts are foundational before:

* Kubernetes
* Docker Swarm
* Helm
* GitOps

---

# 🎯 What I Learned

✅ Multi-container architecture
✅ Dockerfiles with Compose
✅ Healthchecks & dependencies
✅ Restart policies
✅ Named volumes & networks
✅ Scaling basics in Docker Compose

---

# 🏁 Conclusion

Today’s hands-on practice helped me understand:

* How real applications run with multiple services
* How Docker Compose simplifies orchestration
* Service dependencies & healthchecks
* Persistent storage & networking
* Scaling challenges in containerized environments

This is a strong foundation before moving into:

* Kubernetes
* Container orchestration
* Production-grade deployments
