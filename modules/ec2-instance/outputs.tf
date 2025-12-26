output "public_ip" {
  description = "Public IP address of the instance (if EIP is enabled)"
  value       = aws_instance.server.public_ip
}

output "private_ip" {
  description = "private IP address of the instance (if EIP is enabled)"
  value       = aws_instance.server.private_ip
}

output "instance_state" {
  description = "Indicates whether the instance is stopped"
  value       = var.instance_state
}
