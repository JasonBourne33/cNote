

[官方doc 3.3.0](https://kubesphere.com.cn/docs/v3.3/quick-start/enable-pluggable-components/)	

```sh

Platform, Cluser Management, CRDs, search clusterconfiguration, Edit Yaml， 
openpitrix:
  store:
    enabled: true
```



[tomcat](https://kubesphere.io/docs/v3.3/application-store/built-in-apps/tomcat-app/#step-1-deploy-tomcat-from-the-app-store)	

```sh

App Store, Tomcat, install , 改名成tomcat，next, install
Application Workloads, Services, tomcat, More， Edit External Access, NodePort, OK, 

#Access the sample Tomcat project through <NodeIP>:<NodePort>/sample in your browser.
http://193.169.0.3:31679/sample
<NodeIP>:<NodePort>/sample
```



在kubesphere的 tomcat

```sh
#创建目录
mkdir /tomcatWebapp 

#挂载出来
Workloads， Edit YAML， 挂载出来
spec:
	template:
		spec:
			volumes:
                - name: app-volume
                  hostPath:
                    path: /tomcatWebapp
                    type: ''
OK


测试
http://193.169.0.3:31679/ssm-crud-0.0.1-SNAPSHOT/
http://193.169.0.3:31679/ssm-crud-0.0.1-SNAPSHOT/emps    
```

