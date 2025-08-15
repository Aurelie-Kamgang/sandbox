#!/bin/bash
set -xe
curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=$k3s_version sh -s - server --node-name k3s-master
sleep 30
TOKEN=$(sudo cat /var/lib/rancher/k3s/server/node-token)
yum install -y awscli || apt-get install -y awscli
aws ssm put-parameter --name "${ssm_param_name}" --type "SecureString" --value "$TOKEN" --overwrite --region ${region}