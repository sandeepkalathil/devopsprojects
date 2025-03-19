# K3s CI/CD Setup

## Overview
This repository provides a comprehensive guide for installing K3s on a virtual machine and configuring the `kubeconfig` file for CI/CD pipelines. K3s is a lightweight Kubernetes distribution, making it ideal for self-hosted CI/CD environments.

## Installation Steps

### 1. Set Up the Virtual Machine
Ensure that you have a virtual machine (Ubuntu 20.04/22.04 recommended) with internet access. Update the system packages:

```bash
sudo apt update && sudo apt upgrade -y
```

### 2. Install K3s
Download and install K3s using the following command:

```bash
curl -sfL https://get.k3s.io | sh -
```

Verify the installation status:

```bash
sudo systemctl status k3s
```

Check if the node is ready:

```bash
sudo k3s kubectl get nodes
```

### 3. Retrieve and Configure Kubeconfig
Create the necessary directory for the Jenkins user:

```bash
sudo mkdir -p /var/lib/jenkins/.kube
```

Copy the K3s configuration file:

```bash
sudo cp /etc/rancher/k3s/k3s.yaml /var/lib/jenkins/.kube/config
```

Adjust permissions for Jenkins:

```bash
sudo chown -R jenkins:jenkins /var/lib/jenkins/.kube
sudo chmod 600 /var/lib/jenkins/.kube/config
```

Verify the configuration:

```bash
kubectl get nodes
```

### 4. Modify Kubeconfig for CI/CD
Retrieve the internal IP address of the instance:

```bash
hostname -I | awk '{print $1}'
```

Update the `kubeconfig` file to replace `127.0.0.1` with the internal IP:

```bash
sudo sed -i "s/127.0.0.1/$(hostname -I | awk '{print $1}')/g" /var/lib/jenkins/.kube/config
```

### 5. Use K3s in CI/CD Pipelines
For Jenkins, GitHub Actions, or GitLab CI, configure `kubeconfig` as a secret and reference it in pipeline scripts.

#### Example: Jenkins
Set the `KUBECONFIG` environment variable and verify Kubernetes access:

```bash
export KUBECONFIG=/var/lib/jenkins/.kube/config
kubectl get pods
```

### 6. Install Jenkins
Run the installation script:

```bash
sudo sh -x install.sh
```

Ensure that port 8080 is open in the security group attached to the instance to allow access to the Jenkins web interface:

```
http://<PUBLIC_IP>:8080
```

### 7. Verify KUBECONFIG in a Jenkins Pipeline
Create a new Jenkins pipeline and configure it as follows:

#### Pipeline Script Example:

```groovy
pipeline {
    agent any
    environment {
        KUBECONFIG = "/var/lib/jenkins/.kube/config"
    }
    stages {
        stage('Check Kubernetes') {
            steps {
                sh 'kubectl get nodes'
            }
        }
    }
}
```

Run the pipeline by selecting **Build Now**.

### 8. Configure Kubeconfig in GitHub Actions
For GitHub Actions, use the following steps to set up and use `kubeconfig`:

```yaml
- name: Setup Kubeconfig
  run: |
    echo "$KUBECONFIG_CONTENT" | base64 --decode > ~/.kube/config
- name: Deploy to Kubernetes
  run: kubectl apply -f deployment.yaml
```

## Conclusion
This guide provides a structured approach to setting up K3s, configuring `kubeconfig` for CI/CD pipelines, and integrating Kubernetes with Jenkins or GitHub Actions. By following these steps, you can efficiently deploy and manage applications in a self-hosted Kubernetes environment.

