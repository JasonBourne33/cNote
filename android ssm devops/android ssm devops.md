# 单节点

​	[源](https://blog.csdn.net/qq_39559641/article/details/104484560)

```sh
安装 镜像系统 CentOS-7-x86_64-Minimal-2009.iso
root	123456
1） 先 ifup ens33
再用 ip a 看ip地址
2） 用Xshell 连接VMware中的centos 7 （启动网卡，静态ip配置）
用root用户登录到centos
进入目录 cd /etc/sysconfig/network-scripts/   ，打开Xftp6
找到 ifcfg-ens33  右键，N 编辑，把 onboot=no改成yes，
把bootproto=dhcp 改成bootproto=static
最后加上
IPADDR=193.169.0.3
#IPADDR=193.169.0.4
#IPADDR=193.169.0.5
NETMASK=255.255.255.0
GATEWAY=193.169.0.2
DNS1=8.8.8.8
DNS2=8.8.4.4
保存退出
输入 sudo service network restart 重启网络
输入 ip addr 查看ip地址 193.169 开头的
在vm里 编辑- 虚拟网络编辑器- 选中当前的子网地址- 子网ip改成192.169.0.0- 确定
用xftp连入 192.169.0.3 的地址端口 22
root
123456

第二台 CentOS 7 1 	192.169.0.4
第三台 CentOS 7 2 	192.169.0.5
如果还是连不上网络，用 ipaddr 没看到ens33有ip地址
ifup ens33

hostnamectl set-hostname master
```





# 安装前准备（必做）

```sh
hostnamectl set-hostname master
#查看
hostname 
yum install -y bash-completion.noarch
yum install -y net-tools vim lrzsz wget tree screen lsof tcpdump
yum install -y yum-utils

# 还没装  socat  ipvsadm | docker  | containerd | nfs client | ceph client | glusterfs client 
yum install socat -y
yum install -y nfs-utils


#安装epel-release及yum相关组件
yum -y install epel-release yum-plugin-priorities yum-utils
#安装Ceph及相关组件
yum install -y ceph-deploy ceph ceph-radosgw snappy leveldb gdisk python-argparse gperftools-libs
#查看ceph版本
ceph -v

```

## docker

 ```sh
 #配置docker的yum地址
 sudo yum-config-manager \
 --add-repo \
 http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
 #安装指定版本
 sudo yum install -y docker-ce-20.10.7 docker-ce-cli-20.10.7 containerd.io-1.4.6
 #	启动&开机启动docker
 systemctl enable docker --now
 
 # docker加速配置
 sudo mkdir -p /etc/docker
 sudo tee /etc/docker/daemon.json <<-'EOF'
 {
   "registry-mirrors": ["https://82m9ar63.mirror.aliyuncs.com"],
   "exec-opts": ["native.cgroupdriver=systemd"],
   "log-driver": "json-file",
   "log-opts": {
     "max-size": "100m"
   },
   "storage-driver": "overlay2"
 }
 EOF
 sudo systemctl daemon-reload
 sudo systemctl restart docker
 ```





# 单点部署(增加，删除节点)

[kubesphere文档](https://kubesphere.io/zh/docs/quick-start/all-in-one-on-linux/)	[bili](https://www.bilibili.com/video/BV13Q4y1C7hS?p=74&vd_source=ca1d80d51233e3cf364a2104dcf1b743)	[升级](https://kubesphere.io/zh/docs/v3.3/upgrade/upgrade-with-kubekey/)	

```sh

export KKZONE=cn
#安装之前先关掉clash 

curl -sfL https://get-kk.kubesphere.io | VERSION=v3.0.2 sh -
chmod +x kk
yum install -y conntrack

#单节点安装（默认最小化安装方式）
./kk create cluster --with-kubernetes v1.22.12 --with-kubesphere v3.3.1


# 创建集群配置文件 config-sample.yaml 再安装
./kk create config --with-kubernetes v1.22.10 --with-kubesphere v3.3.0
./kk create config --from-cluster
rn config-sample.yaml singleNode-config-sample.yaml
vim singleNode-config.yaml
把devops改为 true
#自定义的安装yaml，devops为 true
./kk create cluster -f singleNode-config-sample.yaml

#升级
./kk upgrade --with-kubernetes v1.22.10 --with-kubesphere v3.3.0
./kk upgrade cluster -f config-sample.yaml

#如果要删除
./kk delete cluster
./kk delete cluster -f config-sample.yaml

#单节点配置好后想添加一个节点
./kk add nodes -f config-sample.yaml
./kk delete node node1 -f config-sample.yaml
```

































NFS

[知乎源](https://zhuanlan.zhihu.com/p/502731000)

```sh
整理后的

开始前先准备 nfs
kubectl taint nodes --all node-role.kubernetes.io/master-
yum install nfs-utils -y
service nfs start
echo "/nfs/data/01 *(insecure,rw,sync,no_root_squash)" > /etc/exports
cat /etc/exports

1.创建namespace，把mysql部署在单独的名称空间中
kubectl create namespace dev

2.创建持久卷PV，用来存储mysql数据文件
（1）定义一个容量大小为1GB的PV，挂载到/nfs/data/01目录，需手动创建该目录
mkdir -p /nfs/data/01
（2）编写mysql-pv.yaml文件内容，要创建的pv对象名称：pv-1gi
（3）创建该PV对象
kubectl create -f mysql-pv.yaml
（4）查看创建结果
kubectl describe pv pv-1gi


3.创建持久卷声明PVC
（1）编写mysql-pvc.yaml文件内容，要创建的pvc对象名称是：mysql-pvc
（2）创建该PVC对象
kubectl create -f mysql-pvc.yaml
（3）查看创建结果
kubectl get pvc -n dev


4.创建Secret对象用来保存mysql的root用户密码
（1）设置密码为123456，执行创建命令
kubectl create secret generic mysql-root-password --from-literal=password=123456 -n dev
(2）查看创建结果
kubectl get secret mysql-root-password -o yaml -n dev

5.创建Deployment和Service
（1）编辑mysql-svc.yaml文件内容
service使用NodePort类型，指定暴露的nodePort端口为31234，我们会在宿主机使用navicat客户端对mysql进行访问
（2）执行创建命令
kubectl create -f mysql-svc.yaml
kubectl delete -f mysql-svc.yaml
（3）查看创建结果
kubectl get pod,svc -n dev
```



```sh
踩坑过程：
（3）查看创建结果
kubectl get pod,svc -n dev
一直在pending
kubectl describe pod,svc -n dev
发现 0/1 nodes are available: 1 node(s) had taint {node-role.kubernetes.io/master: }, that the pod didn‘t
 
继续 kubectl describe pod,svc -n dev
发现 wrong fs type, bad option, bad superblock on 193.169.0.3:/nfs/data/01,
yum install nfs-utils -y
重新 卸载后按照
kubectl delete -f mysql-svc.yaml
kubectl create -f mysql-svc.yaml
发现 mount.nfs: Connection refused
service nfs start
发现 Output: mount.nfs: access denied by server while mounting 193.169.0.3:/nfs/data/01
echo "/nfs/data/01 *(insecure,rw,sync,no_root_squash)" > /etc/exports
```

