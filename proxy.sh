#!/usr/bin/env bash

proxyaddress=10.136.41.21:1087

# 设置的代理
echo "export http_proxy=http://$proxyaddress" >> ~/.bash_profile
echo "export https_proxy=\$http_proxy" >> ~/.bash_profile
echo "export no_proxy=10.96.0.0/12,10.244.0.0/16,10.136.21.0/8" >> ~/.bash_profile
source ~/.bash_profile
