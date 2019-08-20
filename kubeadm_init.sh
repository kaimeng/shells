#!/usr/bin/env bash

kubeadm init --config=kubernetes_config.yaml

echo "kubeadm init successfully ..."

# 使用集群
rm -rf $HOME/.kube
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

# 安装 pod network
mkdir -p ~/k8s/
cd ~/k8s
curl -O https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
kubectl apply -f kube-flannel.yml
