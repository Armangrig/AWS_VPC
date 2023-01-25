data "http" "website" {
  url = "http://${aws_instance.web.public_ip}"
}

output "curl_response" {
  value = data.http.website.body
}

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.app_server.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.app_server.public_ip
}
