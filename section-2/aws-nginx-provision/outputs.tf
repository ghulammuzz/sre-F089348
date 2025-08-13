output "public_ips" {
  value = [for s in aws_instance.nginx_servers : s.public_ip]
}

output "private_ips" {
  value = [for s in aws_instance.nginx_servers : s.private_ip]
}
