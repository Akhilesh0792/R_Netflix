output "alb_dns_endpoint" {
  description = "Open this URL in browser to view Netflix App"
  value       = module.alb.alb_dns_name
}

output "frontend_public_ip" {
  value = module.netflix_frontend.public_ip
}

output "kafka_private_ips" {
  value = { for k, v in module.kafka_nodes : k => v.private_ip }
}

output "s3_bucket_name" {
  description = "akhilesh07"
  value       = "akhilesh07" 
}

output "app_public_dns" {
  description = "Public IP or ALB DNS for Netflix App"
  value = module.alb.alb_dns_name
 # value = module.netflix_frontend.public_ip
}