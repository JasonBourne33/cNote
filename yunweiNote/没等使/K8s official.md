

```sh
https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/

#1 Download the latest release with the command:
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
# 固定版本 curl -LO https://dl.k8s.io/release/v1.24.0/bin/linux/amd64/kubectl

#2 Validate the binary (optional)
curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check

#3 install kubectl
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
chmod +x kubectl
mkdir -p ~/.local/bin
mv ./kubectl ~/.local/bin/kubectl

#4 Test to ensure the version you installed is up-to-date:
kubectl version --client --output=yaml 

#5 Install using native package management
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
# https://developer.aliyun.com/mirror/
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
sudo yum install -y kubectl
sudo yum install -y kubelet-1.24.1 kubeadm-1.24.1 kubectl-1.24.1 
# sudo yum remove -y kubelet-1.24.1 kubeadm-1.24.1 kubectl-1.24.1 
sudo systemctl enable --now kubelet

#下载各个机器需要的镜像
sudo tee ./images.sh <<-'EOF'
#!/bin/bash
images=(
kube-apiserver:v1.24.1
kube-proxy:v1.24.1
kube-controller-manager:v1.24.1
kube-scheduler:v1.24.1
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

