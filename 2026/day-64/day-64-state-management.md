# Day 64 — Terraform State Management and Remote Backends

## 📌 Overview
The state file is the single most important thing in Terraform. It is the **source of truth** — the live map between your `.tf` files and what actually exists in the cloud. Lose it and Terraform forgets every resource it ever created. Corrupt it and your next `apply` could destroy production.

Today's focus: manage state like a professional — migrate to a **remote S3 backend** with **DynamoDB locking**, import existing AWS resources, perform state surgery, and simulate + fix drift.

---

## ✅ Expected Output
- Terraform state migrated from local to S3 remote backend with DynamoDB locking
- An existing AWS resource imported into Terraform state
- State drift simulated and reconciled
- This documentation file: `day-64-state-management.md`

---

## Task 1: Inspecting Current State

Used the Day 63 VPC + EC2 stack (`my_vpc`, `mysubnet`, `my_ec2`, `my_sg`, `my_bucket`) as the starting point.

```bash
terraform show
# Prints full human-readable view of every tracked resource and all its attributes

terraform state list
# Lists all resource addresses currently tracked
```

**Output of `terraform state list`:**
```
aws_instance.my_ec2
aws_internet_gateway.myigw
aws_route_table.myrt
aws_route_table_association.myrta
aws_s3_bucket.my_bucket
aws_security_group.my_sg
aws_subnet.mysubnet
aws_vpc.my_vpc
```

```bash
terraform state show aws_instance.my_ec2
# Shows every attribute AWS stored for the EC2 instance

terraform state show aws_vpc.my_vpc
# Shows every attribute AWS stored for the VPC
```

### Q1: How many resources does Terraform track?
**8 resources** — `aws_vpc`, `aws_subnet`, `aws_internet_gateway`, `aws_route_table`, `aws_route_table_association`, `aws_security_group`, `aws_instance`, `aws_s3_bucket`.

### Q2: What attributes does state store for an EC2 instance?
Far more than what was defined in `main.tf`. Beyond `ami`, `instance_type`, and `tags`, the state file also stored:
- `id` (instance ID like `i-0abc123...`)
- `public_ip`, `private_ip`, `public_dns`, `private_dns`
- `subnet_id`, `vpc_security_group_ids`
- `availability_zone`, `placement_group`
- `root_block_device` details (volume type, size, encrypted, IOPS)
- `network_interface` details
- `arn`, `instance_state`, `monitoring`, `tenancy`
- `cpu_core_count`, `cpu_threads_per_core`

Terraform stores the **full cloud resource snapshot** — not just what was explicitly written in code.

### Q3: What is the `serial` number in `terraform.tfstate`?
The `serial` is an **auto-incrementing counter** that increases by 1 every time the state file is written (every `apply`, `import`, `state mv`, etc.). It's used to detect conflicts — if two simultaneous operations try to write state, the one with the lower serial loses and gets rejected, preventing state corruption.

---

## Task 2: Setting Up S3 Remote Backend

### Why remote state?
| Local State | Remote State (S3) |
|---|---|
| Lives on one machine | Accessible by entire team |
| Lost if laptop breaks | Durable, versioned in S3 |
| No locking — multiple runs corrupt state | DynamoDB locking prevents concurrent writes |
| Sensitive outputs visible in plaintext locally | Encrypted at rest with S3 SSE |
| Manual backup required | Automatic versioning |

### Step 1: Create the backend infrastructure via AWS CLI
```bash
# Create S3 bucket (globally unique name)
aws s3api create-bucket \
  --bucket terraweek-state-saichandu \
  --region us-east-1

# Enable versioning so previous state can be recovered
aws s3api put-bucket-versioning \
  --bucket terraweek-state-saichandu \
  --versioning-configuration Status=Enabled

# Enable server-side encryption
aws s3api put-bucket-encryption \
  --bucket terraweek-state-saichandu \
  --server-side-encryption-configuration '{
    "Rules": [{
      "ApplyServerSideEncryptionByDefault": {
        "SSEAlgorithm": "AES256"
      }
    }]
  }'

# Create DynamoDB table for state locking
aws dynamodb create-table \
  --table-name terraweek-state-lock \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region us-east-1
```

> **Why DynamoDB?** The locking mechanism works by writing a `LockID` item to DynamoDB at the start of every Terraform operation and deleting it at the end. If a second operation starts and finds that item already exists, it errors out instead of proceeding — preventing two people from corrupting the state simultaneously.

### Step 2: Add backend block to `providers.tf`
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
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraweek-state-lock"
    encrypt        = true
  }
}
```

### Step 3: Migrate state
```bash
terraform init
```

Terraform detected an existing local state file and asked:
```
Do you want to copy existing state to the new backend?
Only 'yes' will be accepted to confirm.
Enter a value: yes
```

Typed `yes` — Terraform copied local `terraform.tfstate` to `s3://terraweek-state-saichandu/dev/terraform.tfstate`.

### Step 4: Verify migration
```bash
# Check S3 for the uploaded state file
aws s3 ls s3://terraweek-state-saichandu/dev/

# Verify Terraform sees no changes (state migrated correctly)
terraform plan
# Output: No changes. Infrastructure is up-to-date.
```

✅ The local `terraform.tfstate` is now empty (or replaced by a pointer). All state lives in S3.

---

## Task 3: Testing State Locking

### Simulating a concurrent run
Opened **two terminals** in the same project directory.

**Terminal 1:**
```bash
terraform apply
# Waiting for confirmation (yes/no)...
```

**Terminal 2 (while Terminal 1 is still waiting):**
```bash
terraform plan
```

**Lock error seen in Terminal 2:**
```
╷
│ Error: Error acquiring the state lock
│
│ Error message: ConditionalCheckFailedException: The conditional request failed
│ Lock Info:
│   ID:        8f3a9c12-4b21-4e9a-87d4-abc123456789
│   Path:      terraweek-state-saichandu/dev/terraform.tfstate
│   Operation: OperationTypeApply
│   Who:       saichandu@machine-name
│   Version:   1.7.0
│   Created:   2026-01-01 10:00:00 +0000 UTC
│   Info:
╵
```

### Why is locking critical for team environments?
Without locking, two developers running `terraform apply` simultaneously could:
- **Interleave writes** to the state file, corrupting it beyond recovery
- **Create duplicate resources** (one apply creates, the other doesn't know and creates again)
- **Cause silent data loss** (one apply destroys what the other just created)

DynamoDB locking ensures that only **one Terraform operation holds the lock at a time** — others wait or error out cleanly.

### Releasing a stale lock (if a run crashed mid-apply)
```bash
terraform force-unlock 8f3a9c12-4b21-4e9a-87d4-abc123456789
```
> ⚠️ Only use `force-unlock` when you are **100% certain** no other operation is running. Forcing a lock release while another apply is mid-run will corrupt state.

---

## Task 4: Importing an Existing Resource

### Theory: `terraform import` vs creating from scratch
| | `terraform import` | Normal `terraform apply` |
|---|---|---|
| AWS resource | Already exists | Created by Terraform |
| State file | Resource added to state | Resource added to state |
| `.tf` file | Must be written manually | Generated/exists in code |
| Risk | Must match reality exactly to avoid drift | Starts clean |

**When to use `import`:** When AWS resources were created manually (via console/CLI/another tool) before Terraform was adopted — it's how you bring pre-existing infra under Terraform management without destroying and recreating it.

### Step 1: Manually create a bucket in AWS console
Created bucket named: `terraweek-import-test-saichandu` in `us-east-1` via the AWS console.

### Step 2: Write the resource block in `main.tf`
```hcl
resource "aws_s3_bucket" "imported" {
  bucket = "terraweek-import-test-saichandu"
}
```

### Step 3: Import
```bash
terraform import aws_s3_bucket.imported terraweek-import-test-saichandu
```
**Output:**
```
aws_s3_bucket.imported: Importing from ID "terraweek-import-test-saichandu"...
aws_s3_bucket.imported: Import prepared!
  Prepared aws_s3_bucket for import
aws_s3_bucket.imported: Refreshing state... [id=terraweek-import-test-saichandu]

Import successful!

The resources that were imported are shown above. These resources are now in
your Terraform state and will henceforth be managed by Terraform.
```

### Step 4: Verify
```bash
terraform plan
# No changes. Infrastructure is up-to-date.

terraform state list
# aws_s3_bucket.imported now appears alongside other resources
```

✅ The manually created bucket is now under full Terraform management.

---

## Task 5: State Surgery — `mv` and `rm`

### 5a: Renaming a resource in state
```bash
terraform state list
# aws_s3_bucket.imported

terraform state mv aws_s3_bucket.imported aws_s3_bucket.logs_bucket
```
**Output:**
```
Move "aws_s3_bucket.imported" to "aws_s3_bucket.logs_bucket"
Successfully moved 1 object(s).
```

Updated `main.tf` to match:
```hcl
# renamed from "imported" to "logs_bucket"
resource "aws_s3_bucket" "logs_bucket" {
  bucket = "terraweek-import-test-saichandu"
}
```

```bash
terraform plan
# No changes. — Terraform recognised the rename; nothing in AWS was touched.
```

### 5b: Removing a resource from state (without destroying it in AWS)
```bash
terraform state rm aws_s3_bucket.logs_bucket
```
**Output:**
```
Removed aws_s3_bucket.logs_bucket
Successfully removed 1 resource instance(s).
```

```bash
terraform plan
# + 1 to add — Terraform no longer knows the bucket exists
# (but the bucket is still physically present in S3)
```

### 5c: Re-importing to bring it back
```bash
terraform import aws_s3_bucket.logs_bucket terraweek-import-test-saichandu
terraform plan
# No changes. — back in sync.
```

### 📝 When to use `state mv` vs `state rm`
| Command | When to use |
|---|---|
| `terraform state mv` | Renaming a resource in `.tf` code without destroying/recreating it in AWS (e.g., refactoring resource names, moving resources into a module) |
| `terraform state rm` | Removing a resource from Terraform management without deleting it in AWS (e.g., handing off a resource to another team/config, or temporarily ungating it from Terraform control) |

---

## Task 6: Simulating and Fixing State Drift

### What is state drift?
State drift happens when infrastructure is changed **outside of Terraform** — via the AWS console, CLI, a colleague's manual fix, or another automation tool — so that the real state of AWS no longer matches what's recorded in `terraform.tfstate`.

### Step 1: Apply to get everything in sync
```bash
terraform apply
# All resources in sync, No changes.
```

### Step 2: Manually change the EC2 instance in AWS console
- Went to **AWS Console → EC2 → my_ec2**
- Edited the `Name` tag from `"terraweek-dev-server"` → `"ManuallyChanged"`

### Step 3: Run plan — Terraform detects drift
```bash
terraform plan
```
**Output:**
```
~ aws_instance.my_ec2
    ~ tags = {
        ~ "Name" = "ManuallyChanged" -> "terraweek-dev-server"
          "Environment" = "dev"
          "ManagedBy"   = "Terraform"
          "Project"     = "terraweek"
      }

Plan: 0 to add, 1 to change, 0 to destroy.
```

Terraform read the live state from AWS, compared it to the desired state in code, and flagged the tag difference.

### Step 4: Reconcile — force reality back to match code
```bash
terraform apply
```
**Output:**
```
aws_instance.my_ec2: Modifying... [id=i-0abc123456789]
aws_instance.my_ec2: Modifications complete after 3s

Apply complete! Resources: 0 added, 1 changed, 0 destroyed.
```

```bash
terraform plan
# No changes. Infrastructure matches configuration. ✅ Drift resolved.
```

### 📝 How do teams prevent state drift in production?
- **Restrict AWS console access** — use IAM policies so developers can't manually change infrastructure in production environments.
- **All changes go through Terraform** — enforced via CI/CD pipelines (GitOps); any `apply` outside the pipeline is blocked.
- **Run `terraform plan` in CI on a schedule** — catches drift before it causes problems.
- **Use `terraform apply -refresh-only`** — updates the state to match current AWS reality without making any changes, useful for auditing drift before deciding how to handle it.
- **Sentinel / OPA policies** — policy-as-code layers (Terraform Cloud / Atlantis) that block non-compliant infra changes.

---

## 🧠 State Commands Reference

| Command | What it does | When to use |
|---|---|---|
| `terraform show` | Human-readable view of entire state | Auditing what Terraform tracks |
| `terraform state list` | Lists all tracked resource addresses | Quick overview of managed resources |
| `terraform state show <resource>` | All attributes of one resource | Debugging, checking actual values |
| `terraform state mv` | Renames a resource in state | Refactoring resource names without destroy/recreate |
| `terraform state rm` | Removes resource from state (not from AWS) | Ungating a resource from Terraform control |
| `terraform import` | Adds an existing AWS resource to state | Bringing pre-existing infra under Terraform |
| `terraform force-unlock` | Releases a stale DynamoDB lock | When a crashed apply left the lock stuck |
| `terraform apply -refresh-only` | Syncs state to match current AWS reality | Detecting and reviewing drift without changing anything |

---

## 🏗️ Local State vs Remote State — Architecture

```
LOCAL STATE (Day 61-63)                   REMOTE STATE (Day 64+)

  ┌────────────┐                          ┌────────────┐
  │  main.tf   │                          │  main.tf   │
  │ variables  │                          │ variables  │
  │ outputs    │                          │ outputs    │
  └─────┬──────┘                          └─────┬──────┘
        │ terraform apply                       │ terraform apply
        ▼                                       ▼
  ┌─────────────────┐              ┌────────────────────────┐
  │ terraform.tfstate│             │   S3 Bucket            │
  │ (local file)     │             │   dev/terraform.tfstate│
  │ ⚠️ single point  │             │   (versioned, encrypted)│
  │ of failure       │             └────────────┬───────────┘
  └─────────────────┘                           │ lock acquired
                                   ┌────────────▼───────────┐
                                   │   DynamoDB Table        │
                                   │   terraweek-state-lock  │
                                   │   (prevents concurrent  │
                                   │    writes)              │
                                   └─────────────────────────┘
```

---

## 📸 Screenshots
- ✅ `terraform state list` output
- ✅ `terraform.tfstate` in the S3 bucket (`dev/terraform.tfstate`)
- ✅ DynamoDB table showing `LockID` entry during apply
- ✅ Lock error in Terminal 2 during concurrent run
- ✅ `terraform import` success output
- ✅ `terraform plan` showing drift (tag change) and after reconciliation

*(Insert screenshots here)*

---

## 🪜 .gitignore additions
```
*.tfstate
*.tfstate.backup
.terraform/
*.auto.tfvars
```
> State now lives in S3 — there is nothing sensitive to commit locally.

---

## 🎯 Key Takeaway
Local state is fine for learning, but the moment there's a second person, a second machine, or a CI/CD pipeline involved — remote state with locking becomes non-negotiable. Migrating to S3 + DynamoDB gave the stack proper team-readiness: versioned, encrypted, locked, and accessible from anywhere. And `terraform import` proved that Terraform doesn't have to start from scratch — it can take ownership of any existing AWS resource.

---