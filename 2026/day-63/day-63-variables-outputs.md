# 🚀 Day 63 – Terraform Variables, Outputs, Data Sources & Expressions

> **90 Days of DevOps | TerraWeek - Day 63**

## 📌 Objective

In **Day 62**, we created AWS infrastructure using hardcoded values. In **Day 63**, we'll make the configuration **dynamic, reusable, and production-ready** using **Variables, Variable Files, Outputs, Data Sources, Locals, Built-in Functions, and Conditional Expressions**.

---

# 📂 Project Structure

```text
day-63/
│── provider.tf
│── main.tf
│── variables.tf
│── terraform.tfvars
│── prod.tfvars
│── locals.tf
│── outputs.tf
│── .gitignore
```

---

# 📖 Terraform Variables

Variables allow us to avoid hardcoded values and reuse the same code for multiple environments.

## variables.tf

```hcl
variable "region" {
  default = "us-east-1"
}

variable "project_name" {}

variable "environment" {
  default = "dev"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "subnet_cidr" {
  default = "10.0.1.0/24"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "allowed_ports" {
  default = [22,80,443]
}

variable "extra_tags" {
  default = {}
}
```

---

# 📖 Variable Types

| Type   | Example       |
| ------ | ------------- |
| string | "dev"         |
| number | 10            |
| bool   | true          |
| list   | [22,80,443]   |
| map    | {Owner="Sai"} |

---

# 📖 Variable Files

## terraform.tfvars (Dev)

```hcl
project_name = "terraweek"
environment  = "dev"
instance_type = "t2.micro"
```

---

## prod.tfvars

```hcl
project_name = "terraweek"
environment  = "prod"
instance_type = "t3.small"
vpc_cidr = "10.1.0.0/16"
subnet_cidr = "10.1.1.0/24"
```

Run

```bash
terraform plan

terraform plan -var-file="prod.tfvars"

terraform plan -var="instance_type=t2.nano"
```

---

# 📖 Variable Precedence

```text
Default Value
      ↓
terraform.tfvars
      ↓
*.auto.tfvars
      ↓
-var-file
      ↓
TF_VAR_*
      ↓
-var
```

---

# 📖 Data Sources

Instead of hardcoding the AMI and Availability Zone, Terraform can fetch them dynamically.

```hcl
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name = "name"
    values = ["amzn2-ami-hvm-*"]
  }
}

data "aws_availability_zones" "available" {}
```

---

# 📖 Locals

```hcl
locals {

  name_prefix = "${var.project_name}-${var.environment}"

  common_tags = {
    Project = var.project_name
    Environment = var.environment
    ManagedBy = "Terraform"
  }

}
```

---

# 📖 Updated main.tf (Day-62 Refactored)

```hcl
provider "aws" {
  region = var.region
}

resource "aws_vpc" "my_vpc" {

  cidr_block = var.vpc_cidr

  tags = merge(local.common_tags,{
    Name="${local.name_prefix}-vpc"
  })

}

resource "aws_subnet" "mysubnet" {

  vpc_id = aws_vpc.my_vpc.id

  cidr_block = var.subnet_cidr

  availability_zone = data.aws_availability_zones.available.names[0]

  map_public_ip_on_launch = true

  tags = merge(local.common_tags,{
    Name="${local.name_prefix}-subnet"
  })
}

resource "aws_internet_gateway" "myigw" {

  vpc_id = aws_vpc.my_vpc.id

  tags = merge(local.common_tags,{
    Name="${local.name_prefix}-igw"
  })

}

resource "aws_route_table" "myrt" {

  vpc_id = aws_vpc.my_vpc.id

  route {

    cidr_block = "0.0.0.0/0"

    gateway_id = aws_internet_gateway.myigw.id

  }

}

resource "aws_route_table_association" "myrta" {

  subnet_id = aws_subnet.mysubnet.id

  route_table_id = aws_route_table.myrt.id

}

resource "aws_security_group" "my_sg" {

  name = "${local.name_prefix}-sg"

  vpc_id = aws_vpc.my_vpc.id

  dynamic "ingress" {

    for_each = var.allowed_ports

    content {

      from_port = ingress.value

      to_port = ingress.value

      protocol = "tcp"

      cidr_blocks = ["0.0.0.0/0"]

    }

  }

  egress {

    from_port = 0

    to_port = 0

    protocol = "-1"

    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = merge(local.common_tags,{
    Name="${local.name_prefix}-sg"
  })

}

resource "aws_instance" "my_ec2" {

  ami = data.aws_ami.amazon_linux.id

  instance_type = var.environment == "prod" ? "t3.small" : var.instance_type

  subnet_id = aws_subnet.mysubnet.id

  vpc_security_group_ids = [aws_security_group.my_sg.id]

  tags = merge(local.common_tags,{
    Name="${local.name_prefix}-server"
  })

}

resource "aws_s3_bucket" "my_bucket" {

  bucket = "${var.project_name}-${var.environment}-bucket-2026"

  depends_on = [aws_instance.my_ec2]

  tags = local.common_tags

}
```

---

# 📖 Outputs

## outputs.tf

```hcl
output "vpc_id" {
  value = aws_vpc.my_vpc.id
}

output "subnet_id" {
  value = aws_subnet.mysubnet.id
}

output "instance_id" {
  value = aws_instance.my_ec2.id
}

output "public_ip" {
  value = aws_instance.my_ec2.public_ip
}

output "public_dns" {
  value = aws_instance.my_ec2.public_dns
}

output "security_group_id" {
  value = aws_security_group.my_sg.id
}
```

Commands

```bash
terraform apply

terraform output

terraform output public_ip

terraform output -json
```

---

# 📖 Built-in Functions

```bash
terraform console
```

```hcl
upper("terraform")

join("-",["terra","week","2026"])

length(["a","b","c"])

lookup({dev="t2.micro",prod="t3.small"},"prod")

cidrsubnet("10.0.0.0/16",8,1)
```

---

# 📖 Conditional Expression

```hcl
instance_type = var.environment == "prod" ? "t3.small" : "t2.micro"
```

---

# 📖 Resource vs Data Source

| Resource               | Data Source              |
| ---------------------- | ------------------------ |
| Creates Infrastructure | Reads Existing Resources |

---

# 📖 Variable vs Local vs Output vs Data

| Component | Purpose                  |
| --------- | ------------------------ |
| Variable  | User Input               |
| Local     | Reusable Values          |
| Resource  | Creates Infrastructure   |
| Data      | Reads Existing Resources |
| Output    | Displays Values          |

---

# 📖 Important Commands

```bash
terraform init

terraform validate

terraform fmt

terraform plan

terraform apply

terraform output

terraform console

terraform destroy
```

---

# 🎯 Interview Questions

### What are Variables?

Used to make Terraform configurations reusable and dynamic.

### What are Outputs?

Display resource values after deployment.

### What is terraform.tfvars?

Stores variable values separately from code.

### What is a Data Source?

Fetches existing cloud resources without creating them.

### Difference between Variable and Local?

Variable accepts user input, whereas Local stores reusable calculated values.

### Why use Conditional Expressions?

To deploy different configurations based on the environment.

---

# ✅ Key Learnings

* Parameterized Day-62 Terraform code using Variables.
* Used **terraform.tfvars** for Dev and **prod.tfvars** for Production.
* Displayed resource details using Outputs.
* Replaced hardcoded AMIs with Data Sources.
* Used Locals for consistent naming and tagging.
* Practiced Built-in Functions using `terraform console`.
* Implemented Conditional Expressions for environment-specific instance sizing.
* Built a reusable, production-ready Terraform configuration.

---

# 🎉 Conclusion

Today I transformed my **Day-62 Terraform project** into a reusable Infrastructure as Code solution by replacing hardcoded values with **Variables, Outputs, Data Sources, Locals, and Expressions**. This enables the same Terraform code to deploy **Dev, Test, and Production** environments with minimal changes while following Infrastructure as Code best practices.
