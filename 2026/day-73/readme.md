# 🚀 Day 73 – AWS IAM: Users, Groups, Policies, Roles & EC2 Instance Profiles

> **102 Days of DevOps | AWS DevOps - Day 73**

## 📌 Objective

Today I learned **AWS Identity and Access Management (IAM)**, one of the most important security services in AWS.

The goal is to understand how AWS controls **authentication** and **authorization** and how DevOps engineers securely provide access to users, applications, EC2 instances, and AWS services.

### Today's Hands-On

- Create an IAM User
- Create an IAM Group
- Add User to Group
- Create a Custom IAM Policy using JSON
- Attach Policy to Group
- Create an IAM Role
- Understand Trust Policies
- Attach IAM Role to EC2 using an Instance Profile
- Access AWS services from EC2 without Access Keys
- Understand Permission Boundaries
- Understand Least Privilege

---

# 📚 1. What is AWS IAM?

**AWS Identity and Access Management (IAM)** is a global AWS service used to securely control access to AWS resources.

IAM answers two important questions:

```text
Authentication
      │
      ▼
Who are you?
      │
      ▼
Authorization
      │
      ▼
What are you allowed to do?
```

IAM can control:

- Who can access AWS
- Which AWS services they can access
- Which resources they can access
- Which actions they can perform

---

# 📚 2. Important IAM Components

| IAM Component | Purpose |
|---------------|---------|
| User | Represents a person or application |
| Group | Collection of IAM users |
| Policy | Defines permissions |
| Role | Provides temporary permissions |
| Trust Policy | Defines who can assume a role |
| Instance Profile | Allows an EC2 instance to use an IAM role |
| Permission Boundary | Defines maximum permissions an IAM identity can receive |

---

# 📚 3. IAM User

An **IAM User** represents a person or application that needs access to AWS.

Example:

```text
AWS Account
    │
    └── IAM User
          │
          └── devops-user
```

IAM users can have:

- AWS Management Console access
- Programmatic access
- IAM policies
- Group memberships

### Best Practice

For production environments, avoid using the AWS root account for daily activities.

Use IAM identities or AWS IAM Identity Center and follow least-privilege principles.

---

# 🛠️ Task 1 – Create an IAM User

## Using AWS Console

Navigate to:

```text
AWS Console
    ↓
IAM
    ↓
Users
    ↓
Create user
```

User name:

```text
devops-user
```

Create the user.

---

## Using AWS CLI

```bash
aws iam create-user \
  --user-name devops-user
```

Verify:

```bash
aws iam get-user \
  --user-name devops-user
```

List users:

```bash
aws iam list-users
```

---

# 📚 4. IAM Groups

An IAM Group is a collection of IAM users.

Instead of assigning the same permissions to multiple users individually, we can assign permissions to a group.

Example:

```text
DevOps Group
    │
    ├── devops-user-1
    ├── devops-user-2
    └── devops-user-3
         │
         ▼
    IAM Policy
```

All users in the group receive permissions attached to the group.

---

# 🛠️ Task 2 – Create an IAM Group

Create a group:

```bash
aws iam create-group \
  --group-name DevOpsTeam
```

Add the user to the group:

```bash
aws iam add-user-to-group \
  --user-name devops-user \
  --group-name DevOpsTeam
```

Verify:

```bash
aws iam get-group \
  --group-name DevOpsTeam
```

---

# 📚 5. IAM Policies

An IAM Policy is a JSON document that defines permissions.

A policy normally contains:

```text
Effect
Action
Resource
Condition
```

Basic structure:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "service:Action",
      "Resource": "*"
    }
  ]
}
```

### Effect

Defines whether access is:

```text
Allow
```

or

```text
Deny
```

### Action

Defines what operation can be performed.

Example:

```text
s3:ListAllMyBuckets
```

### Resource

Defines which AWS resource the action applies to.

Example:

```text
arn:aws:s3:::my-bucket
```

---

# 🛠️ Task 3 – Create a Custom IAM Policy

For this practice, create a policy that allows users to list S3 buckets.

Create:

```text
s3-read-policy.json
```

Add:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "ListS3Buckets",
      "Effect": "Allow",
      "Action": [
        "s3:ListAllMyBuckets"
      ],
      "Resource": "*"
    }
  ]
}
```

Create the IAM policy:

```bash
aws iam create-policy \
  --policy-name DevOpsS3ListPolicy \
  --policy-document file://s3-read-policy.json
```

Copy the Policy ARN from the output.

Example:

```text
arn:aws:iam::<ACCOUNT_ID>:policy/DevOpsS3ListPolicy
```

---

# 🛠️ Task 4 – Attach Policy to IAM Group

Attach the custom policy:

```bash
aws iam attach-group-policy \
  --group-name DevOpsTeam \
  --policy-arn arn:aws:iam::<ACCOUNT_ID>:policy/DevOpsS3ListPolicy
```

Replace:

```text
<ACCOUNT_ID>
```

with your AWS Account ID.

Find your AWS Account ID:

```bash
aws sts get-caller-identity
```

Verify attached policies:

```bash
aws iam list-attached-group-policies \
  --group-name DevOpsTeam
```

Now:

```text
devops-user
      │
      ▼
DevOpsTeam
      │
      ▼
DevOpsS3ListPolicy
      │
      ▼
List S3 Buckets
```

---

# 📚 6. IAM Role

An IAM Role is an AWS identity with permissions that can be **temporarily assumed**.

Unlike IAM users, roles are designed for temporary credentials.

Roles are commonly used by:

- EC2
- Lambda
- ECS
- EKS
- AWS services
- CI/CD pipelines
- Cross-account access

Example:

```text
EC2 Instance
     │
     ▼
Assumes IAM Role
     │
     ▼
Receives Temporary Credentials
     │
     ▼
Accesses S3
```

This avoids storing AWS Access Keys directly on the EC2 instance.

---

# 📚 7. What is a Trust Policy?

A **Trust Policy** defines **who or what is allowed to assume an IAM role**.

For example, the following trust policy allows EC2 to assume a role.

Create:

```text
trust-policy.json
```

Add:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
```

Important line:

```json
"Service": "ec2.amazonaws.com"
```

This means:

```text
EC2 is trusted to assume this role.
```

---

# 🛠️ Task 5 – Create an IAM Role for EC2

Run:

```bash
aws iam create-role \
  --role-name EC2-S3-ReadOnly-Role \
  --assume-role-policy-document file://trust-policy.json
```

Verify:

```bash
aws iam get-role \
  --role-name EC2-S3-ReadOnly-Role
```

---

# 🛠️ Task 6 – Attach Permissions to the Role

For practice, attach the AWS managed S3 read-only policy:

```bash
aws iam attach-role-policy \
  --role-name EC2-S3-ReadOnly-Role \
  --policy-arn arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess
```

Verify:

```bash
aws iam list-attached-role-policies \
  --role-name EC2-S3-ReadOnly-Role
```

Architecture:

```text
EC2
 │
 ▼
EC2-S3-ReadOnly-Role
 │
 ▼
AmazonS3ReadOnlyAccess
 │
 ▼
Amazon S3
```

---

# 📚 8. What is an EC2 Instance Profile?

An **Instance Profile** is a container used to pass an IAM role to an EC2 instance.

Conceptually:

```text
EC2 Instance
      │
      ▼
Instance Profile
      │
      ▼
IAM Role
      │
      ▼
IAM Policy
      │
      ▼
AWS Resource
```

When using the AWS Console, instance-profile creation is generally handled automatically when creating an EC2 role.

When using the AWS CLI, we can create it manually.

---

# 🛠️ Task 7 – Create an Instance Profile

Create the instance profile:

```bash
aws iam create-instance-profile \
  --instance-profile-name EC2-S3-Instance-Profile
```

Add the IAM role:

```bash
aws iam add-role-to-instance-profile \
  --instance-profile-name EC2-S3-Instance-Profile \
  --role-name EC2-S3-ReadOnly-Role
```

Verify:

```bash
aws iam get-instance-profile \
  --instance-profile-name EC2-S3-Instance-Profile
```

---

# 🛠️ Task 8 – Attach IAM Role to an Existing EC2 Instance

## Using AWS Console

Navigate to:

```text
EC2
 ↓
Instances
 ↓
Select Instance
 ↓
Actions
 ↓
Security
 ↓
Modify IAM Role
```

Select:

```text
EC2-S3-ReadOnly-Role
```

Click:

```text
Update IAM Role
```

---

# 🛠️ Task 9 – Verify IAM Role from EC2

Connect to your EC2 instance.

Check the current AWS identity:

```bash
aws sts get-caller-identity
```

Test S3 access:

```bash
aws s3 ls
```

If the IAM role is configured correctly, EC2 can access S3 according to the role permissions.

You do **not** need to run:

```bash
aws configure
```

You also do **not** need to store:

```text
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
```

on the EC2 instance.

The flow is:

```text
EC2
 │
 ▼
IAM Role
 │
 ▼
Temporary Credentials
 │
 ▼
AWS API
 │
 ▼
Amazon S3
```

This is much safer than storing long-lived credentials on servers.

---

# 📚 9. IAM User vs IAM Role vs IAM Policy

| Feature | IAM User | IAM Role | IAM Policy |
|---------|----------|----------|------------|
| Purpose | Represents identity | Temporary assumable identity | Defines permissions |
| Credentials | Can have long-term credentials | Uses temporary credentials | No credentials |
| Used By | Users/legacy applications | AWS services, workloads, CI/CD | Users, Groups and Roles |
| Example | DevOps Engineer | EC2 Role | S3 Read Policy |

Simple explanation:

```text
IAM User
= Who you are

IAM Role
= Temporary identity you assume

IAM Policy
= What you are allowed to do
```

---

# 📚 10. IAM Permission Boundary

A **Permission Boundary** defines the maximum permissions that an IAM user or role can receive through identity-based policies.

Example:

```text
IAM Policy
     │
     │ Says:
     ▼
Allow EC2 + S3 + IAM

Permission Boundary
     │
     │ Maximum allowed:
     ▼
EC2 + S3

Effective Permissions
     │
     ▼
EC2 + S3
```

The IAM permissions do not exceed the boundary.

Permission boundaries are useful when organizations allow developers or DevOps teams to create IAM roles but want to limit how powerful those roles can become.

---

# 📚 11. Principle of Least Privilege

**Least Privilege** means giving an identity only the permissions required to perform its job.

Bad example:

```json
{
  "Effect": "Allow",
  "Action": "*",
  "Resource": "*"
}
```

This provides extremely broad access.

Better example:

```json
{
  "Effect": "Allow",
  "Action": [
    "s3:GetObject"
  ],
  "Resource": "arn:aws:s3:::my-app-bucket/*"
}
```

This allows only:

```text
GetObject
```

on:

```text
my-app-bucket
```

### DevOps Best Practice

Follow:

```text
Minimum Actions
      +
Minimum Resources
      +
Conditions Where Possible
      =
Least Privilege
```

---

# 📚 12. Identity-Based Policy vs Resource-Based Policy

## Identity-Based Policy

Attached to:

- IAM User
- IAM Group
- IAM Role

Example:

```text
IAM Role
   │
   ▼
Policy
   │
   ▼
Allow S3 Access
```

## Resource-Based Policy

Attached directly to an AWS resource.

Examples:

- S3 Bucket Policy
- SQS Queue Policy
- SNS Topic Policy
- KMS Key Policy

Example:

```text
S3 Bucket
   │
   ▼
Bucket Policy
   │
   ▼
Who can access this bucket?
```

---

# 📚 13. Explicit Deny vs Allow

AWS permission evaluation follows an important rule:

```text
Explicit Deny
     │
     ▼
Overrides
     │
     ▼
Allow
```

If one policy says:

```text
Allow S3
```

but another applicable policy says:

```text
Deny S3
```

the final result is:

```text
DENIED
```

Remember:

> Explicit Deny always overrides Allow.

---

# 📚 14. IAM Best Practices

1. Avoid using the root user for daily administrative work.
2. Enable MFA for privileged access.
3. Prefer temporary credentials and IAM roles over long-lived access keys.
4. Follow the principle of least privilege.
5. Remove unused users, roles and credentials.
6. Rotate credentials when long-lived credentials are unavoidable.
7. Use permission boundaries where delegated IAM administration is required.
8. Regularly review IAM permissions.
9. Avoid hardcoding AWS credentials in source code.
10. Use IAM roles or OIDC for CI/CD pipelines.

---

# 🧪 Complete Hands-On Flow

```text
Step 1
Create IAM User
     │
     ▼
devops-user

Step 2
Create IAM Group
     │
     ▼
DevOpsTeam

Step 3
Add User to Group
     │
     ▼
devops-user → DevOpsTeam

Step 4
Create Custom JSON Policy
     │
     ▼
DevOpsS3ListPolicy

Step 5
Attach Policy to Group
     │
     ▼
DevOpsTeam → S3 Permissions

Step 6
Create EC2 IAM Role
     │
     ▼
EC2-S3-ReadOnly-Role

Step 7
Configure Trust Policy
     │
     ▼
EC2 can assume Role

Step 8
Attach S3 Policy
     │
     ▼
Role can read S3

Step 9
Attach Role to EC2
     │
     ▼
EC2 → IAM Role → S3

Step 10
Verify
     │
     ▼
aws sts get-caller-identity
aws s3 ls
```

---

# 💻 Important AWS IAM CLI Commands

```bash
# Show current AWS identity
aws sts get-caller-identity

# List IAM users
aws iam list-users

# Create IAM user
aws iam create-user --user-name devops-user

# List groups
aws iam list-groups

# Create group
aws iam create-group --group-name DevOpsTeam

# Add user to group
aws iam add-user-to-group \
  --user-name devops-user \
  --group-name DevOpsTeam

# Get group details
aws iam get-group \
  --group-name DevOpsTeam

# List roles
aws iam list-roles

# Get role
aws iam get-role \
  --role-name EC2-S3-ReadOnly-Role

# List policies attached to role
aws iam list-attached-role-policies \
  --role-name EC2-S3-ReadOnly-Role

# List S3 buckets
aws s3 ls
```

---

# 🎯 Interview Questions & Answers

## 1. What is AWS IAM?

AWS IAM is a service used to securely manage identities and control access to AWS resources.

---

## 2. What is the difference between IAM User and IAM Role?

An IAM User is an identity typically representing a person or application and may have long-term credentials.

An IAM Role is an assumable identity that provides temporary security credentials.

---

## 3. What is an IAM Policy?

An IAM Policy is a JSON document that defines which AWS actions are allowed or denied on specific resources.

---

## 4. What is a Trust Policy?

A Trust Policy defines which principal is allowed to assume an IAM role.

For example, an EC2 trust policy allows:

```text
ec2.amazonaws.com
```

to assume the role.

---

## 5. What is an EC2 Instance Profile?

An Instance Profile is the mechanism used to provide an IAM role to an EC2 instance.

---

## 6. Why use IAM Roles instead of Access Keys on EC2?

IAM Roles provide temporary, automatically managed credentials.

This avoids storing long-lived AWS Access Keys on EC2 instances.

---

## 7. What is Least Privilege?

Least Privilege means granting only the minimum permissions required to complete a specific task.

---

## 8. What is a Permission Boundary?

A Permission Boundary defines the maximum permissions that an IAM user or role can receive from identity-based policies.

---

## 9. What is the difference between IAM Policy and Trust Policy?

An IAM permissions policy defines:

```text
What actions can be performed?
```

A role trust policy defines:

```text
Who can assume the role?
```

---

## 10. What happens if one policy allows an action and another explicitly denies it?

The request is denied.

```text
Explicit Deny > Allow
```

---

# 🧹 Cleanup

Delete the test resources if they are no longer required.

Remove user from group:

```bash
aws iam remove-user-from-group \
  --user-name devops-user \
  --group-name DevOpsTeam
```

Delete IAM user:

```bash
aws iam delete-user \
  --user-name devops-user
```

Before deleting the group, detach attached policies.

Before deleting the IAM role, detach its policies and remove it from the instance profile.

> ⚠️ Do not delete IAM resources that are being used by your real applications or infrastructure.

---

# 📸 Screenshots to Add

Add the following screenshots to document your Day 73 practice:

- IAM User created
- IAM Group created
- User added to Group
- Custom IAM Policy
- IAM Role
- EC2 Trust Policy
- IAM Role attached to EC2
- `aws sts get-caller-identity` output
- `aws s3 ls` output from EC2

---

# 📚 Key Learnings

Today I learned:

- AWS IAM fundamentals
- IAM Users and Groups
- IAM Policies
- Custom JSON Policies
- IAM Roles
- Trust Policies
- EC2 Instance Profiles
- Temporary credentials
- Permission Boundaries
- Principle of Least Privilege
- Identity-based vs Resource-based Policies
- Explicit Deny vs Allow
- Secure EC2 access to AWS services

---

# 🎯 Day 73 Conclusion

On Day 73, I learned how AWS IAM controls authentication and authorization.

I created an IAM user and group, wrote a custom JSON policy, created an IAM role with an EC2 trust policy, and attached the role to an EC2 instance using an instance profile.

The most important lesson is to avoid storing long-lived AWS credentials whenever possible and instead use **IAM Roles, temporary credentials, least privilege, and secure identity federation** for production DevOps environments.

---

`#102DaysOfDevOps` `#AWS` `#IAM` `#AWSDevOps` `#DevOps` `#CloudSecurity` `#CloudComputing` `#EC2` `#90DaysOfDevOps` `#TrainWithShubham`

