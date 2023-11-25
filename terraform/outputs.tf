# Define output to display instance public IP
output "instance_public_ip" {
  value = aws_instance.aws_ubuntu.public_ip
}
output "instance_public_dns" {
  value = aws_instance.aws_ubuntu.public_dns
}

# output "security_group_id" {
#   # value = data.aws_security_group.existing_security_group.id != null ? data.aws_security_group.existing_security_group.id : aws_security_group.new_security_group[0].id
#   value = aws_security_group.new_security_group.id
# }
