resource "aws_vpc" "main" {
  cidr_block                       = "10.0.0.0/16"
  enable_dns_hostnames             = true
  enable_dns_support               = true
  assign_generated_ipv6_cidr_block = true
}

resource "aws_subnet" "main" {
  availability_zone               = "us-east-1a"
  cidr_block                      = cidrsubnet(aws_vpc.main.cidr_block, 8, 0)
  ipv6_cidr_block                 = cidrsubnet(aws_vpc.main.ipv6_cidr_block, 8, 0)
  assign_ipv6_address_on_creation = true
  vpc_id                          = aws_vpc.main.id
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "public" {
  route_table_id              = aws_vpc.main.main_route_table_id
  destination_cidr_block      = "0.0.0.0/0"
  gateway_id                  = aws_internet_gateway.igw.id
} 

resource "aws_route" "public_ipv6" {
  route_table_id              = aws_vpc.main.main_route_table_id
  destination_ipv6_cidr_block = "::/0"
  gateway_id                  = aws_internet_gateway.igw.id
} 