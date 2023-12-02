data "aws_ami" "latest_ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical account ID for Ubuntu

  filter {
    name   = "description"
    values = ["Canonical, Ubuntu, 22.04 LTS, amd64 jammy image build on 2023-09-19"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
