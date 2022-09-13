# 

```sh



# smbms后台系统centos7集成版
调用流程举例：
1 应用端请求，比如 http://localhost:8080/ssm-crud/emps
2 到控制层 EmployeeController
3 到服务层 employeeService
4 映射层 employeeMapper，映射到具体的xml（resources文件下），解析
5 mysql数据库查询 或者 用redis缓存

Centos7环境部署：Jdk11, Jre9, Tomcat9, Nginx, Mysql, RabbitMQ（秒杀操作）， JMeter（压力测试）

# K8s 操作
部署 ingress（网关入口，分配请求） ，集群内部访问的ClusterIP，NodePort服务暴露，PVC存储持久卷，Configmap抽取配置


# devops Jenkins集成版
1 拉取代码 （私人仓库gitlab中）
2 编译
3 构建镜像
4 推送镜像 （阿里云，账号密码认证; Harbor私有镜像）

# devops kubesphere集成版
1 拉取代码（从gitee 或github 中，私人仓库gitlab中）
2 编译
3 构建镜像
4 推送镜像 （阿里云，账号密码认证; Harbor私有镜像）
5 部署到开发环境（或 部署到生产环境）

# kubesphere部署中间件
Nacos, MySQL, Redis, Sentinel, MongoDB, RabbitMQ, ElasticSearch（数据分析和检索）

# 技能
1 有VMware虚拟机，阿里云，腾讯云的centos系统的服务器搭建配置使用经验
2 有android开发经验，了解后台架构smbms，在服务器搭建mysql，tomcat环境，用以运行smbms后台系统，返回数据到用flutter架构做的前端显示
3 有原生安装，docker安装，Kubernetes 安装Jenkins，Redis的经验，理解其写法上对应的点，挂载配置持久卷和配置文件
4 有部署微服务经验,修改dockerfile上传到适合生产环境使用的Nacos，有用 Kubesphere 部署过的中间件 Nacos, MySQL, Redis, Sentinel, MongoDB, RabbitMQ, ElasticSearch
5 有较强独立解决问题的能力，可在 StackOverflow，软件官网（理解原理），Github里的issue 寻找解决问题的方法
```











```sh
# 集群jenkins 的方式 运行流程
Jenkins master控制代理节点，让代理节点控制流水线的构建
```

