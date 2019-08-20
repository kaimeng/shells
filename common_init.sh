#!/usr/bin/env bash

# 在master 节点安装

# 安装 helm
cd ~
curl -O https://get.helm.sh/helm-v2.14.3-linux-amd64.tar.gz
tar -zxvf helm-v2.14.3-linux-amd64.tar.gz
cd linux-amd64/
cp helm /usr/local/bin/

# 安装 tiller
cd ~/shells
kubectl create -f helm-rbac.yaml
helm init --service-account tiller --skip-refresh
helm repo add stable http://mirror.azure.cn/kubernetes/charts

# 安装 nginx-ingress
kubectl label node node1 node-role.kubernetes.io/edge=
helm repo update
cd ~/shells
helm install stable/nginx-ingress -n nginx-ingress --namespace ingress-nginx -f ingress-nginx.yaml

cd ~/shells
helm install stable/kubernetes-dashboard -n kubernetes-dashboard --namespace kube-system -f kubernetes-dashboard.yaml
