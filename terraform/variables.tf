variable "region" {
  type        = string
  default     = "eu-west-1"
  description = "Default AWS region."
}
variable "profile" {
  type        = string
  description = "AWS CLI profile that Terraform should use when interacting with AWS resources."
}

variable "instance_ami" {
  type    = string
  default = "ami-0694d931cee176e7d"
}
variable "instance_type" {
  default = "t2.micro"
  type    = string

}
variable "key_pair_name" {
  type    = string
  default = "test-terraform-github-deploy"
}
variable "security_group_name" {
  type        = string
  description = "Name of the security group"
  default     = "demo_sg"
}

variable "security_group_description" {
  type    = string
  default = "My Security Group Description"
}
