

```sh
# 语雀云笔记
https://www.yuque.com/leifengyang/oncloud/ctiwgo
https://www.bilibili.com/video/BV13Q4y1C7hS?p=56&vd_source=ca1d80d51233e3cf364a2104dcf1b743
# https://193.169.0.3:32025/#/login
eyJhbGciOiJSUzI1NiIsImtpZCI6ImFRWldIV3NfQ21kcFVoUmF2ZmNIZEtnWlh3TDRwb2VIUnFlZVhqTjRudDQifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJrdWJlcm5ldGVzLWRhc2hib2FyZCIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VjcmV0Lm5hbWUiOiJhZG1pbi11c2VyLXRva2VuLXQ3NWw5Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQubmFtZSI6ImFkbWluLXVzZXIiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC51aWQiOiJlYmM5ZTFhNy0zMzYyLTRiNDEtODg4NS1lOTBiN2ZjMzQ0ODIiLCJzdWIiOiJzeXN0ZW06c2VydmljZWFjY291bnQ6a3ViZXJuZXRlcy1kYXNoYm9hcmQ6YWRtaW4tdXNlciJ9.Ch7yKEgVWwVm9Pc8xWRur00lif0IK9e29Gu9dugB7OTI65CFg5vxapfWGILvHVBOvG7CPgL1RnLvkTRzWaZBPJ3260hJS4L0nWFWIVy9Qx3amnycMa1yHv_W6F7yFbxw8tIZNJOajIHzDm8WosN4W02uXpJQA29noQztAunfHlyA34ZZRbbAHHMQl9bpsafIY6ygKt8shtt12-Iu9KOgB6hx8m87AwbNO8f7yC0oDB9vbYwSe0TrD9I08b81sHZKnzQeXk8hPkUYPl9KZT0Iig0IraRv2LzjIeHI4dudofkhwCwCf4ldVpKEVV35sWO__6WAplfPnbr5TVLZPpagDg

#传统的删法和创建
kubectl delete pod myapp mynginx -n default
kubectl run mynginx --image=nginx
#有自愈能力的deployment
kubectl create deployment mytomcat --image=tomcat:8.5.68
kubectl get pod
#验证
kubectl delete pod mynginx	#mynginx就没了
kubectl delete pod mytomcat-6f5f895f4f-djb5j	#会新起一个mytomcat-6f5f895f4f-zdp9h
#如果要真的删除
kubectl get deploy
kubectl delete deploy mytomcat
#部署三份
kubectl create deploy my-dep --image=nginx --replicas=3
kubectl get deploy
kubectl delete deploy my-dep
#部署5份会分给两台node服务器
kubectl create deploy my-dep-01 --image=nginx --replicas=5
kubectl delete deploy my-dep-01 
#用yaml
vi nginx_r5.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: my-dep
  name: my-dep
spec:
  replicas: 5
  selector:
    matchLabels:
      app: my-dep
  template:
    metadata:
      labels:
        app: my-dep
    spec:
      containers:
      - image: nginx
        name: nginx
kubectl apply -f nginx_r5.yaml



```



扩缩容量 scale

```sh
#扩成5份（原来3份，流量高峰的时候扩容）
kubectl scale deploy/my-dep --replicas=5
#缩成2份
kubectl scale deploy/my-dep --replicas=2

#模拟故障	https://www.bilibili.com/video/BV13Q4y1C7hS?p=50&spm_id_from=pageDriver
kubectl get pod -0wide	#如果在node2，就去node2
docker ps|grep my-dep-5b7868d854-2p6v2	
docker stop cad46c2e05d2
#返回master 看已经completed，然后过一会等自愈，变running
kubectl get pod -owide

#滚动更新 (先创建，后删掉旧的，一个接着一个地更新)
kubectl get deploy my-dep -oyaml
kubectl set image deploy/my-dep nginx=nginx:1.16.1 --record
kubectl set image deployment/my-dep nginx=nginx:1.16.1 --record

#回滚版本
kubectl rollout history deployment/my-dep
#查看某个历史详情
kubectl rollout history deployment/my-dep --revision=2 
#回滚(回到上次)
kubectl rollout undo deployment/my-dep
kubectl get pod -w
kubectl get deploy/my-dep -oyaml|grep image
#回滚(回到指定版本)
kubectl rollout undo deployment/my-dep --to-revision=2

#service实验，分别在三个nginx里（在dashboard里操作）
cd /usr/share/nginx/html/
echo 1111 > index.html
echo 2222 > index.html
echo 3333 > index.html
#回到master里 
kubectl get pod -owide
curl 192.168.140.77:80
curl 192.168.140.78:80
curl 192.168.140.79:80
# 用8000端口代替80端口暴露在外(默认不写是type=ClusterIp，只能集群内访问)
kubectl expose deploy my-dep --port=8000 --target-port=80
kubectl get service
curl 10.96.57.147:8000 		#连续多次会发现有1111，2222，3333，这就是一个负载均衡的访问

# nodeport模式，集群外也可以访问
kubectl expose deploy my-dep --port=8000 --target-port=80 --type=NodePort
# 操作青云开放公网端口 30000~32767，再通过公网IP访问  bilibili p56
# 安装ingress 	去云笔记把ingress.yaml 的内容复制到
vi ingress.yaml
kubectl apply -f ingress.yaml

# 处理http的  	http://193.169.0.3:31651
# 处理https的 	https://193.169.0.3:32583/


#开始测试
# 去 https://www.yuque.com/leifengyang/oncloud/ctiwgo 复制测试用的yaml
vi test.yaml
kubectl apply -f test.yaml
kubectl get svc 
curl 10.96.5.185:8000		#访问nginx-demo的
curl 10.96.225.218:8000		# hello-server 的

```

