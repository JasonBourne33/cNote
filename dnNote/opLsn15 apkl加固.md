

```sh
proxy_core 加密

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

