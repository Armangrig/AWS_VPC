data "http" "website" {
  url = "http://${aws_instance.web.public_ip}"
}

output "curl_response" {
  value = data.http.website.body
}


