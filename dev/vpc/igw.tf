# Create an Internet Gateway
# comment: This resource creates an Internet Gateway and attaches it to the specified VPC.
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}


# Create a route in the public route table to direct internet-bound traffic to the Internet Gateway
resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0" # This route directs all internet-bound traffic
  gateway_id             = aws_internet_gateway.main.id
}
# Note: The aws_route resource above creates a route in the public route table that directs all internet-bound traffic (0.0.0.0/0) to the Internet Gateway.
# This setup allows instances in the public subnets to access the internet directly via the Internet Gateway.
# Instances in private subnets will use the NAT Gateway for internet access, as defined in the natgateway.tf file.
# Ensure that the Internet Gateway is created before the route is added by using the implicit dependency on aws_internet_gateway.main.
# This configuration is essential for enabling internet connectivity for resources within the VPC, particularly those in public subnets.
# The Internet Gateway is a critical component for VPCs that require internet access, and it must be properly configured to ensure secure and efficient routing of traffic.
# The above configuration assumes that the VPC, subnets, and route tables are defined in other Terraform files within the same project.