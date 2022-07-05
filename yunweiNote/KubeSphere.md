



# 基础环境，工具和镜像（三节点）

```sh
#配置每个主机名不一样
hostnamectl set-hostname k8s-master
hostnamectl set-hostname node1
hostnamectl set-hostname node2
hostname		查看

yum install -y yum-utils
yum-config-manager \
--add-repo \
http://download.docker.com/linux/centos/docker-ce.repo
#yuchao
systemctl stop firewalld
sustemctl disable firewalld
systemctl stop NetworkManager.service
systemctl disable NetworkManager.service
systemctl stop postfix.service
systemctl disable postfix.service
wget -0 /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
yum install -y bash-completion.noarch
yum install -y net-tools vim lrzsz wget tree screen lsof tcpdump
```



# 安装 docker 

[bili](https://www.bilibili.com/video/BV13Q4y1C7hS?p=69&spm_id_from=pageDriver&vd_source=ca1d80d51233e3cf364a2104dcf1b743) 	[官网](https://kubesphere.com.cn/)	[语雀笔记](https://www.yuque.com/leifengyang/oncloud/gz1sls)

```sh
# 建议 master 4核心8G，两个node 8核心16g
# 三node都装Docker
sudo yum remove docker*
sudo yum install -y yum-utils

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

# 安装 kubernates

```sh
#设置每个机器自己的hostname
#分别设置主机名
hostnamectl set-hostname k8s-master
hostnamectl set-hostname node1
hostnamectl set-hostname node2

# 将 SELinux 设置为 permissive 模式（相当于将其禁用）
sudo setenforce 0
sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

#关闭swap
swapoff -a  
sed -ri 's/.*swap.*/#&/' /etc/fstab

#允许 iptables 检查桥接流量
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sudo sysctl --system



#配置k8s的yum源地址
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=http://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=0
repo_gpgcheck=0
gpgkey=http://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg
   http://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF


#安装 kubelet，kubeadm，kubectl
sudo yum install -y kubelet-1.20.9 kubeadm-1.20.9 kubectl-1.20.9

#启动kubelet
sudo systemctl enable --now kubelet

#所有机器配置master域名
echo "193.169.0.3  k8s-master" >> /etc/hosts

```

# 初始化

```sh
#主节点初始化
kubeadm init \
--apiserver-advertise-address=193.169.0.3 \
--control-plane-endpoint=cluster-endpoint \
--image-repository registry.cn-hangzhou.aliyuncs.com/lfy_k8s_images \
--kubernetes-version v1.20.9 \
--service-cidr=10.96.0.0/16 \
--pod-network-cidr=192.168.0.0/16

#所有网络范围不重叠
#成功后的输出
Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

Alternatively, if you are the root user, you can run:

  export KUBECONFIG=/etc/kubernetes/admin.conf

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

You can now join any number of control-plane nodes by copying certificate authorities
and service account keys on each node and then running the following as root:

  kubeadm join cluster-endpoint:6443 --token p0sd52.k3e2x9mi4cb3ibij \
    --discovery-token-ca-cert-hash sha256:8a7c5274d66b5e5e7415ab85c24ef7c6441cb0428cb23ceb4e2a004514363906 \
    --control-plane 

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join cluster-endpoint:6443 --token p0sd52.k3e2x9mi4cb3ibij \
    --discovery-token-ca-cert-hash sha256:8a7c5274d66b5e5e7415ab85c24ef7c6441cb0428cb23ceb4e2a004514363906


    
#按照上面的提示，在master服务器
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
export KUBECONFIG=/etc/kubernetes/admin.conf
   #sha256 每一次init都是不一样的，如果是slave节点就用woker的代码，要加入董事会的节点就用cotrol-plane的代码
#如果令牌过期了：
kubeadm token create --print-join-command
#查看节点 (要有子节点连上，master才会ready)
kubectl get nodes
```

# kubeSphere

```sh
# 装nfs，在每个机器。
yum install -y nfs-utils
# 在master 执行以下命令 
echo "/nfs/data/ *(insecure,rw,sync,no_root_squash)" > /etc/exports
# 执行以下命令，启动 nfs 服务;创建共享目录
mkdir -p /nfs/data
# 在master执行
systemctl enable rpcbind
systemctl enable nfs-server
systemctl start rpcbind
systemctl start nfs-server
# 使配置生效
exportfs -r
#检查配置是否生效
exportfs


## 创建了一个存储类 （配置默认存储）
vi sc.yaml
kubectl apply -f sc.yaml
kubectl get sc

vi pvc.yaml
kubectl apply -f pvc.yaml
kubectl get pvc

# 集群指标监控组件
vi metrics.yaml
kubectl apply -f metrics.yaml
kubectl get pod -A
kubectl top node
kubectl top pods -A



# 安装kubesphere 核心文件
wget https://github.com/kubesphere/ks-installer/releases/download/v3.1.1/kubesphere-installer.yaml
wget https://github.com/kubesphere/ks-installer/releases/download/v3.1.1/cluster-configuration.yaml
vim cluster-configuration.yaml
#要改
    monitoring: true
    endpointIps: 193.169.0.3
    common:
    	redis:
    		enabled: true
    	openldap:
   		 	enabled: true
   	alerting: 
   		enabled: true
   	auditing:
    	enabled: true
    devops:                
    	enabled: true 
    metrics_server:
    	enabled: true 
    networkpolicy:
    	enabled: true
    openpitrix:
    	store:
    		enabled: true
    servicemesh:
    	enabled: true
    	
    	
kubectl apply -f kubesphere-installer.yaml
kubectl apply -f cluster-configuration.yaml
kubectl get pod -A
#查看安装进度
kubectl logs -n kubesphere-system $(kubectl get pod -n kubesphere-system -l app=ks-install -o jsonpath='{.items[0].metadata.name}') -f
# http://193.169.0.5:30880/login	还访问不了，没跑通
```



## 单点部署

[文档](https://kubesphere.io/zh/docs/quick-start/all-in-one-on-linux/)	[bili](https://www.bilibili.com/video/BV13Q4y1C7hS?p=74&vd_source=ca1d80d51233e3cf364a2104dcf1b743)

```sh
export KKZONE=cn
curl -sfL https://get-kk.kubesphere.io | VERSION=v2.0.0 sh -
chmod +x kk
yum install -y conntrack
#单节点安装
./kk create cluster --with-kubernetes v1.21.5 --with-kubesphere v3.2.1
```



## 多节点部署

[bili](https://www.bilibili.com/video/BV13Q4y1C7hS?p=75&vd_source=ca1d80d51233e3cf364a2104dcf1b743)	[文档](https://kubesphere.io/zh/docs/installing-on-linux/introduction/multioverview/)

```sh
export KKZONE=cn
curl -sfL https://get-kk.kubesphere.io | VERSION=v2.0.0 sh -
chmod +x kk
yum install -y conntrack

# 配置节点，用户root 密码 "123456"
vim config-sample.yaml
./kk create cluster -f config-sample.yaml

#访问 http://193.169.0.3:30880/
Console: http://193.169.0.3:30880
Account: admin
Password: P@88w0rd
999Zzz...

kubectl describe pod openebs-localpv-provisioner-6c9dcb5c54-6kj9m -n kube-system
kubectl describe pod ks-installer-769994b6ff-59gxw -n kubesphere-system

kubectl logs -n kubesphere-system -l job-name=minio && kubectl -n kubesphere-system delete job minio-make-bucket-job
```



# kubesphere	多租户

[bili 355](https://www.bilibili.com/video/BV1np4y1C7Yf?p=355&vd_source=ca1d80d51233e3cf364a2104dcf1b743)	

```sh
hr user-manager 可创建用户
ws-manager     workspace-manager 可创建工作空间，把gulimail的管理员分配给ws-admin
ws-admin 	    platform-regular 项目的leader，可邀请用户
project-admin   platform-regular 常规用户
project-regular platform-regular 普通用户

1 在gulimail， ws-manager指派 ws-admin 为管理员（workspace-admin）
 指定 project-admin 为   workspace-regular (能增删查改项目)
 指定 project-regular 为 workspace-viewer （只能看，比如销售）
2 进项目gulimail项目，邀请project-regular作为项目的operater维护者
3 在gulimail 工作空间里创建 gulimail-devops项目 （没有找到DevOps）
 多谢您的确认，您的货物将很快发出
```

# wordpress 界面操作

[wordpress文档](https://v3-1.docs.kubesphere.io/zh/docs/quick-start/wordpress-deployment/)	[wordpress docker](https://hub.docker.com/_/wordpress)	

```sh
gulimail项目里
配置中心- 创建密匙- 名称mysql-secret，下一步- 添加数据，key是 MYSQL_ROOT_PASSWORD，value是 123456
配置中心- 创建密匙- 名称wordpress-secret，下一步- 添加数据，key是 WORDPRESS_DB_PASSWORD，value是 123456
存储管理- 存储卷- 名称wordpress-pvc,下一步- 单个节点读写
存储管理- 存储卷- 名称mysql-pvc,下一步- 单个节点读写
应用负载- 应用- 部署示例应用- 应用名称wordpress-application,下一步，
	（1 mysql）添加服务- 添加有状态服务- 名称是mysql，下一步- 添加容器镜像，搜mysql:5.6,使用默认端口，往下拉，勾选环境变量，点应用配置文件或密匙，选mysql-secret和MYSQL_ROOT_PASSWORD，点√，下一步- 添加存储卷，选mysql-pvc，选读写，填入/var/lib/mysql，点√，下一步，添加
	（2 wordpress）添加服务- 无状态服务- 名称wordpress，下一步，添加容器镜像，搜wordpress:4.8-apache，使用默认端口，往下拉，勾选 环境变量，应用配置文件或密匙，选wordpress-secret和WORDPRESS_DB_PASSWORD，点添加环境变量，名称WORDPRESS_DB_HOST,值是mysql，点√，下一步- 添加存储卷，选wordpress-pvc，选读写，填入/var/www/html，点√，下一步，添加

wordpress-pvc  /var/www/html
```



# Bug

[2 亲自提问](https://kubesphere.com.cn/forum/d/7352-please-wait-for-the-installation-to-complete/12)	[发帖问](https://kubesphere.com.cn/forum/d/7490-kk-create-cluster-f-config-sampleyaml)	[3 github](https://github.com/calebhailey/homelab/issues/3)

```sh
#4 创建wordpress-application后 running PreBind plugin "VolumeBinding": binding volumes: timed out waiting for the condition

#3 创建wordpress-application后 0/3 nodes are available: 1 node(s) had taints that the pod didn't tolerate.
kubectl taint nodes --all node-role.kubernetes.io/master-


#2 ./kk create cluster -f config-sample.yaml的时候卡在
#Please wait for the installation to complete:
kubectl describe pod openebs-localpv-provisioner-6c9dcb5c54-6kj9m -n kube-system
kubectl describe pod ks-installer-769994b6ff-59gxw -n kubesphere-system
kubectl logs -f ks-installer-769994b6ff-k5lf4 -n kubesphere-system

# HOW TO REMOVE EVICTED PODS IN KUBERNETES
kubectl get pod -n kube-system | grep Evicted | awk '{print $1}' | xargs kubectl delete pod -n kube-system
kubectl get pod -n kubesphere-system | grep Evicted | awk '{print $1}' | xargs kubectl delete pod -n kubesphere-system
kubectl get pod -n kubesphere-monitoring-system  | grep Evicted | awk '{print $1}' | xargs kubectl delete pod -n kubesphere-monitoring-system 

解决：每一台node 必须要有4G的内存才能装


#1 多节点部署./kk create cluster -f config-sample.yaml的时候
#The connection to the server lb.kubesphere.local:6443 was refused - did you specify the #right host or port?
重新执行 ./kk create cluster -f config-sample.yaml 又没了

```

