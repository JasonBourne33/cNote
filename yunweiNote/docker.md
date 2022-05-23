源 https://www.bilibili.com/video/BV13Q4y1C7hS?p=10

文档 https://www.yuque.com/leifengyang/oncloud/mbvigg#3k0Q4

yum install -y yum-utils

指定镜像

sudo yum-config-manager \
--add-repo \
http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo

安装

yum install -y docker-ce docker-ce-cli containerd.io

systemctl enable docker --now

配置加速器，直接复制粘贴下面代码

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





去hb.docker.com找软件

docker pull nginx   	#下载最新版

docker pull nginx:1.20.1

docker images 		#查看所以镜像

docker rmi				镜像名：版本号/镜像id

docker run --name=mynginx nginx 	启动

docker ps				看正在运行中的容器

curl 192.168.174.130:80		测试连接

docker rm mynginx		杀死正在运行的容器

docker run --name=mynginx -d nginx		以后台方式运行



