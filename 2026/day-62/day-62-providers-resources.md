# Day 62 — Providers, Resources and Dependencies

## 📌 Overview
Day 61 created standalone resources (S3 bucket, EC2 instance) with no real relationship between them. But real-world infrastructure is **connected** — an EC2 instance lives inside a subnet, the subnet lives inside a VPC, and a security group controls what traffic is allowed in or out.

Today's goal was to build a **complete networking stack** on AWS and understand how Terraform automatically figures out the correct order to create (and destroy) interconnected resources.

---

## ✅ Expected Output
- A VPC with subnet, internet gateway, route table, security group, and an EC2 instance — all created via Terraform
- A dependency graph visualized with `terraform graph`
- This documentation file: `day-62-providers-resources.md`

---

## Task 1: Exploring the AWS Provider

### `providers.tf`
```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}
```

### Initialize and check the version
```bash
terraform init
```
The output confirmed the AWS provider was installed at the latest version matching the `~> 5.0` constraint (e.g., `5.x.x`).

### Reading `.terraform.lock.hcl`
This file **locks the exact provider version and checksums** that were downloaded. It ensures that everyone running this config — teammates, CI/CD pipelines, future-you — gets the **exact same provider version**, avoiding "it worked on my machine" issues caused by provider upgrades introducing breaking changes.

### 📝 What does `~> 5.0` mean vs `>= 5.0` vs `= 5.0.0`?
| Constraint | Meaning |
|---|---|
| `~> 5.0` | Allow any version **within the 5.x range** (e.g., 5.1, 5.20) but **not 6.0**. This is the "pessimistic" operator — safe minor upgrades only. |
| `>= 5.0` | Allow version 5.0 **or any version above it**, including 6.0, 7.0, etc. — no upper bound, riskier. |
| `= 5.0.0` | **Pin to exactly** version 5.0.0 — no upgrades at all, most restrictive. |

`~> 5.0` is the most commonly recommended choice — it allows bug fixes/minor features but blocks potentially breaking major version jumps.

---

## Task 2: Building a VPC from Scratch

### `main.tf`
```hcl
# 1. The VPC -- our isolated network, 65,536 IPs available
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "TerraWeek-VPC"
  }
}

# 2. A public subnet inside the VPC, 256 IPs available
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block               = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "TerraWeek-Public-Subnet"
  }
}

# 3. Internet Gateway -- lets traffic in/out of the VPC to the internet
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "TerraWeek-IGW"
  }
}

# 4. Route table -- defines where traffic should go
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "TerraWeek-Public-RT"
  }
}

# 5. Associate the route table with the subnet
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id
}
```

### Plan and apply
```bash
terraform plan      # Shows: 5 to add
terraform apply
```
<img width="1366" height="728" alt="image" src="https://github.com/user-attachments/assets/2516e059-ff84-4301-9d96-5809798b935b" />

### ✅ Verification
Checked the AWS VPC console — all 5 resources (VPC, subnet, IGW, route table, association) appeared correctly linked: the subnet sat inside the VPC, the route table's default route pointed to the IGW, and the association tied the route table to the subnet.

---

## Task 3: Understanding Implicit Dependencies

### How does Terraform know to create the VPC before the subnet?
Because the subnet's config references `aws_vpc.main.id`. Terraform parses these references and builds a **dependency graph** automatically — any resource that references another resource's attribute is implicitly marked as depending on it, and Terraform creates the referenced resource first.

### What would happen if the subnet were created before the VPC existed?
It's not actually possible to "try" this in Terraform directly, since Terraform always resolves dependencies before creating. But conceptually — if forced via the AWS CLI/console — the subnet creation would simply **fail**, because subnets must be associated with a valid, already-existing VPC ID.

### All implicit dependencies found in this config:
| Resource | Depends on | Because of |
|---|---|---|
| `aws_subnet.public` | `aws_vpc.main` | `vpc_id = aws_vpc.main.id` |
| `aws_internet_gateway.igw` | `aws_vpc.main` | `vpc_id = aws_vpc.main.id` |
| `aws_route_table.public_rt` | `aws_vpc.main`, `aws_internet_gateway.igw` | `vpc_id` + `gateway_id` in route block |
| `aws_route_table_association.public_assoc` | `aws_subnet.public`, `aws_route_table.public_rt` | `subnet_id` + `route_table_id` |

---

## Task 4: Adding a Security Group and EC2 Instance

### Security Group
```hcl
resource "aws_security_group" "web_sg" {
  name        = "terraweek-sg"
  description = "Allow SSH and HTTP"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "TerraWeek-SG"
  }
}
```

### EC2 Instance
```hcl
resource "aws_instance" "main" {
  ami                         = "ami-0f5ee92e2d63afc18"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "TerraWeek-Server"
  }
}
```

```bash
terraform plan
terraform apply
```

### ✅ Verification
The EC2 instance launched with a public IP and was reachable on SSH (port 22) — confirming the security group, subnet, route table, and internet gateway were all correctly wired together.

---

## Task 5: Explicit Dependencies with `depends_on`

### Second S3 bucket for logs
```hcl
resource "aws_s3_bucket" "logs" {
  bucket = "terraweek-logs-yourname-2026"

  depends_on = [aws_instance.main]

  tags = {
    Name = "TerraWeek-Logs"
  }
}
```

Even though nothing in the bucket's arguments *references* the EC2 instance, `depends_on` forces Terraform to wait until the instance is created before creating this bucket.

```bash
terraform plan
```
The plan output confirmed the bucket would be created **after** the EC2 instance, respecting the explicit dependency.

### Visualizing the dependency graph
```bash
terraform graph | dot -Tpng > graph.png
```
or, without Graphviz installed:
```bash
terraform graph
```
— pasted the DOT output into webgraphviz.com to view the full tree: VPC → subnet/IGW → route table → association, security group → EC2 instance → S3 logs bucket.

### 📝 When would you use `depends_on` in real projects?
Use it when a resource depends on another **but there's no direct attribute reference** to make that dependency implicit. Two real examples:
1. **IAM policy propagation** — an application resource needs an IAM role's permissions to be fully propagated before it starts using AWS APIs, even though it doesn't reference the IAM policy directly.
2. **Resources relying on side effects** — e.g., a database resource that depends on a VPN/peering connection being established first for connectivity, even if it doesn't reference the peering connection's ID directly in its arguments.

---

## Task 6: Lifecycle Rules and Destroy

### Added lifecycle block
```hcl
resource "aws_instance" "main" {
  # ...existing config...

  lifecycle {
    create_before_destroy = true
  }
}
```

### Changing the AMI and planning
Changed the AMI ID to a different valid AMI and ran:
```bash
terraform plan
```
The plan showed Terraform would **create the new instance first**, then destroy the old one — instead of the default behavior of destroying first. This avoids downtime since a replacement is ready before the old one disappears.

### Destroying everything
```bash
terraform destroy
```
Confirmed with `yes`. Terraform destroyed resources in **reverse dependency order** — e.g., the EC2 instance and S3 logs bucket were destroyed before the security group, which was destroyed before the route table association, then route table, IGW, subnet, and finally the VPC itself. Verified in the AWS console that nothing remained.

### 📝 The three lifecycle arguments
| Argument | What it does | When to use it |
|---|---|---|
| `create_before_destroy` | Creates the replacement resource *before* destroying the old one | Zero-downtime replacements, e.g., EC2 instances, launch templates behind a load balancer |
| `prevent_destroy` | Blocks `terraform destroy`/`apply` from deleting this resource at all (errors out instead) | Protecting critical resources like production databases or S3 buckets holding important data |
| `ignore_changes` | Tells Terraform to ignore changes to specific attributes, even if they drift from the config | When an attribute is managed outside Terraform (e.g., auto-scaling-adjusted `desired_capacity`, or tags added by another automation tool) |

---

## 🧠 Implicit vs Explicit Dependencies — Summary

| Type | How it's declared | Example in this project |
|---|---|---|
| **Implicit** | Automatically detected when one resource references another resource's attribute (e.g., `aws_vpc.main.id`) | Subnet → VPC, IGW → VPC, Route table → VPC + IGW |
| **Explicit** | Manually declared using `depends_on`, used when there's no direct attribute reference | S3 logs bucket → EC2 instance |

Terraform builds a full **dependency graph** behind the scenes from both types and uses it to decide the correct creation order (and the exact reverse order for destruction).

---

## 📸 Screenshots
- ✅ `terraform apply` output showing all resources created
- ✅ AWS VPC console showing VPC, subnet, IGW, route table all linked
- ✅ EC2 instance with public IP and correct security group
- ✅ Dependency graph (`graph.png` or Graphviz visual)

*(Insert screenshots here)*

---

## 🪜 .gitignore additions
```
*.tfstate
*.tfstate.backup
.terraform/
graph.png
```

---

## 🎯 Key Takeaway
Real infrastructure isn't a pile of disconnected resources — it's a graph of dependencies. Terraform reads the relationships in code (implicit via references, explicit via `depends_on`) and automatically figures out the safe order to create and destroy everything. Understanding this is what separates "I ran some commands" from "I can build production-grade infrastructure."

---

## 📢 Learn in Public
> "Built a complete AWS networking stack with Terraform today — VPC, subnets, internet gateway, route tables, security groups, and an EC2 instance. All connected through dependency graphs. Terraform decides the order, you define the desired state."

`#90DaysOfDevOps` `#TerraWeek` `#DevOpsKaJosh` `#TrainWithShubham`

---
**Happy Learning!**
**TrainWithShubham**
