# Private subnets
resource "aws_subnet" "private" {
  count                   = length(var.private_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.project_name}-private-subnet-${count.index + 1}"
  }
}

# Public subnets
resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-subnet-${count.index + 1}"
  }
}
# Note: Ensure that the length of var.private_subnet_cidrs, var.public_subnet_cidrs, and var.availability_zones are the same to avoid index errors.
# This setup creates two private and two public subnets across the specified availability zones.
# The public subnets have map_public_ip_on_launch set to true, allowing instances launched in these subnets to receive public IP addresses automatically.
# The private subnets have map_public_ip_on_launch set to false, meaning instances launched in these subnets will not receive public IP addresses.
# The tags assigned to each subnet help in identifying them easily in the AWS Management Console.
# Make sure that the VPC is created before the subnets by using the implicit dependency on aws_vpc.main.
# This configuration is essential for setting up a VPC with both public and private subnets, allowing for a secure and efficient network architecture.
# The above configuration assumes that the VPC is defined in another Terraform file within the same project.
# Adjust the CIDR blocks and availability zones as per your requirements.
# Ensure that the CIDR blocks for the subnets do not overlap and are within the CIDR block of the VPC.
# The availability zones should be valid for the region where the VPC is created.
# This configuration provides a foundational network setup for deploying resources in AWS using Terraform.
# Further configurations such as route tables, NAT gateways, and internet gateways can be added to enhance the network functionality.
# Always validate and plan your Terraform configurations before applying them to avoid any unintended changes.
# This setup is suitable for a variety of applications, including web applications, databases, and other services that require both public and private access.
# Consider implementing security groups and network ACLs to further secure the subnets and control traffic flow.
# Regularly review and update the subnet configurations to align with best practices and evolving requirements.
# Documentation and comments within the Terraform files help in maintaining clarity and understanding of the infrastructure setup.
# Collaboration with team members is facilitated by clear and well-structured Terraform configurations.
# This approach promotes infrastructure as code (IaC) principles, enabling version control and      automation of infrastructure deployments.   
# Always ensure compliance with organizational policies and standards when configuring network resources in AWS.
# The above configuration is a starting point and can be customized further based on specific use cases and
