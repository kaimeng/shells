# shells

git 地址
git clone https://github.com/kaimeng/shells.git

1. 如果系统无法直接连接网络，先设置系统代理 proxy.sh
2. 运行 sh kubernetes_init.sh nodeX (nodeX 是当前节点名)
3. 如果是 master 节点，运行 kubeadm_init.sh

4. 新节点加入 cluser
kubeadm join 10.136.21.110:6443 --token 8p2jg8.drolmtbcvwmad1cd \
    --discovery-token-ca-cert-hash sha256:c3d8c448131ae25a0d0eaf3bb132c8dc7b9ce542802a03f1b288cd5f573560fe

5. 修改ConfigMap的kube-system/kube-proxy中的config.conf，mode: “ipvs”
   kubectl edit cm kube-proxy -n kube-system

   之后重启各个节点上的kube-proxy pod：
   kubectl get pod -n kube-system | grep kube-proxy | awk '{system("kubectl delete pod "$1" -n kube-system")}'

6. 在master节点运行 common_init.sh

dashboard token
eyJhbGciOiJSUzI1NiIsImtpZCI6IiJ9.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJrdWJlLXN5c3RlbSIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VjcmV0Lm5hbWUiOiJrdWJlcm5ldGVzLWRhc2hib2FyZC10b2tlbi1sdzloMiIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50Lm5hbWUiOiJrdWJlcm5ldGVzLWRhc2hib2FyZCIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50LnVpZCI6IjEyY2I0NGJhLTMwZTMtNGU1ZC04MGRlLTQzODk3ZDllMmYyMCIsInN1YiI6InN5c3RlbTpzZXJ2aWNlYWNjb3VudDprdWJlLXN5c3RlbTprdWJlcm5ldGVzLWRhc2hib2FyZCJ9.dd9oxX-TqVvcZ0VmvsaLuqKieeFcT7e5iExL55P6lOrEIOHdIP92MjB44h2T2E0DLJ1XRsARJL8kYHsk8ionlO3PPIVf7uRTZO8JMmepE9-0rHZczIkl__ouZqRT6nxenkl_hzU86ye6zwPXqVYuHtPtaWI8O4-8G1N8SK5XIB5ZVW-gFVmxhvNZq3bkDd14RJtszzMXPMvc5QxJ9FQh3OYhN37Knc1ZhMn2pyEdANjESHLIns2uFDUtgmx7sz54KRqwCY0hZunJWOu1NTD_0FZ889Zha4IxhjtIxyWjTohvRAJLCOhmDYJ14IHIx8kGe8xaJeQkkcyRNWBSGZWk7A
