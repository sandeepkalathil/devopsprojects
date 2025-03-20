output "alb_dns_name" {
  description = "ALB DNS Name"
  value       = module.alb.lb_dns_name
}