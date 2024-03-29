  

[kubesphere all in one](https://kubesphere.com.cn/docs/v3.3/quick-start/all-in-one-on-linux/)	点上面文档中心，选最新版本的文档来看，避免旧版本启用踩坑



[bili](https://www.bilibili.com/video/BV13Q4y1C7hS?p=106&vd_source=ca1d80d51233e3cf364a2104dcf1b743)	[尚医通gitee](https://gitee.com/leifengyang/yygh-parent)	[queyu笔记](https://www.yuque.com/leifengyang/oncloud/bp7pnm)

```sh
https://gitee.com/leifengyang/yygh-parent
https://gitee.com/leifengyang/yygh-admin
https://gitee.com/leifengyang/yygh-site


#打包的sentinel
hub.docker.com/r/leifengyang/sentinel




```



# devops 安装

 [51](https://blog.51cto.com/wutengfei/3264097#:~:text=%E5%AE%89%E8%A3%85%20kubesphere%20%EF%BC%8C%E5%90%AF%E7%94%A8%20KubeSphere%20DevOps%20%E7%B3%BB%E7%BB%9F%E3%80%82%20%E9%9C%80%E8%A6%81%E6%9C%89%E4%B8%80%E4%B8%AA%20Docker,%E9%9C%80%E8%A6%81%E5%88%9B%E5%BB%BA%E4%B8%80%E4%B8%AA%E4%BC%81%E4%B8%9A%E7%A9%BA%E9%97%B4%E3%80%81%E4%B8%80%E4%B8%AA%20DevOps%20%E5%B7%A5%E7%A8%8B%E5%92%8C%E4%B8%80%E4%B8%AA%E5%B8%90%E6%88%B7%20%28project-regular%29%EF%BC%8C%E5%BF%85%E9%A1%BB%E9%82%80%E8%AF%B7%E8%AF%A5%E5%B8%90%E6%88%B7%E8%87%B3%20DevOps%20%E5%B7%A5%E7%A8%8B%E4%B8%AD%E5%B9%B6%E8%B5%8B%E4%BA%88%20operator%20%E8%A7%92%E8%89%B2%E3%80%82)	[cn](https://www.cnblogs.com/cjsblog/p/13100301.html)	[cn2](https://blog.csdn.net/sinat_33404263/article/details/108746718)	

```sh
#访问 http://193.169.0.3:30880/
Console: http://193.169.0.3:30880
Account: admin
Password: P@88w0rd
999Zzz...

vim devops-deploy.yaml
kubectl apply -f devops-deploy.yaml
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
curl -sfL `https://get-kk.kubesphere.io` | VERSION=v2.2.1 sh -
#这里一直没反应就直接网页打开https://get-kk.kubesphere.io 下载好
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

#单节点配置好后想添加一个节点（修改config-sample，加上node1）
./kk add nodes -f config-sample.yaml
#删除节点node1
./kk delete node node1 -f config-sample.yaml
```















# dockerfile 上生产环境的 nacos

[bili](https://www.bilibili.com/video/BV13Q4y1C7hS?p=111&spm_id_from=pageDriver&vd_source=ca1d80d51233e3cf364a2104dcf1b743)	

```sh
# 访问地址
 
账号密码 nacos, nacos
修改后的配置文件存在 F:\cNote\yunweiNote\DEFAULT_GROUP
F:\cNote\yunweiNote对着 DEFAULT_GROUP 压缩成zip，
193.169.0.3:32716/nacos 登陆nacos，然后import，选DEFAULT_GROUP导入

ConfigManagement, Configuration, +, service-cmn-prod.yaml,
Idea里，复制 yygh-parent\service\service-cmn\src\main\resources\application-dev.yml 内容 ,改
port: 8080
dashboard: his-sentinel.his:8080
host: his-redis.his:6379
url: jdbc:mysql://his-mysql.his:3306/yygh_cmn?characterEncoding=utf-8&useSSL=false
publish

+， service-hosp-prod.yaml
Idea里，复制 service-hosp\src\main\resources\application-dev.yml 内容 ,改
port: 8080
host: mongodb.his
dashboard: his-sentinel.his:8080
url: jdbc:mysql://his-mysql.his:3306/yygh_hosp?characterEncoding=utf-8&useSSL=false
host: rabbitmq.his
host: his-redis.his

+， service-order-prod.yaml
Idea里，复制 service-order\src\main\resources\application-dev.yml 内容 ,改
port: 8080
dashboard: his-sentinel.his:8080
url: jdbc:mysql://his-mysql.his:3306/yygh_hosp?characterEncoding=utf-8&useSSL=false
host: rabbitmq.his
host: his-redis.his

+， service-oss-prod.yaml
Idea里，复制 service-oss-order\src\main\resources\application-dev.yml 内容 ,改
port: 8080, sentinel, 

+， service-sms-prod.yaml
Idea里，复制 service-sms-order\src\main\resources\application-dev.yml 内容 ,改
port: 8080, sentinel, rabbitmq, redis

+， service-statistic-prod.yaml
Idea里，复制 service-statistic-order\src\main\resources\application-dev.yml 内容 ,改
port: 8080, sentinel

+， service-task-prod.yaml
port: 8080, sentinel, rabbitmq

+， service-user-prod.yaml
port: 8080, sentinel, mysql

+， service-gateway-prod.yaml
port: 8080, 删掉nacos

直接改 hospital-manage
F:\yunweiProject\yygh-parent\hospital-manage\src\main\resources\application-prod.yml
改 redis,mysql
```



| 中间件        | 集群内地址            | 外部访问地址                                          |
| ------------- | --------------------- | ----------------------------------------------------- |
| Nacos         | his-nacos.his:8848    | [http://193.169.0.3:30349/](http://193.169.0.3/)nacos |
| MySQL         | his-mysql.his:3306    | [193.169.0.3](http://193.169.0.3):32012               |
| Redis         | his-redis.his:6379    | [193.169.0.3](http://193.169.0.3):30727               |
| Sentinel      | his-sentinel.his:8080 | http://193.169.0.3:32212/                             |
| MongoDB       | mongodb.his:**27017** | [193.169.0.3](http://193.169.0.3):32766               |
| RabbitMQ      | rabbitmq.his:5672     | [193.169.0.3](http://193.169.0.3):31215               |
| ElasticSearch | his-es.his:9200       | [193.169.0.3](http://193.169.0.3):30054               |







# Devops 和 Jenkins, Pipeline

[bili](https://www.bilibili.com/video/BV13Q4y1C7hS?p=112&vd_source=ca1d80d51233e3cf364a2104dcf1b743)	[gitee yygh](https://gitee.com/leifengyang/yygh-parent)	[jinkens安装](https://kubesphere.com.cn/en/docs/v3.3/faq/devops/install-jenkins-plugins/)	[aliyun 镜像仓库](https://cr.console.aliyun.com/cn-hangzhou/instance/credentials)

> ```sh
> # DevOps
> DevOps Projects， create, his-devops
> his-devops, Pipelines, create, yygh-parent-devops, create
> # 创建Pipeline模板
> yygh-parent-devops, Edit Pipeline, Continuous Integration & Delivery(视频中旧版)
> yygh-parent-devops, Edit Pipeline, Maven, 
> Agent, node, maven
> # 1 拉取代码
> 选Clone repository, add step, container, name：maven , Add nesting steps, git, create credential
> gitee-id , username and password, JasonBourne233, leftSniperg33, 
> https://gitee.com/jasonbourne233/yygh-parent, gitee-id, master
> # 打印
> Add nesting steps, shell, ls -al , ok
> 
> # 配置maven镜像
> Cluster Manager, Configuration， Configmaps, ks-devops-agent， Edit Settings, 
> 找到mirror，加上阿里云的
>     <mirror>
>       <id>ali</id>
>       <name>aliyun</name>
>       <url>http://maven.aliyun.com/nexus/content/groups/public/</url>
>       <mirrorOf>central</mirrorOf>
>     </mirror>
>     
> # 2 编译项目
> Run compile, add step, container, Add nesting steps, shell, ls -al , ok
> Add nesting steps, shell, mvn clean package -Dmaven.test.skip=true , ok
> Add nesting steps, shell, ls hospital-manage/target
> 
> # 3 编译项目 Build Image
> 名字 hospital-manage image, add step, container, maven, 
> Add nesting steps, shell, ls hospital-manage , ok
> Add nesting steps, shell, 
> docker build -t hospital-manage:v1 -f hospital-manage/Dockerfile ./hospital-manage/ , ok
> 其他的微服务也是这样
> idea， stage('default-2')
> sh 'ls server-gateway/target'
> sh 'docker build -t server-gateway:latest -f server-gateway/Dockerfile  ./server-gateway/'
> sh 'ls service/service-cmn/target'
> sh 'docker build -t service-cmn:latest -f service/service-cmn/Dockerfile  ./service/service-cmn/'
> sh 'ls service/service-hosp/target'
> sh 'docker build -t service-hosp:latest -f service/service-hosp/Dockerfile  ./service/service-hosp/'
> 
> # 4 push image  9:10添加凭证
> 选中 推送hospital-manage镜像， withCredentials, Create Credential, 
> aliyun-docker-registry, Username and password, admin, Harbor12345, ok
> aliyun-docker-registry, DOCKER_PWD_VAR, DOCKER_USER_VAR
> 
> 
> # 5 deploy to dev  6:30创建凭证
> 选中 5 hospital-manage - 部署到dev环境，kubernetesDeploy, Create Credential, 
> demo-kubeconfig, kubeconf, 默认Content， ok
> "$KUBECONFIG_CREDENTIAL_ID" ， hospital-manage/deploy/** 
> 
> 在his项目里面，Configuration, Secrets, create, aliyun-docker-hub , next
> Image registry information, registry.cn-hangzhou.aliyuncs.com , aliyun4520815170 , lSa3 
> 
> #5.2内存不够，maven要等很久
> kubectl get pod -A|grep maven
> kubectl describe pod -n kubesphere-devops-worker       maven-14hng
> kubectl top pods -A
> kubectl top nodes
> #5.3文件编码
> idea，setting, file encoding, 全改成utf-8
> 因为 F:\yunweiProject\yygh-parent\server-gateway\Dockerfile 
> 里 -Dfile.encoding=utf8
> 
> echo "Harbor12345" | docker login $REGISTRY -u "admin" --password-stdin
> docker login "193.169.0.4" -username "admin" --password "Harbor12345"
> 
> 
> 
> 
> #以前打包用的命令
> idea， terminal, mvn clean package -Dmaven.test.skip=true , 
> 
> # Fork项目
> Fork yygh-parent 到我自己的， 进 https://gitee.com/leifengyang/yygh-parent ，右上角fork
> https://gitee.com/jasonbourne233/yygh-parent
> 
> # 在run的时候会让jenkins出错（重启 warning 变黄）
> 原因：默认资源被限制了，不够用
> Platform, ClusterManagement, Application Workloads, Workloads, devops-jenkins, 
> More, Edit Setting, Containers, cpu和Memory Limit 改大一点（改成无限会爆满服务器死机）
> 启动不了的，一直在重启的pod，可以把cpu和内存改大一点
> ```
>







# GitLab

[gitlab bili 41](https://www.bilibili.com/video/BV1vy4y1s7k6?p=41&vd_source=ca1d80d51233e3cf364a2104dcf1b743)		[gitlab下载](https://packages.gitlab.com/gitlab/gitlab-ce)	[gitlab改端口](https://www.jianshu.com/p/35698999cf44)

```sh
下载到rpm到 F:\yunwei\relevent soft\gitlab-ce-15.1.5-ce.0.el7.x86_64.rpm
拖到 node1 的~
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
gitlab-ctl reconfigure
gitlab-ctl start
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











# 上传镜像到docker

 ```sh
 
 ```

























# Jenkins dashboard

[登陆密码踩坑](https://blog.csdn.net/CSDN877425287/article/details/108577735)	[登录密码 kubesphere官方](https://v2-1.docs.kubesphere.io/docs/zh-CN/devops/jenkins-setting/)	

```sh
http://193.169.0.3:30180/
用dashboard装的，admin，密码9Z.(KubeSphere 集群管理员的密码)
左边Manage Jenkins, Plugin Manager, 




米国
台积电，中期选举，sleepy joe和大大通电话已经完成交易，

兔子
大大想在20big 连任，土地财政压力，正常battle不可能直播还要真正的物资部署，直播为了制造恐惧
```











# 1 RabbitMQ ， Bitnami

[bitnami bili](https://www.bilibili.com/video/BV13Q4y1C7hS?p=85&vd_source=ca1d80d51233e3cf364a2104dcf1b743)	

```sh
#RabbitMQ (这是视频里发办法，不好用)
top left App Store, RabbitMQ, Install, Next, Data Persistenc Enabled, Root Password is admin , install
Application Workloads, Service, 再 rabbitmq 右边三点, Edit External Access, NodePort,
15672对应的就是端口
访问 http://193.169.0.3:32658/

#RabbitMQ ，我自己手动的
Application Workloads, Workloads, Statefulsets, name is rabbitmq, next, 
Add Contener, search rabbitmq , Synchronize Host Timezone, next, create
#集群内部的service
Services，create, Specify Workload, rabbitmq , 
Internal Domain Name, rabbitmq, http-5672, Container is 5672, Service Port is 5672,
next, create
#暴露给外网访问的service
Services, create, Specify Workload, name is rabbitmq-node, Virtual IP Address, Specify Workload, Statefulsets, rabbitmq, Name is http-5672, Container is 5672, Service Port is 5672, next,
External Access, NodePort, 


# Bitnami
App Management, App Respositories, name is bitnami, charts.bitnami.com/bitnami, Validate

# Zookeeper
Application Workloads, Apps, create, bitnami, Zookeeper, next, Install


```



# 2 sentinel & mangoDB

​	[mongo bili](https://www.bilibili.com/video/BV13Q4y1C7hS?p=109&vd_source=ca1d80d51233e3cf364a2104dcf1b743)	[官方 应用模板](https://kubesphere.io/zh/docs/v3.3/project-user-guide/application/deploy-app-from-template/#%E6%AD%A5%E9%AA%A4-1%E6%B7%BB%E5%8A%A0%E5%BA%94%E7%94%A8%E4%BB%93%E5%BA%93)	[mysql 官方](https://kubesphere.com.cn/docs/v3.3/application-store/built-in-apps/mysql-app/#%E6%AD%A5%E9%AA%A4-3%E4%BB%8E%E9%9B%86%E7%BE%A4%E5%A4%96%E8%AE%BF%E9%97%AE-mysql-%E6%95%B0%E6%8D%AE%E5%BA%93)	

```sh
从企业空间点击项目里，应用负载，服务，创建，有状态服务，名称是his-sentinel,下一步，搜leifengyang/sentinel:1.8.2，拉下去选 同步主机时区，下一步，下一步，创建
服务，创建，指定工作负载创建服务，名称是his-sentinel-node,下一步，指定工作负载，有状态副本集，选his-sentinal-v1 ,名称是 http-8080，容器端口和服务端口都是 8080，下一步，选外部访问，NodePort，创建
看到外网访问的端口是 32333
访问  193.169.0.3:32333
账号，密码都是 sentinal

#添加应用模板
点进his的企业空间，左边 应用管理，应用仓库，添加，名称 bitnami，将应用仓库的 URL 设置为 https://helm-chart-repo.pek3a.qingstor.com/kubernetes-charts/  ，同步间隔 3000s，确定

#mangoDB 安装
应用负载，应用，创建，从应用模板，选 bitnami，搜mangodb，右边安装，
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











# 3 nacos上云, 数据库迁移(ry_cloud)

[bili 数据库迁移](https://www.bilibili.com/video/BV13Q4y1C7hS?p=90&vd_source=ca1d80d51233e3cf364a2104dcf1b743)	[bili nacos](https://www.bilibili.com/video/BV13Q4y1C7hS?p=91&vd_source=ca1d80d51233e3cf364a2104dcf1b743)	

```sh
#数据迁移 用workbench
Migtation, Source Selection, 填好本地的，localhost:3306, Test Connection， next, 
在Target Selection 填好ks的，193.169.0.3:31035  , Test Connection, next,
在 Sechemas Selection 里选 ry-cloud,ry-config,ryseata 


#nacos 服务创建
Service, StatefulService, his-nacos,  nacos/nacos-server:v2.0.3 ,
http-8848, 8848, 8848, 同步主机时区
ping his-nacos.his
复制 his-nacos-v1-0.his-nacos.his.svc.cluster.local 到 config.cluster

#nacos上云 配置文件 (F:\yunwei\nacos\conf)
Configuration, Configmaps, create，nacos-conf, add data
key is application.proerties, value is content inside, 
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
Application Workloads, Services, create, Specify Workload, his-nacos-node, Specify Workload, his-nacos-v1, 
http-8848, 8848, 8848，
External Access, NodePort

# 访问地址
http://193.169.0.3:32716/nacos
账号密码 nacos, nacos

# log 出现Error creating bean with name 'memoryMonitor' defined in URL
重新create his-nacos，可能是application.properties对mysql数据库没配置文件没更新到

```









# 4 mysql kubesphere(ry_cloud)

[bili mysql](https://www.bilibili.com/video/BV13Q4y1C7hS?p=80&vd_source=ca1d80d51233e3cf364a2104dcf1b743)	

```sh
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

# 直接在下面配置就不用这个了
Storage, Persistent Volume Claims, create, next, name is mysql-pvc,next, create

#pod里的 配置文件目录/etc/mysql/conf.d
Application Workloads, Workloads, Statefulsets, name is his-mysql, next, 
Add Contener, search mysql:5.7.35 , (1cpu,2000m memory),Use Default Ports,, enable Environment Variables, key is MYSQL_ROOT_PASSWORD , value is 123456, enable Synchronize Host Timezone, check,next, 
Add Persistent Volume Claim Template , mysql-pvc , Read and write, Mount path is /var/lib/mysql, check, 
Mount Configmap or Secret, select mysql-conf, select Read-only, /etc/mysql/conf.d , next, create

#集群内部的service
Services, 删掉 his-mysql-oi46 ，create, his-mysql , 
Internal Domain Name, his-mysql, http-3306, Container is 3306, Service Port is 3306,
next, create
mysql -uroot -hhis-mysql.his -p 	#测试
#暴露给外网访问的service
Services, Specify Workload, name is his-mysql-node, Virtual IP Address, Specify Workload, Statefulsets, his-mysql, Name is http-3306, Container is 3306, Service Port is 3306, next,
External Access, NodePort, 
#用sqlyog连接193.169.0.3:31035
mysql -uroot -hhis-mysql-node.his -p
```







