output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "public_subnets" {
  description = "Public subnets ID"
  value       = module.vpc.public_subnets
}

output "private_subnets" {
  description = "Private subnets ID"
  value       = module.vpc.private_subnets
}

output "public_security_group_id" {
  description = "Public security group ID"
  value       = aws_security_group.public_sg.id
}

output "private_security_group_id" {
  description = "Private security group ID"
  value       = aws_security_group.private_sg.id
} 