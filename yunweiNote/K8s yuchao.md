



```sh
#环境
yum install vim -y
yum install net-tools -y
hostname k8s-master
#添加host 解析
vi /etc/hosts
193.169.0.3 k8s-master
193.169.0.4 slave1
193.169.0.5 slave2
#把文件发给slave节点
scp -rp /etc/hosts/ 193.169.0.4:/etc/hosts
yes
scp -rp /etc/hosts/ 193.169.0.5:/etc/hosts
```

在master 节点装etcd

```sh
yum install etcd -y
vim /etc/etcd/etcd.conf
#找到并改设置
ETCD_LISTEN_CLIENT_URLS="http://0.0.0.0:2379"
ETCD_ADVERTISE_CLIENT_URLS="http://193.169.0.3:2379"
#查看 2379
systemctl start etcd
systemctl enable etcd
netstat -tnlp

yum install kubernetes-master -y
vim /etc/kubernetes/apiserver
#修改，解开注释
# The address on the local server to listen to
KUBE_API_ADDRESS="--insecure-bind-address=0.0.0.0"
KUBE_API_ADDRESS="--insecure-bind-address=127.0.0.1"
# The port on the local server to listen on.
 KUBE_API_PORT="--port=8080"

# Port minions listen on
 KUBELET_PORT="--kubelet-port=10250"

# Comma separated list of nodes in the etcd cluster
KUBE_ETCD_SERVERS="--etcd-servers=http://193.169.0.3:2379"

vim /etc/kubernetes/config
KUBE_MASTER="--master=http://193.169.0.3:8080"
#开服务，并开机启动
systemctl start kube-apiserver.service
systemctl start kube-controller-manager.service
systemctl start kube-scheduler.service
systemctl enable kub-apiserver.service
systemctl enable kube-controller-manager.service
systemctl enable kube-scheduler.service
#检查健康状态
kubectl get componentstatus

```

[](#b1)	[b1r]()

安装node节点 (3个节点全装)

```sh
yum install kubernetes-node -y
vim /etc/kubernetes/config
KUBE_MASTER="--master=http://193.169.0.4:8080"
vim /etc/kubernetes/kubelet
KUBELET_ADDRESS="--address=193.169.0.4"
KUBELET_PORT="--port=10250"
KUBELET_HOSTNAME="--hostname-override=k8s-master"
KUBELET_API_SERVER="--api-servers=http://193.169.0.3:8080"
systemctl start kubelet.service
systemctl start kube-proxy.service
systemctl enable kubelet.service
systemctl enable kube-proxy.service
kubectl get nodes
#应该有master ready了
systemctl status docker
```













[](#b1r)	["b1"]()

```sh
# kubectl get componentstatus 的时候
The connection to the server cluster-endpoint:6443 was refused
env | grep -i kub
systemctl status docker.service

#全局查找
grep -r "cluster-endpoint"
看到 .kube/config:    server: https://cluster-endpoint:6443
cd /root/.kube 	删掉config
find . -name "kub-apiserver.service"

#systemctl start kub-apiserver.service的时候报错
Failed to start kub-apiserver.service: Unit not found.
systemctl status kube-apiserver.service
#打错字母了 ，是systemctl start kube-apiserver.service



```



