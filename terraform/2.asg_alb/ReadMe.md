
---

# ⚙️ AWS Auto Scaling with Launch Template (Terraform)

This stage introduces **scalability and high availability** into the infrastructure by deploying an **Auto Scaling Group (ASG)** that automatically manages the number of EC2 instances.

Each EC2 instance is launched using a **Launch Template**, ensuring that all instances are created with **consistent configurations**, including installed software and system settings defined through **user data scripts**.

---

# 📦 Folder: `2.asg_alb/`

This layer builds upon the **network infrastructure** provisioned in:

```
1.permanent_infra/
```

The module deploys the **application infrastructure layer**, which includes scalable compute resources and load balancing.

---

# 🧰 Overview

| Component                           | Description                                                                                     |
| ----------------------------------- | ----------------------------------------------------------------------------------------------- |
| **Launch Template**                 | Defines EC2 configuration including AMI, instance type, user data, and security group settings. |
| **Auto Scaling Group (ASG)**        | Manages a fleet of EC2 instances and automatically replaces unhealthy instances.                |
| **Scaling Policy**                  | Maintains a target average CPU utilization to automatically scale the number of instances.      |
| **Application Load Balancer (ALB)** | Distributes traffic across EC2 instances for high availability and fault tolerance.             |

Although the **Application Load Balancer (ALB)** is deployed in this module, it is **not actively used in the configuration drift demonstration**.
It is included to represent a **more realistic production architecture** and will be utilized in future iterations of the project.

---

# ⚙️ Configuration Details

## 1️⃣ Launch Template

The `aws_launch_template` resource defines the configuration used to launch EC2 instances.

It specifies:

* **Amazon Machine Image (AMI)** retrieved dynamically using the `aws_ami` data source.
* **Instance type** defined through variables.
* **Security group** association.
* **User data script** used to perform initial system configuration.

The user data script installs and configures required software when each instance starts.

Example:

```hcl
user_data = base64encode(templatefile(var.ec2_user_data, {}))
```

This ensures that every EC2 instance launched by the Auto Scaling Group starts with the **same baseline configuration**.

---

## 2️⃣ Auto Scaling Group (ASG)

The `aws_autoscaling_group` resource manages the lifecycle of EC2 instances.

Key characteristics:

* Launches EC2 instances across **multiple subnets** for high availability.
* Automatically **replaces unhealthy instances**.
* Scales **between `min_ec2` and `max_ec2`** as defined in variables.
* Uses **EC2 health checks** to monitor instance health.

This ensures that the application remains available even if individual instances fail.

---

## 3️⃣ Target Tracking Scaling Policy

The `aws_autoscaling_policy` resource implements **automatic scaling**.

The policy maintains a **target average CPU utilization** across all instances.

Example configuration:

```
Target CPU utilization: 50%
```

Behavior:

* If CPU usage rises above the target → **new instances are launched**
* If CPU usage drops below the target → **instances are terminated**

This allows the system to **scale dynamically based on workload demand**.

---

# 📄 Variables

| Variable         | Type     | Description                                 |
| ---------------- | -------- | ------------------------------------------- |
| `aws_region`     | `string` | AWS region where resources will be deployed |
| `instance_type`  | `string` | EC2 instance type (e.g., `"t3.micro"`)      |
| `ec2_user_data`  | `string` | Path to the EC2 user data script            |
| `min_ec2`        | `number` | Minimum number of EC2 instances             |
| `max_ec2`        | `number` | Maximum number of EC2 instances             |
| `number_of_ec2s` | `number` | Desired capacity during initial deployment  |

These variables allow the infrastructure to be **easily customized without modifying Terraform code**.

---

# 🚀 Deployment Steps

### 1️⃣ Navigate to the directory

```bash
cd 2.asg_alb
```

### 2️⃣ Initialize Terraform

```bash
terraform init
```

### 3️⃣ Review the execution plan

```bash
terraform plan
```

### 4️⃣ Deploy the infrastructure

```bash
terraform apply
```

Terraform will create:

* Launch Template
* Application Load Balancer
* Auto Scaling Group
* EC2 instances

---

### 5️⃣ Verify the Auto Scaling Group

You can confirm the deployed Auto Scaling Group using the AWS CLI:

```bash
aws autoscaling describe-auto-scaling-groups \
  --query "AutoScalingGroups[*].{Name:AutoScalingGroupName,Size:DesiredCapacity}"
```

This command displays the ASG name and the current number of running instances.

---

# 🧠 Key Takeaways

This architecture demonstrates several important cloud design principles:

* **Elastic scalability** through Auto Scaling Groups
* **High availability** across multiple Availability Zones
* **Consistent server configuration** using Launch Templates
* **Infrastructure as Code** using Terraform

The Auto Scaling Group ensures that the application infrastructure can **adapt automatically to changing workload demands** while maintaining reliability.

---

