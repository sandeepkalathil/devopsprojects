# **Deploying Apache HTTPD on Kubernetes Using Helm (With Lightweight Kubernetes Setup)**  

## **1. Introduction**  
Helm is a package manager for Kubernetes that simplifies application deployment and management. Instead of writing multiple YAML files and manually applying them with `kubectl apply -f`, Helm enables packaging all Kubernetes resources into a **Helm Chart**.  

Using Helm, we can define variables in `values.yaml`, making deployments reusable and configurable. In this guide, we will deploy **Apache HTTPD** on a **lightweight Kubernetes cluster (K3s)** using Helm.

---

## **2. Prerequisites**  
Before proceeding, ensure you have the following:  
✅ An **AWS EC2 instance** (Ubuntu 20.04 or later)  
✅ **K3s (Lightweight Kubernetes)** installed  
✅ **Helm** installed  
✅ Basic knowledge of **Kubernetes and Helm**  

---

## **3. Step-by-Step Deployment Guide**  

### **Step 1: Install Lightweight Kubernetes (K3s) on EC2**  
To reduce resource consumption, we use **K3s**, a lightweight Kubernetes distribution ideal for EC2 instances.  

#### **1. Install K3s**  
Run the following command on your EC2 instance to install K3s:  
```bash
curl -sfL https://get.k3s.io | sh -
```

#### **2. Verify Kubernetes Installation**  
After installation, check if Kubernetes is running:  
```bash
kubectl get nodes
```
If `kubectl` is not found, set up your environment:  
```bash
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
```
Now, verify again:  
```bash
kubectl get nodes
```
Expected Output:
```
NAME              STATUS   ROLES                  AGE    VERSION
ip-172-31-1-249   Ready    control-plane,master   5m     v1.31.6+k3s1
```

---

### **Step 2: Install Helm on Your EC2 Instance**  
Helm is required to deploy applications using Helm Charts.  

#### **1. Install Helm**  
```bash
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
```

#### **2. Verify the Helm Installation**  
```bash
helm version
```
Expected Output:
```
version.BuildInfo{Version:"v3.x.x", GitCommit:"xxxx", ...}
```

---

### **Step 3: Create a Helm Chart for HTTPD**  
A Helm chart packages Kubernetes resources into a structured format.

#### **1. Create a New Helm Chart**  
```bash
helm create httpd-chart
cd httpd-chart
```
This command generates a folder structure under `httpd-chart/`. Now, modify the necessary files.

---

### **Step 4: Modify Helm Chart Files**  

#### **1. Edit `values.yaml` (Configuration for Deployment, Service, and Ingress)**  
Modify `values.yaml` to configure the deployment settings:  

```yaml
replicaCount: 1

image:
  repository: httpd
  tag: latest

service:
  type: ClusterIP
  port: 80

ingress:
  enabled: false  # Set to true if using Ingress
  hostname: httpd.local  # Change to your domain if required
```

---

#### **2. Edit `templates/deployment.yaml` (Define HTTPD Deployment)**  
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: httpd-deployment
spec:
  replicas: {{ .Values.replicaCount }}
  selector:
    matchLabels:
      app: httpd
  template:
    metadata:
      labels:
        app: httpd
    spec:
      containers:
        - name: httpd
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
          ports:
            - containerPort: 80
```

---

#### **3. Edit `templates/service.yaml` (Expose HTTPD via Kubernetes Service)**  
```yaml
apiVersion: v1
kind: Service
metadata:
  name: httpd-service
spec:
  selector:
    app: httpd
  ports:
    - protocol: TCP
      port: {{ .Values.service.port }}
      targetPort: 80
  type: {{ .Values.service.type }}
```

---

#### **4. Edit `templates/ingress.yaml` (Optional: Enable Ingress for External Access)**  
```yaml
{{- if .Values.ingress.enabled }}
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: httpd-ingress
spec:
  rules:
    - host: {{ .Values.ingress.hostname }}
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: httpd-service
                port:
                  number: {{ .Values.service.port }}
{{- end }}
```

---

### **Step 5: Deploy the Helm Chart**  
#### **1. Configure K3s for Helm Deployment**  
```bash
sudo cp -prf /etc/rancher/k3s/k3s.yaml /home/ubuntu/kube.conf
sudo chown ubuntu:ubuntu /home/ubuntu/kube.conf
export KUBECONFIG=/home/ubuntu/kube.conf
```

#### **2. Deploy HTTPD Using Helm**  
```bash
helm install my-httpd ./httpd-chart
```

#### **3. Verify Deployment**  
```bash
kubectl get pods
kubectl get svc
```

#### **4. Test the Service Locally**  
```bash
kubectl port-forward svc/httpd-service 8080:80
curl http://localhost:8080
```

---

### **Step 6: Enable Ingress (Optional: Expose HTTPD Externally)**  
If you want to expose the service using Ingress, follow these steps:

#### **1. Install Nginx Ingress Controller**  
```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml
```

#### **2. Modify `values.yaml` to Enable Ingress**  
```yaml
ingress:
  enabled: true
  hostname: httpd.local
```

#### **3. Upgrade the Helm Deployment**  
```bash
helm upgrade my-httpd ./httpd-chart
```

#### **4. Configure Hostname Resolution**  
```bash
echo "$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[0].address}') httpd.local" | sudo tee -a /etc/hosts
```

#### **5. Test the HTTPD Service**  
```bash
curl http://httpd.local
```

---

### **Step 7: Cleanup (Uninstall HTTPD and K3s)**  
To remove the Helm deployment:  
```bash
helm uninstall my-httpd
```
To completely remove K3s:  
```bash
/usr/local/bin/k3s-uninstall.sh
```

---

## **4. Conclusion**  
In this guide, we deployed **Apache HTTPD** on a **K3s (lightweight Kubernetes cluster)** using **Helm**. Unlike traditional `kubectl apply -f` methods, Helm provides **reusability, configurability, and simplified deployment management**.

