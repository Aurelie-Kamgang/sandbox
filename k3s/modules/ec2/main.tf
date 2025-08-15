resource "aws_instance" "this" {
  count                       = var.worker_number
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = var.subnets[count.index % length(var.subnets)]
  vpc_security_group_ids      = [var.security_group_id]
  associate_public_ip_address = true
  iam_instance_profile        = var.iam_instance_profile
  user_data_base64 = var.instance_role == "master" ? base64encode(templatefile(var.user_data_template, {
    region         = var.region
    ssm_param_name = var.ssm_param_name
    k3s_version    = var.k3s_version
    })) : base64encode(templatefile(var.user_data_template, {
    region         = var.region
    ssm_param_name = var.ssm_param_name
    master_ip      = var.master_ip
    k3s_version    = var.k3s_version
  }))
  root_block_device {
    volume_type           = var.volume_type
    volume_size           = var.volume_size
    delete_on_termination = true
  }
  tags = {
    Name = "k3s_${var.instance_role}_${var.worker_number}"
  }
}
