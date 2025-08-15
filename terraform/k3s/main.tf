resource "aws_instance" "k3s_master" {
  # ...
  iam_instance_profile = aws_iam_instance_profile.instance_profile.name

  user_data = templatefile("${path.module}/master_userdata.sh", {
    region         = var.region
    ssm_param_name = var.ssm_param_name
  })
}


resource "aws_instance" "k3s_master" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.main.id
  vpc_security_group_ids      = [aws_security_group.k3s.id]
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.instance_profile.name

  user_data = <<-EOF
    #!/bin/bash
    curl -sfL https://get.k3s.io | sh -s - server --node-name k3s-master
    sleep 30
    TOKEN=$(sudo cat /var/lib/rancher/k3s/server/node-token)
    REGION="${var.region}"
    yum install -y awscli || apt-get install -y awscli
    aws ssm put-parameter --name "/k3s/token" --type "SecureString" --value "$TOKEN" --overwrite --region $REGION
  EOF

  tags = {
    Name = "k3s-master"
  }
}


resource "aws_instance" "k3s_agent" {
  count                = var.agent_count
  iam_instance_profile = aws_iam_instance_profile.instance_profile.name

  user_data = templatefile("${path.module}/agent_userdata.sh", {
    region         = var.region
    ssm_param_name = var.ssm_param_name
    master_ip      = aws_instance.k3s_master.private_ip
  })
}


resource "aws_instance" "k3s_agent" {
  count                       = var.agent_count
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.main.id
  vpc_security_group_ids      = [aws_security_group.k3s.id]
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.instance_profile.name

  user_data = <<-EOF
    #!/bin/bash
    yum install -y awscli || apt-get install -y awscli
    REGION="${var.region}"
    MASTER_IP="${aws_instance.k3s_master.private_ip}"
    TOKEN=$(aws ssm get-parameter --name "/k3s/token" --with-decryption --region $REGION --query 'Parameter.Value' --output text)
    curl -sfL https://get.k3s.io | K3S_URL="https://${MASTER_IP}:6443" K3S_TOKEN="$TOKEN" sh -s - agent --node-name k3s-agent-${count.index}
  EOF

  tags = {
    Name = "k3s-agent-${count.index}"
  }
}