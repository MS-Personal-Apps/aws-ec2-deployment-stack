
# Create the security group only if it doesn't exist
resource "aws_security_group" "new_security_group" {
  # count       = data.aws_security_group.existing_security_group.id == null ? 1 : 0
  vpc_id      = aws_vpc.vpc_deploy_app.id
  name        = var.security_group_name
  description = var.security_group_description

  // Add your security group rules here
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  // Add more rules as needed
}


# Check if the security group already exists
# data "aws_security_group" "existing_security_group" {
#   name = var.security_group_name
# }

# resource "aws_network_interface_sg_attachment" "sg_attachment" {
#   security_group_id    = data.aws_security_group.existing_security_group.id != null ? data.aws_security_group.existing_security_group.id : aws_security_group.new_security_group[0].id
#   network_interface_id = aws_instance.aws_ubuntu.primary_network_interface_id
# }
