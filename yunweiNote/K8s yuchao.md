



```sh
#环境
systemctl stop firewalld
sustemctl disable firewalld
systemctl stop NetworkManager.service
systemctl disable NetworkManager.service
systemctl stop postfix.service
systemctl disable postfix.service
wget -0 /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
yum install -y bash-completion.noarch
yum install -y net-tools vim lrzsz wget tree screen lsof tcpdump

#操作系统 cat /etc/redhat-release	CentOS Linux release 7.4.1708

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
#KUBE_API_ADDRESS="--insecure-bind-address=127.0.0.1"
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
KUBE_MASTER="--master=http://193.169.0.3:8080"
vim /etc/kubernetes/kubelet
KUBELET_ADDRESS="--address=193.169.0.4"
KUBELET_PORT="--port=10250"
KUBELET_HOSTNAME="--hostname-override=slave1"
KUBELET_API_SERVER="--api-servers=http://193.169.0.3:8080"
systemctl start kubelet.service
systemctl start kube-proxy.service
systemctl enable kubelet.service
systemctl enable kube-proxy.service
systemctl status docker
kubectl get nodes
#应该有master ready了

#master的配置
vim /etc/kubernetes/config
KUBE_MASTER="--master=http://193.169.0.3:8080"
vim /etc/kubernetes/kubelet
KUBELET_ADDRESS="--address=193.169.0.3"
KUBELET_PORT="--port=10250"
KUBELET_HOSTNAME="--hostname-override=k8s-master"
KUBELET_API_SERVER="--api-servers=http://193.169.0.3:8080"
```


安装fannel （三个节点）

```sh
yum install flannel -y
vim /etc/sysconfig/flanneld
FLANNEL_ETCD_ENDPOINTS="http://193.169.0.3:2379"	#一定是master 的地址
etcdctl set /atomic.io/network/config '{ "Network": "172.16.0.0/16" }'
systemctl start flanneld.service
systemctl enable flanneld.service
systemctl restart docker
# ip addr 可以看到docker和flannel一致了
# tail -f /var/log/messages 看日志

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

#yum install kubernetes-node -y 的时候报错冲突了
Error: docker-ce-cli conflicts with 2:docker-1.13.1-209.git7d71120.el7.centos.x86_64
yum remove docker-ce -y
yum remove docker-ce-cli -y
yum remove kubernetes-node -y
yum remove docker -y
yum remove kubectl-1.20.9-0 -y
yum remove kubernetes -y
yum erase -y kubelet kubectl kubeadm kubernetes-cni


# systemctl status docker 报错
slave1 dockerd-current[111288]: unable to configure the Docker daemon with file /etc/docker/daemon.json: the following directives are specified both as a flag and in the configuration file: exec-opts: (from flag: [native.cgroupdriver=systemd], from file: [native.cgroupdriver=systemd]), log-driver: (from flag: journald, from file: json-file), storage-driver: (from flag: overlay2, from file: overlay2)

rm -rf /etc/docker/daemon.json

# kubectl get nodes 报错
The connection to the server localhost:8080 was refused - did you specify the right host or port?

firewall-cmd --zone=public --add-port=8080/tcp --permanent	
systemctl restart firewalld.service
systemctl enable firewalld.service  


```











