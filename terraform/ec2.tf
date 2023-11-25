resource "aws_instance" "aws_ubuntu" {
  instance_type = var.instance_type
  ami           = var.instance_ami
  key_name      = var.key_pair_name

  user_data = file("file.sh")
  // subnet
  subnet_id              = aws_subnet.public_a.id
  vpc_security_group_ids = [aws_security_group.new_security_group.id]
  tags = {
    Name = var.instance_name # Specify the desired name for the instance
  }
}
