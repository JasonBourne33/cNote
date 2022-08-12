[ kubesphere all in one](https://kubesphere.com.cn/docs/v3.3/quick-start/all-in-one-on-linux/)	点上面文档中心，选最新版本的文档来看，避免旧版本启用踩坑

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

yum install -y bash-completion.noarch
yum install -y net-tools vim lrzsz wget tree screen lsof tcpdump
wget /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
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

# kubeSphere （配置文件）

[bili p73](https://www.bilibili.com/video/BV13Q4y1C7hS?p=73&vd_source=ca1d80d51233e3cf364a2104dcf1b743)	

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
    	enabled: false  
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



## 单点部署(增加，删除节点)

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
./kk upgrade cluster -f config-sample.yaml

#如果要删除
./kk delete cluster
./kk delete cluster -f config-sample.yaml

#单节点配置好后想添加一个节点
./kk add nodes -f config-sample.yaml
./kk delete node node1 -f config-sample.yaml
```



## 多节点部署

[bili](https://www.bilibili.com/video/BV13Q4y1C7hS?p=75&vd_source=ca1d80d51233e3cf364a2104dcf1b743)	[文档](https://kubesphere.io/zh/docs/installing-on-linux/introduction/multioverview/)

```sh
export KKZONE=cn
curl -sfL https://get-kk.kubesphere.io | VERSION=v2.0.0 sh -
chmod +x kk
yum install -y conntrack

# 创建集群配置文件 config-sample.yaml
./kk create config --with-kubernetes v1.22.10 --with-kubesphere v3.3.0
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
#两个节点都要装的 (必须要有个node1，不然卡死在calico那里)
# master 4核8G， node1 4核心4G
yum install socat -y
yum install -y conntrack

export KKZONE=cn
#一定要最新版，现在是3.3.0，b站是旧的不能用
curl -sfL https://get-kk.kubesphere.io | VERSION=v2.2.1 sh -
chmod +x kk


# 创建集群配置文件 config-sample.yaml 再安装
./kk create config --with-kubernetes v1.22.10 --with-kubesphere v3.3.0
vim config-sample.yaml
把devops改为 true,内存设置为3G
./kk create cluster -f config-sample.yaml

#升级 
./kk upgrade --with-kubernetes v1.22.10 --with-kubesphere v3.3.0
./kk upgrade cluster -f config-sample.yaml

#如果要删除
./kk delete cluster
./kk delete cluster -f config-sample.yaml

#单节点配置好后想添加一个节点（修改config-sample，加上node1）
./kk add nodes -f config-sample.yaml
#删除节点node1
./kk delete node node1 -f config-sample.yaml
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



# Mysql (docker, K8s)

[his bili](https://www.bilibili.com/video/BV13Q4y1C7hS?p=80&vd_source=ca1d80d51233e3cf364a2104dcf1b743)	[yuque doc](https://www.yuque.com/leifengyang/oncloud/vgf9wk)	

```sh
#docker容器里 日志目录的/var/log/mysql 挂载到linux主机的的/mydata/mysql/log
#容器里的 数据目录/var/lib/mysql 挂载到linux主机的的/mydata/mysql/data
#容器里的 配置文件目录/etc/mysql/conf.d 挂载到linux主机的的/mydata/mysql/conf
docker run -p 3306:3306 --name mysql-01 \
-v /mydata/mysql/log:/var/log/mysql \
-v /mydata/mysql/data:/var/lib/mysql \
-v /mydata/mysql/conf:/etc/mysql/conf.d \
-e MYSQL_ROOT_PASSWORD=root \
--restart=always \
-d mysql:5.7 


#kubesphere
Configuration , Configmaps, create, name is mysql-conf, next, key is my.cnf(content is following)
[client]
default-character-set=utf8mb4
[mysql]
default-character-set=utf8mb4
[mysqld]
init_connect='SET collation_connection = utf8mb4_unicode_ci'
init_connect='SET NAMES utf8mb4'
character-set-server=utf8mb4
collation-server=utf8mb4_unicode_ci
skip-character-set-client-handshake
skip-name-resolve

Storage, Persistent Volume Claims, create, next, name is mysql-pvc,next, create

#pod里的 配置文件目录/etc/mysql/conf.d
Application Workloads, Workloads, Statefulsets, name is his-mysql, next, Add Contener, search mysql:5.7.35 , (1cpu,2000m memory),Use Default Ports,, enable Environment Variables, key is MYSQL_ROOT_PASSWORD , value is 123456, enable Synchronize Host Timezone, check,next, 
Add Persistent Volume Claim Template , Read and write, Mount path is /var/lib/mysql, check, 
Mount Configmap or Secret, select mysql-conf, select Read-only, /etc/mysql/conf.d ,Select Specific Keys , next, create

#暴露给外网访问的service
Services , create, Specify Workload, name is his-mysql, next, select Virtual IP Address, Specify Workload, Statefulsets, his-mysql, OK, Name is http-3306, Container is 3306, Service Port is 3306, next,
External Access, NodePort, 
#用sqlyog连接193.169.0.3:31208
mysql -uroot -hhis-mysql-node.his -p


```



# Redis （dockers，k8s, kubesphere）

[guli redis bili](https://www.bilibili.com/video/BV1np4y1C7Yf?p=373&vd_source=ca1d80d51233e3cf364a2104dcf1b743)	[redis docker](https://www.bilibili.com/video/BV13Q4y1C7hS?p=20&vd_source=ca1d80d51233e3cf364a2104dcf1b743)	[redis k8s ](https://www.bilibili.com/video/BV13Q4y1C7hS?p=65&vd_source=ca1d80d51233e3cf364a2104dcf1b743)	 [redis kubersphere](https://www.bilibili.com/video/BV13Q4y1C7hS?p=82&vd_source=ca1d80d51233e3cf364a2104dcf1b743)	[yuque doc](https://www.yuque.com/leifengyang/oncloud/vgf9wk)	

```sh
#Redis docker  (appendonly yes 是持久化存储
#主机的配置 /data/redis/redis.conf     pod的配置 /etc/redis/redis.conf
#主机的数据 /data/redis/data			 pod的数据 /data
#redis-server 用的是pod的配置 /etc/redis/redis.conf
docker run -v /data/redis/redis.conf:/etc/redis/redis.conf \
--appendonly yes \
-v /data/redis/data:/data \
-d --name myredis \
-p 6379:6379 \
redis:latest redis-server /etc/redis/redis.conf

#Redis k8s
#主机的配置 /root/redis333.conf    pod的配置 /redis-master/redis.conf	配置集 redis-conf222
#主机的数据 emptyDir: {}	(k8s临时分配的目录，让其工作)	 pod的数据 /data
#redis-server 用的是pod的配置 /redis-master/redis.conf
vi /root/redis333.conf
appendonly yes
:wq
kubectl create cm redis-conf222 --from-file=redis333.conf  #变成配置集
kubectl get cm  #查看，有redis-conf
kubectl get cm redis-conf222 -oyaml  #查看具体内容，配置集精简后得到以下
apiVersion: v1
data:
  redis333.conf: |+
    appendonly yes
kind: ConfigMap
metadata:
  name: redis-conf222
  namespace: default
#创建pod的yaml
vi redis.yaml
apiVersion: v1
kind: Pod
metadata:
  name: redis
spec:
  containers:
    - name: redis
      image: redis
      command:
        - redis-server
        - "/redis-master/redis.conf"  #指的是redis容器内部的位置
      ports:
        - containerPort: 6379
      volumeMounts:                   #持久卷
        - mountPath: /data
          name: data
        - mountPath: /redis-master
          name: config111
  volumes:
    - name: data
      emptyDir: {}
    - name: config111
      configMap:
        name: redis-conf222
        items:
          - key: redis.conf333
            path: redis.conf
#应用上redis.yaml
kubectl apply -f redis.yaml



#Redis kubersphere
#主机的配置（配置字典） redis-conf    pod的配置 /redis-master/redis.conf
#主机的数据(存储卷) redis-pvc	 pod的数据 /data
#redis-server 用的是pod的配置 /redis-master/redis.conf

Configuration , Configmaps, create, name is redis-conf, next, Add Data,key is redis.conf, value is
appendonly yes
port 6379
bind 0.0.0.0
Application Workloads，Workloads，Statefulsets，create，name is his-redis，下一步，搜 redis ，使用默认端口，(1cpu,1024m memory), 选Start Command，命令 redis-server ， 参数 /etc/redis/redis.conf ,选同步主机时区,√，下一步，
Add Persistent Volume Claim Template，PVC Name Prefix is redis-pvc ，下面的挂载路径，选 读写，目录 /data，选 Mount Configmap or Secret，选 redis.conf，只读， /etc/redis, √(如果点了无效，先勾选再取消Slect Specific Keys)，下一步，创建
#创建外网访问服务
Services , create, Specify Workload, name is his-redis-node, next, select Virtual IP Address, Specify Workload, Statefulsets, his-redis, OK, Name is http-6379, Container is 6379, Service Port is 6379, next, External Access, NodePort
#用redismanager 连接193.169.0.3:30727

#测试redis的持久化
在redis-manager创个键值对，在Application Workloads，Workloads，Statefulsets, his-redis 里把Replicas数将为0，再变为1，发现redis-manager那里还保存着键值对 

#在创建Workloads的时候指定Statefulsets，这样可以1对1绑定（即时在Workloads实例增多的时候）

```



# ElasticSearch

[yuque doc](https://www.yuque.com/leifengyang/oncloud/vgf9wk)	[bili](https://www.bilibili.com/video/BV13Q4y1C7hS?p=83&vd_source=ca1d80d51233e3cf364a2104dcf1b743)	

```sh
# 创建数据目录
mkdir -p /mydata/es-01 && chmod 777 -R /mydata/es-01

# 容器启动  （-e就是environment，环境变量，-v就是volume，卷挂载）
docker run --restart=always -d -p 9200:9200 -p 9300:9300 \
-e "discovery.type=single-node" \
-e ES_JAVA_OPTS="-Xms512m -Xmx512m" \
-v es-config:/usr/share/elasticsearch/config \
-v /mydata/es-01/data:/usr/share/elasticsearch/data \
--name es-01 \
elasticsearch:7.13.4

如果出现 iptables: No chain/target/match by that name. 就
service dockers restart
# docker ps |grep es-01	 没有找到es-01
docker exec -it es-01 /bin/bash 	#进入控制台
pwd
cd config/
ls
看到需要挂载的是 elasticsearch.yml（核心配置） ， jvm.options（java虚拟机配置）
cat elasticsearch.yml
cat jvm.options

# 进 193.169.0.3:30880 , 挂载文件
Configuration, Configmaps, create, es-conf, next, Add Data, key is elasticsearch.yml , value is 
cluster.name: "docker-cluster"
network.host: 0.0.0.0
继续 Add Data， key is jvm.options， value is [cat jvm.options]

# 创建工作负载，挂载存储卷
Application Workloads， Workloads, Statefulsets, create, name is his-es, next, search elasticsearch:7.13.4 ,use default Ports ,(1cpu 1G Memory) , 
Environment Variables, key is discovery.type , value is single-node
					key is ES_JAVA_OPTS , value is -Xms512m -Xmx512m
Synchronize Host Timezone , next, 
Add Persistent Volume Claim Template, name is es-pvc, Read and write, Mount Path is 
/usr/share/elasticsearch/data , 
Mount Configmap or Secret, es-conf, Read-only, Mount Path is
/usr/share/elasticsearch/config/elasticsearch.yml ,Specify Subpath is elasticsearch.yml ,
Select Sepcific Keys, elasticsearch.yml, elasticsearch.yml ， √
Mount Configmap or Secret, es-conf, Read-only, Mount Path is
/usr/share/elasticsearch/config/jvm.options ,Specify Subpath is jvm.options , 
Select Sepcific Keys, jvm.options, jvm.options ，√
next, create 

#创建外网访问服务
Services , create, Specify Workload, name is his-es, next, select Virtual IP Address, Specify Workload, Statefulsets, his-es, OK, 
Name is http-9200, Container is 9200, Service Port is 9200,  
next, External Access, NodePort

#访问 http://193.169.0.3:30544/




```





# RabbitMQ ， Bitnami

[bitnami bili](https://www.bilibili.com/video/BV13Q4y1C7hS?p=85&vd_source=ca1d80d51233e3cf364a2104dcf1b743)	

```sh
top left App Store, RabbitMQ, Install, Next, Data Persistenc Enabled, Root Password is admin , install
Application Workloads, Service, 再 rabbitmq 右边三点, Edit External Access, NodePort,
15672对应的就是端口
访问 http://193.169.0.3:32658/


# Bitnami
App Management, App Respositories, name is bitnami, charts.bitnami.com/bitnami, Validate

# Zookeeper
Application Workloads, Apps, create, bitnami, Zookeeper, next, Install


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



# 可插拔组件，添加新节点	 

[官方doc 3.3.0](https://kubesphere.com.cn/docs/v3.3/quick-start/enable-pluggable-components/)	

1. 以 `admin` 身份登录控制台。点击左上角的**平台管理** ，然后选择**集群管理**。

2. 点击**定制资源定义**(CRDS)，然后在搜索栏中输入 `clusterconfiguration`，点击搜索结果进入其详情页面。

3. 在**Custom Resources**中，点击 `ks-installer` 右侧的三个点，然后选择**编辑 YAML**。

4. 在该配置文件中，将对应组件 `enabled` 的 `false` 更改为 `true`，以启用要安装的组件。完成后，点击**确定**以保存配置。

5. 应用商店 openpitrix:  store:    enabled: true # 将“false”更改为“true”。

   devops true
   
   
   
   ./kk add nodes -f sample.yaml



# sentinel & mangoDB

​	[mongo bili](https://www.bilibili.com/video/BV13Q4y1C7hS?p=109&vd_source=ca1d80d51233e3cf364a2104dcf1b743)	[官方 应用模板](https://kubesphere.io/zh/docs/v3.3/project-user-guide/application/deploy-app-from-template/#%E6%AD%A5%E9%AA%A4-1%E6%B7%BB%E5%8A%A0%E5%BA%94%E7%94%A8%E4%BB%93%E5%BA%93)	[mysql 官方](https://kubesphere.com.cn/docs/v3.3/application-store/built-in-apps/mysql-app/#%E6%AD%A5%E9%AA%A4-3%E4%BB%8E%E9%9B%86%E7%BE%A4%E5%A4%96%E8%AE%BF%E9%97%AE-mysql-%E6%95%B0%E6%8D%AE%E5%BA%93)	

```sh
从企业空间点击项目里，应用负载，服务，创建，有状态服务，名称是his-sentinel,下一步，搜leifengyang/sentinel:1.8.2，拉下去选 同步主机时区，下一步，下一步，创建
服务，创建，指定工作负载创建服务，名称是his-sentinel-node,下一步，指定工作负载，有状态副本集，选his-sentinal-v1 ,名称是 http-8080，容器端口和服务端口都是 8080，下一步，选外部访问，NodePort，创建
看到外网访问的端口是 31929
访问  193.169.0.3:31929
账号，密码都是 sentinal

#添加应用模板
点进his的企业空间，左边 应用管理，应用仓库，添加，名称test-repo，将应用仓库的 URL 设置为 https://helm-chart-repo.pek3a.qingstor.com/kubernetes-charts/  ，同步间隔 3000s，确定
#mangoDB 安装
应用负载，应用，创建，从应用模板，选test-repo，搜mangodb，右边安装，
名称mongodb，关掉Enable password authentication，安装
#找到内网访问的地址和端口
应用负载，服务，mongodb，复制DNS，服务端口27017
mongodb.his:27017
#暴露外网访问服务
应用负载，服务，创建，名称his-mango-node,下一步，指定工作负载，选 mongodb，确定，协议选 TCP，名称tcp-27017，容器端口27017，服务端口27017，下一步，外部访问，NodePort，创建，点进 his-mango-node，看到NodePort是32527
mongodb.his:32527 
#用 MongoDB Compass 连接
193.169.0.3:32527

#mysql 安装
应用负载，应用，创建，从应用模板，选test-repo，搜 mysql，名称mysql，下一步，
在应用设置下，取消 mysqlRootPassword 字段的注解（默认testing，不能设置）
应用负载，服务，点 mysql，左边更多操作，选 编辑外部访问，选 NodePort，确定，看到NodePort是30405
#用sqlyog访问，外网服务端口：
193.169.0.3:30405
root,testing
#初始化数据库
yygh-parent\data\sql 下所有的sql，拖进sqlyog，一个个全选执行
```



# Nacos 本地，ry_cloud setting

[生产环境配置bili](https://www.bilibili.com/video/BV13Q4y1C7hS?p=111&vd_source=ca1d80d51233e3cf364a2104dcf1b743)	[ArtifactHUB](https://artifacthub.io/packages/helm/bitnami/redis?modal=install) 	[ruoyi](https://gitee.com/y_project/RuoYi-Cloud)	[nacos官网 要翻墙](https://nacos.io/zh-cn/docs/quick-start.html)	[nacos git](https://github.com/alibaba/nacos/releases) 

```sh
dockerhub是docker的商店，artifactHUB是kubernates的商店
his企业空间，应用管理，应用仓库，名称 bitnami ，URL右边 https://charts.bitnami.com/bitnami ，确定

# RuoYi-Cloud
Fork到自己仓库，再克隆下来 git clone https://gitee.com/jasonbourne33/RuoYi-Cloud.git


nacos\conf 目录下打开 application.properties
解开注释 spring.datasource.platform=mysql

db.url.0=jdbc:mysql://127.0.0.1:3306/nacos?characterEncoding=utf8&connectTimeout=1000&socketTimeout=3000&autoReconnect=true&useUnicode=true&useSSL=false&serverTimezone=UTC
db.user.0=root
db.password.0=123456
创建数据库 nacos，字符集选 utf-8，执行nacos\conf 目录下 nacos-mysql.sql的语句

在F:\yunwei\nacos\bin 里打开cmd，执行 startup.cmd -m standalone 	#单点模式启动
# 访问 localhost:8848/nacos/#/login ，账号密码都是 nacos
改 application.properties，把nacos改为ry-config  #把设置改成 ry-config 的
db.url.0=jdbc:mysql://127.0.0.1:3306/ry-config?
characterEncoding=utf8&connectTimeout=1000&socketTimeout=3000&autoReconnect=true&useUnicode=true&useSSL=false&serverTimezone=UTC
重新启动，执行 startup.cmd -m standalone
Sqlyog创建数据库 ry-cloud,字符集选 utf-8, 选中ry-cloud，执行 quartz.sql 和 ry_20220613.sql ，ry_seata_20210128.sql
在 localhost:8848/nacos/#/login 里，在ruoyi-job-dev.yml, ruoyi-system-dev.yml, 右边点edit，把mysql的password改成本地的123456，发布
下载并安装node.js,重启idea，Terminal控制台下进入ruoyi-ui ， RuoYi-Cloud\ruoyi-ui> 执行安装
npm install --registry=https://registry.npm.taobao.org	#安装依赖
npm run dev		#启动服务

#改配置,启动网关
把 his-redis-node 的外网访问端口 复制到 nacos打开的
ruoyi-gateway-dev.yml，ruoyi-auth-dev.yml,ruoyi-system-dev.yml,ruoyi-job-dev.yml 
下的对应redis的 host和port， 
右键RuoYiGatewayApplication，run，启动完后选中Auth，File，Job，Monitor，System，右键，run


#Idea里开service 界面并配置
View， Tool Window, Services, 
+ ， Run Confige Type, Spring Boot


# 输入验证码后报错
获取用户失败:[503] during [GET] to [http://ruoyi-system/user/info/admin] [RemoteUserService#getUserInfo(String,String)]: [Load balancer does not contain an instance for the service ruoyi-system]
要等system启动，稍等

















#Nacos本地 （报错，放弃）
下载，解压nacos-server，nacos\conf 下解开注释，改成本地的mysql账号和密码
### If use MySQL as datasource:
spring.datasource.platform=mysql
### Count of DB:
db.num=1
### Connect URL of DB:
db.url.0=jdbc:mysql://127.0.0.1:3306/nacos?characterEncoding=utf8&connectTimeout=1000&socketTimeout=3000&autoReconnect=true&useUnicode=true&useSSL=false&serverTimezone=UTC
db.user.0=root
db.password.0=123
### Connection pool configuration: hikariCP
db.pool.config.connectionTimeout=30000
db.pool.config.validationTimeout=10000
db.pool.config.maximumPoolSize=20
db.pool.config.minimumIdle=2

#单点模式启动
打开sqlyog，执行nacos\conf 下的 nacos-mysql.sql ，nacos\bin 下右键命令台，startup.cmd -m standalone
localhost:8848/nacos/#/login





```







# nacos上云, 数据库迁移

[bili](https://www.bilibili.com/video/BV13Q4y1C7hS?p=90&vd_source=ca1d80d51233e3cf364a2104dcf1b743)	

```sh
Migtation, Source Selection, 填好本地的，Test Connection， next, 在Test Selection 填好ks的，Test Connection, Sechemas Selection 里选 ry-cloud,ry-config,ryseata 


#nacos 服务
Service, StatefulService, his-nacos,  nacos/nacos-server:v2.0.3,
http-8848, 8848, 8848, 同步主机时区
ping his-nacos.his
复制 his-nacos-v1-0.his-nacos.his.svc.cluster.local 到 config.cluster

#nacos上云 配置文件
Configuration, Configmaps, nacos-conf, key is application.proerties, value is content inside, 
key is cluster.conf, value is content inside

conf.cluster 是
his-nacos-v1-0.his-nacos.his.svc.cluster.local:8848
his-nacos-v1-1.his-nacos.his.svc.cluster.local:8848
his-nacos-v1-2.his-nacos.his.svc.cluster.local:8848

application.properties 要改
db.url.0=jdbc:mysql://his-mysql.his:3306/ry-config?


#有状态服务
Service, StatefulService, his-nacos,  nacos/nacos-server:v2.0.3,
http-8848, 8848, 8848, 同步主机时区，
Mount Configmap or Secret, nacos-conf, Read-only, /home/nacos/conf/cluster.conf, SubPath is  cluster.conf, Specific Keys is cluster.conf, cluster.conf,
Mount Configmap or Secret, nacos-conf, Read-only, /home/nacos/conf/application.properties, SubPath is application.properties ， Specific Keys is application.properties, application.properties,

#暴露外部访问的service
Application Workloads, Services, Specify Workload, his-nacos-node, Specify Workload, his-nacos-v1, 
http-8848, 8848, 8848，
External Access, NodePort

# 访问地址
http://193.169.0.3:30444/nacos
账号密码 nacos, nacos


```





# 打包jar

[bili](https://www.bilibili.com/video/BV13Q4y1C7hS?p=95&spm_id_from=pageDriver&vd_source=ca1d80d51233e3cf364a2104dcf1b743)	[leifengyang RuoYi](https://gitee.com/leifengyang/RuoYi-Cloud/blob/master/ruoyi-auth/Dockerfile)	

```sh
打包后没出现target包 Idea, Settings, Editor, File Encodings, UTF-8 * 3

# 先启动nacos
F:\yunwei\nacos\bin
startup.cmd -m standalone
# 再测试jar
C:\Users\Administrator\Desktop\docker
java -jar ruoyi-auth.jar
#在桌面
C:\Users\Administrator\Desktop\docker
改Dokerfile，创建target，里面放jar
#制作镜像
cd /root/docker/ruoyi-auth
docker build -t ruoyi-auth -f Dockerfile .
cd /root/docker/ruoyi-file
docker build -t ruoyi-file -f Dockerfile .
cd /root/docker/ruoyi-gateway
docker build -t ruoyi-gateway -f Dockerfile .
cd /root/docker/ruoyi-system
docker build -t ruoyi-system -f Dockerfile .
cd /root/docker/ruoyi-visual-monitor
docker build -t ruoyi-visual-monitor -f Dockerfile .

Dokcerfile 在 idea, F:\yunweiProject\RuoYi-Cloud\docker\ruoyi\auth\dockerfile


```













# gulimail的 wordpress ，mysql 的 券，密匙，服务

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



# Bug

[2 亲自提问](https://kubesphere.com.cn/forum/d/7352-please-wait-for-the-installation-to-complete/12)	[发帖问](https://kubesphere.com.cn/forum/d/7490-kk-create-cluster-f-config-sampleyaml)	[3 github](https://github.com/calebhailey/homelab/issues/3)

```sh
#5 在单点部署后 ks-jenkins 没有就绪(变黄 warning)，一直在重启
Application Workloads 里调大一点cpu和内存

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
