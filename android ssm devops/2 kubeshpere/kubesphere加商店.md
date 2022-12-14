

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

