resource "aws_instance" "aws_ubuntu" {
  instance_type = var.instance_type
  ami           = data.aws_ami.latest_ubuntu.id
  key_name      = var.key_pair_name

  user_data = file("setup_nginx_all.sh")

  // enable subnet if using custom vpc
  # subnet_id              = aws_subnet.public_a.id
  vpc_security_group_ids = [aws_security_group.new_security_group.id]
  tags = {
    Name = var.instance_name
  }
}
