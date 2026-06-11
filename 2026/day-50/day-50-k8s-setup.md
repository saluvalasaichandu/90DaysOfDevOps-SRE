# Day 50 – Kubernetes Architecture and Cluster Setup

## 🎯 Objective

Until now, we have been creating and managing containers using Docker. Docker is excellent for containerization, but when applications grow and need hundreds or thousands of containers across multiple servers, managing them manually becomes difficult.

Kubernetes solves this challenge by providing automated deployment, scaling, networking, self-healing, and orchestration for containerized applications.

Today marks the beginning of the Kubernetes journey.

---

# What is Kubernetes?

Kubernetes (K8s) is an open-source container orchestration platform used to automate:

* Application Deployment
* Scaling
* Load Balancing
* Service Discovery
* Self-Healing
* Rolling Updates
* High Availability

---

# Kubernetes History

## Why Kubernetes Was Created?

Docker made it easy to package applications into containers.

However, organizations faced challenges such as:

* Running containers across multiple servers
* Load balancing traffic
* Container failures
* Automatic scaling
* Zero-downtime deployments

Managing these tasks manually became difficult.

Kubernetes was created to solve these problems by automating container orchestration.

---

## Who Created Kubernetes?

Kubernetes was originally developed by Google.

It was inspired by Google's internal container orchestration system called:

**Borg**

Google donated Kubernetes to the Cloud Native Computing Foundation (CNCF).

---

## Meaning of Kubernetes

The word Kubernetes comes from Greek.

Meaning:

```text
Helmsman
or
Pilot
```

A helmsman steers a ship, just as Kubernetes manages and controls containers.

---

## Why K8s?

```text
Kubernetes

K + 8 letters + s

K8s
```

---

# Kubernetes Architecture

Kubernetes consists of:

```text
1. Control Plane (Master Node)
2. Worker Nodes
```

---

# High-Level Architecture

```text
                    User
                      |
                      |
                kubectl CLI
                      |
                      |
              +---------------+
              | API Server    |
              +---------------+
                      |
      ----------------------------------
      |                |               |
      |                |               |
      v                v               v

  +-------+      +---------+     +-----------+
  | etcd  |      |Scheduler|     |Controller |
  +-------+      +---------+     | Manager   |
                                 +-----------+

                      |
        -------------------------------------
        |                                   |
        |                                   |
        v                                   v

+-------------------+           +-------------------+
|   Worker Node 1   |           |   Worker Node 2   |
+-------------------+           +-------------------+

| kubelet          |            | kubelet          |
| kube-proxy       |            | kube-proxy       |
| containerd       |            | containerd       |
| Pod A            |            | Pod C            |
| Pod B            |            | Pod D            |

+-------------------+           +-------------------+
```

---

# Control Plane Components

The Control Plane manages the entire Kubernetes cluster.

---

## 1. API Server

### Purpose

Acts as the front door of Kubernetes.

Every command goes through API Server.

Examples:

```bash
kubectl get pods

kubectl get nodes

kubectl apply -f pod.yaml
```

The API Server receives the request and processes it.

---

## 2. etcd

### Purpose

Distributed key-value database.

Stores:

* Pod information
* Deployments
* Services
* Configurations
* Cluster state

Example:

```text
Desired Pods = 3

Running Pods = 3
```

Stored inside etcd.

---

## 3. Scheduler

### Purpose

Decides where a Pod should run.

Example:

```text
Node1 CPU = 20%
Node2 CPU = 90%

Scheduler selects Node1
```

---

## 4. Controller Manager

### Purpose

Maintains desired state.

Example:

```text
Desired Pods = 3

Current Pods = 2
```

Controller Manager automatically creates:

```text
1 Additional Pod
```

This enables self-healing.

---

# Worker Node Components

Worker Nodes run actual applications.

---

## 1. kubelet

### Purpose

Node agent.

Responsibilities:

* Receives instructions from API Server
* Creates Pods
* Monitors Pod health
* Reports status

---

## 2. kube-proxy

### Purpose

Handles networking.

Responsibilities:

* Pod communication
* Service networking
* Load balancing

---

## 3. Container Runtime

### Purpose

Runs containers.

Examples:

* containerd
* CRI-O

Earlier Docker was commonly used.

Modern Kubernetes uses containerd by default.

---

# Request Flow

## What Happens During kubectl apply?

Command:

```bash
kubectl apply -f pod.yaml
```

Flow:

```text
kubectl
   |
   v
API Server
   |
   v
etcd
   |
   v
Scheduler
   |
   v
Selected Worker Node
   |
   v
kubelet
   |
   v
containerd
   |
   v
Pod Running
```

---

# What Happens if API Server Goes Down?

### Effects

Cannot:

```text
Create Pods
Delete Pods
Update Deployments
Run kubectl Commands
```

### Existing Pods

Continue Running

Reason:

Worker nodes already have running containers.

---

# What Happens if a Worker Node Goes Down?

Suppose:

```text
Node1 Crashes
```

Controller Manager detects:

```text
Node Not Ready
```

Then:

```text
ReplicaSet creates replacement Pod
```

Scheduler places it on:

```text
Healthy Node
```

This is Kubernetes Self-Healing.

---

# Installing kubectl

## Linux

```bash
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

chmod +x kubectl

sudo mv kubectl /usr/local/bin/
```

Verify:

```bash
kubectl version --client
```

---

# Installing Kind

Kind stands for:

```text
Kubernetes IN Docker
```

---

## Install Kind

```bash
curl -Lo ./kind https://kind.sigs.k8s.io/dl/latest/kind-linux-amd64

chmod +x ./kind

sudo mv ./kind /usr/local/bin/kind
```

Verify:

```bash
kind version
```

---

# Why Choose Kind?

For learning Kubernetes:

✅ Lightweight

✅ Fast

✅ Uses Docker

✅ Easy to create/delete clusters

✅ No VM required

---

# Create Kubernetes Cluster

```bash
kind create cluster --name devops-cluster
```

Expected Output:

```text
Creating cluster "devops-cluster"

Installing CNI

Installing StorageClass

Set kubectl context
```

---

# Verify Cluster

## Cluster Information

```bash
kubectl cluster-info
```

---

## Check Nodes

```bash
kubectl get nodes
```

Example:

```text
NAME                            STATUS   ROLES
devops-cluster-control-plane    Ready    control-plane
```

---

# Screenshot

## kubectl get nodes

```text
[Screenshot Here]
```

Insert screenshot:

```bash
kubectl get nodes
```

---

# Explore Kubernetes Cluster

## List Nodes

```bash
kubectl get nodes
```

---

## Detailed Node Information

```bash
kubectl describe node <node-name>
```

---

## List Namespaces

```bash
kubectl get namespaces
```

Expected:

```text
default
kube-system
kube-public
kube-node-lease
```

---

## List All Pods

```bash
kubectl get pods -A
```

---

## kube-system Pods

```bash
kubectl get pods -n kube-system
```

Expected:

```text
coredns
etcd
kube-apiserver
kube-controller-manager
kube-scheduler
kube-proxy
```

---

# Screenshot

## kube-system Pods

```text
[Screenshot Here]
```

Insert screenshot:

```bash
kubectl get pods -n kube-system
```

---

# kube-system Components Explained

## kube-apiserver

Acts as the front door of Kubernetes.

Receives all requests.

---

## etcd

Stores cluster state.

---

## kube-scheduler

Assigns Pods to Nodes.

---

## kube-controller-manager

Maintains desired state.

---

## kube-proxy

Handles networking and load balancing.

---

## CoreDNS

Provides DNS services inside Kubernetes.

Example:

```text
frontend.default.svc.cluster.local
```

---

# Cluster Lifecycle Operations

## Delete Cluster

```bash
kind delete cluster --name devops-cluster
```

---

## Recreate Cluster

```bash
kind create cluster --name devops-cluster
```

---

## Verify Cluster

```bash
kubectl get nodes
```

---

# Kubernetes Context Commands

## Current Context

```bash
kubectl config current-context
```

---

## List Contexts

```bash
kubectl config get-contexts
```

---

## View kubeconfig

```bash
kubectl config view
```

---

# What is kubeconfig?

A kubeconfig file stores:

* Cluster Information
* API Server Endpoint
* Authentication Details
* Certificates
* Context Information

---

## Default Location

```bash
~/.kube/config
```

---

# Key Learnings

✅ Learned Kubernetes history

✅ Understood why Kubernetes was created

✅ Learned Kubernetes architecture

✅ Explored Control Plane components

✅ Explored Worker Node components

✅ Installed kubectl

✅ Installed Kind

✅ Created first Kubernetes cluster

✅ Verified cluster using kubectl

✅ Explored namespaces

✅ Explored kube-system pods

✅ Learned kubeconfig

✅ Practiced cluster lifecycle operations

---

# Interview Questions

## Q1. What is Kubernetes?

Kubernetes is an open-source container orchestration platform used for deploying, scaling, and managing containerized applications.

---

## Q2. Why Kubernetes when Docker already exists?

Docker provides containerization.

Kubernetes provides orchestration for containers running across multiple servers.

---

## Q3. What is etcd?

etcd is a distributed key-value database used to store Kubernetes cluster state.

---

## Q4. What is kubelet?

kubelet is the node agent responsible for creating and monitoring Pods.

---

## Q5. What happens when a worker node fails?

Controller Manager detects failure and ReplicaSet creates replacement Pods on healthy nodes.

---

## Q6. Where is kubeconfig stored?

```bash
~/.kube/config
```

---