resource "aws_launch_template" "website_node" {
  name_prefix   = "website-node"
  image_id      = var.website_node_ami
  instance_type = var.website_node_instance_type
  key_name = var.key_name
  network_interfaces {
    associate_public_ip_address = false
    security_groups            = [aws_security_group.website_node.id]
  }

  iam_instance_profile {
    name = var.iam_instance_profile
  }

  user_data = base64encode(file("userdata.sh"))

  tags = var.common_tags
}

# website Node Security Group
resource "aws_security_group" "website_node" {
  name        = "website-node-sg"
  description = "Security group for website build nodes"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]  
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, {
    Name = "website-node-sg"
  })
}

# Auto Scaling Group for website Nodes
resource "aws_autoscaling_group" "website_nodes" {
  name                = "website-nodes"
  desired_capacity    = var.website_node_count
  max_size           = var.website_node_max_count
  min_size           = var.website_node_min_count
  target_group_arns  = module.alb.target_group_arns
  vpc_zone_identifier = module.vpc.private_subnets

  launch_template {
    id      = aws_launch_template.website_node.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "website-node"
    propagate_at_launch = true
  }
}