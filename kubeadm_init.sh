#!/usr/bin/env bash

kubeadm init --config=kubernetes_config.yaml


mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

kubectl get cs

mkdir -p ~/k8s/
cd ~/k8s
curl -O https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
kubectl apply -f kube-flannel.yml

kubectl get pod –all-namespaces -o wide
