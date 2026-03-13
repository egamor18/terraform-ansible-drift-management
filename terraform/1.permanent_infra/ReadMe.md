
---

# 🏗️ AWS VPC + Security Groups + Subnets (Terraform)

This Terraform configuration deploys a **basic AWS networking foundation** designed for web applications.

It provisions a **Virtual Private Cloud (VPC)** with **public subnets across multiple Availability Zones**, along with **security groups** that allow controlled access to EC2 instances.

This infrastructure serves as the **foundation layer** for application workloads that will be deployed in later stages of the project.

---

# 📋 Overview

## 🔧 Components Created

| Component          | Description                                                                               |
| ------------------ | ----------------------------------------------------------------------------------------- |
| **VPC**            | A custom Virtual Private Cloud deployed in `eu-central-1`.                                |
| **Public Subnets** | Two public subnets distributed across different Availability Zones for high availability. |
| **Security Group** | Allows inbound **SSH (22)**, **HTTP (80)**, and **HTTPS (443)** access from the internet. |

This setup creates the **base networking layer** required to launch compute resources such as **EC2 instances and load balancers**.

---

# 🧰 Prerequisites

Before deploying this infrastructure, ensure the following tools and configurations are available:

* **Terraform v1.5 or later**
* **AWS CLI** configured with valid credentials
* **IAM permissions** to create VPC and Security Group resources

Verify your environment with:

```bash
aws sts get-caller-identity
terraform -version
```

---

# 🚀 Deployment Steps

Before deploying this module, ensure that the **`1.permanent_infra/` directory** contains the correct configuration values.

### 1️⃣ Initialize Terraform

```bash
terraform init
```

### 2️⃣ Review the Execution Plan

```bash
terraform plan
```

### 3️⃣ Apply the Configuration

```bash
terraform apply
```

This step will provision the networking infrastructure in AWS.

### 4️⃣ Destroy Resources (Cleanup)

To remove the deployed infrastructure:

```bash
terraform destroy
```

---

# 🧠 Notes

* This configuration uses **public subnets** for simplicity and demonstration purposes.

* For **production environments**, consider using:

  * **private subnets**
  * **NAT Gateway**
  * **VPC endpoints**

* Security group rules currently allow access from `0.0.0.0/0`.
  In production environments, restrict this to **specific trusted IP ranges**.

---

# 📈 Next Steps

Once the networking foundation is created, proceed to the next module:

**`2.asg_alb/`**

This module deploys:

* **Application Load Balancer (ALB)**
* **Launch Template**
* **Auto Scaling Group**
* **EC2 instances**

Together, these components form the **application infrastructure layer** that runs the workload on top of the network created in this module.

---

**Author:** Eric Gamor
**AWS Region:** `eu-central-1`
**Terraform Version:** `>= 1.5`
**AWS Provider:** `>= 5.0`

---
