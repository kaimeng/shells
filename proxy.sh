#!/usr/bin/env bash

# 设置的代理
echo "export http_proxy=http://10.136.21.76:1080" >> ~/.bash_profile
echo "export https_proxy=\$http_proxy" >> ~/.bash_profile
ip=`hostname -I`
ip2=${ip/ /,}
echo "export no_proxy=10.96.0.0,10.244.0.0,$ip2" >> ~/.bash_profile
source ~/.bash_profile
