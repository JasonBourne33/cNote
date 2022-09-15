





# Dashboard

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
/type搜索，把值改了 type: NodePort
kubectl get svc -A |grep kubernetes-dashboard

#开放端口30753（云服务器在控制台也要操作）
#firewall-cmd --zone=public --add-port=30753/tcp --permanent	
firewall-cmd --zone=public --add-port=31522/tcp --permanent	
systemctl restart firewalld.service
firewall-cmd --reload 
# 家  https://193.169.0.3:31642/#/login
# comp		https://193.169.0.3:32233/#/login
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
eyJhbGciOiJSUzI1NiIsImtpZCI6IkJwU25DS1dvU01nSXRWUVM4ODNkSjRQZXRqZDhseHpNLVVsa25GYWxkWFUifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJrdWJlcm5ldGVzLWRhc2hib2FyZCIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VjcmV0Lm5hbWUiOiJhZG1pbi11c2VyLXRva2VuLXRrbTVnIiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQubmFtZSI6ImFkbWluLXVzZXIiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC51aWQiOiJkMzJlOWQwZS02ZDQzLTQ2OWUtOTczOC00MDM0N2I3Nzc3YzUiLCJzdWIiOiJzeXN0ZW06c2VydmljZWFjY291bnQ6a3ViZXJuZXRlcy1kYXNoYm9hcmQ6YWRtaW4tdXNlciJ9.tYvp9tgtxayVTczwBAdD3DubCvSV0WBGuMXXGhDrb9O8Nyktl4nZ4CF6iMZFgk1JNIS7indxfyKKBCg7SPMP1HbvKSvuj5hKSxkKX-hZQ5UA17u8a47wnhQkX89aBk-1s8V2KsLLKdV3xGOb07BEir2OL1Quv9Uxs3pC7d54_gq-gEO6vrFpKK8OVBl6UGC_qiujsMOevYa1mbmQflKRG8ZmWAjF8T6EvXQqNyZH2hFHBkbhsdn98p_qkds0vunCMUJ0ctWArzLGIGTMho_i42NTpp-0ub5holKipLdf-gMBMHlx3FC2XjvtM3caB70ZqP9i_dWHKVN3VrFyZFDCQQ



kubectl describe -n devops pod jenkins-666c68d849-d9zd9
kubectl get pod -A
kubectl describe -n kubernetes-dashboard pod dashboard-metrics-scraper-79c5968bdc-tnwzm
kubectl describe -n kubernetes-dashboard pod kubernetes-dashboard-658485d5c7-2j886
kubectl logs -f -n kubernetes-dashboard kubernetes-dashboard-658485d5c7-2j886
```









# k8s pod装 jenkins

[bili](https://www.bilibili.com/video/BV1Ef4y1f78A?p=52&vd_source=ca1d80d51233e3cf364a2104dcf1b743)	[配置文件github](https://github.com/zeyangli/devops-on-k8s/blob/master/devops/jenkins.yaml)	

```sh
docker run --name myjenkins \
-p 8080:8080 -p 50000:50000 \
-v /var/jenkins_home jenkins/jenkins \
-v /usr/local/maven/apache-maven-3.8.6:/usr/local/maven/apache-maven-3.8.6 


# 装java 
复制 F:\SSM\relevent soft\可用 jdk11 jre9 tomcat9\jdk-11.0.14_linux-x64_bin.rpm 到/root
rpm -i jdk-11.0.14_linux-x64_bin.rpm
# maven安装
把 F:\yunwei\Jenkins 尚硅谷\软件\apache-maven-3.8.6-bin.tar.gz 拖进 master
tar -zxvf apache-maven-3.8.6-bin.tar.gz -C /usr/local/maven
vim /etc/profile
MAVEN_HOME=/usr/local/maven/apache-maven-3.8.2
export PATH=${MAVEN_HOME}/bin:${PATH}
source  /etc/profile
/usr/local/maven/apache-maven-3.8.6/bin/mvn


vi myjenkins.yaml

#应用上myjenkins.yaml
kubectl create ns devops
mkdir /data
mkdir /data/devops
mkdir /data/devops/jenkins
kubectl apply -f myjenkins.yaml

http://193.169.0.3:30080/login
查看密码
kubectl get pod -A
kubectl logs jenkins-666c68d849-2w5tx -n devops


虽然显示 This may also be found at: /var/jenkins_home/secrets/initialAdminPassword
但是  -bash: /var/jenkins_home/secrets/initialAdminPassword: No such file or directory
进到k8s的jenkins容器里又没权限
bash: /var/jenkins_home/secrets/initialAdminPassword: Permission denied
所以只能用 kubectl logs jenkins-89775958f-n9lp9 -n devops 看密码

================================================
用root进入jenkins
docker ps
docker exec -it -u root 'a105eb174e81' /bin/bash

下载完plugin后可能需要 重启jenkins http://193.169.0.3:30080/restart







#安装maven插件
左边 Manage Jenkins，拉下去 Plugin Manager， Available，搜 maven ，勾选Maven Integration， 
Install without restart, 
创建
返回到Dashboard，New Item, name is first, Maven project, 

# 把 github 或 gitee 的项目放到 私人gitlab
gitee 私人令牌	9e24dea4123f65d0851f76c66f52fb99
	https://gitee.com/jasonbourne233/yygh-parent.git
github私人令牌 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
	https://github.com/JasonBourne33/yygh-parent
gitea 私人令牌	
	https://try.gitea.io/JasonBourne233/yygh-parent.git

#上传本地 yygh 到 gitlab
在 F:\yunweiProject\gitlab yygh\yygh-parent 先
git clone https://try.gitea.io/JasonBourne233/yygh-parent.git
git clone http://193.169.0.4/root/java-project.git
再把 java-project 里面的内容复制出来，覆盖
git add .
git commit -m first
git push

yum install -y git
Jenkins里 Source Code Management， 选git， http://193.169.0.4/root/java-project.git
the tool configuration ， 拉下去 add maven， name is maven3, /usr/local/maven
```













# Docker 装gitlab (node1)

​	[ali云盘](https://www.aliyundrive.com/s/UPsbm5PbEtb/folder/62e8d87261c8769ce48f4c04a6690382e6e1ddae)	[尚硅谷 Jenkins](https://www.bilibili.com/video/BV1bS4y1471A?p=9&vd_source=ca1d80d51233e3cf364a2104dcf1b743)

```sh
下载到rpm到 F:\yunwei\relevent soft\gitlab-ce-15.1.5-ce.0.el7.x86_64.rpm
#安装docker
yum update -y
yum install -y yum-utils device-mapper-persistent-data lvm2
#添加docker下载镜像
yum-config-manager --add-repo http://download.docker.com/linux/centos/docker-ce.repo

yum list docker-ce --showduplicates | sort -r
yum install docker-ce-20.10.17-3.el7 -y
systemctl start docker
systemctl enable docker		#开机启动

docker version

# 10.40 安装gitlab
docker run --detach \
  --hostname 193.169.0.3 \
  --publish 443:443 --publish 80:80 \
  --name gitlab \
  --restart always \
  --volume $GITLAB_HOME/config:/etc/gitlab:Z \
  --volume $GITLAB_HOME/logs:/var/log/gitlab:Z \
  --volume $GITLAB_HOME/data:/var/opt/gitlab:Z \
  --shm-size 256m \
  registry.gitlab.cn/omnibus/gitlab-jh:latest
  
如果端口被占用，停掉nginx，解决冲突
systemctl stop nginx
docker ps -a
docker start gitlab
docker exec -it gitlab /bin/bash

root, 查看初始密码 cat /etc/gitlab/initial_root_password，登录进去
右上角， edit profile， 左边password，改密码999Zzz...




```













# 原生安装 GitLab（弃用）

[gitlab bili 41](https://www.bilibili.com/video/BV1vy4y1s7k6?p=41&vd_source=ca1d80d51233e3cf364a2104dcf1b743)		[gitlab下载](https://packages.gitlab.com/gitlab/gitlab-ce)	[gitlab改端口](https://www.jianshu.com/p/35698999cf44)

```sh
下载到rpm到 F:\yunwei\relevent soft\gitlab-ce-15.1.5-ce.0.el7.x86_64.rpm
拖到 master 的~
创建一个安装的 sh脚本
vim gitlab-install.sh
里面内容 :wq 退出
sudo rpm -ivh /root/gitlab-ce-15.1.5-ce.0.el7.x86_64.rpm
sudo yum install -y curl policycoreutils-python openssh-server cronie
sudo lokkit -s http -s ssh
sudo yum install -y postfix
sudo service postfix start
sudo chkconfig postfix on
curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.rpm.sh | sudo bash
sudo EXTERNAL_URL="http://gitlab.example.com" yum -y install gitlab-ce
赋予权限
chmod +x gitlab-install.sh
安装
./gitlab-install.sh
初始化GitLab服务
gitlab-ctl reconfigure		（耗时）
gitlab-ctl start
gitlab-ctl restart
访问 193.169.0.3
root, 查看初始密码 cat /etc/gitlab/initial_root_password，登录进去
右上角， edit profile， 左边password，改密码999Zzz...
在host加上映射	vim /etc/hosts
193.169.0.3  gitlab-server

# 在gitlab dashboard 创建服务
右边 new project， create blank project, name is git-test, 

#在idea 里装gitlab插件 (idea集成gitlab)
settings， Plugins， 搜 gitlab projects 2020
settings， GitLab， Add New GitLab Server, 












#默认访问是80端口，如果已经被占用了，需要改默认端口
/var/opt/gitlab/nginx/conf/gitlab-http.conf
server {
  listen *:80;  --修改端口，80改成86

访问： 193.169.0.3:86
#空间已经不够用了
At least xMB  more space needed on the / filesystem.
docker system prune -a		清理
df -h			查看





```



















# Harbor

[github下载](https://github.com/goharbor/harbor/releases)	[bili 单体安装](https://www.bilibili.com/video/BV1nY411T747?p=23&vd_source=ca1d80d51233e3cf364a2104dcf1b743)	[卸载旧docker](https://www.jianshu.com/p/8c0600a0c25f)	[harbor](https://www.bilibili.com/video/BV1Ve4y197Lf?p=8&vd_source=ca1d80d51233e3cf364a2104dcf1b743)	[上传镜像 马士兵](https://www.bilibili.com/video/BV1Ve4y197Lf?p=9&spm_id_from=pageDriver&vd_source=ca1d80d51233e3cf364a2104dcf1b743)

```sh
下载离线包 harbor-offline-installer-v2.4.3.tgz 
tar -zxvf harbor-offline-installer-v2.4.3.tgz 
yum -y install lrzsz
# 安装compose
# 相当于 https://github.com/docker/compose/releases/download/v2.9.0/docker-compose-linux-x86_64
curl -L https://github.com/docker/compose/releases/download/v2.9.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose	#这样安装太慢，直接离线下载好 docker-compose-linux-x86_64

cp /root/docker-compose-linux-x86_64 /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
cp harbor.yml.tmpl harbor.yml
vim harbor
hostname: 193.169.0.4
:wq


#Need to upgrade docker package to 17.06.0+.   卸载旧docker
rpm -qa | grep docker
rpm -e docker-1.13.1-209.git7d71120.el7.centos.x86_64
rpm -e docker-client-1.13.1-209.git7d71120.el7.centos.x86_64
rpm -e docker-common-1.13.1-209.git7d71120.el7.centos.x86_64
#配置ali的docker yum源
yum install -y yum-utils device-mapper-persistent-datalvm2 git
yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
yum install docker-ce -y

# 启动
/root/harbor/install.sh
# 配置域名 ，访问
vim /etc/hosts
193.169.0.4 www.charbor.com
http://193.169.0.4   or     www.charbor.com
admin , Harbor12345

# 配置仓库 （在master节点用也这样配置）
vim /etc/docker/daemon.json
{
  "insecure-registries": ["193.169.0.4"]
}
:wq
systemctl daemon-reload
systemctl restart docker
# 重启compose
docker-compose down
docker-compose up -d
docker ps		#要有9个goharbor

#测试推送镜像
docker pull centos
docker tag centos:latest 193.169.0.4/library/centos:v233
docker login 193.169.0.4 --username=admin --password-stdin=Harbor12345
docker push 193.169.0.4/library/centos:v233
#在master 拉去镜像
docker pull 193.169.0.4/library/centos:v233
'docker push  $REGISTRY/$DOCKERHUB_NAMESPACE/service-user:SNAPSHOT-$BUILD_NUMBER'
 

```













## 弃用分割线==============



# Jenkins尚硅谷的安装方法 (master)

[bili](https://www.bilibili.com/video/BV1bS4y1471A?p=9&vd_source=ca1d80d51233e3cf364a2104dcf1b743)	

```sh
把 F:\yunwei\Jenkins 尚硅谷\软件\jenkins.war 拖进 master
java -jar jenkins.war --httpPort=8081	#因为8080端口可能被占用
# 初始密码位置
/root/.jenkins/secrets/initialAdminPassword
ced957d4e4b041c5b623df74fbbcc0d1

sudo chown -R root:jenkins /var/lib/jenkins/

# 装java 
复制 F:\SSM\relevent soft\可用 jdk11 jre9 tomcat9\jdk-11.0.14_linux-x64_bin.rpm 到/root
rpm -i jdk-11.0.14_linux-x64_bin.rpm
# maven安装
把 F:\yunwei\Jenkins 尚硅谷\软件\apache-maven-3.8.6-bin.tar.gz 拖进 node1
tar -zxvf apache-maven-3.8.6-bin.tar.gz -C /usr/local/maven
vim /etc/profile
MAVEN_HOME=/usr/local/maven/apache-maven-3.8.2
export PATH=${MAVEN_HOME}/bin:${PATH}
source  /etc/profile
/usr/local/maven/apache-maven-3.8.6/bin/mvn


# docker装 jenkins
安装docker
sudo yum install -y docker-ce-20.10.17 docker-ce-cli-20.10.17 containerd.io-1.6.6
systemctl enable docker --now
装jenkins
docker pull jenkins/jenkins:lts-jdk11
docker run --name myjenkins \
-p 8080:8080 -p 50000:50000 \
-v /var/jenkins_home jenkins/jenkins \
-v /usr/local/maven/apache-maven-3.8.6:/usr/local/maven/apache-maven-3.8.6 

sudo chown -R root /usr/local/maven/apache-maven-3.8.6
sudo chown -R myjenkins /usr/local/maven/apache-maven-3.8.6

如果要删掉
docker ps -a
docker rm c4271b32d37d

#Bug java -jar jenkins.war 启动报错 Failed to bind to 0.0.0.0/0.0.0.0:8080
lsof -i tcp:8080		查看占用了8080的应用
kill -9 1720			杀掉应用 pid 1720

访问
193.169.0.3:8080
创建账号 admin ， 9Z.
看密码
/var/jenkins_home/secrets/initialAdminPassword
840bb3809b7a4a6295d6e672e81181bc


```

[占用8080端口的解决办法](https://stackoverflow.com/questions/38357981/could-not-bind-to-0-0-0-08080-it-may-be-in-use-or-require-sudo)	

# Jenkins Install

[马士兵bili](https://www.bilibili.com/video/BV1DB4y1U7Gz?p=12&vd_source=ca1d80d51233e3cf364a2104dcf1b743)	jenkins cn官网	[配置docker加速](https://cr.console.aliyun.com/cn-hangzhou/instances/mirrors)	[尚硅谷的安装方法](https://www.bilibili.com/video/BV1bS4y1471A?p=9&vd_source=ca1d80d51233e3cf364a2104dcf1b743)

```sh
#执行流程
jenkins从gitlab把代码拉下来（clone） 
Jenkins master把编译工作分成几个agent来执行(分步式)
04.55 agent（mvn）连接到nexus去下载依赖包，agent把编译好的jar包部署到web服务器


# 装java 
复制 F:\SSM\relevent soft\可用 jdk11 jre9 tomcat9\jdk-11.0.14_linux-x64_bin.rpm 到/root
rpm -i jdk-11.0.14_linux-x64_bin.rpm
# 用docker装jenkins
配置docker加速
编辑 /etc/docker/daemon.json ，加上
{
  "registry-mirrors": ["https://of79xv0k.mirror.aliyuncs.com"]
}

然后重启daemon
sudo systemctl daemon-reload
sudo systemctl restart docker
docker pull jenkins/jenkins


```







## 官网安装 Jenkins

[安装dnf](https://www.rootusers.com/how-to-install-dnf-package-manager-in-centosrhel/)	[官网linux安装](https://www.jenkins.io/doc/book/installing/linux/)	[官网docker安装](https://www.jenkins.io/doc/book/installing/docker/)

```sh
# 安装dnf
yum install epel-release -y
yum install dnf -y

sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key
sudo dnf upgrade
# Add required dependencies for the jenkins package
sudo dnf install java-11-openjdk
sudo dnf install jenkins


# 初始密码位置
/root/.jenkins/secrets/initialAdminPassword
ced957d4e4b041c5b623df74fbbcc0d1



```



