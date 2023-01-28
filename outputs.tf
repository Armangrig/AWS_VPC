output "first_instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.first_aws_instance.public_ip
}


