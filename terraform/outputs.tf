# Define output to display instance public IP
output "instance_public_ip" {
  value = aws_instance.aws_ubuntu.public_ip
}
output "instance_public_dns" {
  value = aws_instance.aws_ubuntu.public_dns
}
