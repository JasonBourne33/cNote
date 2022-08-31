



# Install

[马士兵bili](https://www.bilibili.com/video/BV1DB4y1U7Gz?p=12&vd_source=ca1d80d51233e3cf364a2104dcf1b743)	jenkins cn官网	[配置docker加速](https://cr.console.aliyun.com/cn-hangzhou/instances/mirrors)	

```sh
#执行流程
jenkins从gitlab把代码拉下来（clone） 
Jenkins master把编译工作分成几个agent来执行(fenbushi )
04.55 agent（mvn）连接到nexus去下载依赖包，agent把编译好的jar包部署到web服务器


# 装java 
复制 F:\SSM\relevent soft\可用 jdk11 jre9 tomcat9\jdk-11.0.14_linux-x64_bin.rpm 到/root
rpm -i jdk-11.0.14_linux-x64_bin.rpm
# 装jenkins
配置docker加速
编辑 /etc/docker/daemon.json ，加上
"registry-mirrors": ["https://of79xv0k.mirror.aliyuncs.com"]
然后重启daemon
sudo systemctl daemon-reload
sudo systemctl restart docker
docker pull jenkins/jenkins



```





[尚硅谷 Jenkins](https://www.bilibili.com/video/BV1bS4y1471A?spm_id_from=333.337.search-card.all.click&vd_source=ca1d80d51233e3cf364a2104dcf1b743)	[ali云盘](https://www.aliyundrive.com/s/UPsbm5PbEtb/folder/62e8d87261c8769ce48f4c04a6690382e6e1ddae)	

```sh
#安装docker
yum update
yum install -y yum-utils device-mapper-persistent-data lvm2
添加阿里镜像
yum-config-manager --add-repo https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
yum list docker-ce --showduplicates | sort -r
yum install docker-ce-20.10.9-3.el7
systemctl start docker
systemctl enable docker		#开机启动
docker version

```



































