



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
#配置每个主机名不一样
hostnamectl set-hostname k8s-master
hostnamectl set-hostname slave1
hostnamectl set-hostname slave2
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

```sh
#安装Docker
sudo yum install -y docker-ce-20.10.7 docker-ce-cli-20.10.7 containerd.io-1.4.6

#启动
systemctl enable docker --now

#配置镜像加速
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

# yum remove -y docker-ce-20.10.7

#禁用掉linux的一些安全设置
sudo setenforce 0
sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

#关闭swap分区
swapoff -a
sed -ri 's/.*swap.*/#&/' /etc/fstab

#把ipv6的桥接到ipv4，方便统计
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sudo sysctl --system

#安装三大件
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
#sudo yum remove -y kubelet-1.20.9 kubeadm-1.20.9 kubectl-1.20.9
sudo systemctl enable --now kubelet

#下载各个机器需要的镜像
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
#所有机器添加master域名映射，以下需要修改为自己的
echo "193.169.0.3  cluster-endpoint" >> /etc/hosts
#验证
ping cluster-endpoint
```



初始化主节点 (只master节点装)

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



calico 

```sh
# https://projectcalico.docs.tigera.io/maintenance/clis/calicoctl/install
# Install calicoctl as a Kubernetes pod
# 安装网络组件calico (master节点 )
#curl https://docs.projectcalico.org/manifests/calico.yaml -O
#curl https://docs.projectcalico.org/v3.9/manifests/calico.yaml -O
wget https://docs.projectcalico.org/v3.9/manifests/calico.yaml --no-check-certificate
#根据配置文件，给集群创建资源
kubectl apply -f calico.yaml	
kubectl edit -f calico.yaml	
#查看部署了哪些应用 ( 相当于docker ps)
kubectl get pods -A		

#如果要删除
#kubectl delete https://docs.projectcalico.org/v3.9/manifests/calico.yaml
#kubectl delete -f calico.yaml	


# calico-kube-controllers 有 CrashLoopBackOff
# Calico networking (BGP)
firewall-cmd --zone=public --add-port=179/tcp --permanent
# Calico networking with Typha enabled
firewall-cmd --zone=public --add-port=5473/tcp --permanent
# flannel networking (VXLAN)
firewall-cmd --zone=public --add-port=4789/udp --permane
firewall-cmd --reload 
#calico-kube-controllers 有 ImagePullBackOff
```





Dashboard

```sh
#部署
# kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.3.1/aio/deploy/recommended.yaml
wget https://raw.githubusercontent.com/kubernetes/dashboard/v2.3.1/aio/deploy/recommended.yaml
vi dashboard.yaml 
#把recommended.yaml的内容复制到 dashboard.yaml
kubectl apply -f dashboard.yaml
#如果要删除
#kubectl delete -f dashboard.yaml

#设置访问端口
kubectl edit svc kubernetes-dashboard -n kubernetes-dashboard
/type搜索，把值改了 type:NodePort
kubectl get svc -A |grep kubernetes-dashboard

#开放端口30753（云服务器在控制台也要操作）
#firewall-cmd --zone=public --add-port=30753/tcp --permanent	
firewall-cmd --zone=public --add-port=32025/tcp --permanent	
systemctl restart firewalld.service
firewall-cmd --reload 
# 访问  https://193.169.0.3:32025/#/login
# advance ， 继续前往，提示要token
# 在root目录下创建用户配置的yaml
vi dash.yaml
#内容
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kubernetes-dashboard
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kubernetes-dashboard
#创建
kubectl apply -f dash.yaml
  

 

kubectl -n kubernetes-dashboard get secret $(kubectl -n kubernetes-dashboard get sa/admin-user -o jsonpath="{.secrets[0].name}") -o go-template="{{.data.token | base64decode}}"
#复制token进去登录，我的是
eyJhbGciOiJSUzI1NiIsImtpZCI6ImFRWldIV3NfQ21kcFVoUmF2ZmNIZEtnWlh3TDRwb2VIUnFlZVhqTjRudDQifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJrdWJlcm5ldGVzLWRhc2hib2FyZCIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VjcmV0Lm5hbWUiOiJhZG1pbi11c2VyLXRva2VuLXQ3NWw5Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQubmFtZSI6ImFkbWluLXVzZXIiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC51aWQiOiJlYmM5ZTFhNy0zMzYyLTRiNDEtODg4NS1lOTBiN2ZjMzQ0ODIiLCJzdWIiOiJzeXN0ZW06c2VydmljZWFjY291bnQ6a3ViZXJuZXRlcy1kYXNoYm9hcmQ6YWRtaW4tdXNlciJ9.Ch7yKEgVWwVm9Pc8xWRur00lif0IK9e29Gu9dugB7OTI65CFg5vxapfWGILvHVBOvG7CPgL1RnLvkTRzWaZBPJ3260hJS4L0nWFWIVy9Qx3amnycMa1yHv_W6F7yFbxw8tIZNJOajIHzDm8WosN4W02uXpJQA29noQztAunfHlyA34ZZRbbAHHMQl9bpsafIY6ygKt8shtt12-Iu9KOgB6hx8m87AwbNO8f7yC0oDB9vbYwSe0TrD9I08b81sHZKnzQeXk8hPkUYPl9KZT0Iig0IraRv2LzjIeHI4dudofkhwCwCf4ldVpKEVV35sWO__6WAplfPnbr5TVLZPpagDg


```







Bug

```sh
#1 kubeadm reset 		重置 的时候报错

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


#2 Kubernetes  	 join 的时候卡住 (没解决)
certificate has expired or is not yet valid: current time 2022-05-26T22:40:29-04:00 is before 2022-05-29T09:55:50Z

rm -rf /etc/cni/net.d
iptables -F && iptables -t nat -F && iptables -t mangle -F && iptables -X
sysctl net.bridge.bridge-nf-call-iptables=1
sudo ip link del cni0
sudo ip link del flannel.1
rm -rf $HOME/.kube/config

rm -rf /etc/kubernetes/bootstrap-kubelet.conf
rm -rf /etc/kubernetes/pki/ca.crt

kubectl exec -ti calico-node-qqd5r -n kube-system -- bash
kubectl logs -f calico-node-qqd5r
#修改calico.yaml
            - name: IP
              value: "autodetect"
            - name: IP_AUTODETECTION_METHOD
              value: "interface=ens33"
            # Enable IPIP
            - name: CALICO_IPV4POOL_IPIP
#可能是因为 calico-node 没ready 
kubectl exec -ti calico-node-qqd5r -n kube-system -- bash
cat /etc/calico/confd/config/bird.cfg



#3 master节点 init 的时候报错 
[kubelet-check] Initial timeout of 40s passed.

	Unfortunately, an error has occurred:
		timed out waiting for the condition

	This error is likely caused by:
		- The kubelet is not running
		- The kubelet is unhealthy due to a misconfiguration of the node in some way (required cgroups disabled)

	If you are on a systemd-powered system, you can try to troubleshoot the error with the following commands:
		- 'systemctl status kubelet'
		- 'journalctl -xeu kubelet'

	Additionally, a control plane component may have crashed or exited when started by the container runtime.
	To troubleshoot, list all containers using your preferred container runtimes CLI.

	Here is one example how you may list all Kubernetes containers running in docker:
		- 'docker ps -a | grep kube | grep -v pause'
		Once you have found the failing container, you can inspect its logs with:
		- 'docker logs CONTAINERID'

error execution phase wait-control-plane: couldn't initialize a Kubernetes cluster
To see the stack trace of this error execute with --v=5 or higher

#没解决,重装系统才行

#4 子node join 的时候报错
[preflight] Running pre-flight checks
	[WARNING SystemVerification]: this Docker version is not on the list of validated versions: 20.10.7. Latest validated version: 19.03
	[WARNING Hostname]: hostname "slave1" could not be reached
	[WARNING Hostname]: hostname "slave1": lookup slave1 on 8.8.8.8:53: no such host
error execution phase preflight: [preflight] Some fatal errors occurred:
	[ERROR FileContent--proc-sys-net-ipv4-ip_forward]: /proc/sys/net/ipv4/ip_forward contents are not set to 1
[preflight] If you know what you are doing, you can make a check non-fatal with `--ignore-preflight-errors=...`
To see the stack trace of this error execute with --v=5 or higher

#改文件
echo "1" > /proc/sys/net/ipv4/ip_forward



#当挂起再开虚拟机后报错
The connection to the server localhost:8080 was refused - did you specify the right host or port?
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config



#6 pods calico-node on worker nodes with 'Running' but not Ready 0/1
https://github.com/projectcalico/calico/issues/4197
```



