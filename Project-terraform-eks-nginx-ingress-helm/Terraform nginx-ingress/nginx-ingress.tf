# Fetch EKS Cluster details
data "aws_eks_cluster" "cluster" {
  name = "stylish-threads-cluster"
}

data "aws_eks_cluster_auth" "cluster" {
  name = "stylish-threads-cluster"
}

provider "helm" {
  kubernetes {
    host                   = "https://773C9D84D978CAE0C61D6C9451592ED8.sk1.eu-north-1.eks.amazonaws.com"  # Terraform output will provide the endpoint url
    token                  = data.aws_eks_cluster_auth.cluster.token
    cluster_ca_certificate = base64decode("LS0tLS1CRUdJTiBDRVJU") # Terraform output will provide the certificate
  }
}

resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  namespace  = "ingress-nginx"

  create_namespace = true

  set {
    name  = "controller.service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "controller.ingressClassResource.default"
    value = "true"
  }
}