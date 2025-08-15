provider "aws" {
  region = var.aws_region
  default_tags { tags = { Project = "k3s-cluster", Environment = var.environment, ManagedBy = "terraform" } }
}