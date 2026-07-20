output "vpc_id" {
  value = module.vpc.vpc_id
}

output "subnet_id" {
  value = module.vpc.subnet_id
}

output "security_group_id" {
  value = module.sg.sg_id
}

output "instance_id" {
  value = module.ec2.instance_id
}

output "instance_public_ip" {
  value = module.ec2.public_ip
}

output "environment" {
  value = local.environment
}