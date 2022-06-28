

```sh
Console: http://193.169.0.3:30880
Account: admin
Password: P@88w0rd
999Zzz...
```



# 多租户

```sh
左上角 Platform- Access Control- Account- create account
hr-zhang	user-manager		可添加用户
boss-li		workspaces-manager	可创建workspace
```



# mysql

[bili](https://www.bilibili.com/video/BV13Q4y1C7hS?p=80&vd_source=ca1d80d51233e3cf364a2104dcf1b743)	[docker mysql](https://registry.hub.docker.com/_/mysql)	[yuque笔记](https://www.yuque.com/leifengyang/oncloud/vgf9wk)	

```sh

docker run -p 3306:3306 --name mysql-01 \
-v /mydata/mysql/log:/var/log/mysql \	#里面的/var/log/mysql挂载到外面的/mydata/mysql/log
-v /mydata/mysql/data:/var/lib/mysql \
-v /mydata/mysql/conf:/etc/mysql/conf.d \
-e MYSQL_ROOT_PASSWORD=root \
--restart=always \
-d mysql:5.7 
```

