# output "podtato-url" {
#   value = "http://${aws_instance.podtatohead-main.public_ip}:8080"
# }

output "podtato-url" {
  value = "http://${aws_elb.main_elb.dns_name}"
}

output "podtato-ip" {
  value = "${aws_launch_configuration.podtatohead-main.associate_public_ip_address}"
}
output "podtato-url-https" {
  value = "http://${aws_elb.main_elb.dns_name}:8080"
}

# output "PUBLIC_IPV4_ADDRESS" {
#   value = aws_launch_configuration.podtatohead-main.public_ip
# }

output "app_url" {
  value = "https://${aws_elb.main_elb.dns_name}.nip.io"
}

output "app_authorization_url" {
  value = "https://${aws_elb.main_elb.dns_name}.nip.io/oauth2/callback"
}