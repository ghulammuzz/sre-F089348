output "instance_id" {
  value = aws_instance.web.id
}

output "public_ip" {
  description = "Public IP of the instance"
  value       = aws_instance.web.public_ip
}