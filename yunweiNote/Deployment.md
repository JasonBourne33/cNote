

```sh
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

