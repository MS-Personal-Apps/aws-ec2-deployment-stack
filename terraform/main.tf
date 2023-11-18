
resource "aws_instance" "aws_ubuntu" {
  instance_type = var.instance_type
  ami           = var.instance_ami
  key_name      = var.key_pair_name
  user_data     = file("configuration.tpl")
}

# Check if the security group already exists
data "aws_security_group" "existing" {
  name = var.security_group_name
}

# Create the security group only if it doesn't exist
resource "aws_security_group" "new" {
  count = data.aws_security_group.existing.arn ? 0 : 1

  name        = var.security_group_name
  description = "My security group description"

  // Ingress rules
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // Add more ingress rules as needed
}

