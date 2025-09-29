# create a private Route Table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-private-route-table-1"
  }
}



# create a public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.project_name}-public-route-table-1"
  }
}

# Associate the private Route Table with the private subnets
resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}


# Associate the public Route Table with the public subnets
resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Create a route in the public Route Table to the Internet Gateway
resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}
# Note: Ensure that the Internet Gateway is created before the route by using the implicit dependency on aws_internet_gateway.igw.
# This setup allows instances in the public subnets to access the internet.

#create a route in the private Route Table to the NAT Gateway
resource "aws_route" "private_nat_access" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}
# Note: Ensure that the NAT Gateway is created before the route by using the implicit dependency on aws_nat_gateway.nat.
# This setup allows instances in the private subnets to access the internet via the NAT Gateway while remaining unreachable from the outside.
# The tags assigned to each route table and route help in identifying them easily in the AWS Management Console.
# Make sure that the subnets are created before the route tables by using the implicit dependency on aws_subnet.private and aws_subnet.public