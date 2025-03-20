# Deploying VPC, EC2, ALB, and Auto Scaling Group using Terraform

## Overview
This document provides a comprehensive guide to deploying a cloud infrastructure setup using Terraform. The setup includes:
- A Virtual Private Cloud (VPC)
- An Application Load Balancer (ALB)
- An Auto Scaling Group (ASG) with EC2 instances

Terraform is utilized to automate the provisioning process, ensuring efficient infrastructure management.

## Prerequisites
Before proceeding, ensure the following requirements are met:
- Terraform installed on your local machine
- AWS CLI configured with appropriate credentials
- A working AWS account with permissions to create VPCs, EC2 instances, ALBs, and ASGs

## Architecture Overview
The infrastructure consists of:
1. A VPC with public and private subnets
2. An Internet Gateway to enable external access
3. An Application Load Balancer (ALB) for distributing traffic across EC2 instances
4. An Auto Scaling Group (ASG) to manage instance scaling
5. EC2 instances running Apache with a simple HTML page

## Terraform File Structure
The project is organized into the following Terraform files:
- **main.tf** - Defines the primary infrastructure resources
- **variables.tf** - Contains input variables for customization
- **output.tf** - Specifies output values for easy reference
- **alb.tf** - Configures the Application Load Balancer
- **ec2.tf** - Defines EC2 instance configurations
- **userdata.sh** - A script to install and configure Apache on EC2 instances

## Deployment Steps
### Step 1: Initialize Terraform
Navigate to the directory containing Terraform files and initialize Terraform:
```sh
terraform init
```

### Step 2: Plan the Infrastructure
Review the resources that will be created:
```sh
terraform plan
```

### Step 3: Apply the Configuration
Deploy the infrastructure:
```sh
terraform apply -auto-approve
```

### Step 4: Retrieve Outputs
After deployment, retrieve essential output values such as the Load Balancer DNS:
```sh
terraform output
```

### Step 5: Verify the Deployment
1. Navigate to the Load Balancer URL provided in the Terraform output.
2. The webpage should display "Welcome to My Website."

Example Load Balancer URL:
```
http://stylish-website-alb-296335331.eu-north-1.elb.amazonaws.com
```

### Step 6: Auto Scaling Group Validation
- Delete two instances from the Auto Scaling Group (ASG), and verify that it automatically spins up two new instances.
- Ensure that the Target Groups update dynamically with the newly created instances.

## Cleanup
To destroy the infrastructure when it is no longer needed:
```sh
terraform destroy -auto-approve
```

## Conclusion
This guide provides a step-by-step approach to deploying a scalable, highly available setup using Terraform. It ensures efficient traffic distribution via ALB and dynamic resource allocation through ASG, making it an optimal solution for high-availability cloud applications.

