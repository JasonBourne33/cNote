

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
./kk create cluster --with-kubernetes v1.21.5 --with-kubesphere v3.2.1
```

## 多节点部署

[bili](https://www.bilibili.com/video/BV13Q4y1C7hS?p=75&vd_source=ca1d80d51233e3cf364a2104dcf1b743)	

```sh

```

