

[知乎源](https://zhuanlan.zhihu.com/p/502731000)

```sh
1.创建namespace，把mysql部署在单独的名称空间中
kubectl create namespace dev

2.创建持久卷PV，用来存储mysql数据文件
（1）定义一个容量大小为1GB的PV，挂载到/nfs/data/01目录，需手动创建该目录
mkdir -p /nfs/data/01
（2）编写mysql-pv.yaml文件内容，要创建的pv对象名称：pv-1gi
（3）创建该PV对象
kubectl create -f mysql-pv.yaml
（4）查看创建结果
kubectl describe pv pv-1gi


3.创建持久卷声明PVC
（1）编写mysql-pvc.yaml文件内容，要创建的pvc对象名称是：mysql-pvc
（2）创建该PVC对象
kubectl create -f mysql-pvc.yaml
（3）查看创建结果
kubectl get pvc -n dev


4.创建Secret对象用来保存mysql的root用户密码
（1）设置密码为123456，执行创建命令
kubectl create secret generic mysql-root-password --from-literal=password=123456 -n dev
(2）查看创建结果
kubectl get secret mysql-root-password -o yaml -n dev

5.创建Deployment和Service
（1）编辑mysql-svc.yaml文件内容
service使用NodePort类型，指定暴露的nodePort端口为31234，我们会在宿主机使用navicat客户端对mysql进行访问
（2）执行创建命令
kubectl create -f mysql-svc.yaml
（3）查看创建结果
kubectl get pod,svc -n dev
一直在pending
kubectl describe pod,svc -n dev
发现 1 node(s) had taint {node.kubernetes.io/unreachable: }, that the pod didn't tolerate.
kubectl describe node k8s-master
把node1 开了后显示
NAME                         READY   STATUS              RESTARTS   AGE
pod/mysql-8474cf8649-d9bx5   0/1     ContainerCreating   0          155m
kubectl describe pod,svc -n dev

```

