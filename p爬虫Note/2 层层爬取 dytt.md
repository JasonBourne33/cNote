



[层层相套的爬取](https://www.bilibili.com/video/BV1Db4y1m7Ho?p=99&vd_source=ca1d80d51233e3cf364a2104dcf1b743)	电影天堂dytt

```sh
F:\pyProject , 右键 cmd，
scrapy startproject scrapy_dytt_099
scrapy genspider mv https://www.ygdy8.net/html/gndy/oumei/index.html

scrapy crawl mv

1 不能识别span 标签
//div[@class="co_content8"]//img[1]/@src
2 -t crawl 是创建能爬取各页的项目，项目里会继承CrawlSpider 
#scrapy genspider -t crawl mv https://www.ygdy8.net/html/gndy/oumei/index.html
class MvSpider(CrawlSpider):
```





sonicglass 爬取

```sh
F:\pyProject , 右键 cmd，
scrapy startproject scrapy_sonic
进入spider文件夹下
scrapy genspider ssonic https://sinoicglass.manufacturer.globalsources.com/showroom_6008854096487/glass-bong_115021-1.htm
scrapy crawl ssonic




start_urls = ['https://sinoicglass.manufacturer.globalsources.com/showroom_6008854096487/glass-bong_115021-1.htm'] #烟枪

#前路径，主div  //div[@class="product-lsit-box"]/div/ul/li/a/
#第一页图片 //div[@class="mod-prod-img"]/img/@src
#第一页标题 //div[@class="mod-prod-info"]/div[@class="tit"]/span/text()
#第二页的链接  //div/ul[@class="product-list"]/li/a/@href
#第二页的产品编号 //div[@id="Product" and @class="descriptions"]//table/tbody/tr[1]/td[@class="ant-descriptions-item-content"]/text()

```















[目标 glassBong](https://sinoicglass.manufacturer.globalsources.com/showroom_6008854096487/glass-bong_115021-1.htm)	



idea 配置python

```sh
Project Structure or press Ctrl+Alt+Shift+S. ， SDKs， + ，ADD python SDK， 
System Interpreter，F:\python3.11\python.exe

右键， run 
```

