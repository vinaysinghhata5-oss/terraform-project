resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public-1.id

  tags = {
    Name = "${var.project_name}-nat-gateway"
  }
}
# Create an Elastic IP for the NAT Gateway
resource "aws_eip" "nat" {
  vpc = true
  tags = {
    Name = "${var.project_name}-nat-eip"
  }
}
resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main.id
  depends_on             = [aws_nat_gateway.main]
}
# Note: The depends_on argument ensures that the NAT Gateway is created before this route is added. This is important because the route depends on the NAT Gateway being available.
# This setup allows instances in the private subnets to access the internet via the NAT Gateway while remaining unreachable from the internet.
