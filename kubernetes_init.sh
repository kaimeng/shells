#!/usr/bin/env bash

proxyaddress=10.136.41.21:1087

# 设置hostname
hostnamectl set-hostname $1
ip=`hostname -I`
ip_array=(${ip// / })
echo ${ip_array[0]} $1 >> /etc/hosts


# 禁用防火墙
systemctl stop firewalld
systemctl disable firewalld

# Set SELinux in permissive mode (effectively disabling it)
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

cat > /etc/sysctl.d/k8s.conf <<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

modprobe br_netfilter
sysctl -p /etc/sysctl.d/k8s.conf

cat > /etc/sysconfig/modules/ipvs.modules <<EOF
#!/bin/bash
modprobe -- ip_vs
modprobe -- ip_vs_rr
modprobe -- ip_vs_wrr
modprobe -- ip_vs_sh
modprobe -- nf_conntrack_ipv4
EOF
chmod 755 /etc/sysconfig/modules/ipvs.modules && bash /etc/sysconfig/modules/ipvs.modules && lsmod | grep -e ip_vs -e nf_conntrack_ipv4

yum install -y ipset

swapoff -a
sed -i 's/^\/dev\/mapper\/centos-swap/#\/dev\/mapper\/centos-swap/' /etc/fstab

############## 安装 docker ##############
# Install Docker CE
## Set up the repository
### Install required packages.
yum install -y yum-utils device-mapper-persistent-data lvm2

### Add Docker repository.
yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo

## Install Docker CE.
yum install -y docker-ce-18.06.2.ce

## Create /etc/docker directory.
mkdir /etc/docker

# Setup daemon.
cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2",
  "storage-opts": [
    "overlay2.override_kernel_check=true"
  ],
  "registry-mirrors": ["https://uwbqrb9q.mirror.aliyuncs.com"]
}
EOF

mkdir -p /etc/systemd/system/docker.service.d

# 设置 docker 代理
cat > /etc/systemd/system/docker.service.d/http-proxy.conf <<EOF
[Service]
Environment="HTTP_PROXY=http://$proxyaddress" "NO_PROXY=localhost,127.0.0.1"
EOF
cat > /etc/systemd/system/docker.service.d/https-proxy.conf <<EOF
[Service]
Environment="HTTPS_PROXY=http://$proxyaddress" "NO_PROXY=localhost,127.0.0.1"
EOF

# Restart Docker
systemctl daemon-reload
systemctl restart docker


############## 安装 kubernetes ##############
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

yum install -y kubelet-1.16.0-0 kubeadm-1.16.0-0 kubectl-1.16.0-0 --disableexcludes=kubernetes
systemctl enable --now kubelet

systemctl enable kubelet.service
systemctl enable docker.service
