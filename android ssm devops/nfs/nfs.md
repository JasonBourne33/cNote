

[bili](https://www.bilibili.com/video/BV13Q4y1C7hS?p=62&vd_source=ca1d80d51233e3cf364a2104dcf1b743)	[文档](https://www.yuque.com/leifengyang/oncloud/ctiwgo#ToC7Q)	

```sh
整理后的
1 两个node都执行
yum install -y nfs-utils

2 主节点
echo "/nfs/data/ *(insecure,rw,sync,no_root_squash)" > /etc/exports
mkdir -p /nfs/data
mkdir -p /nfs/data/nginx-pv
systemctl enable rpcbind --now
systemctl enable nfs-server --now
#配置生效
exportfs -r
exportfs

3、从节点
showmount -e 193.169.0.3
#执行以下命令挂载 nfs 服务器上的共享目录到本机路径 /root/nfsmount
mkdir -p /nfs/data

mount -t nfs 193.169.0.3:/nfs/data /nfs/data
# 写入一个测试文件
echo "hello nfs server" > /nfs/data/test.txt
exportfs




kubectl delete -f nginx.yaml
kubectl apply -f nginx.yaml


















































```



```sh
踩坑过程：
```

