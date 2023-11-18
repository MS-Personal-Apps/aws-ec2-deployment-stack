
resource "aws_instance" "aws_ubuntu" {
  instance_type = var.instance_type
  ami           = var.instance_ami
  key_name      = var.key_pair_name
  user_data     = file("configuration.tpl")
}

# Check if the security group already exists
data "aws_security_group" "existing_security_group" {
  name = var.security_group_name
}

# Create the security group only if it doesn't exist
resource "aws_security_group" "new_security_group" {
  count = data.aws_security_group.existing_security_group.id == null ? 1 : 0

  name        = var.security_group_name
  description = var.security_group_description

  // Add your security group rules here
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // Add more rules as needed
}

