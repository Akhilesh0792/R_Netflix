output "alb_sg_id"      { value = aws_security_group.alb_sg.id }
output "frontend_sg_id" { value = aws_security_group.frontend_sg.id }
output "kafka_sg_id"    { value = aws_security_group.kafka_sg.id }