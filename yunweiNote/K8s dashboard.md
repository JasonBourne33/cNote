

```sh
#部署
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.3.1/aio/deploy/recommended.yaml

#设置访问端口
kubectl edit svc kubernetes-dashboard -n kubernetes-dashboard
```

