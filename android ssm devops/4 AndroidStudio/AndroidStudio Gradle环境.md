Project Sturcture

```sh
Project Sturcture
Project		7.3.1	 7.4
SDK Location 	F:\AndroidSDK

Modules		
compileSdkVersion: 33
Build Tools Version 33.0.1
Source Compatibility 	$JavaVersion.VERSION_11
Traget Compatibility	$JavaVersion.VERSION_11

```



Gradle

```
implementation 'androidx.appcompat:appcompat:1.5.1'
```



填坑

```sh
环境变量配置的名字必须是 ANDROID_HOME ， 改了名字AS就会报错
```



日志乱码

```sh
1 编辑 D:\AS\bin\studio64.exe.vmoptions
最后加上一句 -Dfile.encoding=UTF-8
2 Setting， File Encodings, 设置三个地方utf-8
```

