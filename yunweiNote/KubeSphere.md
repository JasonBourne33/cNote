[kubesphere all in one](https://kubesphere.com.cn/docs/v3.3/quick-start/all-in-one-on-linux/)	点上面文档中心，选最新版本的文档来看，避免旧版本启用踩坑

# dashboard

```sh
kubectl get svc -A |grep kubernetes-dashboard
https://193.169.0.3:30394/#/login
#复制token进去登录，我的是
eyJhbGciOiJSUzI1NiIsImtpZCI6IjQ5NEhVLXByNkRCaktJd3oxVlFLRnQ3YXJrb0l4cDNJTm9oUUxxZnUtYm8ifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJrdWJlcm5ldGVzLWRhc2hib2FyZCIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VjcmV0Lm5hbWUiOiJhZG1pbi11c2VyLXRva2VuLTZuajlzIiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQubmFtZSI6ImFkbWluLXVzZXIiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC51aWQiOiI2ZjJmNDQzNC1lZTNkLTQ1YzEtOGFmMC00Y2QyMzA4NzA3NWEiLCJzdWIiOiJzeXN0ZW06c2VydmljZWFjY291bnQ6a3ViZXJuZXRlcy1kYXNoYm9hcmQ6YWRtaW4tdXNlciJ9.jbqikUCRpFFUNBVE4pmC2LYkd5-kCJ8uTERUJJIKGU76osPn-Hgg8Yf81Wfuju8q0s90s7dsj3dmMijfYUWSkrv6Yt4G0BOKSIlSPB-JZRN08BDME2ANpYZk69HD678_rhxmb3d805M2kQYVaAZErKWNJETLtgR5KsSzruR1xmEyG04F1YHWzMg3YhwAt913qC-xDC8B4DnakZtMYRZUfleNmx5OD3vzmxYGbfzaSUpFQjokZdsXCcS2Jy4jFsso8pruKe-s-tnMYVxQPWAUV11KyQeHE9-n3dgKgsWJCBsv2Qkrnflk_yOMeTMK8kWqpvY0xkHWRe8JU_eFqRLm-g

```



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
systemctl disable firewalld
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

[文档](https://kubesphere.io/zh/docs/quick-start/all-in-one-on-linux/)	[bili](https://www.bilibili.com/video/BV13Q4y1C7hS?p=74&vd_source=ca1d80d51233e3cf364a2104dcf1b743)	[升级](https://kubesphere.io/zh/docs/v3.3/upgrade/upgrade-with-kubekey/)	

```sh
export KKZONE=cn
#一定要最新版，现在是3.3.0，b站是旧的不能用
curl -sfL https://get-kk.kubesphere.io | VERSION=v2.2.1 sh -
chmod +x kk
yum install -y conntrack

#单节点安装（默认最小化安装方式）
./kk create cluster --with-kubernetes v1.22.10 --with-kubesphere v3.3.0


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

#如果要删除
./kk delete cluster
./kk delete cluster -f singleNode-config-sample.yaml

#单节点配置好后想添加一个节点
./kk add nodes -f 2config-sample.yaml
```



## 多节点部署

[bili](https://www.bilibili.com/video/BV13Q4y1C7hS?p=75&vd_source=ca1d80d51233e3cf364a2104dcf1b743)	[文档](https://kubesphere.io/zh/docs/installing-on-linux/introduction/multioverview/)

```sh
export KKZONE=cn
curl -sfL https://get-kk.kubesphere.io | VERSION=v2.0.0 sh -
chmod +x kk
yum install -y conntrack

# 创建集群配置文件 config-sample.yaml
./kk create config --with-kubernetes v1.20.4 --with-kubesphere v3.1.1
# 配置节点，用户root 密码 "123456"
vim config-sample.yaml
./kk create cluster -f config-sample.yaml

#访问 http://193.169.0.3:30880/
Console: http://193.169.0.3:30880
Account: admin
Password: P@88w0rd
999Zzz...

# 重置密码
kubectl patch users admin -p '{"spec":{"password":"999Zzz..."}}' --type='merge' && kubectl annotate users admin iam.kubesphere.io/password-encrypted-

kubectl describe pod openebs-localpv-provisioner-6c9dcb5c54-6kj9m -n kube-system
kubectl describe pod ks-installer-769994b6ff-59gxw -n kubesphere-system

kubectl logs -n kubesphere-system -l job-name=minio && kubectl -n kubesphere-system delete job minio-make-bucket-job
```





#  3.3.0部署

[部署](https://kubesphere.io/zh/docs/v3.3/installing-on-kubernetes/introduction/overview/)	

```sh
#两个节点都要装的
yum install socat
yum install -y conntrack

export KKZONE=cn
#一定要最新版，现在是3.3.0，b站是旧的不能用
curl -sfL https://get-kk.kubesphere.io | VERSION=v2.2.1 sh -
chmod +x kk


# 创建集群配置文件 config-sample.yaml 再安装
./kk create config --with-kubernetes v1.22.10 --with-kubesphere v3.3.0
vim config-sample.yaml
把devops改为 true
./kk create cluster -f config-sample.yaml

#升级 
./kk upgrade --with-kubernetes v1.22.10 --with-kubesphere v3.3.0
./kk upgrade cluster -f config-sample.yaml

#如果要删除
./kk delete cluster
./kk delete cluster -f config-sample.yaml

#单节点配置好后想添加一个节点（修改config-sample，加上node）
./kk add nodes -f config-sample.yaml
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

[wordpress文档](https://v3-1.docs.kubesphere.io/zh/docs/quick-start/wordpress-deployment/)	[wordpress docker](https://hub.docker.com/_/wordpress)	[bili](https://www.bilibili.com/video/BV1np4y1C7Yf?p=356&vd_source=ca1d80d51233e3cf364a2104dcf1b743)	

```sh
gulimail项目里
配置中心- 创建密匙- 名称mysql-secret，下一步- 添加数据，key是 MYSQL_ROOT_PASSWORD，value是 123456
配置中心- 创建密匙- 名称wordpress-secret，下一步- 添加数据，key是 WORDPRESS_DB_PASSWORD，value是 123456
存储管理- 存储卷- 名称wordpress-pvc,下一步- 单个节点读写
存储管理- 存储卷- 名称mysql-pvc,下一步- 单个节点读写
应用负载- 应用- 部署示例应用- 应用名称wordpress-application,下一步，
	（1 mysql）添加服务- 添加有状态服务- 名称是mysql，下一步- 添加容器镜像，搜mysql:5.6,使用默认端口，往下拉，勾选 环境变量，应用配置文件或密匙，选mysql-secret和MYSQL_ROOT_PASSWORD，点√，下一步- 添加存储卷，选mysql-pvc，选读写，填入/var/lib/mysql，点√，下一步，添加
	（2 wordpress）添加服务- 无状态服务- 名称wordpress，下一步，添加容器镜像，搜wordpress:4.8-apache，使用默认端口，往下拉，勾选 环境变量，应用配置文件或密匙，选wordpress-secret和WORDPRESS_DB_PASSWORD，点添加环境变量，名称WORDPRESS_DB_HOST,值是mysql，点√，下一步- 添加存储卷，选wordpress-pvc，选读写，填入/var/www/html，点√，下一步，添加

#外网访问
gulimail 下application workloads的Services，wordpress的右边三点 Edit extranel access
gulimail 下application workloads的Services，点wordpress，看到NodePort是30084，那么访问地址就是 193.169.0.3:30084
```

# 流水线

​	[bili](https://www.bilibili.com/video/BV1np4y1C7Yf?p=359&vd_source=ca1d80d51233e3cf364a2104dcf1b743)	[sonarqube 3.3.0](https://kubesphere.io/zh/docs/v3.3/devops-user-guide/how-to-integrate/sonarqube/)	[GitHub devops-java-sample](https://github.com/kubesphere/devops-java-sample)	

```sh
vi devops-config.yaml
devops:
  enabled: true 
kubectl apply -f devops-config.yaml

kubectl get svc -n kubesphere-devops-system
#创建凭证
创建devops项目 gulimail，进入gulimail，
凭证，创建凭证，id是 dockerhub-id,账户凭证，2641，lSd33
创建凭证，id是 github-id,账户凭证，106，lSg33
创建凭证，id是 demo-kubeconfig,类型是 kubeconfig，不用改
创建凭证，id是 sonar-qube,类型是 访问令牌，密钥是生产的token

devops-java-sample项目里，Jenkinsfile-online文件下
    environment {
        DOCKER_CREDENTIAL_ID = 'dockerhub-id'
        GITHUB_CREDENTIAL_ID = 'github-id'
        KUBECONFIG_CREDENTIAL_ID = 'demo-kubeconfig'
        REGISTRY = 'docker.io'
        DOCKERHUB_NAMESPACE = 'whosyourdaddy233'
        GITHUB_ACCOUNT = 'JasonBourne33'
        APP_NAME = 'devops-java-sample'
        SONAR_CREDENTIAL_ID = 'sonar-qube'
    }

```



# sonarqube

[sonarqube 3.3.0](https://kubesphere.io/zh/docs/v3.3/devops-user-guide/how-to-integrate/sonarqube/)	

```sh
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
#查看 Helm 版本
helm version

helm upgrade --install sonarqube sonarqube --repo https://charts.kubesphere.io/main -n kubesphere-devops-system  --create-namespace --set service.type=NodePort

export NODE_PORT=$(kubectl get --namespace kubesphere-devops-system -o jsonpath="{.spec.ports[0].nodePort}" services sonarqube-sonarqube)
export NODE_IP=$(kubectl get nodes --namespace kubesphere-devops-system -o jsonpath="{.items[0].status.addresses[0].address}")
echo http://$NODE_IP:$NODE_PORT
# 访问http://193.169.0.3:32764
admin
admin
999Zzz...
右上角A， security， 输入kubersphere，generate，复制tokens
3a17aab65f5f13d54a99c3b8d28186e266d04c78

kubectl get pod -n kubesphere-devops-system
kubectl get svc --all-namespaces  	#能看到sonarqube的端口


```



# 可插拔组件	 

[官方doc 3.3.0](https://kubesphere.com.cn/docs/v3.3/quick-start/enable-pluggable-components/)	

1. 以 `admin` 身份登录控制台。点击左上角的**平台管理** ，然后选择**集群管理**。

2. 点击**定制资源定义**，然后在搜索栏中输入 `clusterconfiguration`，点击搜索结果进入其详情页面。

3. 在**自定义资源**中，点击 `ks-installer` 右侧的三个点，然后选择**编辑 YAML**。

4. 在该配置文件中，将对应组件 `enabled` 的 `false` 更改为 `true`，以启用要安装的组件。完成后，点击**确定**以保存配置。

5. 应用商店 openpitrix:  store:    enabled: true # 将“false”更改为“true”。

   devops true



# sentinel

​	[mongo](https://www.bilibili.com/video/BV13Q4y1C7hS?p=109&vd_source=ca1d80d51233e3cf364a2104dcf1b743)	

```sh
从企业空间点击项目里，应用负载，服务，创建，有状态服务，名称是his-sentinel,下一步，搜leifengyang/sentinel:1.8.2，拉下去选 同步主机时区，下一步，下一步，创建
服务，创建，指定工作负载创建服务，名称是his-sentinel-node,下一步，指定工作负载，有状态副本集，选his-sentinal-v1 ,名称是 http-8080，容器端口和服务端口都是 8080，下一步，选外部访问，NodePort，创建
看到外网访问的端口是 31929
访问  193.169.0.3:31929
账号，密码都是 sentinal

#mangoDB
应用负载，应用，基于模板的应用，部署新应用，从应用模板，选择应用仓库，bitnami（我没有）
```



# Bug

[2 亲自提问](https://kubesphere.com.cn/forum/d/7352-please-wait-for-the-installation-to-complete/12)	[发帖问](https://kubesphere.com.cn/forum/d/7490-kk-create-cluster-f-config-sampleyaml)	[3 github](https://github.com/calebhailey/homelab/issues/3)

```sh
#5 在单点部署后 ks-jenkins 没有就绪，一直在重启
尝试弄个node节点再试试，怎么再kubesphere控制台直接加入节点？

#4 创建wordpress-application后 running PreBind plugin "VolumeBinding": binding volumes: timed out waiting for the condition
要把node1和node2也全启动，如果觉得卡
kubectl delete node node1
kubectl delete node node2
kubectl get nodes

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

``
