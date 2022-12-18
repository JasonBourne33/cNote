

[his bili](https://www.bilibili.com/video/BV13Q4y1C7hS?p=80&vd_source=ca1d80d51233e3cf364a2104dcf1b743)	

```sh
# 配置mysql-conf
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

#pod里的 配置文件目录/etc/mysql/conf.d
Application Workloads, Workloads, Statefulsets, name is mysql, next, Add Contener, search mysql:5.7.35 , (1cpu,2000m memory),Use Default Ports,, enable Environment Variables, key is MYSQL_ROOT_PASSWORD , value is 123456, enable Synchronize Host Timezone, check,next, 
Add Persistent Volume Claim Template , Read and write, Mount path is /var/lib/mysql, check, 
Mount Configmap or Secret, select mysql-conf, select Read-only, /etc/mysql/conf.d  , next, create

#暴露给外网访问的service （删掉自动生成的）
Services , create, Specify Workload, name is mysql, next, select Virtual IP Address, Specify Workload, Statefulsets, mysql, OK, Name is http-3306, Container is 3306, Service Port is 3306, next,
External Access, NodePort, create
#用sqlyog连接193.169.0.3:30947
mysql -uroot -hhis-mysql-node.his -p
```

