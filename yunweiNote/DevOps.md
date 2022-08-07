

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

#单节点配置好后想添加一个节点（修改config-sample，加上node1）
./kk add nodes -f config-sample.yaml
#删除节点node1
./kk delete node node1 -f config-sample.yaml
```







# sentinel & mangoDB

​	[mongo bili](https://www.bilibili.com/video/BV13Q4y1C7hS?p=109&vd_source=ca1d80d51233e3cf364a2104dcf1b743)	[官方 应用模板](https://kubesphere.io/zh/docs/v3.3/project-user-guide/application/deploy-app-from-template/#%E6%AD%A5%E9%AA%A4-1%E6%B7%BB%E5%8A%A0%E5%BA%94%E7%94%A8%E4%BB%93%E5%BA%93)	[mysql 官方](https://kubesphere.com.cn/docs/v3.3/application-store/built-in-apps/mysql-app/#%E6%AD%A5%E9%AA%A4-3%E4%BB%8E%E9%9B%86%E7%BE%A4%E5%A4%96%E8%AE%BF%E9%97%AE-mysql-%E6%95%B0%E6%8D%AE%E5%BA%93)	

```sh
#sentinel
从企业空间点击项目里，应用负载，服务，创建，有状态服务，名称是his-sentinel,下一步，搜leifengyang/sentinel:1.8.2，拉下去选 同步主机时区，下一步，下一步，create
创建服务，创建，指定工作负载创建服务，名称是his-sentinel-node,下一步，指定工作负载，有状态副本集，选his-sentinal-v1 ,名称是 http-8080，容器端口和服务端口都是 8080，下一步，选外部访问，NodePort，创建
看到外网访问的端口是 32212
访问  193.169.0.3:32212
账号，密码都是 sentinal


# Bitnami
App Management, App Respositories, name is bitnami, charts.bitnami.com/bitnami, Validate

#mangoDB 安装
应用负载，应用，创建，从应用模板，选test-repo，搜mangodb，版本10.30.12 [4.4.11]，右边安装，
名称mongodb，关掉Enable authentication，安装
#暴露外网访问服务
应用负载，服务，specify workload, 名称his-mongo-node,下一步，指定工作负载，选 mongodb，确定，协议选 TCP，名称tcp-27017，容器端口27017，服务端口27017，下一步，外部访问，NodePort，创建，点进 his-mongo-node，看到NodePort是端口号
#用 MongoDB Compass 连接
new Connection, Advanced Connection Options, Host:
home  193.169.0.3:30336
193.169.0.3:32766

#mysql 安装(仓库)
应用负载，应用，创建，从应用模板，选bitnami，搜 mysql，名称mysql，下一步，
在应用设置下，取消 mysqlRootPassword 字段的注解（默认testing，不能设置）
应用负载，服务，点 mysql，左边更多操作，选 编辑外部访问，选 NodePort，确定，看到NodePort
#用sqlyog访问，外网服务端口：
193.169.0.3:32012
root,testing
#初始化数据库
F:\yunweiProject\yygh-parent\data\sql 下所有的sql，拖进sqlyog，一个个全选执行
```



# dockerfile

[bili](https://www.bilibili.com/video/BV13Q4y1C7hS?p=111&spm_id_from=pageDriver&vd_source=ca1d80d51233e3cf364a2104dcf1b743)	

```sh
# 访问地址
http://193.169.0.3:31474/nacos
账号密码 nacos, nacos

ConfigManagement, COnfiguration, +, service-cmn-prod.yaml,
Idea里，复制 yygh-parent\service\service-cmn\src\main\resources\application-dev.yml 内容 ,改
port: 8080
dashboard: his-sentinel.his:8080
host: his-redis.his:6379
url: jdbc:mysql://his-mysql.his:3306/yygh_cmn?characterEncoding=utf-8&useSSL=false
publish

+， service-hosp-prod.yaml
Idea里，复制 yygh-parent\service\service-cmn\src\main\resources\application-dev.yml 内容 ,改
port: 8080
dashboard: his-sentinel.his:8080
url: jdbc:mysql://his-mysql.his:3306/yygh_hosp?characterEncoding=utf-8&useSSL=false
host: rabbitm-w0llqp-rabbitmq.his
host: his-redis.his

+， service-order-prod.yaml
Idea里，复制 yygh-parent\service\service-cmn\src\main\resources\application-dev.yml 内容 ,改
port: 8080
dashboard: his-sentinel.his:8080
url: jdbc:mysql://his-mysql.his:3306/yygh_hosp?characterEncoding=utf-8&useSSL=false
host: rabbitm-w0llqp-rabbitmq.his
host: his-redis.his

```



































# mysql kubesphere(ry_cloud)

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

Storage, Persistent Volume Claims, create, next, name is mysql-pvc,next, create

#pod里的 配置文件目录/etc/mysql/conf.d
Application Workloads, Workloads, Statefulsets, name is his-mysql, next, Add Contener, search mysql:5.7.35 , (1cpu,2000m memory),Use Default Ports,, enable Environment Variables, key is MYSQL_ROOT_PASSWORD , value is 123456, enable Synchronize Host Timezone, check,next, 
Add Persistent Volume Claim Template , Read and write, Mount path is /var/lib/mysql, check, 
Mount Configmap or Secret, select mysql-conf, select Read-only, /etc/mysql/conf.d ,Select Specific Keys , next, create

#暴露给外网访问的service
Services, Specify Workload, name is his-mysql, Virtual IP Address, Specify Workload, Statefulsets, his-mysql, Name is http-3306, Container is 3306, Service Port is 3306, next,
External Access, NodePort, 
#用sqlyog连接193.169.0.3:32012
mysql -uroot -hhis-mysql-node.his -p
```





# nacos上云, 数据库迁移(ry_cloud)

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
http://193.169.0.3:31474/nacos
账号密码 nacos, nacos


```

