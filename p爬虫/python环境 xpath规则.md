安装xpath	

[xpath 匹配规则](https://www.bilibili.com/video/BV1Db4y1m7Ho/?p=70&spm_id_from=pageDriver&vd_source=ca1d80d51233e3cf364a2104dcf1b743)	

```sh
F:\pyProject\xpath.zip 拖到 chrome 的extension里
在任意网页按 ctrl+shift + x 打开
在 F:\python3.9\Scripts 里打开cmd，安装lxml
pip install lxml -i https://pypi.douban.com/simple
在任意py文件头上面加上 from lxml import etree ，如果不报错就是安装成功了
```



[安装twisted](https://www.bilibili.com/video/BV1Db4y1m7Ho/?p=90&vd_source=ca1d80d51233e3cf364a2104dcf1b743)	

 ```sh
 在cmd 打python --version，看版本 3.9.0
 要先安装twisted
 https://www.lfd.uci.edu/~gohlke/pythonlibs/#twisted  搜twisted, 
 现在twisted只支持到 python3.9
 下载 Twisted-20.3.0-cp39-cp39-win_amd64.whl
 如果要
 python -m pip install --upgrade pip
 安装tewisted
 pip install F:\pyProject\Twisted-20.3.0-cp39-cp39-win_amd64.whl
 
 pip install scrapy
 
 
 ```



基础使用

```sh
创建项目 scrapy_baidu_091
scrapy startproject scrapy_baidu_091
进入spiders文件夹，创建要爬取的链接 www.baidu.com
scrapy genspider baidu www.baidu.com
运行这个爬虫
scrapy crawl baidu
```

58同城

```sh
scrapy startproject scrapy_58tc_092
scrapy genspider tc https://bj.58.com/sou/?key=%E5%89%8D%E7%AB%AF%E5%BC%80%E5%8F%91&classpolicy=classify_B
scrapy crawl tc
```





[层层相套的爬取](https://www.bilibili.com/video/BV1Db4y1m7Ho?p=99&vd_source=ca1d80d51233e3cf364a2104dcf1b743)	电影天堂dytt

```sh
F:\pyProject , 右键 cmd，
scrapy startproject scrapy_dytt_099
scrapy genspider mv https://www.ygdy8.net/html/gndy/oumei/index.html
scrapy crawl mv


```



















[目标 glassBong](https://sinoicglass.manufacturer.globalsources.com/showroom_6008854096487/glass-bong_115021-1.htm)	



idea 配置python

```sh
Project Structure or press Ctrl+Alt+Shift+S. ， SDKs， + ，ADD python SDK， 
System Interpreter，F:\python3.11\python.exe

右键， run 
```



```sh
豆瓣250源项目  F:\pythonProject1
forexfactory的 F:\pyForex

```



