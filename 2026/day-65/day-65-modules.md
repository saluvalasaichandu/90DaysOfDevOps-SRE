# Day 65 — Terraform Modules: Build Reusable Infrastructure

## 📌 Overview
Until now, everything was written in one big `main.tf`. That works for learning, but in real teams you manage dozens of environments with hundreds of resources. Copy-pasting configs across projects is a recipe for drift and inconsistency.

Today's focus: **Terraform Modules** — the way to package, reuse, and share infrastructure code. Think of a module like a function in programming. Write once, call many times with different inputs.

---

## ✅ Expected Output
- A custom EC2 module built from scratch
- A custom security group module wired into the EC2 module
- A VPC created using the official public Terraform Registry module
- This documentation file: `day-65-modules.md`

---

## Task 1: Understanding Module Structure

### Theory: Root Module vs Child Module
| | Root Module | Child Module |
|---|---|---|
| **What it is** | The top-level directory where `terraform apply` is run | Any module called by another module using a `module` block |
| **Lives in** | The project root (where `main.tf` sits) | `./modules/<name>/` (local) or downloaded from registry |
| **Calls** | Child modules via `module {}` blocks | Other modules (nested) or defines resources directly |
| **Has provider** | ✅ Yes — provider config lives here | ❌ No — inherits the provider from the root |

A module is simply **a directory containing `.tf` files**. There is no special keyword to declare a module — the directory itself is the module.

### Project directory structure created
```
terraform-modules/
├── main.tf               # Root module — calls child modules, wires everything
├── variables.tf          # Root-level input variables
├── outputs.tf            # Root-level outputs (referencing module outputs)
├── providers.tf          # Provider + backend config
├── locals.tf             # Shared local values (name_prefix, common_tags)
└── modules/
    ├── ec2-instance/
    │   ├── main.tf       # aws_instance resource definition
    │   ├── variables.tf  # Module input variables
    │   └── outputs.tf    # Module outputs (instance_id, public_ip, etc.)
    └── security-group/
        ├── main.tf       # aws_security_group resource definition
        ├── variables.tf  # Module input variables
        └── outputs.tf    # Module output (sg_id)
```

---

## Task 2: Building the Custom EC2 Module

### `modules/ec2-instance/variables.tf`
```hcl
variable "ami_id" {
  type        = string
  description = "AMI ID to launch the EC2 instance with"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID where the instance will be placed"
}

variable "security_group_ids" {
  type        = list(string)
  description = "List of security group IDs to attach"
}

variable "instance_name" {
  type        = string
  description = "Value for the Name tag on the EC2 instance"
}

variable "tags" {
  type        = map(string)
  description = "Additional tags to apply to the instance"
  default     = {}
}
```

### `modules/ec2-instance/main.tf`
```hcl
resource "aws_instance" "this" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids

  tags = merge(var.tags, {
    Name = var.instance_name
  })

  lifecycle {
    create_before_destroy = true
  }
}
```

### `modules/ec2-instance/outputs.tf`
```hcl
output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.this.id
}

output "public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.this.public_ip
}

output "private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = aws_instance.this.private_ip
}
```

---

## Task 3: Building the Custom Security Group Module

### Theory: `dynamic` block
A `dynamic` block generates repeated nested blocks (like `ingress`) from a list — instead of writing one `ingress {}` block per port, the `dynamic` block loops over `var.ingress_ports` and creates each rule automatically.

```
dynamic "ingress" {
  for_each = var.ingress_ports       # loops over [22, 80, 443]
  content {                          # defines what each iteration creates
    from_port = ingress.value        # ingress.value = current list item
    to_port   = ingress.value
    ...
  }
}
```

### `modules/security-group/variables.tf`
```hcl
variable "vpc_id" {
  type        = string
  description = "VPC ID where the security group will be created"
}

variable "sg_name" {
  type        = string
  description = "Name of the security group"
}

variable "ingress_ports" {
  type        = list(number)
  description = "List of TCP ports to allow inbound"
  default     = [22, 80]
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the security group"
  default     = {}
}
```

### `modules/security-group/main.tf`
```hcl
resource "aws_security_group" "this" {
  name        = var.sg_name
  description = "Security group managed by Terraform module"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.ingress_ports
    content {
      description = "Allow port ${ingress.value}"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = var.sg_name
  })
}
```

### `modules/security-group/outputs.tf`
```hcl
output "sg_id" {
  description = "ID of the security group"
  value       = aws_security_group.this.id
}
```

---

## Task 4: Calling Modules from Root

### `providers.tf`
```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "terraweek-state-saichandu"
    key            = "day65/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraweek-state-lock"
    encrypt        = true
  }
}

provider "aws" {
  region = var.region
}
```

### `variables.tf`
```hcl
variable "region" {
  type    = string
  default = "us-east-1"
}

variable "project_name" {
  type = string
}

variable "environment" {
  type    = string
  default = "dev"
}
```

### `locals.tf`
```hcl
locals {
  name_prefix = "${var.project_name}-${var.environment}"

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}
```

### `main.tf` (Root — wires VPC + both custom modules)
```hcl
# Data sources
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# VPC and networking (hand-written for now — replaced in Task 5)
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-vpc"
  })
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block               = "10.0.1.0/24"
  availability_zone        = "us-east-1a"
  map_public_ip_on_launch = true

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-public-subnet"
  })
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags   = local.common_tags
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = local.common_tags
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id
}

# ── Security Group Module ────────────────────────────────────────────────────
module "web_sg" {
  source        = "./modules/security-group"

  vpc_id        = aws_vpc.main.id
  sg_name       = "${local.name_prefix}-web-sg"
  ingress_ports = [22, 80, 443]
  tags          = local.common_tags
}

# ── EC2 Module — Web Server ─────────────────────────────────────────────────
module "web_server" {
  source             = "./modules/ec2-instance"

  ami_id             = data.aws_ami.amazon_linux.id
  instance_type      = "t2.micro"
  subnet_id          = aws_subnet.public.id
  security_group_ids = [module.web_sg.sg_id]
  instance_name      = "${local.name_prefix}-web"
  tags               = local.common_tags
}

# ── EC2 Module — API Server (same module, different inputs) ─────────────────
module "api_server" {
  source             = "./modules/ec2-instance"

  ami_id             = data.aws_ami.amazon_linux.id
  instance_type      = "t2.micro"
  subnet_id          = aws_subnet.public.id
  security_group_ids = [module.web_sg.sg_id]
  instance_name      = "${local.name_prefix}-api"
  tags               = local.common_tags
}
```

### `outputs.tf` (Root)
```hcl
output "web_server_id" {
  value = module.web_server.instance_id
}

output "web_server_ip" {
  value = module.web_server.public_ip
}

output "api_server_id" {
  value = module.api_server.instance_id
}

output "api_server_ip" {
  value = module.api_server.public_ip
}

output "security_group_id" {
  value = module.web_sg.sg_id
}
```

### `terraform.tfvars`
```hcl
project_name = "terraweek"
environment  = "dev"
```

### Apply
```bash
terraform init      # links local modules from ./modules/
terraform plan      # shows resources from both module calls
terraform apply
```

**Plan output showed:**
```
Plan: 9 to add, 0 to change, 0 to destroy.

# module.web_server.aws_instance.this  → terraweek-dev-web
# module.api_server.aws_instance.this  → terraweek-dev-api
# module.web_sg.aws_security_group.this
# + vpc, subnet, igw, route table, association
```

### ✅ Verification
Both EC2 instances appeared in the AWS console — `terraweek-dev-web` and `terraweek-dev-api` — sharing the same security group, same subnet, launched from the exact same module source with only the `instance_name` input differing. No copy-paste required.
<img width="1364" height="727" alt="image" src="https://github.com/user-attachments/assets/3c178464-9c7e-4e0e-88e2-ff9bb6d98179" />
<img width="1356" height="711" alt="image" src="https://github.com/user-attachments/assets/54961ea5-0efc-44a2-be0a-d6c9c8b01148" />
<img width="1366" height="290" alt="image" src="https://github.com/user-attachments/assets/fa62a40a-c23c-416f-8da3-32641d70f953" />
<img width="1363" height="565" alt="image" src="https://github.com/user-attachments/assets/0c92cdc9-470b-4b18-badf-6c6594ed341a" />
<img width="1357" height="575" alt="image" src="https://github.com/user-attachments/assets/89c652af-f2d0-4f17-9338-d29ad36f892f" />

---

## Task 5: Using a Public Registry Module

### Why a registry module?
Writing a production-grade VPC from scratch (subnets, IGW, route tables, NAT gateways, NACLs, route associations) takes 80+ lines and is error-prone. The official `terraform-aws-modules/vpc/aws` module is community-maintained, battle-tested, and handles all edge cases with one module block.

### Replace hand-written VPC in `main.tf`
```hcl
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "${local.name_prefix}-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]

  enable_nat_gateway   = false
  enable_dns_hostnames = true

  tags = local.common_tags
}
```

### Update EC2 and SG module calls to use registry VPC outputs
```hcl
module "web_sg" {
  source        = "./modules/security-group"
  vpc_id        = module.vpc.vpc_id       # ← from registry module output
  sg_name       = "${local.name_prefix}-web-sg"
  ingress_ports = [22, 80, 443]
  tags          = local.common_tags
}

module "web_server" {
  source             = "./modules/ec2-instance"
  ami_id             = data.aws_ami.amazon_linux.id
  instance_type      = "t2.micro"
  subnet_id          = module.vpc.public_subnets[0]   # ← first public subnet
  security_group_ids = [module.web_sg.sg_id]
  instance_name      = "${local.name_prefix}-web"
  tags               = local.common_tags
}

module "api_server" {
  source             = "./modules/ec2-instance"
  ami_id             = data.aws_ami.amazon_linux.id
  instance_type      = "t2.micro"
  subnet_id          = module.vpc.public_subnets[0]
  security_group_ids = [module.web_sg.sg_id]
  instance_name      = "${local.name_prefix}-api"
  tags               = local.common_tags
}
```

```bash
terraform init     # downloads the registry module
terraform plan
terraform apply
```

### Hand-written VPC vs Registry VPC module
| | Hand-written (Day 62) | Registry module (`~> 5.0`) |
|---|---|---|
| Lines of HCL written | ~40 lines | ~15 lines |
| Resources created | 5 | 15+ (subnets, RTBs, IGW, NACLs, route associations, etc.) |
| Features | Basic public subnet only | Public + private subnets, optional NAT, DNS, VPN support |
| Maintenance | Manual | Community-maintained, regularly updated |

### Where does Terraform download registry modules?
```bash
ls .terraform/modules/
```
Registry modules are downloaded into `.terraform/modules/<module_name>/` during `terraform init`. The exact path and version are also recorded in `.terraform/modules/modules.json`.

```
.terraform/
└── modules/
    ├── modules.json          # index of all downloaded modules
    ├── vpc/                  # terraform-aws-modules/vpc/aws
    │   └── (full source)
    ├── web_server/           # symlinked to local ./modules/ec2-instance
    └── api_server/           # symlinked to local ./modules/ec2-instance
```

---

## Task 6: Module Versioning and Best Practices

### Version constraint syntax
```hcl
# Exact version — safest for production, no surprise upgrades
version = "5.1.0"

# Pessimistic constraint — any 5.x version, but not 6.0
version = "~> 5.0"

# Range — greater than or equal to 5.0, less than 6.0
version = ">= 5.0, < 6.0"
```

```bash
# Check for newer available versions and upgrade if allowed by constraint
terraform init -upgrade
```

### State list showing module prefixes
```bash
terraform state list
```
```
module.api_server.aws_instance.this
module.vpc.aws_internet_gateway.this[0]
module.vpc.aws_route.public_internet_gateway[0]
module.vpc.aws_route_table.public[0]
module.vpc.aws_route_table_association.public[0]
module.vpc.aws_route_table_association.public[1]
module.vpc.aws_subnet.private[0]
module.vpc.aws_subnet.private[1]
module.vpc.aws_subnet.public[0]
module.vpc.aws_subnet.public[1]
module.vpc.aws_vpc.this[0]
module.web_server.aws_instance.this
module.web_sg.aws_security_group.this
```

Every resource is namespaced under `module.<name>.` — clean separation, easy to identify which module owns which resource.

### Destroy everything
```bash
terraform destroy
```
Terraform destroyed resources in reverse dependency order — EC2 instances first, then security group, then VPC components.

### 📝 Five Module Best Practices
1. **Always pin versions for registry modules** — `version = "~> 5.0"` prevents surprise breaking changes on `terraform init`. Never use a registry module without a version constraint.
2. **Keep modules focused — one concern per module** — an EC2 module should only create EC2 instances. It should not also create security groups or S3 buckets. Focused modules are reusable in more situations.
3. **Use variables for everything, hardcode nothing** — every value that could differ between environments (name, instance type, CIDR, tags) should be a variable with a sensible default. A module with hardcoded values can only be used once.
4. **Always define outputs so callers can reference resources** — if the security group module didn't output `sg_id`, the EC2 module call couldn't wire them together. Outputs are the module's public API.
5. **Add a `README.md` to every custom module** — document what the module does, all input variables (type, description, default), and all outputs. Future-you and teammates will thank you.

---

## 🧠 How Module Outputs Flow

```
Root module
│
├── module "vpc"                           registry module
│   └── outputs: vpc_id, public_subnets[]
│                    │
├── module "web_sg"  ◄──── vpc_id         custom module
│   └── outputs: sg_id
│                    │
├── module "web_server" ◄── sg_id         custom module
│   └── outputs: instance_id, public_ip
│
└── module "api_server" ◄── sg_id         same custom module, different inputs
    └── outputs: instance_id, public_ip
         │
         ▼
  Root outputs.tf → terraform output → used by CI/CD / other scripts
```

---

## 📸 Screenshots
- ✅ Project directory tree (`ls -R terraform-modules/`)
- ✅ `terraform init` output showing local + registry modules linked
- ✅ `terraform plan` showing resources under `module.web_server.*` and `module.api_server.*`
- ✅ AWS console — two EC2 instances (`terraweek-dev-web`, `terraweek-dev-api`) running
- ✅ `terraform state list` showing `module.` prefixes
- ✅ `.terraform/modules/` directory contents

*(Insert screenshots here)*

---

## 🪜 .gitignore additions
```
*.tfstate
*.tfstate.backup
.terraform/
*.auto.tfvars
```

---

## 🎯 Key Takeaway
The same `ec2-instance` module source was called twice with different inputs to produce two completely independent EC2 instances — no code duplication. Then 40 lines of hand-written VPC code was replaced with a single, production-grade `module "vpc"` block from the public registry. Modules are the key to scalable, maintainable infrastructure code: write once, configure many times.

---
