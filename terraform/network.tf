# Create a VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.aws_vpc.cidr_block
  tags = {
    Name = var.aws_vpc.tags.Name
  }
}

# Create Private Subnets
resource "aws_subnet" "private_subnets" {
  count                   = var.aws_subnet.count
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index)
  availability_zone       = var.aws_subnet.availability_zone[count.index]
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.aws_subnet.private_subnet.Name}${count.index}"
  }
}

# Create Public Subnets
resource "aws_subnet" "public_subnets" {
  count                   = var.aws_subnet.count
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index + var.aws_subnet.count)
  availability_zone       = var.aws_subnet.availability_zone[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.aws_subnet.public_subnet.Name}${count.index}"
  }
}

# Internet Gateway for Public Subnet
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = var.aws_internet_gateway.tags.Name
  }
}

# Route the Public Subnet Traffic through the Internet Gateway
resource "aws_route" "route" {
  route_table_id         = aws_vpc.vpc.main_route_table_id
  destination_cidr_block = var.aws_route.destination_cidr_block
  gateway_id             = aws_internet_gateway.internet_gateway.id
}

# Create a NAT gateway with an Elastic IP for each Private Subnet to get Internet Connect
resource "aws_eip" "eip" {
  count      = var.aws_eip.count
  vpc        = var.aws_eip.vpc
  depends_on = [aws_internet_gateway.internet_gateway]
  tags = {
    Name = "${var.aws_eip.tags.Name}${count.index}"
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  count         = var.aws_nat_gateway.count
  subnet_id     = element(aws_subnet.public_subnets.*.id, count.index)
  allocation_id = element(aws_eip.eip.*.id, count.index)
}

# Create a New Route Table for Private Subnets, make it route non-local traffic through the NAT gateway to the internet
resource "aws_route_table" "route_table" {
  count  = var.aws_route_table.count
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.nat_gateway.*.id, count.index)
  }
}

# Explicitly associate the Private Subnets with the Private Route Table
resource "aws_route_table_association" "private_route_table_association" {
  count          = var.aws_route_table_association.count
  subnet_id      = element(aws_subnet.private_subnets.*.id, count.index)
  route_table_id = element(aws_route_table.route_table.*.id, count.index)
}