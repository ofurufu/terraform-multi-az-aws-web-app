output "alb_dns_name" {
  value = aws_lb.main.dns_name
}
output "alb_arn" {
  value = aws_lb.main.arn
}
output "asg_name" {
  value = aws_autoscaling_group.app.name
}
output "app_sg_id" {
  value = aws_security_group.app.id
}