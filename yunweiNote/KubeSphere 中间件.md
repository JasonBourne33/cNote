

# Redis

```sh
#docker 命令
mkdir -p /mydata/redis/conf && vim /mydata/redis/conf/redis.conf
appendonly yes
port 6379
bind 0.0.0.0

docker run -d -p 6379:6379 --restart=always \
-v /mydata/redis/conf/redis.conf:/etc/redis/redis.conf \
-v /mydata/redis-01/data:/data \
--name redis-01 redis:6.2.5 \
redis-server /etc/redis/redis.conf


# kubesphere
配置中心- 创建密匙- 名称redis-conf，下一步- 添加数据，key是 redis-conf，value是 
appendonly yes
port 6379
bind 0.0.0.0
应用负载，工作负载，有状态副部级，创建，名称his-redis，下一步，搜 redis ，使用默认端口，选启动命令，运行命令 redis-server ， 参数 /etc/redis/redis.conf ,选同步主机时区,√，下一步，添加存储券模板，名称 redis-pvc ，下面的挂载路径，选 读写，目录 /data，选 挂载配置文件和密匙，选 redis-conf，只读， /etc/redis, √，下一步，创建
```

