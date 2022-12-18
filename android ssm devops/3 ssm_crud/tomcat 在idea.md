

```sh
 #安装包路径
F:\SSM\relevent soft\可用 jdk11 jre9 tomcat9\apache-tomcat-9.0.60-windows-x64.zip

#idea 里配置tomcat
Idea, Setting, Application Servers, +, tomcat server, D:\apache-tomcat-9.0.60

#idea运行测试
http://localhost:8080/ssm_crud_war/emps


```



[中文日志](https://www.cnblogs.com/miamianfighting/p/14061074.html)

```sh
打开到tomcat安装目录下的conf/文件夹 修改logging.properties文件，
找到 java.util.logging.ConsoleHandler.encoding = utf-8
更改为 java.util.logging.ConsoleHandler.encoding = GBK
```



