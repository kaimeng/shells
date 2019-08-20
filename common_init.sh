#!/usr/bin/env bash

curl -O https://get.helm.sh/helm-v2.14.3-linux-amd64.tar.gz
tar -zxvf helm-v2.14.3-linux-amd64.tar.gz
cd linux-amd64/
cp helm /usr/local/bin/

cd ~/shells
kubectl create -f helm-rbac.yaml
helm init --service-account tiller --skip-refresh
helm repo add stable http://mirror.azure.cn/kubernetes/charts
