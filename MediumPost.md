
---

# Managing Configuration Drift in AWS using Terraform and Ansible

---

# Problem Description

In many organizations, engineers work directly on servers to install applications, troubleshoot issues, or make configuration changes. Over time, this can lead to **configuration drift**, where servers that were originally identical begin to differ in their configurations.

For example:

* Some engineers may install **different versions of an application**.
* Others may **open firewall ports temporarily** and forget to close them.
* Certain applications may be **removed or modified** during troubleshooting.

As a result, servers that were originally standardized may begin to behave differently. This introduces several risks:

* **Security vulnerabilities**
* **Unpredictable application behavior**
* **Failed deployments**
* **Difficulty in troubleshooting**
* **Compliance violations**

Configuration drift is extremely common in environments with **multiple servers and multiple administrators**.

---

# Proposed Solution

The solution to configuration drift is **configuration standardization and automation**.

In a small environment, an engineer could manually log into each server and verify:

* Installed packages
* Application versions
* Firewall rules
* System configurations

However, this approach does not scale well.

For example:

| Number of Servers | Manual Effort  |
| ----------------- | -------------- |
| 1                 | Manageable     |
| 10                | Time consuming |
| 100+              | Impractical    |

To solve this scalability problem, **automation tools** are required.

This is where **Ansible** becomes very useful.

---

# Role of Ansible

**Ansible** is a configuration management and automation tool used to enforce consistent system configurations across multiple servers.

It ensures that servers remain in a **desired state**, regardless of any manual changes that may occur over time.

Ansible achieves this using the concept of **idempotency**.

Idempotency means:

* If the required configuration already exists → **Ansible does nothing**
* If the configuration is missing or incorrect → **Ansible fixes it**

For example:

* If nginx should be installed but is missing → Ansible installs it
* If nginx is already installed → Ansible skips installation

This allows safe repeated execution of automation scripts.

---

# Terraform vs Ansible

Although both Terraform and Ansible can interact with cloud resources, they serve **different but complementary purposes**.

---

## Terraform

Terraform is primarily used for **Infrastructure as Code (IaC)**.

It is responsible for **creating and managing infrastructure resources** such as:

* VPCs
* Subnets
* Security groups
* Load balancers
* EC2 instances
* Auto Scaling Groups

Terraform keeps track of created infrastructure using a **state file**:

```text
terraform.tfstate
```

This file records:

* all created resources
* their current configuration
* dependencies between resources

Terraform compares the desired configuration with the state file to detect changes and maintain infrastructure consistency.

---

## Ansible

Ansible focuses on **configuration management**.

It is responsible for managing the **software and system configuration** inside the servers created by Terraform.

Examples include:

* installing applications
* managing application versions
* enforcing firewall rules
* managing system configuration files
* performing security hardening

Unlike Terraform, Ansible **does not maintain a state file**. Instead, it checks the **actual state of the server** each time it runs.

---

# Complementary Roles

Terraform and Ansible are often used together.

A useful analogy:

| Tool      | Role                              |
| --------- | --------------------------------- |
| Terraform | Builds the house                  |
| Ansible   | Furnishes and maintains the house |

<img alt="complementary roles of Terraform and Ansible" src="images/ansible_terraform_house.png" width="1000" height="400" />

**Figure 1: Complementary roles of Terraform and Ansible**

Terraform creates the infrastructure.

Ansible manages and maintains the systems running on that infrastructure.

Although Terraform can perform some initial configuration using **user_data scripts**, it is not ideal for ongoing configuration management.

This is where Ansible becomes extremely valuable.

---

# Project Goal

The goal of this project is to demonstrate how **Terraform and Ansible can work together to manage configuration drift** in a cloud environment.

In this project, Terraform is used to create the cloud infrastructure:

* VPC
* Public subnets
* Security groups
* Auto Scaling Group (ASG)
* EC2 instances

During instance creation, the **user_data** field is used to apply initial system configurations.

These configurations include:

* installing nginx
* configuring the firewall
* applying standard system configurations

The architectural overview is shown in Figure 2.

<img alt="Architecture overview" src="images/ansible_terraform.png" width="1000" height="600" />

**Figure 2: Architectural overview**

---

# Repository Structure

The repository is organized to clearly separate **infrastructure provisioning**, **configuration management**, and **documentation assets**.

```text
terraform-ansible-drift-management/
│
├── ansible/
│   ├── 1.view_configs_on_all_servers.yml
│   ├── 2.standardize_configs_on_all_servers.yml
│   ├── ansible.cfg
│   │
│   ├── inventory/
│   │   └── aws_ec2.yml
│   │
│   ├── scripts/
│   │   ├── firewalld_config_view.sh
│   │   └── firewalld_standardization.sh
│   │
│   └── tasks/
│       ├── firewall_standardization.yml
│       ├── nginx_standardization.yml
│       ├── ssh_hardening.yml
│       └── ssh_hardening2.yml
│
├── images/
│   ├── architecture and drift screenshots
│   └── remediation screenshots
│
├── terraform_vpc_subnet_alb_asg_ec2/
│   │
│   ├── 1.permanent_infra/
│   │   ├── pre-provisioned_infra.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── terraform.tfvars
│   │
│   ├── 2.asg_alb/
│   │   ├── main.tf
│   │   ├── alb.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   ├── terraform.tfvars
│   │   └── user_data.sh.tmpl
│   │
│   └── ReadMe.md
│
├── MediumPost.md
├── Readme.md

```

This structure demonstrates good DevOps practices by separating **infrastructure provisioning** from **configuration management**.

---

# Prerequisites

Before running this project, ensure the following tools are installed:

* Terraform
* Ansible
* AWS CLI
* Python 3
* boto3 Python package

AWS credentials must also be configured:

```bash
aws configure
```

---

# Step-by-Step Execution

This section explains how to reproduce the project from infrastructure creation to configuration drift remediation.

---

# 1. Terraform Infrastructure Deployment

The infrastructure is deployed in **two phases**:

1. **Foundation infrastructure**
2. **Application infrastructure**

Separating these layers improves modularity and mirrors real-world infrastructure design.

---

## Step 1 — Create the Foundation Infrastructure

First git clone the repository.

```bash
git clone https://github.com/egamor18/terraform-ansible-drift-management.git 
```

Navigate to the foundation infrastructure directory:

```bash
cd 1.permanent_infra
```

Review the configuration variables.

```bash
terraform.tfvars
```

Initialize Terraform:

```bash
terraform init
```

Preview the infrastructure plan:

```bash
terraform plan
```

Apply the configuration:

```bash
terraform apply
```

This step creates the **core networking infrastructure**:

* VPC
* Public subnets
* Internet gateway
* Security group

These resources form the **foundation network layer** for the project.

---

## Step 2 — Deploy the Application Infrastructure

Navigate to the application infrastructure directory:

```bash
cd asg_alb
```

Initialize Terraform:

```bash
terraform init
```

Preview the infrastructure plan:

```bash
terraform plan
```

Apply the configuration:

```bash
terraform apply
```

This step creates:

* Application Load Balancer (ALB)
* Launch Template
* Auto Scaling Group
* EC2 instances

---

# 2. Ansible Configuration Verification

Once the infrastructure is running, Ansible is used to verify and manage the configuration of the EC2 instances.

---

## Step 3 — Discover Instances Using Dynamic Inventory

Because instances belong to an **Auto Scaling Group**, their IP addresses may change.

To handle this, the project uses the **AWS EC2 dynamic inventory plugin**.

```bash
ansible-inventory -i inventory/aws_ec2.yml --graph
```

Next run the inspection playbook:

```bash
ansible-playbook -i inventory/aws_ec2.yml 1.view_configs_on_all_servers.yml
```

This playbook displays:

* nginx installation status
* nginx version
* firewall rules
* SSH configuration

---

# 3. Introduce Configuration Drift

## Step 4 — Manually Create Configuration Drift

Configuration drift is intentionally introduced by manually modifying server configurations.

---

### Scenario 1 — Application Removed

```bash
sudo dnf remove nginx nginx-common -y
```

<img alt="nginx removed" src="images/4.drift_1.png" width="1000" height="600" />

---

### Scenario 2 — Different Application Version

```bash
sudo dnf install nginx-1.22.1
```

<img alt="different version installed" src="images/4.drift_2.png" width="1000" height="600" />

---

### Scenario 3 — Unauthorized Firewall Change

```bash
sudo firewall-cmd --permanent --add-port=9292/tcp
sudo firewall-cmd --reload
```

<img alt="Port 9292 opened" src="images/4.drift_3.png" width="1000" height="600" />

---

# 4. Drift Detection

Run the inspection playbook again:

```bash
ansible-playbook -i inventory/aws_ec2.yml 1.view_configs_on_all_servers.yml
```

This reveals configuration differences between servers.

---

# 5. Configuration Standardization

Run the remediation playbook:

```bash
ansible-playbook -i inventory/aws_ec2.yml 2.standardize_configs_on_all_servers.yml
```

This playbook:

* reinstalls missing packages
* standardizes nginx versions
* removes unauthorized firewall rules
* enforces SSH configuration policies

---

# 6. Outcome of Configuration Standardization

Run the inspection playbook again:

```bash
ansible-playbook -i inventory/aws_ec2.yml 1.view_configs_on_all_servers.yml
```

Results of the remediation playbook compared with the initial configuration:

**The missing nginx is installed**

<img src="images/after_standardization_1.png" width="1000">

**The nginx version is standardized**

<img src="images/after_standardization_2.png" width="1000">

**Unauthorized firewall rules are removed**

<img src="images/after_standardization_3.png" width="1000">

All servers return to the **approved configuration baseline**.

---

# 7. Cleanup (Destroy Infrastructure)

Destroy the application infrastructure:

```bash
cd asg_alb
terraform destroy --auto-approve
```

Then destroy the foundation infrastructure:

```bash
cd 1.permanent_infra
terraform destroy --auto-approve
```

All AWS resources created during the project will be removed.

---

# DevOps Principles Demonstrated

| Concept                       | Description                                                     |
| ----------------------------- | --------------------------------------------------------------- |
| Infrastructure as Code        | AWS infrastructure defined using Terraform                      |
| Configuration Management      | System configurations enforced using Ansible                    |
| Automation                    | Manual configuration tasks replaced with automated workflows    |
| Configuration Drift Detection | Identification of unintended configuration changes              |
| Drift Remediation             | Automated restoration of standardized configurations            |
| Dynamic Infrastructure        | Auto Scaling Group instances discovered using dynamic inventory |

---

## Feedback and Contributions

If you have suggestions for improvements or additional drift scenarios to test, feel free to open an issue or submit a pull request.

Constructive feedback and contributions are always welcome.
Thank you.

---
## 👤 Author

**Eric Gamor**

Cloud & DevOps Engineer | Terraform | AWS | Cloud Automation | AI/ML
