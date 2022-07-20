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





去hub.docker.com找软件

docker pull nginx   	#下载最新版
docker pull nginx:1.20.1
docker images 		#查看所以镜像
docker rmi				镜像名：版本号/镜像id
docker rm -f mynginx		杀死正在运行的容器

```sh
docker run --name=mynginx -d --restart=always -p 88:80 nginx
```

-d 以后台方式运行	--restart重启还在	-p 把主机的88端口映射到80端口

docker ps -a				看正在运行中的容器

要在安全组规则里设置放行88端口

curl 192.168.174.130:88		测试连接

docker update 0d0 --restart=always



# Redis

装redis	[bili](https://www.bilibili.com/video/BV13Q4y1C7hS?p=20)

docker pull redis

mkdir data	然后	mkdir data/redis	cd data/redis

vim data/redis/redis.conf	编辑内容

appendonly yes
requirepass 123

redis自定义配置文件启动命令

```sh
docker run -v /data/redis/redis.conf:/etc/redis/redis.conf \
-v /data/redis/data:/data \
-d --name myredis \
-p 6379:6379 \
redis:latest redis-server /etc/redis/redis.conf
```

在安全组放行6379

docker exec -it  myredis /bin/bash		进入容器

docker rm -f myredis

http://localhost:8080/count	统计人数测试地址，放seckill了



踩坑
1 要先把 linux 的 redis 停掉再去启动 docker 的 redis
/usr/redis/redis-6/bin/redis-cli shutdown

2 docker run 的时候显示 IPv4 forwarding is disabled. Networking will not work.
https://cloud.tencent.com/developer/article/1552661
vim /etc/sysctl.conf	添加代码
net.ipv4.ip_forward=1 
systemctl restart network  	重启服务
sysctl net.ipv4.ip_forward  	看是否成功







