
# Check if the security group already exists
# data "aws_security_group" "existing_security_group" {
#   name = var.security_group_name
# }

# resource "aws_network_interface_sg_attachment" "sg_attachment" {
#   security_group_id    = data.aws_security_group.existing_security_group.id != null ? data.aws_security_group.existing_security_group.id : aws_security_group.new_security_group[0].id
#   network_interface_id = aws_instance.aws_ubuntu.primary_network_interface_id
# }
