



![heima node](.\heima node.png)

```sh
主机名称 IP地址 安装的软件 
代码托管服 务器 192.168.66.100 Gitlab-12.4.2 
Docker仓库 服务器 192.168.66.102 Harbor1.9.2 
k8s-master 192.168.66.101 kube-apiserver、kube-controller-manager、kubescheduler、docker、etcd、calico，NFS 
k8s-node1 192.168.66.103 kubelet、kubeproxy、Docker18.06.1-ce 
k8s-node2 192.168.66.104 kubelet、kubeproxy、Docker18.06.1-ce
```



## Kubernetes环境	(2个node都要)

[bili p78](https://www.bilibili.com/video/BV1kJ411p7mV?p=78&vd_source=ca1d80d51233e3cf364a2104dcf1b743)

```sh
#1 关闭防火墙和关闭SELinux
systemctl stop firewalld
systemctl disable firewalld
systemctl stop NetworkManager.service
systemctl disable NetworkManager.service
systemctl stop postfix.service
systemctl disable postfix.service

setenforce 0 #临时关闭
vi /etc/sysconfig/selinux 	#永久关闭
改为SELINUX=disabled

#2 设置系统参数 
设置允许路由转发，不对bridge的数据进行处理
创建文件
vi /etc/sysctl.d/k8s.conf
内容如下：
net.bridge.bridge-nf-call-ip6tables = 1 
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1 vm.swappiness = 0
#执行文件
sysctl -p /etc/sysctl.d/k8s.conf

# kube-proxy开启ipvs的前置条件
cat > /etc/sysconfig/modules/ipvs.modules <<EOF
#!/bin/bash
modprobe -- ip_vs
modprobe -- ip_vs_rr
modprobe -- ip_vs_wrr
modprobe -- ip_vs_sh
modprobe -- nf_conntrack_ipv4
EOF

chmod 755 /etc/sysconfig/modules/ipvs.modules && bash 
/etc/sysconfig/modules/ipvs.modules && lsmod | grep -e ip_vs -e nf_conntrack_ipv4

# 所有节点关闭swap
swapoff -a #临时关闭
vi /etc/fstab #永久关闭
注释掉以下字段
/dev/mapper/cl-swap swap swap defaults 0 0

清空yum缓存
yum clean all
设置yum安装源
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/
enabled=1
gpgcheck=0
repo_gpgcheck=0
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg
https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF

安装：（慢慢等）
# yum install -y kubelet kubeadm kubectl	根本不能用最新版的，完全对不上，浪费时间
sudo yum install -y kubelet-1.20.9 kubeadm-1.20.9 kubectl-1.20.9
systemctl enable kubelet
查看版本
kubelet --version

```



## 安装docker	 (2个node都要)

[bili p47](https://www.bilibili.com/video/BV1kJ411p7mV/?p=47&vd_source=ca1d80d51233e3cf364a2104dcf1b743)	72页pdf

```sh
1）卸载旧版本
yum list installed | grep docker 	#列出当前所有docker的包
yum -y remove docker			#的包名称 卸载docker包
rm -rf /var/lib/docker 		#删除docker的所有镜像和容器
2）安装必要的软件包
sudo yum install -y yum-utils \ device-mapper-persistent-data \ lvm2
3）设置下载的镜像仓库
sudo yum-config-manager --add-repo http://download.docker.com/linux/centos/docker-ce.repo
4）列出需要安装的版本列表
yum list docker-ce --showduplicates | sort -r
5）安装指定版本（这里使用18.0.1版本）
yum install docker-ce-20.10.17-3.el7 -y
6）查看版本
docker -v
7）启动Docker
sudo systemctl start docker 启动
sudo systemctl enable docker 设置开机启动
8）添加阿里云镜像下载地址
vi /etc/docker/daemon.json
内容如下：
{
  "registry-mirrors": ["https://of79xv0k.mirror.aliyuncs.com"]
}
9）重启Docker
sudo systemctl restart docker

```







## Master 节点初始化	(直接用k8s.md的安装，这里安装失败了)

[bili p79](https://www.bilibili.com/video/BV1kJ411p7mV?p=79&spm_id_from=pageDriver&vd_source=ca1d80d51233e3cf364a2104dcf1b743)	

```sh
kubeadm init初始化报错container runtime is not running
vim /etc/containerd/config.toml
注释掉disabled_plugins
#disabled_plugins = ["cri"]
sudo systemctl restart docker

rm -rf /etc/containerd/config.toml
sudo systemctl restart docker

Master节点需要完成
1）运行初始化命令
#主节点初始化
kubeadm init \
--apiserver-advertise-address=193.169.0.3 \
--control-plane-endpoint=cluster-endpoint \
--image-repository registry.cn-hangzhou.aliyuncs.com/lfy_k8s_images \
--kubernetes-version v1.20.9 \
--service-cidr=10.96.0.0/16 \
--pod-network-cidr=192.168.0.0/16


# init的时候报错 /etc/kubernetes/manifests/kube-apiserver.yaml already exists
kubeadm reset -y



```







## nfs 测试 (尚硅谷)

[bili 62](https://www.bilibili.com/video/BV13Q4y1C7hS?p=62)	[语雀笔记](https://www.yuque.com/leifengyang/oncloud/ctiwgo#Rk0Qj)	

```sh
1、所有节点
#所有机器安装
yum install -y nfs-utils

2、主节点
#nfs主节点
echo "/nfs/data/ *(insecure,rw,sync,no_root_squash)" > /etc/exports
mkdir -p /nfs/data
systemctl enable rpcbind --now
systemctl enable nfs-server --now
#配置生效
exportfs -r

3、从节点
showmount -e 193.169.0.3
#执行以下命令挂载 nfs 服务器上的共享目录到本机路径 /root/nfsmount
mkdir -p /nfs/data
mount -t nfs 193.169.0.3:/nfs/data /nfs/data	#两个node都要
# 写入一个测试文件
echo "hello nfs server" > /nfs/data/test.txt
 测试
cd /nfs/data/
echo 1111 > a
cat /nfs/data/a

4、原生方式数据挂载
mkdir /nfs/data/nginx-pv
kubectl apply -f deploy.yaml
kubectl delete -f deploy.yaml

https://www.bilibili.com/video/BV13Q4y1C7hS?p=64&vd_source=ca1d80d51233e3cf364a2104dcf1b743
```







## k8s装 jenkins

[bili p83](https://www.bilibili.com/video/BV1kJ411p7mV?p=83&vd_source=ca1d80d51233e3cf364a2104dcf1b743)	[bili nfs](https://www.bilibili.com/video/BV1kJ411p7mV?p=82&vd_source=ca1d80d51233e3cf364a2104dcf1b743)	

```sh
#先装nfs		
1）安装NFS服务（node1也需要安装）
yum install -y nfs-utils
2）创建共享目录
mkdir -p /nfs/data
# mkdir -p /opt/nfs/jenkins
vi /etc/exports 编写NFS的共享配置
内容如下:
/opt/nfs/jenkins *(rw,no_root_squash) 	*代表对所有IP都开放此目录，rw是读写
3）启动服务
systemctl enable nfs 
systemctl start nfs 
4）查看NFS共享目录
showmount -e 193.169.0.3

#装nfs
把 k8s-jenkins 拉到 /root/k8s-jenkins
kubectl apply -f /root/k8s-jenkins/nfs-client/.
kubectl describe pod nfs-client-provisioner
kubectl delete -f /root/k8s-jenkins/nfs-client/.
#处理污点 	
https://stackoverflow.com/questions/56162944/master-tainted-no-pods-can-be-deployed
kubectl taint nodes node1 key1=value1:NoSchedule	加上污点
kubectl taint nodes node1 key1=value1:NoSchedule-	解除污点
kubectl describe node/k8s-master | grep Taint	查看污点
kubectl describe node/node1 | grep Taint
kubectl taint node k8s-master node-role.kubernetes.io/master:NoSchedule-

https://blog.csdn.net/sqhren626232/article/details/93619602		解决
在spec template spec tolerations 加入
      tolerations:
        - key: "node-role.kubernetes.io/master"
          operator: "Equal"
          value: ""
          effect: "NoSchedule"

#装jenkins
1)黑马的安装 失败了，一直pending
kubectl create namespace kube-ops
kubectl apply -f /root/k8s-jenkins/jenkins-master/.
kubectl delete -f /root/k8s-jenkins/jenkins-master/.
kubectl describe -n kube-ops pod jenkins-0

spec template spec containers volumeMounts name		#pod里挂载的路径
				  volumes name hostPath path 	  #宿主机（centos）的路径
2）我自己找的 myjenkins.yaml	
kubectl create namespace devops
mkdir /root/jenkinsVolume
kubectl apply -f /root/myjenkins.yaml
kubectl delete -f /root/myjenkins.yaml
kubectl describe pod jenkins -n devops
kubectl logs jenkins-5ddf79879-lzxgh -n devops
kubectl get pod jenkins-5ddf79879-lzxgh -n devops
kubectl -n devops get pods


#pdf 20页 国内插件 
sed -i 's/http:\/\/updates.jenkinsci.org\/download/https:\/\/mirrors.tuna.tsinghua.edu.cn\/jenkins/g' default.json && sed -i 's/http:\/\/www.google.com/https:\/\/www.baidu.com/g' default.json


docker run lizhenliang/nfs-client-provisioner \
 NFS_SERVER=193.169.0.3
docker pull lizhenliang/nfs-client-provisioner



kubectl describe node/node1 | grep Taint
```

























