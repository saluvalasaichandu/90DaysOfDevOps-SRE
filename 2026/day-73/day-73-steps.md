# Day-73 Practical Guide

# Observability with Prometheus on AWS EC2

---

# Architecture

```
Laptop
   │
   │ SSH
   ▼
AWS EC2 (Amazon Linux 2023)

        │
        ▼

Docker Engine

        │
        ▼

Docker Compose

        │
        ▼

Prometheus Container

        │
        ▼

Prometheus Web UI
```

---

# Prerequisites

You should have

* AWS Account
* EC2 Key Pair
* VS Code
* Git
* PuTTY (Windows) OR Windows Terminal
* Docker knowledge

---

# STEP 1 — Launch EC2 Instance

Login to AWS Console

```
AWS Console
```

Go to

```
EC2
```

Click

```
Launch Instance
```

---

## Instance Details

Name

```
prometheus-server
```

AMI

```
Amazon Linux 2023
```

Instance Type

```
t2.medium
```

(Recommended)

---

## Key Pair

Choose

```
Existing Key Pair
```

or

```
Create New Key Pair
```

Example

```
saichandu-key.pem
```

Download it.

---

## Network

Allow

```
SSH
```

Port

```
22
```

Source

```
My IP
```

---

Add another Security Group Rule

HTTP

```
Custom TCP

9090

Anywhere (0.0.0.0/0)
```

Because Prometheus runs on

```
9090
```

---

Click

```
Launch Instance
```

Wait until

```
Running
```

---

# STEP 2 — Connect to EC2

Open Terminal

Navigate to key

```bash
cd Downloads
```

Connect

```bash
ssh -i saichandu-key.pem ec2-user@<PUBLIC-IP>
```

Example

```bash
ssh -i saichandu-key.pem ec2-user@54.xx.xx.xx
```

You should see

```
[ec2-user@ip-xxx ~]$
```

---

# STEP 3 — Update Server

Run

```bash
sudo dnf update -y
```

Wait until complete.

---

# STEP 4 — Install Docker

Install Docker

```bash
sudo dnf install docker -y
```

---

Start Docker

```bash
sudo systemctl start docker
```

---

Enable Docker

```bash
sudo systemctl enable docker
```

---

Verify

```bash
systemctl status docker
```

Expected

```
active (running)
```

---

# STEP 5 — Give Docker Permission

Add ec2-user

```bash
sudo usermod -aG docker ec2-user
```

Apply Changes

```bash
newgrp docker
```

Verify

```bash
docker ps
```

If no permission error appears,

you're good.

---

# STEP 6 — Install Docker Compose

Amazon Linux 2023 already includes the Docker Compose plugin.

Verify:

```bash
docker compose version
```

If you see a version number, you're ready.

If not:

```bash
sudo dnf install docker-compose-plugin -y
```

Verify again:

```bash
docker compose version
```

---

# STEP 7 — Create Project Folder

```bash
mkdir observability-stack
```

Go inside

```bash
cd observability-stack
```

---

Check

```bash
pwd
```

Output

```
/home/ec2-user/observability-stack
```

---

# STEP 8 — Create prometheus.yml

Create file

```bash
vi prometheus.yml
```

Press

```
i
```

Paste

```yaml
global:
  scrape_interval: 15s

  evaluation_interval: 15s

scrape_configs:

  - job_name: "prometheus"

    static_configs:

      - targets:
          - localhost:9090
```

Save

```
ESC

:wq
```

---

Verify

```bash
cat prometheus.yml
```

---

# STEP 9 — Create docker-compose.yml

Create

```bash
vi docker-compose.yml
```

Paste

```yaml
services:

  prometheus:

    image: prom/prometheus:latest

    container_name: prometheus

    ports:

      - "9090:9090"

    volumes:

      - ./prometheus.yml:/etc/prometheus/prometheus.yml

      - prometheus_data:/prometheus

    command:

      - '--config.file=/etc/prometheus/prometheus.yml'

    restart: unless-stopped

volumes:

  prometheus_data:
```

Save

```
:wq
```

---

Verify

```bash
cat docker-compose.yml
```

---

# STEP 10 — Pull Image

```bash
docker compose pull
```

It downloads

```
prom/prometheus
```

---

# STEP 11 — Start Container

```bash
docker compose up -d
```

Expected

```
Creating prometheus...
Started
```

---

# STEP 12 — Verify Running Containers

```bash
docker ps
```

Expected

```
CONTAINER ID

prometheus

Up
```

---

# STEP 13 — Check Logs

```bash
docker logs prometheus
```

You should see

```
Server is ready

Loading configuration

Listening on 9090
```

---

# STEP 14 — Open Browser

Visit

```
http://<EC2-PUBLIC-IP>:9090
```

Example

```
http://54.xx.xx.xx:9090
```

Prometheus Home Page opens.

---

# STEP 15 — Check Targets

Go

```
Status

↓

Targets
```

Expected

```
prometheus

UP
```

Congratulations!!

Prometheus is scraping itself.

---

# STEP 16 — Run Your First PromQL Query

Click

```
Graph
```

Run

```promql
up
```

Click

```
Execute
```

Output

```
1
```

Meaning

```
Healthy
```

---

Run

```promql
count({__name__=~".+"})
```

Shows

```
Total Metrics
```

---

Run

```promql
process_resident_memory_bytes
```

Shows

```
RAM Used
```

---

Run

```promql
prometheus_http_requests_total
```

Shows

```
HTTP Requests
```

---

Run

```promql
rate(prometheus_http_requests_total[5m])
```

Shows

```
Request Rate
```

---

# STEP 17 — Add Notes App

Edit

```bash
vi docker-compose.yml
```

Add

```yaml
notes-app:

  image: trainwithshubham/notes-app:latest

  container_name: notes-app

  ports:

    - "8000:8000"

  restart: unless-stopped
```

---

# STEP 18 — Edit prometheus.yml

Add

```yaml
- job_name: "notes-app"

  static_configs:

    - targets:
        - notes-app:8000
```

The complete `prometheus.yml` should now be:

```yaml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:
  - job_name: "prometheus"
    static_configs:
      - targets:
          - localhost:9090

  - job_name: "notes-app"
    static_configs:
      - targets:
          - notes-app:8000
```

> **Important:** If the sample application does **not** expose a Prometheus `/metrics` endpoint, the target may show as **DOWN**. That's expected for some demo apps. In later days you'll use exporters such as **Node Exporter** and **cAdvisor** for proper metrics collection.

---

# STEP 19 — Restart

```bash
docker compose down
```

Then

```bash
docker compose up -d
```

---

# STEP 20 — Verify

Open

```
Status

↓

Targets
```

Expected

```
prometheus

UP

notes-app

UP (only if it exposes metrics correctly)
```

---

# STEP 21 — Generate Traffic

```bash
curl http://localhost:8000
```

Run

```bash
curl http://localhost:8000
```

Again

```bash
curl http://localhost:8000
```

Now check metrics again in Prometheus.

---

# STEP 22 — Check Storage

```bash
docker exec prometheus du -sh /prometheus
```

Displays

```
Storage Used
```

---

# STEP 23 — Check TSDB

Go

```
Status

↓

TSDB Status
```

You can see

* Number of series
* Chunks
* Storage
* Retention

---

# STEP 24 — Stop Everything

```bash
docker compose down
```

---

# STEP 25 — Start Again

```bash
docker compose up -d
```

Because we used a Docker volume, your Prometheus data is preserved across restarts.

---

## Final Folder Structure

```
observability-stack/
├── docker-compose.yml
├── prometheus.yml
└── prometheus_data/
```

## Commands You Should Know

```bash
# Update EC2
sudo dnf update -y

# Install Docker
sudo dnf install docker -y

# Start Docker
sudo systemctl start docker

# Enable Docker
sudo systemctl enable docker

# Add ec2-user to docker group
sudo usermod -aG docker ec2-user
newgrp docker

# Check Docker Compose
docker compose version

# Create project
mkdir observability-stack
cd observability-stack

# Start Prometheus
docker compose up -d

# View running containers
docker ps

# View logs
docker logs prometheus

# Stop stack
docker compose down

# Restart stack
docker compose up -d

# Check storage
docker exec prometheus du -sh /prometheus
```