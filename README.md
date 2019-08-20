# shells

git 地址
git clone https://github.com/kaimeng/shells.git

1. 如果系统无法直接连接网络，先设置系统代理 proxy.sh
2. 运行 sh kubernetes_init.sh nodex (nodex 是当前节点名)
3. 如果是 master 节点，运行 kubeadm_init.sh

修改ConfigMap的kube-system/kube-proxy中的config.conf，mode: “ipvs”
kubectl edit cm kube-proxy -n kube-system

之后重启各个节点上的kube-proxy pod：
kubectl get pod -n kube-system | grep kube-proxy | awk '{system("kubectl delete pod "$1" -n kube-system")}'
