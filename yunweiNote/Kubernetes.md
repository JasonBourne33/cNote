

Docker	容器

Kubernetes	管理容器
https://www.bilibili.com/video/BV13Q4y1C7hS?p=33&spm_id_from=pageDriver
https://www.yuque.com/leifengyang/oncloud/ghnb83

KubeSphere	K8s的钥匙
https://www.bilibili.com/video/BV13Q4y1C7hS?p=69&spm_id_from=pageDriver

DevOps	自动化部署 Developers Operations|
https://www.bilibili.com/video/BV13Q4y1C7hS?p=106

青云创建三天按需服务器	（可以用vmware 虚拟机）
cat  /etc/redhat-release		 查看centos版本
2核CPU，2G内存



kubesphere.com.cn		官网

给三台虚拟机装

用xshell的批量输入（编辑，文本编辑器，全部）

基础环境（工具和镜像）

```sh
yum install -y yum-utils
yum-config-manager \
--add-repo \
http://download.docker.com/linux/centos/docker-ce.repo
```

安装Docker
sudo yum install -y docker-ce-20.10.7 docker-ce-cli-20.10.7 containerd.io-1.4.6

启动
systemctl enable docker --now

配置镜像加速

```sh
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

配置每个主机名不一样
hostnamectl set-hostname k8s-master
hostnamectl set-hostname slave1
hostnamectl set-hostname slave2
hostname		查看

禁用掉linux的一些安全设置
sudo setenforce 0
sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

关闭swap分区
swapoff -a
sed -ri 's/.*swap.*/#&/' /etc/fstab

把ipv6的桥接到ipv4，方便统计
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sudo sysctl --system

安装三大件


```sh
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=http://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=0
repo_gpgcheck=0
gpgkey=http://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg
   http://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
exclude=kubelet kubeadm kubectl
EOF

sudo yum install -y kubelet-1.20.9 kubeadm-1.20.9 kubectl-1.20.9 --disableexcludes=kubernetes
sudo systemctl enable --now kubelet
```

下载各个机器需要的镜像

```sh
sudo tee ./images.sh <<-'EOF'
#!/bin/bash
images=(
kube-apiserver:v1.20.9
kube-proxy:v1.20.9
kube-controller-manager:v1.20.9
kube-scheduler:v1.20.9
coredns:1.7.0
etcd:3.4.13-0
pause:3.2
)
for imageName in ${images[@]} ; do
docker pull registry.cn-hangzhou.aliyuncs.com/lfy_k8s_images/$imageName
done
EOF
   
chmod +x ./images.sh && ./images.sh
```

初始化主节点

```sh
#所有机器添加master域名映射，以下需要修改为自己的
echo "192.169.0.3  cluster-endpoint" >> /etc/hosts
#验证
ping cluster-endpoint

#主节点初始化
kubeadm init \
--apiserver-advertise-address=192.169.0.3 \
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

  kubeadm join cluster-endpoint:6443 --token 4bdd8g.ff8akpvxzzvjnu1f \
    --discovery-token-ca-cert-hash sha256:df8535e23d6d34024fef77d2f1753f1a644a6d1ac8487531d9bbbe38c9ba2ca0 \
    --control-plane 

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join cluster-endpoint:6443 --token 4bdd8g.ff8akpvxzzvjnu1f \
    --discovery-token-ca-cert-hash sha256:df8535e23d6d34024fef77d2f1753f1a644a6d1ac8487531d9bbbe38c9ba2ca0
    
    #按照上面的提示，在master服务器
    export KUBECONFIG=/etc/kubernetes/admin.conf
   #sha256 每一次init都是不一样的，如果是slave节点就用woker的代码，要加入董事会的节点就用cotrol-plane的代码

```

kubectl get nodes		查看节点
kubeadm reset		重置 的时候报错

```sh
The reset process does not clean CNI configuration. To do so, you must remove /etc/cni/net.d

The reset process does not reset or clean up iptables rules or IPVS tables.
If you wish to reset iptables, you must do so manually by using the "iptables" command.

If your cluster was setup to utilize IPVS, run ipvsadm --clear (or similar)
to reset your system's IPVS tables.

#删除net.d
rm -rf /etc/cni/net.d
#重置iptables
iptables -F && iptables -t nat -F && iptables -t mangle -F && iptables -X
sysctl net.bridge.bridge-nf-call-iptables=1
#清除对应的残余网卡信息
sudo ip link del cni0
sudo ip link del flannel.1
#删除 $HOME/.kube/config
rm -rf $HOME/.kube/config
```

安装网络组件 (master节点 )

```sh
curl https://docs.projectcalico.org/manifests/calico.yaml -O
kubectl apply -f calico.yaml		根据配置文件，给集群创建资源
kubectl get pods -A		查看部署了哪些应用 ( 相当于docker ps)
kubectl delete -f calico.yaml		如果要删除

# calico-kube-controllers 没有 CrashLoopBackOff
```



如果令牌过期了：
kubeadm token create --print-join-command

当挂起再开虚拟机后报错
The connection to the server localhost:8080 was refused - did you specify the right host or port?

```sh
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```





Dashboard

```sh
#部署
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.3.1/aio/deploy/recommended.yaml
wget https://raw.githubusercontent.com/kubernetes/dashboard/v2.3.1/aio/deploy/recommended.yaml
vi dashboard.yaml 
#把recommended.yaml的内容复制到 dashboard.yaml
kubectl apply -f dashboard.yaml
#如果要删除
kubectl delete -f dashboard.yaml

#设置访问端口
kubectl edit svc kubernetes-dashboard -n kubernetes-dashboard
/type搜索，把值改了 type:NodePort

#开放端口30753（云服务器在控制台也要操作）
firewall-cmd --zone=public --add-port=30753/tcp --permanent	
systemctl restart firewalld.service
firewall-cmd --reload 
```

































