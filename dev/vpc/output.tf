output "vpc_id" {
  value       = aws_vpc.main.id
  description = "The ID of the VPC"
  depends_on  = [aws_vpc.main]
}

output "public_subnets" {
  value       = aws_subnet.public[*].id
  description = "List of public subnet IDs"
  depends_on  = [aws_subnet.public]
}

output "private_subnets" {
  value       = aws_subnet.private[*].id
  description = "List of private subnet IDs"
  depends_on  = [aws_subnet.private]
}

# Optional: if you create NAT & IGW in VPC module
output "nat_gateway_ids" {
  value       = aws_nat_gateway.nat[*].id
  description = "List of NAT Gateway IDs"
}

output "internet_gateway_ids" {
  value       = aws_internet_gateway.igw[*].id
  description = "Internet Gateway IDs"
}