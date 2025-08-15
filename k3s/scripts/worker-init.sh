#!/bin/bash
yum install -y awscli || apt-get install -y awscli
TOKEN=$(aws ssm get-parameter --name "${ssm_param_name}" --with-decryption --region ${region} --query 'Parameter.Value' --output text)
curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=$k3s_version K3S_URL="https://${master_ip}:6443" K3S_TOKEN="$TOKEN" sh -s - agent --node-name k3s-agent