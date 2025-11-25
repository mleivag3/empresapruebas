resource "aws_vpc" "this" {
  cidr_block = var.cidr_vpc
  tags = {
    Name = "${var.project}-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id
  tags = { Name = "${var.project}-igw" }
}

# Public subnets
resource "aws_subnet" "public" {
  for_each = { for idx, cidr in var.public_subnets : idx => cidr }
  vpc_id = aws_vpc.this.id
  cidr_block = each.value
  availability_zone = var.availability_zones[each.key]
  map_public_ip_on_launch = true
  tags = { Name = "${var.project}-public-${each.key}" }
}

# Private subnets
resource "aws_subnet" "private" {
  for_each = { for idx, cidr in var.private_subnets : idx => cidr }
  vpc_id = aws_vpc.this.id
  cidr_block = each.value
  availability_zone = var.availability_zones[each.key]
  map_public_ip_on_launch = false
  tags = { Name = "${var.project}-private-${each.key}" }
}
