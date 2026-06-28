# Day 61 — Introduction to Terraform and Your First AWS Infrastructure

## 📌 Overview
Until now, the focus was on deploying containers, building CI/CD pipelines, and orchestrating workloads on Kubernetes. But none of that infrastructure (servers, networks, clusters) appears on its own — someone or something has to provision it first.

Today marks the start of the **Infrastructure as Code (IaC)** journey using **Terraform** — a tool that lets you define, provision, and manage cloud infrastructure entirely through code.

By the end of this day, real AWS resources (an S3 bucket and an EC2 instance) were created and destroyed using nothing but a `.tf` file and a terminal.

---

## ✅ Expected Output
- Terraform installed and working locally
- AWS CLI installed and configured with valid credentials
- An S3 bucket and EC2 instance created **and destroyed** via Terraform
- This documentation file: `day-61-terraform-intro.md`

---

## Task 1: Understanding Infrastructure as Code (IaC)

### What is IaC, and why does it matter in DevOps?
Infrastructure as Code means defining servers, storage, networks, and other cloud resources in code files instead of manually clicking through a cloud provider's console. This code can be versioned, reviewed, shared, and re-run — the same way application code is.

It matters in DevOps because infrastructure becomes part of the development lifecycle. It can be tested, peer-reviewed, rolled back, and automated within CI/CD pipelines, instead of being a manual, undocumented, one-person task.

### What problems does IaC solve compared to manually creating resources in the AWS console?
- **No more "configuration drift"** — manual changes in the console aren't tracked anywhere, so two "identical" environments can quietly become different over time.
- **Repeatability** — spinning up a new environment (dev/staging/prod) takes minutes, not hours of repeating manual clicks.
- **Auditability** — every infrastructure change goes through Git, so there's a clear history of *who changed what and when*.
- **Disaster recovery** — if something is deleted by accident, the same `.tf` files can recreate it exactly.
- **Collaboration** — teams can review infrastructure changes via pull requests, just like application code.

### How is Terraform different from CloudFormation, Ansible, and Pulumi?
| Tool | Type | Key Difference |
|---|---|---|
| **CloudFormation** | AWS-native IaC | Locked into AWS only; Terraform works across AWS, Azure, GCP, and more |
| **Ansible** | Configuration management | Mainly used to install/configure software *on* existing servers, not to provision the cloud infrastructure itself |
| **Pulumi** | IaC using real code | Uses general-purpose languages (Python, JS, Go); Terraform uses its own declarative language called HCL |

### What does "declarative" and "cloud-agnostic" mean?
- **Declarative**: You describe the *desired end state* (e.g., "I want one S3 bucket and one EC2 instance"), and Terraform figures out the steps to get there. You don't write step-by-step imperative instructions.
- **Cloud-agnostic**: The same Terraform workflow (`init`, `plan`, `apply`, `destroy`) works regardless of which cloud provider is being used — only the provider block and resource types change.

---

## Task 2: Installing Terraform and Configuring AWS

### Install Terraform (Linux)
```bash
wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
```

### Verify installation
```bash
terraform -version
```

### Install and configure AWS CLI
```bash
aws configure
# Access Key ID, Secret Access Key, region (ap-south-1), output format (json)
```

### Verify AWS credentials work
```bash
aws sts get-caller-identity
```
This returns the AWS Account ID, User ARN, and User ID — confirming Terraform will be able to authenticate against the correct AWS account.

---

## Task 3: First Terraform Config — Creating an S3 Bucket

### Project setup
```bash
mkdir terraform-basics && cd terraform-basics
```

### `main.tf`
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

resource "aws_s3_bucket" "my_bucket" {
  bucket = "terraweek-yourname-2026"
}
```

### Terraform lifecycle
```bash
terraform init      # Downloads the AWS provider plugin
terraform plan       # Shows a preview of resources to be created
terraform apply       # Creates the bucket (confirm with 'yes')
```

### What did `terraform init` download?
It downloaded the **AWS provider plugin** — the piece of code that knows how to talk to the AWS API to create, read, update, and delete AWS resources. Without it, Terraform's core engine wouldn't know how to interact with AWS specifically.

### What does the `.terraform/` directory contain?
- `providers/` — the downloaded provider plugin binaries (e.g., the AWS provider)
- `.terraform.lock.hcl` — a lock file pinning exact provider versions, so everyone on the team uses the same version

Verified in the AWS S3 console that the bucket was successfully created.

---

## Task 4: Adding an EC2 Instance

### Updated `main.tf` (added resource)
```hcl
resource "aws_instance" "my_ec2" {
  ami           = "ami-0f5ee92e2d63afc18"
  instance_type = "t2.micro"

  tags = {
    Name = "TerraWeek-Day1"
  }
}
```

### Apply only the new resource
```bash
terraform plan      # Shows: 1 to add, 0 to change, 0 to destroy
terraform apply
```

### How does Terraform know the bucket already exists and only EC2 needs to be created?
Terraform compares the resources defined in the `.tf` files against what's recorded in the **state file** (`terraform.tfstate`). Since the S3 bucket is already recorded there as created, Terraform skips it during `plan`/`apply` and only provisions the new `aws_instance` resource that isn't in the state yet.

Verified in the AWS EC2 console that the instance was running with the tag `Name = TerraWeek-Day1`.

<img width="1366" height="299" alt="image" src="https://github.com/user-attachments/assets/ee82118d-3622-4b50-acc3-533ee941f118" />

---

## Task 5: Understanding the State File

### Commands run and what they returned
```bash
terraform show
```
→ A human-readable printout of every resource currently tracked, including all of its attributes (ID, ARN, tags, AMI, etc.) exactly as they exist in AWS right now.

```bash
terraform state list
```
→ A short list of resource addresses being managed, e.g.:
```
aws_s3_bucket.my_bucket
aws_instance.my_ec2
```

```bash
terraform state show aws_s3_bucket.my_bucket
terraform state show aws_instance.my_ec2
```
→ A detailed, attribute-by-attribute view of a single resource — bucket ARN/region for the S3 bucket; AMI, instance type, public/private IP, subnet, and tags for the EC2 instance.

### What information does the state file store?
For every resource: its unique cloud ID, all of its current attribute values (IPs, ARNs, tags, sizes, etc.), metadata about dependencies between resources, and the provider used to manage it.

### Why should the state file never be edited manually?
Terraform treats the state file as the **source of truth** for what currently exists. A manual edit (or a typo) can make Terraform believe a resource exists when it doesn't (or vice versa), causing it to try to recreate, orphan, or delete real infrastructure incorrectly on the next `plan`/`apply`.

### Why should the state file not be committed to Git?
- It can contain **sensitive data** (IP addresses, resource IDs, sometimes secrets/passwords in plaintext).
- It's environment-specific — committing it risks conflicts or stale state across team members/branches.
- Best practice is to store it remotely (e.g., S3 + DynamoDB lock) rather than version it in Git.

---

## Task 6: Modify, Plan, and Destroy

### Change made
EC2 tag updated:
```hcl
tags = {
  Name = "TerraWeek-Modified"
}
```

### `terraform plan` output symbols
- `~` → resource will be **updated in-place** (no replacement)
- `+` → resource will be **created**
- `-` → resource will be **destroyed**
- `-/+` → resource will be **destroyed and recreated**

### Was this an in-place update or destroy-and-recreate?
This was an **in-place update** (`~`). Changing a tag doesn't require AWS to tear down and rebuild the EC2 instance — only the tag attribute is modified directly via the API.

### Apply the change
```bash
terraform apply
```
Verified in the AWS console that the EC2 instance's `Name` tag updated to `TerraWeek-Modified` without the instance ID changing.

### Destroy everything
```bash
terraform destroy
```
Confirmed with `yes`. Both the S3 bucket and EC2 instance were removed. Verified in the AWS console that no leftover resources remained.

---

## 🧠 Terraform Commands Summary

| Command | What it does |
|---|---|
| `terraform init` | Initializes the working directory; downloads required provider plugins |
| `terraform plan` | Shows a preview of what will be created, changed, or destroyed — without making any real changes |
| `terraform apply` | Executes the plan and actually creates/updates/destroys resources in AWS |
| `terraform destroy` | Deletes all resources defined in the configuration and tracked in state |
| `terraform show` | Displays the current state in a human-readable format |
| `terraform state list` | Lists all resources currently tracked in the state file |
| `terraform fmt` | Auto-formats `.tf` files to standard style |
| `terraform validate` | Checks configuration syntax without contacting AWS |

---

## 🗂️ Why the State File Matters
The state file (`terraform.tfstate`) is what allows Terraform to be declarative and incremental — it's the bridge between "what's written in code" and "what actually exists in the cloud." Without it, Terraform would have no way of knowing which resources it already manages, leading to duplicate resources or failed updates. This is exactly why it needs careful handling — never edited by hand, never committed to Git, and ideally stored remotely with locking for team use.

---

## 📸 Screenshots
- ✅ `terraform apply` creating the S3 bucket and EC2 instance
- ✅ AWS Console showing both resources (S3 + EC2 with correct tags)
- ✅ `terraform destroy` confirming clean teardown

*(Insert screenshots here)*

---

## 🪜 .gitignore additions
```
*.tfstate
*.tfstate.backup
.terraform/
```

---

## 🎯 Key Takeaway
With nothing but a single `.tf` file and a terminal, real AWS infrastructure was created, modified, and destroyed — fully tracked, repeatable, and free of manual console clicks. Infrastructure as Code finally clicked.

---

## 📢 Learn in Public
> "Started the TerraWeek Challenge — installed Terraform, created my first S3 bucket and EC2 instance using code, and destroyed it all with one command. Infrastructure as Code just clicked."

`#90DaysOfDevOps` `#TerraWeek` `#DevOpsKaJosh` `#TrainWithShubham`

---
**Happy Learning!**
**TrainWithShubham**
