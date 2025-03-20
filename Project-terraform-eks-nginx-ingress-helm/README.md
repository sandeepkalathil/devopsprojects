Here’s the enhanced version of your document, formatted in a professional manner and tailored for a `README.md` file:

```markdown
# Deploy NGINX Ingress Controller on AWS EKS using Terraform and Helm

This guide outlines the process for deploying the **NGINX Ingress Controller** on an **AWS EKS** cluster using **Terraform** and **Helm**. The NGINX Ingress Controller manages external access to services within the Kubernetes cluster, routing traffic to the appropriate services based on defined rules.

## Prerequisites

Before starting, ensure that you have the following tools and services installed:

1. **Terraform** (>= 1.6.0)
2. **AWS CLI** (configured with IAM permissions)
3. **kubectl** (Kubernetes CLI)
4. **Helm** (Package manager for Kubernetes)
5. An **AWS EKS Cluster** (already set up)

---

## Installation Instructions

Follow these steps to install the required dependencies on an Ubuntu-based system.

### 1. Install Terraform

```bash
# Update and upgrade system packages
sudo apt update && sudo apt upgrade -y

# Install necessary dependencies
sudo apt install -y gnupg software-properties-common curl unzip

# Add HashiCorp GPG key and repository
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

# Update package lists and install Terraform
sudo apt update && sudo apt install -y terraform
```

### 2. Install kubectl

```bash
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo chmod +x kubectl
sudo mv kubectl /usr/local/bin/
sudo kubectl version --client
```

### 3. Install Helm

```bash
curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
sudo helm version
```

### 4. Install AWS CLI

```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```

To automate the installation, you can use the provided `scripts.sh` script.

### Configure AWS Credentials

Run the following command to configure AWS CLI:

```bash
aws configure
```

---

## Step 1: Create Terraform Configuration Files

1. **Create Terraform Directory:**

```bash
mkdir -p terraform
cd terraform/
```

2. **Create Terraform Files:**
   - **`main.tf:`** Define the Virtual Private Cloud (VPC) setup.
   - **`eks.tf:`** Define the AWS EKS cluster configuration.
   - **`iam.tf:`** Define the IAM roles.
   - **`outputs.tf:`** Define outputs for the configuration.
   - **`variables.tf:`** Define variables for the configuration.

3. **Initialize Terraform:**

```bash
terraform init
```

4. **Plan and Apply the Configuration:**

```bash
terraform plan
terraform apply -auto-approve
```

---

## Step 2: Install NGINX Ingress Controller using Helm

1. **Create a New Directory for NGINX Ingress Deployment:**

```bash
mkdir terraform-nginx-ingress && cd terraform-nginx-ingress
terraform init
terraform apply -auto-approve
```

2. **Update the kubeconfig File to Access the EKS Cluster:**

```bash
aws eks update-kubeconfig --region eu-north-1 --name stylish-threads-cluster
```

The output will confirm the addition of a new context to the kubeconfig file:

```
Added new context arn:aws:eks:eu-north-1:794038256791:cluster/stylish-threads-cluster to /home/ubuntu/.kube/config
```

3. **Get a Token for Accessing the EKS Cluster:**

```bash
aws eks get-token --cluster-name stylish-threads-cluster
```

4. **Verify Cluster Access:**

```bash
kubectl get nodes
kubectl get svc -n ingress-nginx
```

At this point, the NGINX Ingress Controller service should be running with an external IP address. The Ingress Controller's service will have the external IP associated with it.

---

## Step 3: Test the Ingress Controller

Test the NGINX Ingress Controller by sending an HTTP request to the external IP address.

```bash
curl -I http://a69714a18eaa84dba905578400eaabfc-1289960659.eu-north-1.elb.amazonaws.com
```

You should receive an HTTP 404 response, which is normal since no ingress rules have been defined yet.

---

## Step 4: Deploy an NGINX Application Behind the Ingress Controller

### 1. Deploy NGINX Application

Create a deployment and service for the NGINX application.

**`nginx-deployment.yaml:`**

Apply the YAML file to create the deployment and service:

```bash
kubectl apply -f nginx-deployment.yaml
```

### 2. Create an Ingress Resource

Now, create an Ingress resource to route traffic to the NGINX service.

**`nginx-ingress.yaml:`**

Apply the Ingress resource:

```bash
kubectl apply -f nginx-ingress.yaml
```

---

## Step 5: Verify Deployment

To verify the deployment, you can use the following commands:

1. **Test the Ingress:**

```bash
curl -I http://a69714a18eaa84dba905578400eaabfc-1289960659.eu-north-1.elb.amazonaws.com/
```

2. **Access via Browser:**

Open a web browser and navigate to the external IP address:

```
http://a69714a18eaa84dba905578400eaabfc-1289960659.eu-north-1.elb.amazonaws.com/
```

You should see the default NGINX welcome page if everything is set up correctly.

---

## Conclusion

This guide has provided detailed instructions to deploy the **NGINX Ingress Controller** on an **AWS EKS** cluster using **Terraform** and **Helm**. With the Ingress Controller successfully deployed, you can now manage external access to your Kubernetes services and route traffic based on defined Ingress rules.
```

---

This structure improves readability, provides clear instructions, and makes it easy to follow the process step by step. Feel free to modify or add additional sections as needed for your project.