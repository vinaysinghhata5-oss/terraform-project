# create single nat gateway (place in first public subnet)
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id # use the first public subnet
  tags = {
    Name = "${var.project_name}-nat-gateway"
  }
  depends_on = [aws_internet_gateway.igw]
}
# create elastic ip for nat gateway
resource "aws_eip" "nat" {
  vpc = true
  tags = {
    Name = "${var.project_name}-nat-eip"
  }
}

# Note: Ensure that the Internet Gateway is created before the NAT Gateway by using the depends_on argument.
# This setup creates a NAT Gateway in each public subnet, allowing instances in private subnets to

# access the internet while remaining unreachable from the outside.
# The Elastic IPs are associated with the NAT Gateways to provide them with public IP addresses.
# The tags assigned to each NAT Gateway and Elastic IP help in identifying them easily in the AWS Management Console.
# Make sure that the public subnets are created before the NAT Gateways by using the implicit dependency on aws_subnet.public.
# This configuration is essential for setting up a VPC with both public and private subnets, allowing for a secure and efficient network architecture.
# The above configuration assumes that the VPC and subnets are defined in other Terraform files within the same project.    
# Adjust the number of NAT Gateways and Elastic IPs based on the number of public subnets you have.
# Ensure that the NAT Gateways are placed in different availability zones for high availability.
# This configuration provides a foundational network setup for deploying resources in AWS using Terraform.
# Further configurations such as route tables and internet gateways can be added to enhance the network functionality.
# Always validate and plan your Terraform configurations before applying them to avoid any unintended changes.