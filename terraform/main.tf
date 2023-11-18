
resource "aws_instance" "aws_ubuntu" {
  instance_type = var.instance_type
  ami           = var.instance_ami
  key_name      = var.key_pair_name
  user_data     = file("configuration.tpl")
}

# Define the security group parameters
variable "vpc_id" {
  description = "ID of the VPC where the security group will be created"
}


variable "security_group_exists" {
  description = "Indicates whether the security group already exists"
  default     = false
}

variable "ingress_rules" {
  description = "List of ingress rules for the security group"
  default = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    # Add more rules as needed
  ]
}

# Check if the security group already exists
data "aws_security_group" "existing" {
  count = var.security_group_exists ? 1 : 0

  name = var.security_group_name
}

# Create the security group only if it doesn't exist
resource "aws_security_group" "new" {
  count = var.security_group_exists ? 0 : 1

  name        = var.security_group_name
  description = "My security group description"
  vpc_id      = var.vpc_id

  // Ingress rules
  ingress {
    from_port   = var.ingress_rules[0].from_port
    to_port     = var.ingress_rules[0].to_port
    protocol    = var.ingress_rules[0].protocol
    cidr_blocks = var.ingress_rules[0].cidr_blocks
  }

  // Add more ingress rules as needed
}

