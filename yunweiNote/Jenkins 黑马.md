



![heima node](.\heima node.png)

```sh
主机名称 IP地址 安装的软件 
代码托管服 务器 192.168.66.100 Gitlab-12.4.2 
Docker仓库 服务器 192.168.66.102 Harbor1.9.2 
k8s-master 192.168.66.101 kube-apiserver、kube-controller-manager、kubescheduler、docker、etcd、calico，NFS 
k8s-node1 192.168.66.103 kubelet、kubeproxy、Docker18.06.1-ce 
k8s-node2 192.168.66.104 kubelet、kubeproxy、Docker18.06.1-ce
```





## k8s装 jenkins

[bili p83](https://www.bilibili.com/video/BV1kJ411p7mV?p=83&vd_source=ca1d80d51233e3cf364a2104dcf1b743)	

```sh
#先装nfs
1）安装NFS服务（在所有K8S的节点都需要安装）
yum install -y nfs-utils
2）创建共享目录
mkdir -p /opt/nfs/jenkins
vi /etc/exports 编写NFS的共享配置
内容如下:
/opt/nfs/jenkins *(rw,no_root_squash) 	*代表对所有IP都开放此目录，rw是读写
3）启动服务
systemctl enable nfs 
systemctl start nfs 
4）查看NFS共享目录
showmount -e 193.169.0.3

把 k8s-jenkins 拉到 /root/k8s-jenkins
kubectl apply -f /root/k8s-jenkins/nfs-client/.
kubectl delete -f /root/k8s-jenkins/nfs-client/.

kubectl create namespace kube-ops
kubectl apply -f /root/k8s-jenkins/jenkins-master/.









```

























