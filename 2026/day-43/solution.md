# Task 4: Implement and Test RBAC in a Multi-Team Environment

## Objective

Implement Role-Based Access Control (RBAC) in Jenkins to ensure that different teams (Developers, Testers, and Operations) have appropriate access permissions based on their responsibilities.

---

# What is RBAC?

RBAC (Role-Based Access Control) is a security model that restricts system access based on assigned roles.

Instead of granting permissions directly to users, permissions are assigned to roles and users are mapped to those roles.

---

# Architecture

```text
                    Jenkins

                         │

    ┌────────────────────┼────────────────────┐

    │                    │                    │

 Admin Team       Developer Team       Tester Team

 Full Access      Build & View         View Only

```

---

# Prerequisites

Install the following Jenkins Plugin:

```text
Role-Based Authorization Strategy
```
<img width="1366" height="684" alt="image" src="https://github.com/user-attachments/assets/27209ba2-53f3-4759-932a-b370e88848fd" />

Navigate:

```text
Manage Jenkins
        ↓
Plugins
        ↓
Available Plugins
        ↓
Role-Based Authorization Strategy
```

Install and restart Jenkins.

---

# Step 1: Enable Role Strategy

Navigate:

```text
Manage Jenkins
        ↓
Security
        ↓
Authorization
```

Select:

```text
Role-Based Strategy
```

Save Configuration.

---

# Step 2: Create Roles

Navigate:

```text
Manage Jenkins
        ↓
Manage and Assign Roles
```

---

## Role 1: Admin

### Permissions

```text
Overall/Administer

Job/Create

Job/Delete

Job/Configure

Job/Build

Job/Read

Credentials/View

Credentials/Create

Credentials/Delete

Node/Configure

Node/Create

Node/Delete
```

Purpose:

```text
Full Jenkins Administration
```

---

## Role 2: Developer

### Permissions

```text
Overall/Read

Job/Read

Job/Build

Job/Workspace

Job/Discover

View/Read
```

Purpose:

```text
Build and monitor pipelines
```

Cannot:

```text
Delete jobs

Manage credentials

Modify Jenkins settings
```

---

## Role 3: Tester

### Permissions

```text
Overall/Read

Job/Read

View/Read
```

Purpose:

```text
View build status and test results
```

Cannot:

```text
Trigger builds

Modify jobs

Access credentials
```

---

# Step 3: Create Users

Navigate:

```text
Manage Jenkins
        ↓
Users
        ↓
Create User
```

---

## Create Admin User

```text
Username : admin-user

Password : ********
```

---

## Create Developer User

```text
Username : dev-user

Password : ********
```

---

## Create Tester User

```text
Username : tester-user

Password : ********
```

---

# Step 4: Assign Roles

Navigate:

```text
Manage Jenkins
        ↓
Manage and Assign Roles
        ↓
Assign Roles
```

---

## Role Mapping

| User        | Role      |
| ----------- | --------- |
| admin-user  | Admin     |
| dev-user    | Developer |
| tester-user | Tester    |

---

# Step 5: Verify Access

## Login as Admin

Expected Access:

```text
Create Jobs

Delete Jobs

Manage Jenkins

Manage Plugins

Manage Credentials

Configure Nodes
```

Result:

```text
Success
```
<img width="1363" height="724" alt="image" src="https://github.com/user-attachments/assets/af2616ec-9398-44fd-be72-a533e209cffe" />

---

## Login as Developer

Expected Access:

```text
View Jobs

Trigger Builds

View Console Output

Access Workspace
```

Restrictions:

```text
Cannot Delete Jobs

Cannot Configure Jenkins

Cannot Manage Credentials
```

Result:

```text
Success
```

---

## Login as Tester

Expected Access:

```text
View Jobs

View Build Results

View Console Logs
```

Restrictions:

```text
Cannot Build

Cannot Configure Jobs

Cannot Manage Jenkins
```

Result:

```text
Success
```

---

# Verification Example

## Admin User

```text
Dashboard

Manage Jenkins

Credentials

Nodes

Build History
```

Visible:

```text
YES
```

---

## Developer User

```text
Dashboard

Jobs

Build History
```

Visible:

```text
YES
```

```text
Manage Jenkins
```

Visible:

```text
NO
```

---

## Tester User

```text
Dashboard

Jobs

Build Results
```

Visible:

```text
YES
```

```text
Build Button
```

Visible:

```text
NO
```

---

# Example Risk Without RBAC

## Scenario

Developer accidentally deletes a production deployment pipeline.

Without RBAC:

```text
Developer
      ↓
Delete Production Job
      ↓
Production Deployment Fails
```

Impact:

```text
Application Downtime

Revenue Loss

Customer Impact
```

---

# Example Security Threat

## Credential Exposure

Without RBAC:

```text
Any User
       ↓
View Jenkins Credentials
       ↓
Access AWS Keys
       ↓
Access Production Environment
```

Potential Result:

```text
Data Breach

Unauthorized Changes

Cloud Resource Misuse
```

RBAC prevents this by restricting credential access to administrators.

---

# Screenshots to Capture

## Screenshot 1

```text
Role Strategy Enabled
```

---

## Screenshot 2

```text
Roles Created
```

Admin

Developer

Tester

---

## Screenshot 3

```text
Role Assignment
```

---

## Screenshot 4

```text
Developer Login Verification
```

---

## Screenshot 5

```text
Tester Login Verification
```

---

# Benefits of RBAC

## Security

Restricts unauthorized access.

---

## Compliance

Supports audit and governance requirements.

---

## Separation of Duties

Different teams receive only the permissions required for their work.

---

## Reduced Risk

Prevents accidental changes to critical pipelines and infrastructure.

---

# Interview Questions

## 1. Why is RBAC essential in a CI/CD environment, and what are the consequences of weak access control?

### Answer

RBAC ensures that users only have access to the resources required for their job responsibilities. It protects Jenkins pipelines, credentials, agents, and production deployments from unauthorized access.

Weak access control can result in:

* Accidental deletion of pipelines
* Unauthorized deployments
* Credential leakage
* Security breaches
* Compliance violations

---

## 2. Can you describe a scenario where inadequate RBAC could lead to security issues?

### Answer

Consider a developer who has unrestricted Jenkins access. The developer accidentally views stored AWS credentials and uses them to access production resources.

This could lead to:

* Unauthorized infrastructure changes
* Data loss
* Service outages
* Financial impact

RBAC mitigates this risk by restricting credential access to administrators only.

---

# Real-World Enterprise RBAC Model

| Team          | Access Level        |
| ------------- | ------------------- |
| Jenkins Admin | Full Control        |
| DevOps Team   | Build + Deploy      |
| Developers    | Build + View        |
| QA Team       | View + Test Reports |
| Security Team | Audit + Reports     |
| Product Team  | Read Only           |

---

# Conclusion

Successfully implemented RBAC in Jenkins using the Role Strategy Plugin.
