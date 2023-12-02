# resource "aws_vpc" "vpc_deploy_app" {
#   cidr_block           = "10.0.0.0/16"
#   enable_dns_hostnames = true
#   enable_dns_support   = true
# }

# resource "aws_subnet" "public_a" {
#   vpc_id            = aws_vpc.vpc_deploy_app.id
#   cidr_block        = "10.0.1.0/24"
#   availability_zone = "${var.region}a"
# }

# # resource "aws_subnet" "public_b" {
# #   vpc_id            = aws_vpc.vpc_deploy_app.id
# #   cidr_block        = "10.0.2.0/24"
# #   availability_zone = "${var.region}b"
# # }

# resource "aws_subnet" "public_b" {
#   vpc_id            = aws_vpc.vpc_deploy_app.id
#   cidr_block        = "10.0.2.0/24"
#   availability_zone = "${var.region}c"
# }
# resource "aws_internet_gateway" "internet_gateway" {
#   vpc_id = aws_vpc.vpc_deploy_app.id
# }

# resource "aws_route" "internet_access" {
#   route_table_id         = aws_vpc.vpc_deploy_app.main_route_table_id
#   destination_cidr_block = "0.0.0.0/0"
#   gateway_id             = aws_internet_gateway.internet_gateway.id
# }

