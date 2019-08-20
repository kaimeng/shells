#!/usr/bin/env bash

# 在master 节点安装

cd ~
curl -O https://get.helm.sh/helm-v2.14.3-linux-amd64.tar.gz
tar -zxvf helm-v2.14.3-linux-amd64.tar.gz
cd linux-amd64/
cp helm /usr/local/bin/

cd ~/shells
kubectl create -f helm-rbac.yaml
helm init --service-account tiller --skip-refresh
helm repo add stable http://mirror.azure.cn/kubernetes/charts

kubectl label node node1 node-role.kubernetes.io/edge=
helm repo update
helm install stable/nginx-ingress -n nginx-ingress --namespace ingress-nginx -f ingress-nginx.yaml
