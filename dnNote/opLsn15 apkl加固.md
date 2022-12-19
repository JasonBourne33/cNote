

使用	Lsn11  p1  28.55 ， p2  42.40  49.05

[谷歌文档](https://developer.android.google.cn/studio/command-line/apksigner?hl=zh-cn)	

```sh
1）Yi项目里 右键，new， Module， Android Library， proxy_core
右键，new， Module， Java or Kotlin Library， proxy_tools

2）把Lsn15 的 proxy_core和 tools 的类分别复制到Yi里对应的 module下

3）Yi的 Appllication 标签下，把名改了android:name="com.example.proxy_core.ProxyApplication"
下面加入两个 meta-data 标签 app_name的value就是原来Application的name
<!--真实的Application的全名-->
        <meta-data android:name="app_name" android:value="com.example.administrator.lsn_11_demo.MyApplication"/>
        <!--用于dex后的目录名_版本号-->
        <meta-data android:name="app_version" android:value="\dexDir_1.0"/>
        
4）右边Gradle，proxy_core， build， assemble， build
proxy_tools， 执行 main方法
app包，build，outputs，apk，debug，temp下有发布的包


```







































[源码网页版](https://www.androidos.net.cn/android/6.0.1_r16/xref/libcore/dalvik/src/main/java/dalvik/system/DexPathList.java)	androidref.com

```sh
OpLsn11 p01 18.20
找源码
PathClassLoader extends BaseDexClassLoader, 点进 BaseDexClassLoader
DexPathList dexPathList, 点进  DexPathList
findClass()方法里 for (Element element : dexElements)  的 dexElements 就是 dex文件的数组
把我的class变成dex数组和 dexElements 合并
dexElements的初始化在 makePathElements
通过调用makePathElements 得到dexElements 再和我的合并
```



```sh
添加依赖
app， Project Structure， app， Dependencies， +， proxy_core, 

35.00
AndroidManifest.xml, 把开始的application 改成 core的 ProxyApplication
    <application
        android:name="com.example.proxy_core.ProxyApplication"
```

