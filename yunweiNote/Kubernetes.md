在seckill项目里创建 Dockerfile

把target和Dockerfile放入aaa文件中传到linux的root

cd /root/aaa/
执行命令

```sh
docker build -t seckill:v1.0 -f Dockerfile . 
```

docker images		查看

启动

 ```sh
 docker run -d -p 8080:8080  seckill:v1.0 \
 --name=seckill
 ```

docker rm -f 













踩坑
1 启动时爆错 8080接口已经用了
netstat -tnlp 	杀掉占用的的进程
kill -[pid]
