# 1. Public Subnets
resource "aws_subnet" "public" {
  for_each                = var.public_subnets
  vpc_id                  = var.vpc_id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-${each.key}"
  }
}

# 2. Private Subnets
resource "aws_subnet" "private" {
  for_each          = var.private_subnets
  vpc_id            = var.vpc_id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = {
    Name = "${var.project_name}-private-${each.key}"
  }
}

# 3. Elastic IP for NAT Gateway
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "${var.project_name}-nat-eip"
  }
}

# 4. NAT Gateway (Placed in First Public Subnet)
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = values(aws_subnet.public)[0].id

  tags = {
    Name = "${var.project_name}-nat-gw"
  }
}

# 5. Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.igw_id
  }

  tags = {
    Name = "${var.project_name}-public-rt"
  }
}

# 6. Associate Public Subnets with Public Route Table
resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_rt.id
}

# 7. Private Route Table (Clean Table without inline route conflict)
resource "aws_route_table" "private_rt" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.project_name}-private-rt"
  }
}

# 7.1 Standalone NAT Route (Isse Peering Connection ka 10.0.0.0/17 route delete nahi hoga)
resource "aws_route" "private_nat" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

# 8. Associate Private Subnets with Private Route Table
resource "aws_route_table_association" "private" {
  for_each       = aws_subnet.private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_rt.id
}