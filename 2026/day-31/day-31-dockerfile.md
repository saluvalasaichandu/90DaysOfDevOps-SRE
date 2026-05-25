# 🚀 Day 31 – Dockerfile: Build Your Own Images

# 📌 Introduction

Dockerfiles help us create custom Docker images for applications.
Instead of manually configuring containers every time, we automate everything using code.

Today’s goal:

* Understand Dockerfiles
* Build custom images
* Learn Dockerfile instructions
* Understand CMD vs ENTRYPOINT
* Build a simple website image
* Learn Docker caching & optimization

---

# 🐳 What is a Dockerfile?

A Dockerfile is a text file containing instructions to build Docker images automatically.

Example:

```text id="d31a01"
Dockerfile → Docker Image → Docker Container
```

---

# 📂 Task 1 – First Dockerfile

# 📌 Create Project Folder

```bash id="d31a02"
mkdir my-first-image
cd my-first-image
```

---

# 📌 Create Dockerfile

```dockerfile id="d31a03"
FROM ubuntu

RUN apt update && apt install curl -y

CMD ["echo","Hello from my custom image!"]
```

---

# 📌 Build Image

```bash id="d31a04"
docker build -t my-ubuntu:v1 .
```
<img width="1365" height="623" alt="image" src="https://github.com/user-attachments/assets/926a2337-af6e-482b-98fe-841d926f6906" />


---

# 📌 Run Container

```bash id="d31a05"
docker run my-ubuntu:v1
```
<img width="1366" height="52" alt="image" src="https://github.com/user-attachments/assets/03cc6125-9d30-41da-977d-5abf7c6fc5d5" />

---

# 📌 Output

```text id="d31a06"
Hello from my custom image!
```

---

# 📘 Task 2 – Important Dockerfile Instructions

# 📌 Dockerfile Example

```dockerfile id="d31a07"
FROM ubuntu

RUN apt update && apt install nginx -y

WORKDIR /app

COPY . .

EXPOSE 80

CMD ["nginx","-g","daemon off;"]
```
<img width="1366" height="725" alt="image" src="https://github.com/user-attachments/assets/01406ba1-9622-4d04-b660-1e69d1b1b2bf" />
<img width="1366" height="352" alt="image" src="https://github.com/user-attachments/assets/f4cf9830-8fd3-4247-a57e-7bc74a88bc9e" />
<img width="1365" height="361" alt="image" src="https://github.com/user-attachments/assets/3adaabdf-c6b2-4649-b482-a71a7de2d329" />

---

# 📌 Instruction Explanation

| Instruction | Purpose                       |
| ----------- | ----------------------------- |
| `FROM`      | Base image                    |
| `RUN`       | Execute commands during build |
| `COPY`      | Copy files                    |
| `WORKDIR`   | Set working directory         |
| `EXPOSE`    | Document container port       |
| `CMD`       | Default command               |

---

# ⚙️ Task 3 – CMD vs ENTRYPOINT

# 📌 CMD Example

```dockerfile id="d31a08"
CMD ["echo","hello"]
```

### Run:

```bash id="d31a09"
docker run image-name
```
<img width="1366" height="578" alt="image" src="https://github.com/user-attachments/assets/03f36c77-6fc2-49eb-8455-ad9f28681c16" />
<img width="1212" height="123" alt="image" src="https://github.com/user-attachments/assets/78d1aad3-8631-42f1-8ccd-79e6f6f752de" />


### Override CMD:

```bash id="d31a10"
docker run image-name ls
```

CMD gets replaced.

---

# 📌 ENTRYPOINT Example

```dockerfile id="d31a11"
ENTRYPOINT ["echo"]
```

### Run:

```bash id="d31a12"
docker run image-name hello
```

Output:

```text id="d31a13"
hello
```
<img width="1366" height="703" alt="image" src="https://github.com/user-attachments/assets/4037b09e-0de5-449a-a732-07ecb596ceaf" />

ENTRYPOINT stays fixed.

---

# 📌 CMD vs ENTRYPOINT

| CMD               | ENTRYPOINT            |
| ----------------- | --------------------- |
| Default command   | Fixed executable      |
| Easily overridden | Arguments appended    |
| Flexible          | Used for main process |

---

# 🌐 Task 4 – Build Static Website

# 📌 Create index.html

```html id="d31a14"
<h1>Welcome to My Docker Website</h1>
```

---

# 📌 Dockerfile

```dockerfile id="d31a15"
FROM nginx:alpine

COPY index.html /usr/share/nginx/html/
```
<img width="1362" height="717" alt="image" src="https://github.com/user-attachments/assets/b3c44ca0-0156-49e8-a788-e7865fae54fc" />

---

# 📌 Build Image

```bash id="d31a16"
docker build -t my-website:v1 .
```
<img width="1366" height="457" alt="image" src="https://github.com/user-attachments/assets/9e1abe76-cd5b-45cf-b8b9-2458999c583f" />

---

# 📌 Run Website Container

```bash id="d31a17"
docker run -d -p 8080:80 my-website:v1
```

Open browser:

```text id="d31a18"
http://localhost:8080
```
<img width="1366" height="673" alt="image" src="https://github.com/user-attachments/assets/8cf7d50f-d942-4d8c-a9ba-c7c226c5ebce" />

---

# 🚫 Task 5 – .dockerignore

# 📌 Create .dockerignore

```text id="d31a19"
node_modules
.git
*.md
.env
```

---

# 📌 Why Use .dockerignore?

✅ Smaller images
✅ Faster builds
✅ Better security
✅ Avoid unnecessary files

---

# ⚡ Task 6 – Docker Build Optimization

# 📌 Docker Build Cache

Docker reuses unchanged layers during rebuilds.

Example:

```dockerfile id="d31a20"
COPY package.json .
RUN npm install
COPY . .
```

---

# 📌 Why Layer Order Matters

Frequently changing files should come last.

Benefits:

* Faster rebuilds
* Better caching
* Reduced build time

---

# 🛠️ Useful Docker Commands

| Command         | Purpose            |
| --------------- | ------------------ |
| `docker build`  | Build image        |
| `docker run`    | Run container      |
| `docker images` | List images        |
| `docker ps`     | Running containers |
| `docker logs`   | View logs          |
| `docker exec`   | Access container   |

---

# 🚀 Real-World DevOps Importance

Dockerfiles are used in:

* CI/CD pipelines
* Kubernetes deployments
* Microservices
* DevSecOps
* GitOps workflows

Every production container starts with a Dockerfile.

---

# 🎯 What I Learned

✅ Dockerfile basics
✅ Building custom Docker images
✅ CMD vs ENTRYPOINT
✅ Creating static website containers
✅ Docker caching & optimization
✅ Using `.dockerignore`

---

# 🏁 Conclusion

Today’s hands-on practice helped me understand:

* How Docker images are created
* How Dockerfiles automate builds
* How containers run applications
* How optimization improves build performance

These concepts are essential before moving to:

* Docker Compose
* Multi-stage builds
* Kubernetes deployments
* CI/CD container pipelines
