

[kubesphere all in one](https://kubesphere.com.cn/docs/v3.3/quick-start/all-in-one-on-linux/)	点上面文档中心，选最新版本的文档来看，避免旧版本启用踩坑



[bili](https://www.bilibili.com/video/BV13Q4y1C7hS?p=106&vd_source=ca1d80d51233e3cf364a2104dcf1b743)	[尚医通gitee](https://gitee.com/leifengyang/yygh-parent)	[queyu笔记](https://www.yuque.com/leifengyang/oncloud/bp7pnm)

```sh
https://gitee.com/leifengyang/yygh-parent
https://gitee.com/leifengyang/yygh-admin
https://gitee.com/leifengyang/yygh-site


#打包的sentinel
hub.docker.com/r/leifengyang/sentinel




```



# 安装

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



# sentinel & mangoDB

​	[mongo bili](https://www.bilibili.com/video/BV13Q4y1C7hS?p=109&vd_source=ca1d80d51233e3cf364a2104dcf1b743)	[官方 应用模板](https://kubesphere.io/zh/docs/v3.3/project-user-guide/application/deploy-app-from-template/#%E6%AD%A5%E9%AA%A4-1%E6%B7%BB%E5%8A%A0%E5%BA%94%E7%94%A8%E4%BB%93%E5%BA%93)	[mysql 官方](https://kubesphere.com.cn/docs/v3.3/application-store/built-in-apps/mysql-app/#%E6%AD%A5%E9%AA%A4-3%E4%BB%8E%E9%9B%86%E7%BE%A4%E5%A4%96%E8%AE%BF%E9%97%AE-mysql-%E6%95%B0%E6%8D%AE%E5%BA%93)	

```sh
#sentinel
从企业空间点击项目里，应用负载，服务，创建，有状态服务，名称是his-sentinel,下一步，搜leifengyang/sentinel:1.8.2，拉下去选 同步主机时区，下一步，下一步，create
创建服务，创建，指定工作负载创建服务，名称是his-sentinel-node,下一步，指定工作负载，有状态副本集，选his-sentinal-v1 ,名称是 http-8080，容器端口和服务端口都是 8080，下一步，选外部访问，NodePort，创建
看到外网访问的端口是 32212
访问  193.169.0.3:32212
账号，密码都是 sentinal

#添加应用模板
点进his的企业空间，左边 应用管理，应用仓库，添加，名称test-repo，将应用仓库的 URL 设置为 https://helm-chart-repo.pek3a.qingstor.com/kubernetes-charts/  ，同步间隔 3000s，确定
# Bitnami
App Management, App Respositories, name is bitnami, charts.bitnami.com/bitnami, Validate

#mangoDB 安装
应用负载，应用，创建，从应用模板，选test-repo，搜mangodb，版本10.30.12 [4.4.11]，右边安装，
名称mongodb，关掉Enable authentication，安装
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

