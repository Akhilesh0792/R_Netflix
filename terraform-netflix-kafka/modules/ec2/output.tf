output "instance_id" { value = aws_instance.netflix.id }
output "public_ip"   { value = aws_instance.netflix.public_ip }
output "private_ip"  { value = aws_instance.netflix.private_ip }