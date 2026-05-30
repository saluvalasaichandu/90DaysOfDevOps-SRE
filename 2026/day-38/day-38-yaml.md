# 🚀 Day 38 – YAML Basics

## 📌 Introduction

Before working with CI/CD tools like Jenkins, GitHub Actions, GitLab CI/CD, Kubernetes, Docker Compose, and Ansible, understanding YAML is essential.

YAML (YAML Ain't Markup Language) is a human-readable data serialization language widely used for configuration files and automation pipelines.

Today I learned:

* YAML Syntax
* Key-Value Pairs
* Lists
* Nested Objects
* Multi-line Strings
* YAML Validation

---

# 🎯 Objectives

By the end of this lab, you will understand:

✅ YAML syntax and indentation

✅ Key-value pairs

✅ Lists

✅ Nested objects

✅ Multi-line strings

✅ YAML validation

---

# 📚 What is YAML?

YAML is a configuration language used by many DevOps tools.

Examples:

* Kubernetes Manifests
* Docker Compose
* GitHub Actions
* Jenkins Pipelines
* Ansible Playbooks

Example:

```yaml
name: Saichandu
role: DevOps Engineer
experience: 4
```

---

# YAML Rules

## 1. Use Spaces Only

✅ Correct

```yaml
name: DevOps
```

❌ Wrong

```yaml
name: DevOps
```

(Tabs are not allowed)

---

## 2. Indentation Matters

YAML relies on indentation to define structure.

```yaml
person:
  name: Saichandu
  role: DevOps Engineer
```

---

## 3. Key : Value Format

```yaml
name: Saichandu
role: DevOps Engineer
```

---

# 🛠️ Task 1 – Key Value Pairs

## Create person.yaml

### person.yaml

```yaml
name: Saichandu
role: DevOps Engineer
experience_years: 4
learning: true
```

---

## Verify

```bash
cat person.yaml
```

Output:

```yaml
name: Saichandu
role: DevOps Engineer
experience_years: 4
learning: true
```

---

# 🛠️ Task 2 – Lists

## Updated person.yaml

```yaml
name: Saichandu
role: DevOps Engineer
experience_years: 4
learning: true

tools:
  - Docker
  - Kubernetes
  - Jenkins
  - Terraform
  - AWS

hobbies: [Reading, Blogging]
```

---

# Two Ways to Create Lists

## Block Style

```yaml
tools:
  - Docker
  - Kubernetes
  - Jenkins
```

---

## Inline Style

```yaml
hobbies: [Reading, Blogging]
```

---

# 🛠️ Task 3 – Nested Objects

## Create server.yaml

```yaml
server:
  name: app-server
  ip: 192.168.1.10
  port: 8080

database:
  host: mysql-db
  name: employee_db

  credentials:
    user: admin
    password: admin123
```

---

# Understanding Nested Objects

```yaml
database:
  host: mysql-db
```

database is the parent object.

host is a child object.

---

# What Happens If We Use Tabs?

Example:

```yaml
server:
	name: app-server
```

Validation Error:

```text
found character '\t' that cannot start any token
```

Reason:

YAML supports spaces only.

---

# 🛠️ Task 4 – Multi-Line Strings

## Using Pipe (|)

```yaml
startup_script_pipe: |
  #!/bin/bash
  yum update -y
  systemctl start nginx
```

Output:

```text
#!/bin/bash
yum update -y
systemctl start nginx
```

---

## Using Greater Than (>)

```yaml
startup_script_folded: >
  This is a sample startup script
  that will be converted into
  a single line.
```

Output:

```text
This is a sample startup script that will be converted into a single line.
```

---

# Difference Between | and >

| Symbol | Behavior                          |
| ------ | --------------------------------- |
| |      | Preserves new lines               |
| >      | Converts lines into a single line |

---

## When to Use |

Use for:

* Shell Scripts
* Certificates
* Configurations

Example:

```yaml
script: |
  echo "Hello"
  echo "World"
```

---

## When to Use >

Use for:

* Long Descriptions
* Notes
* Messages

Example:

```yaml
description: >
  This application
  is deployed using
  Kubernetes.
```

---

# 🛠️ Task 5 – Validate YAML

## Install yamllint

Ubuntu:

```bash
sudo apt update
sudo apt install yamllint -y
```

Amazon Linux:

```bash
sudo yum install python3-pip -y
pip3 install yamllint
```

---

## Validate person.yaml

```bash
yamllint person.yaml
```

Output:

```text
No Errors
```

---

## Validate server.yaml

```bash
yamllint server.yaml
```

Output:

```text
No Errors
```

---

# Intentionally Break YAML

Example:

```yaml
server:
name: app-server
```

Validate:

```bash
yamllint server.yaml
```

Output:

```text
syntax error
mapping values are not allowed here
```

Fix indentation and validate again.

---

# 🛠️ Task 6 – Spot the Difference

## Correct YAML

```yaml
name: devops

tools:
  - docker
  - kubernetes
```

---

## Broken YAML

```yaml
name: devops

tools:
- docker
  - kubernetes
```

---

# What's Wrong?

Problem:

```yaml
- docker
```

is not properly indented under tools.

Correct:

```yaml
tools:
  - docker
  - kubernetes
```

Reason:

List items must align correctly under the parent key.

---

# Real World YAML Example

## Docker Compose

```yaml
version: "3"

services:
  nginx:
    image: nginx
    ports:
      - "80:80"
```

---

## Kubernetes Pod

```yaml
apiVersion: v1
kind: Pod

metadata:
  name: nginx

spec:
  containers:
  - name: nginx
    image: nginx
```

---

# YAML Best Practices

### Use 2 Spaces

```yaml
name: devops
```

---

### Never Use Tabs

❌ Wrong

```yaml
	name: devops
```

---

### Keep Indentation Consistent

```yaml
server:
  name: app
  port: 8080
```

---

### Validate Before Deployment

```bash
yamllint file.yaml
```

---

# Why YAML Matters in DevOps

YAML is used everywhere:

| Tool           | Usage                        |
| -------------- | ---------------------------- |
| Kubernetes     | Resource Manifests           |
| Docker Compose | Multi-container Applications |
| GitHub Actions | CI/CD Pipelines              |
| Jenkins        | Pipeline Definitions         |
| Ansible        | Playbooks                    |
| ArgoCD         | GitOps Deployments           |

---

# 📝 What I Learned

### 1. YAML Is Indentation Sensitive

Even one incorrect space can break a file.

---

### 2. Tabs Are Not Allowed

Always use spaces.

---

### 3. YAML Is Everywhere in DevOps

Most automation and CI/CD tools use YAML.

---

# 💡 Interview Questions

## What is YAML?

YAML is a human-readable configuration language used for data serialization and automation.

---

## Why Is YAML Popular?

* Easy to read
* Easy to write
* Supports nested structures
* Used by DevOps tools

---

## Difference Between | and > ?

| preserves line breaks.

> folds multiple lines into a single line.

---

## Why Are Tabs Not Allowed?

YAML uses spaces for indentation and structure.

Tabs cause parsing errors.

---

# 🏁 Conclusion

Today I learned the fundamentals of YAML.

Key Takeaways:

✅ Key-Value Pairs

✅ Lists

✅ Nested Objects

✅ Multi-line Strings

✅ YAML Validation

✅ YAML Best Practices

This knowledge will help in upcoming topics:

* Jenkins Pipelines
* GitHub Actions
* Kubernetes
* Docker Compose
* Ansible Playbooks

---
