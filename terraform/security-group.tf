
resource "aws_security_group" "new_security_group" {
  ## Create the security group only if it doesn't exist
  # count       = data.aws_security_group.existing_security_group.id == null ? 1 : 0
  # vpc_id      = aws_vpc.vpc_deploy_app.id
  name        = var.security_group_name
  description = var.security_group_description
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
}
