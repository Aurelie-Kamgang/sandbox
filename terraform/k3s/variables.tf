variable "region" {
  description = "AWS region"
  default     = "eu-west-1"
}

variable "ami_id" {
  description = "AMI Ubuntu Server"
  default     = "ami-xxxxxxxx"
}

variable "instance_type" {
  description = "Instance type"
  default     = "t3a.medium"
}

variable "agent_count" {
  description = "Number of agents"
  default     = 2
}

variable "ssm_param_name" {
  description = "SSM parameter name for k3s token"
  default     = "/k3s/token"
}