############################################
# ALB DNS name
############################################
output "alb_dns_name" {
  value = aws_lb.this.dns_name
}

############################################
# Target group ARN
############################################
output "target_group_arn" {
  value = aws_lb_target_group.app.arn
}