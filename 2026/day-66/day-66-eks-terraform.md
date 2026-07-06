# 🚀 Day 66 – Provision an AWS EKS Cluster using Terraform Modules

> **90 Days of DevOps | TerraWeek - Day 66**

## 🎯 Objective

Provision an **Amazon EKS Cluster** using **Terraform Registry Modules**, connect **kubectl**, deploy an **Nginx application**, and destroy the complete infrastructure using Terraform.

---

# 📂 Project Structure

```text
terraform-eks/
│── providers.tf
│── variables.tf
│── terraform.tfvars
│── vpc.tf
│── eks.tf
│── outputs.tf
└── k8s/
    └── nginx-deployment.yaml
```

---

# 📖 Step 1 : Configure Provider

### providers.tf

```hcl
terraform {

  required_providers {

    aws = {
      source  = "hashicorp/aws"
      version = "~>5.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~>2.30"
    }

  }

}

provider "aws" {
  region = var.region
}
```

---

# 📖 Step 2 : Variables

### variables.tf

```hcl
variable "region" {
  default = "us-east-1"
}

variable "cluster_name" {
  default = "terraweek-eks"
}

variable "cluster_version" {
  default = "1.31"
}

variable "node_instance_type" {
  default = "t3.medium"
}

variable "node_desired_count" {
  default = 2
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}
```

---

# 📖 Step 3 : Variable Values

### terraform.tfvars

```hcl
region = "us-east-1"

cluster_name = "terraweek-eks"

cluster_version = "1.31"

node_instance_type = "t3.medium"

node_desired_count = 2

vpc_cidr = "10.0.0.0/16"
```

---

# 📖 Step 4 : Create VPC

### vpc.tf

```hcl
module "vpc" {

  source = "terraform-aws-modules/vpc/aws"
  version = "~>5.0"

  name = "terraweek-vpc"

  cidr = var.vpc_cidr

  azs = [
    "us-east-1a",
    "us-east-1b"
  ]

  public_subnets = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]

  private_subnets = [
    "10.0.3.0/24",
    "10.0.4.0/24"
  ]

  enable_nat_gateway = true

  single_nat_gateway = true

  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }

}
```

### Why Public & Private Subnets?

- Public Subnets → Load Balancers
- Private Subnets → Worker Nodes
- Subnet Tags help EKS identify where to create Load Balancers.

---

# 📖 Step 5 : Create EKS Cluster

### eks.tf

```hcl
module "eks" {

  source = "terraform-aws-modules/eks/aws"
  version = "~>20.0"

  cluster_name = var.cluster_name

  cluster_version = var.cluster_version

  cluster_endpoint_public_access = true

  vpc_id = module.vpc.vpc_id

  subnet_ids = module.vpc.private_subnets

  eks_managed_node_groups = {

    worker_nodes = {

      ami_type = "AL2_x86_64"

      instance_types = [var.node_instance_type]

      min_size = 1

      desired_size = var.node_desired_count

      max_size = 3

    }

  }

  tags = {

    Environment = "Dev"

    Project = "TerraWeek"

    ManagedBy = "Terraform"

  }

}
```

---

# 📖 Step 6 : Outputs

### outputs.tf

```hcl
output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_region" {
  value = var.region
}
```

---

# 📖 Step 7 : Deploy Infrastructure

```bash
terraform init

terraform fmt

terraform validate

terraform plan

terraform apply
```

Terraform creates approximately **30+ AWS Resources** including:

- VPC
- Public & Private Subnets
- Internet Gateway
- NAT Gateway
- Route Tables
- IAM Roles
- Security Groups
- EKS Cluster
- Managed Node Group
- Auto Scaling Group
- Launch Template

---

# 📖 Step 8 : Configure kubectl

```bash
aws eks update-kubeconfig \
--region us-east-1 \
--name terraweek-eks
```

Verify Cluster

```bash
kubectl get nodes

kubectl get pods -A

kubectl cluster-info
```

Expected Output

```
2 Worker Nodes

STATUS : Ready
```

---

# 📖 Step 9 : Deploy Nginx Application

### k8s/nginx-deployment.yaml

```yaml
apiVersion: apps/v1
kind: Deployment

metadata:
  name: nginx

spec:
  replicas: 3

  selector:
    matchLabels:
      app: nginx

  template:
    metadata:
      labels:
        app: nginx

    spec:
      containers:

      - name: nginx
        image: nginx:latest

        ports:
        - containerPort: 80

---

apiVersion: v1
kind: Service

metadata:
  name: nginx-service

spec:
  type: LoadBalancer

  selector:
    app: nginx

  ports:
  - port: 80
    targetPort: 80
```

Deploy Application

```bash
kubectl apply -f k8s/nginx-deployment.yaml
```

Verify

```bash
kubectl get deployments

kubectl get pods

kubectl get svc
```

Watch External IP

```bash
kubectl get svc nginx-service -w
```

Open Browser

```
http://<LoadBalancer-DNS>
```

Expected Output

```
Welcome to nginx!
```

---

# 📖 Step 10 : Destroy Infrastructure

Delete Kubernetes Resources

```bash
kubectl delete -f k8s/nginx-deployment.yaml
```

Destroy AWS Infrastructure

```bash
terraform destroy
```

Verify AWS Console

- No EKS Cluster
- No EC2 Worker Nodes
- No NAT Gateway
- No Load Balancer
- No VPC
- No Elastic IP
- No Security Groups

---

# 📖 Important Terraform Commands

```bash
terraform init

terraform fmt

terraform validate

terraform plan

terraform apply

terraform output

terraform destroy
```

---

# 📖 Important Kubernetes Commands

```bash
kubectl get nodes

kubectl get pods -A

kubectl get deployments

kubectl get svc

kubectl cluster-info

kubectl get events
```

---

# 📖 Interview Questions

### What is Amazon EKS?

Amazon EKS is a managed Kubernetes service provided by AWS.

### Why use Terraform for EKS?

Terraform automates infrastructure creation, making deployments repeatable, scalable, and version-controlled.

### Why are Worker Nodes deployed in Private Subnets?

For better security. Only the Load Balancer is exposed publicly.

### Why is a NAT Gateway required?

It allows Worker Nodes in private subnets to access the internet for updates without exposing them publicly.

### Why use Terraform Registry Modules?

They are reusable, production-ready modules maintained by the community that reduce code and follow best practices.

---

# 📖 Key Learnings

- Created an AWS EKS Cluster using Terraform Modules.
- Provisioned networking with VPC, Public & Private Subnets.
- Created Managed Node Groups.
- Connected kubectl to the cluster.
- Deployed an Nginx application.
- Exposed the application using an AWS LoadBalancer.
- Destroyed all resources using Terraform.

---
