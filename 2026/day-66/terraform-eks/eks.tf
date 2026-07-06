module "eks" {

  source = "terraform-aws-modules/eks/aws"
  version = "~>20.0"

  cluster_name = var.cluster_name

  cluster_version = var.cluster_version

  cluster_endpoint_public_access = true

  vpc_id = module.vpc.vpc_id

  subnet_ids = module.vpc.private_subnets

  eks_managed_node_groups = {

    worker_nodes = {

      ami_type = "AL2_x86_64"

      instance_types = [var.node_instance_type]

      min_size = 1

      desired_size = var.node_desired_count

      max_size = 3

    }

  }

  tags = {

    Environment = "Dev"

    Project = "TerraWeek"

    ManagedBy = "Terraform"

  }

}