output "backendUrlProvider" {
  value = "http://${aws_instance.dealstore-backend-p.public_ip}:8080"
}

output "backendUrlDeal" {
  value = "http://${aws_instance.dealstore-backend-d.public_ip}:8080"
}

output "frontendUrl" {
  value = "http://${aws_instance.dealstore-frontend.public_ip}:8080"
}

