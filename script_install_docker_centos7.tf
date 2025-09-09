# D'abord, sauvegardons et nettoyons
sudo cp /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup

# Créer un nouveau fichier de configuration avec des miroirs fonctionnels
sudo tee /etc/yum.repos.d/CentOS-Base.repo << 'EOF'
[base]
name=CentOS-7 - Base
baseurl=http://vault.centos.org/7.9.2009/os/x86_64/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
enabled=1

[updates]
name=CentOS-7 - Updates
baseurl=http://vault.centos.org/7.9.2009/updates/x86_64/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
enabled=1

[extras]
name=CentOS-7 - Extras
baseurl=http://vault.centos.org/7.9.2009/extras/x86_64/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
enabled=1

[centosplus]
name=CentOS-7 - Plus
baseurl=http://vault.centos.org/7.9.2009/centosplus/x86_64/
gpgcheck=1
enabled=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
EOF

sudo yum clean all
sudo yum makecache
sudo yum update

sudo yum install -y yum-utils git wget curl iptables iptables-services

# Installation de Docker
sudo yum remove -y docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine || true
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin 
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker centos
