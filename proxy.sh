#!/usr/bin/env bash

# 设置的代理
echo "export http_proxy=http://10.136.21.76:1080" >> ~/.bash_profile
echo "export https_proxy=\$http_proxy" >> ~/.bash_profile
source ~/.bash_profile
