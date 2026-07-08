# Day 67 — TerraWeek Capstone: Multi-Environment Infrastructure with Workspaces and Modules

## 📌 Overview
Seven days of Terraform — HCL, providers, resources, dependencies, variables, outputs, data sources, state management, remote backends, custom modules, and registry modules. Today everything comes together in one production-grade project.

The goal: build a **multi-environment AWS infrastructure** using custom modules and Terraform workspaces. **One codebase, three environments — dev, staging, and prod.** This is how infrastructure teams operate at scale.

---

## ✅ Expected Output
- A complete Terraform project with custom modules and proper file structure
- Three separate environments (dev, staging, prod) deployed using workspaces
- Each environment with its own VPC, security group, and EC2 instance with different sizing
- Everything destroyed cleanly after verification
- This documentation file: `day-67-terraweek-capstone.md`

---

## Task 1: Learning Terraform Workspaces

### Theory: What are Workspaces?
A Terraform workspace is an **isolated instance of state** within the same configuration directory. Instead of duplicating your code into separate folders per environment, workspaces let a single codebase manage multiple environments — each with its own independent state file.

```bash
mkdir terraweek-capstone && cd terraweek-capstone
terraform init

terraform workspace show          # shows: default

terraform workspace new dev
terraform workspace new staging
terraform workspace new prod

terraform workspace list
# * default
#   dev
#   prod
#   staging

terraform workspace select dev
terraform workspace select staging
terraform workspace select prod
```

### Q1: What does `terraform.workspace` return inside a config?
It returns a **string** containing the name of the currently active workspace — e.g., `"dev"`, `"staging"`, or `"prod"`. This built-in variable can be used anywhere inside your `.tf` files to drive workspace-specific behavior:
```hcl
locals {
  environment = terraform.workspace   # "dev" / "staging" / "prod"
}
```

### Q2: Where does each workspace store its state file?
| Workspace | State file path |
|---|---|
| `default` | `terraform.tfstate` (root, as usual) |
| `dev` | `terraform.tfstate.d/dev/terraform.tfstate` |
| `staging` | `terraform.tfstate.d/staging/terraform.tfstate` |
| `prod` | `terraform.tfstate.d/prod/terraform.tfstate` |

With a remote S3 backend, each workspace key becomes:
`env:/<workspace>/terraform.tfstate` automatically.

### Q3: Workspaces vs separate directories per environment?
| | Workspaces | Separate directories |
|---|---|---|
| Codebase | Single shared codebase | Separate copy per environment |
| Risk of drift | Low — all envs run same code | High — copies diverge over time |
| State isolation | Automatic per workspace | Manual, separate state files |
| Best for | Environments with same structure, different sizing | Radically different architectures per env |

---

## Task 2: Project Structure

```
terraweek-capstone/
├── main.tf               # Root — calls all three child modules
├── variables.tf          # Input variables
├── outputs.tf            # Root outputs referencing module outputs
├── providers.tf          # AWS provider + S3 remote backend
├── locals.tf             # Workspace-aware local values
├── dev.tfvars            # Dev environment values
├── staging.tfvars        # Staging environment values
├── prod.tfvars           # Prod environment values
├── .gitignore
└── modules/
    ├── vpc/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── security-group/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    └── ec2-instance/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

### `.gitignore`
```
.terraform/
*.tfstate
*.tfstate.backup
*.tfvars
.terraform.lock.hcl
terraform.tfstate.d/
```

### Why is this structure best practice?
- **Separation of concerns** — each file has a single responsibility (providers, variables, outputs never mix with resource logic).
- **Modularity** — the three child modules (`vpc`, `security-group`, `ec2-instance`) are reusable in any other project without modification.
- **Environment isolation via workspaces** — `dev.tfvars`, `staging.tfvars`, `prod.tfvars` hold the environment-specific values; the code itself is identical across all three.
- **Security** — `.gitignore` keeps state files (which may contain sensitive IPs/secrets) and tfvars (which may contain secrets) out of version control.

---

## Task 3: Custom Modules

### Module 1: `modules/vpc/`

**`modules/vpc/variables.tf`**
```hcl
variable "cidr" {
  type        = string
  description = "VPC CIDR block"
}

variable "public_subnet_cidr" {
  type        = string
  description = "Public subnet CIDR block"
}

variable "environment" {
  type        = string
  description = "Deployment environment name"
}

variable "project_name" {
  type        = string
  description = "Project name for tagging and naming"
}
```

**`modules/vpc/main.tf`**
```hcl
resource "aws_vpc" "this" {
  cidr_block           = var.cidr
  enable_dns_hostnames = true

  tags = {
    Name        = "${var.project_name}-${var.environment}-vpc"
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.this.id
  cidr_block               = var.public_subnet_cidr
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.project_name}-${var.environment}-public-subnet"
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name        = "${var.project_name}-${var.environment}-igw"
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-rt"
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}
```

**`modules/vpc/outputs.tf`**
```hcl
output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.this.id
}

output "subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.public.id
}
```

---

### Module 2: `modules/security-group/`

**`modules/security-group/variables.tf`**
```hcl
variable "vpc_id" {
  type        = string
  description = "VPC ID where the security group will be created"
}

variable "ingress_ports" {
  type        = list(number)
  description = "List of TCP ports to allow inbound"
  default     = [22, 80]
}

variable "environment" {
  type        = string
  description = "Deployment environment name"
}

variable "project_name" {
  type        = string
  description = "Project name for tagging and naming"
}
```

**`modules/security-group/main.tf`**
```hcl
resource "aws_security_group" "this" {
  name        = "${var.project_name}-${var.environment}-sg"
  description = "Security group for ${var.environment} environment"
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

  tags = {
    Name        = "${var.project_name}-${var.environment}-sg"
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
}
```

**`modules/security-group/outputs.tf`**
```hcl
output "sg_id" {
  description = "ID of the security group"
  value       = aws_security_group.this.id
}
```

---

### Module 3: `modules/ec2-instance/`

**`modules/ec2-instance/variables.tf`**
```hcl
variable "ami_id" {
  type        = string
  description = "AMI ID for the EC2 instance"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID to launch the instance in"
}

variable "security_group_ids" {
  type        = list(string)
  description = "List of security group IDs to attach"
}

variable "environment" {
  type        = string
  description = "Deployment environment name"
}

variable "project_name" {
  type        = string
  description = "Project name for tagging and naming"
}
```

**`modules/ec2-instance/main.tf`**
```hcl
resource "aws_instance" "this" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids

  tags = {
    Name        = "${var.project_name}-${var.environment}-server"
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }

  lifecycle {
    create_before_destroy = true
  }
}
```

**`modules/ec2-instance/outputs.tf`**
```hcl
output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.this.id
}

output "public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.this.public_ip
}
```

### Validate all modules
```bash
terraform validate
# Success! The configuration is valid.
```

---

## Task 4: Workspace-Aware Root Configuration

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
    key            = "capstone/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraweek-state-lock"
    encrypt        = true
  }
}

provider "aws" {
  region = "us-east-1"
}
```

### `locals.tf`
```hcl
locals {
  environment = terraform.workspace

  name_prefix = "${var.project_name}-${local.environment}"

  common_tags = {
    Project     = var.project_name
    Environment = local.environment
    ManagedBy   = "Terraform"
    Workspace   = terraform.workspace
  }
}
```

### `variables.tf`
```hcl
variable "project_name" {
  type    = string
  default = "terraweek"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR block for this environment"
}

variable "subnet_cidr" {
  type        = string
  description = "Public subnet CIDR block for this environment"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type for this environment"
}

variable "ingress_ports" {
  type        = list(number)
  description = "Ports to allow inbound"
  default     = [22, 80]
}
```

### `main.tf`
```hcl
# Data source: always fetch the latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# ── VPC Module ───────────────────────────────────────────────────────────────
module "vpc" {
  source = "./modules/vpc"

  cidr               = var.vpc_cidr
  public_subnet_cidr = var.subnet_cidr
  environment        = local.environment
  project_name       = var.project_name
}

# ── Security Group Module ────────────────────────────────────────────────────
module "sg" {
  source = "./modules/security-group"

  vpc_id        = module.vpc.vpc_id
  ingress_ports = var.ingress_ports
  environment   = local.environment
  project_name  = var.project_name
}

# ── EC2 Module ───────────────────────────────────────────────────────────────
module "ec2" {
  source = "./modules/ec2-instance"

  ami_id             = data.aws_ami.amazon_linux.id
  instance_type      = var.instance_type
  subnet_id          = module.vpc.subnet_id
  security_group_ids = [module.sg.sg_id]
  environment        = local.environment
  project_name       = var.project_name
}
```

### `outputs.tf`
```hcl
output "vpc_id" {
  value = module.vpc.vpc_id
}

output "subnet_id" {
  value = module.vpc.subnet_id
}

output "security_group_id" {
  value = module.sg.sg_id
}

output "instance_id" {
  value = module.ec2.instance_id
}

output "instance_public_ip" {
  value = module.ec2.public_ip
}

output "environment" {
  value = local.environment
}
```

### Environment tfvars files

**`dev.tfvars`**
```hcl
vpc_cidr      = "10.0.0.0/16"
subnet_cidr   = "10.0.1.0/24"
instance_type = "t2.micro"
ingress_ports = [22, 80]
```

**`staging.tfvars`**
```hcl
vpc_cidr      = "10.1.0.0/16"
subnet_cidr   = "10.1.1.0/24"
instance_type = "t2.small"
ingress_ports = [22, 80, 443]
```

**`prod.tfvars`**
```hcl
vpc_cidr      = "10.2.0.0/16"
subnet_cidr   = "10.2.1.0/24"
instance_type = "t3.small"
ingress_ports = [80, 443]
```

### Key differences across environments
| Setting | Dev | Staging | Prod |
|---|---|---|---|
| VPC CIDR | `10.0.0.0/16` | `10.1.0.0/16` | `10.2.0.0/16` |
| Instance type | `t2.micro` | `t2.small` | `t3.small` |
| SSH (port 22) | ✅ Allowed | ✅ Allowed | ❌ Blocked |
| HTTPS (port 443) | ❌ | ✅ | ✅ |
| EC2 Name tag | `terraweek-dev-server` | `terraweek-staging-server` | `terraweek-prod-server` |

> Different VPC CIDRs per environment prevent IP overlap if VPC peering is ever needed.

---

## Task 5: Deploying All Three Environments

### Dev
```bash
terraform workspace select dev
terraform plan -var-file="dev.tfvars"
terraform apply -var-file="dev.tfvars"
```

### Staging
```bash
terraform workspace select staging
terraform plan -var-file="staging.tfvars"
terraform apply -var-file="staging.tfvars"
```

### Prod
```bash
terraform workspace select prod
terraform plan -var-file="prod.tfvars"
terraform apply -var-file="prod.tfvars"
```

### Verify outputs from each workspace
```bash
terraform workspace select dev     && terraform output
terraform workspace select staging && terraform output
terraform workspace select prod    && terraform output
```

**Sample output (dev workspace):**
```
environment        = "dev"
instance_id        = "i-0abc123dev"
instance_public_ip = "3.x.x.x"
security_group_id  = "sg-0dev123"
subnet_id          = "subnet-0dev456"
vpc_id             = "vpc-0dev789"
```

### ✅ AWS Console Verification
- **3 VPCs** with CIDRs `10.0.0.0/16`, `10.1.0.0/16`, `10.2.0.0/16`
- **3 EC2 instances** — `t2.micro`, `t2.small`, `t3.small`
- **Name tags** — `terraweek-dev-server`, `terraweek-staging-server`, `terraweek-prod-server`
- **Security groups** — dev/staging allow port 22, prod does not
- All 3 environments completely isolated — no shared resources

---

## Task 6: Terraform Best Practices Guide

### 1. File Structure
Separate files for providers, variables, outputs, main logic, and locals. Never mix resource definitions with variable declarations or provider config. One file — one responsibility.

### 2. State Management
Always use a remote backend (S3 + DynamoDB). Enable versioning on the S3 bucket so you can roll back corrupted state. Enable encryption. Never commit state files to Git — they may contain sensitive output values.

### 3. Variables
Never hardcode values in resource definitions. Use `.tfvars` per environment. For sensitive values (passwords, tokens), use `TF_VAR_*` environment variables or a secrets manager — never commit them to Git.

### 4. Modules
One concern per module. A VPC module creates VPC resources only — not EC2, not security groups. Always define input `variables.tf` and `outputs.tf` so callers can compose modules. Pin registry module versions with `~> X.Y` so upgrades are intentional.

### 5. Workspaces
Use for environment isolation when all environments share the same infrastructure structure. Reference `terraform.workspace` in `locals.tf` to drive environment-specific naming and tagging automatically from a single codebase.

### 6. Security
Add `.terraform/`, `*.tfstate`, `*.tfstate.backup`, and `*.tfvars` to `.gitignore`. Encrypt state at rest. Restrict S3 bucket access with IAM policies so only CI/CD systems and senior engineers can read/write state.

### 7. Commands
Always run `terraform fmt` (formatting) and `terraform validate` (syntax) before committing. Always run `terraform plan` and review the diff before `terraform apply`. Never apply without a plan review.

### 8. Tagging
Tag every resource with at minimum: `Project`, `Environment`, `ManagedBy = "Terraform"`. Use `merge(local.common_tags, { Name = "..." })` on every resource so common tags are applied consistently without repetition.

### 9. Naming Convention
Use a consistent prefix: `<project>-<environment>-<resource-type>`. Example: `terraweek-prod-vpc`, `terraweek-dev-sg`, `terraweek-staging-server`. This makes the AWS console filterable and readable at a glance.

### 10. Cleanup
Always `terraform destroy` non-production environments when not in use. AWS charges by the hour — an idle dev EC2 instance costs money. Automate teardown of dev/staging environments at the end of business hours using CI/CD schedules.

---

## Task 7: Destroying All Environments

```bash
# Destroy prod first
terraform workspace select prod
terraform destroy -var-file="prod.tfvars"

# Destroy staging
terraform workspace select staging
terraform destroy -var-file="staging.tfvars"

# Destroy dev
terraform workspace select dev
terraform destroy -var-file="dev.tfvars"

# Delete workspaces (must be on default to delete others)
terraform workspace select default
terraform workspace delete dev
terraform workspace delete staging
terraform workspace delete prod
```

**Output after deletion:**
```
Deleted workspace "dev"!
Deleted workspace "staging"!
Deleted workspace "prod"!
```
<img width="1366" height="728" alt="image" src="https://github.com/user-attachments/assets/356a82ea-4f18-4c28-bb63-5489c81af9a5" />


✅ Verified in AWS console — all VPCs, EC2 instances, security groups, IGWs, route tables, and subnets removed. AWS account clean.

---

## 🗓️ TerraWeek — Day-by-Day Concepts Table

| Day | Concepts Covered |
|---|---|
| **61** | What is IaC, why it matters, Terraform vs CloudFormation/Ansible/Pulumi, declarative model, `init` / `plan` / `apply` / `destroy`, state basics, `.terraform/` directory |
| **62** | AWS provider versioning (`~> 5.0`), resources + implicit/explicit dependencies, `depends_on`, dependency graph (`terraform graph`), lifecycle rules (`create_before_destroy`, `prevent_destroy`, `ignore_changes`) |
| **63** | Variable types (string/number/bool/list/map), `.tfvars` files, variable precedence order, `outputs.tf`, data sources vs resources, `locals`, built-in functions (`merge`, `format`, `lookup`, `cidrsubnet`, `length`), conditional expressions |
| **64** | `terraform.tfstate` internals, serial number, S3 remote backend, DynamoDB state locking, state migration, `state list` / `show` / `mv` / `rm`, `terraform import`, state drift simulation and reconciliation, `force-unlock` |
| **65** | Module structure (root vs child), custom EC2 + security group modules, `dynamic` block, calling local modules, Terraform Registry (`terraform-aws-modules/vpc/aws`), module versioning, module outputs wiring |
| **66** | EKS cluster provisioning with modules, real-world Kubernetes infra, node groups, kubeconfig, production-grade provisioning patterns |
| **67** | Terraform workspaces, `terraform.workspace` built-in, multi-environment deployment from one codebase, workspace-aware `locals.tf`, per-environment `.tfvars`, workspace state isolation, full capstone project |

---

## 🎯 Key Takeaway
One codebase, three completely isolated environments — deployed and destroyed without a single manual console click. Workspaces + `.tfvars` is the production pattern for managing infrastructure at scale: the modules handle the "what", the variables handle the "how much", and the workspace handles the "where". This is what Terraform looks like in a real team.

---
