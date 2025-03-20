# EKS Cluster
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = "${var.project_name}-cluster"
  cluster_version = "1.28"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  cluster_endpoint_public_access = true

  eks_managed_node_groups = {
    general = {
      desired_size = 2
      min_size    = 2
      max_size    = 2

      instance_types = ["t3.medium"]
      capacity_type  = "ON_DEMAND"

      labels = {
        role = "general"
      }

      tags = var.common_tags
    }
  }

  # Add OIDC provider for service accounts
  enable_irsa = true

  # Add ECR pull access for worker nodes
  node_security_group_additional_rules = {
    ecr_pull = {
      description = "ECR Pull"
      protocol    = "tcp"
      from_port   = 443
      to_port     = 443
      type        = "egress"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  # Create separate IAM policies instead of inline policies
  create_cloudwatch_log_group = false
  create_iam_role = true
  iam_role_use_name_prefix = false

  # Attach policies using separate resources
  attach_cluster_encryption_policy = true
  cluster_encryption_policy_use_name_prefix = false

  tags = var.common_tags
}