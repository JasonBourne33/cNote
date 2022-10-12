

华为手机调试的时候每次都提示第三方应用
设置，安全，更多安全设置，取消掉 外部来源应用检查 ，



## Power Designer



```sh
#创建类图
New Model, Categories, Application, Class Diagram

#添加接口，方法 Lsn01 56.20
1）接口 Interface，双击Interface，Operations 添加方法  ，Preview看代码， Attributes 成员变量， 

2）实现接口的类 Class，（Realization 虚线）implement 实现 Interface ，双击Class，Operations，Unimplemented Operations ， 

3）继承类的类 Class，（Generalization ）extend 继承 父类

依赖（Dependency）：一个类的实现需要另一个类的协助
关联（Association）：	01.18.00

去掉注释 01.31.25 
上面 Language , Edit Current Object Language, Generation, Options, J2EE, GenerateOID, 选no
正向工程
上面 Language， generate java code


```



## UEStudio

[bili 基础技巧](https://www.bilibili.com/video/BV1us41167Tk/?spm_id_from=333.337.search-card.all.click&vd_source=ca1d80d51233e3cf364a2104dcf1b743)	

```sh
F:\p破解
ALT+C 列模式，直接编辑列
```



## AS 发癫

```sh
1 在main方法的时候 SourceSet with name 'main' not found.
在.idea里 gradle.xml里 <GradleProjectSettings>标签里加上 <option name="delegatedBuild" value="false" />
2 在main方法的时候 Failed to find Build Tools revision 30.0.2
快捷键 Ctrl Alt Shift + S ， Modules， Build Tools Version 找能用的 30.0.3
快捷键 Ctrl Alt + S , 搜SDK, SDK Tools, Show Package details, 安装30.0.3

festival的
nowaday=== Wed Jul 19 00:00:00 CST 2017
nowadaygetTime=== 1500393600000

我的
getTime  === Wed Jul 19 23:02:12 CST 2017
getTime x2 === 1500476532756

```





## 年月日时 算法

[bili](https://www.bilibili.com/video/BV18T4y1J7gU/?spm_id_from=333.880.my_history.page.click&vd_source=ca1d80d51233e3cf364a2104dcf1b743)	

```sh
1）纪年法： (公元年-3)/60=取商，取余数
（2020-3）/60=33余37 （庚子）

2）月算法：
Festival里只算出 二十六
Chronology 是 153/10 和 153/12
先找月算法并理解

尝试 用Chronology的年和月，日算法自己写 成功

五虎盾：
https://www.bilibili.com/video/BV1pp4y1Y7wj/?vd_source=ca1d80d51233e3cf364a2104dcf1b743
甲己之年丙作首，乙庚之年戊为头
丙辛之年寻庚上，丁壬壬寅顺水流
若问戊癸何处起，甲寅之上好追求

天干是 甲 或 己 的年份第一个月的天干是 丙
天干是 乙 或 庚 的年份第一个月的天干是 戊
天干是 丙 或 辛 的年份第一个月的天干是 庚
天干是 丁 或 壬 的年份第一个月的天干是 壬
天干是 戊 或 癸 的年份第一个月的天干是 甲

3）日算法：
2000~2099 日干支系数=(年尾两位数+7) *5+15+ (年尾两位数+19) /4
1900~1999 日干支系数=(年尾两位数+3) *5+55+ (年尾两位数-1) /4


example 2020年6月16日		农历 庚子 年 , 壬午 月 , 庚寅 日
日干支系数=(20+7) *5+15+ (20+19) /4=159  159/60=2 余39
（39+31+29+31+30+31+16）/60=207/60=3 余数27 	27对应 六十甲子表是 (庚寅日)


4）时算法：五鼠盾
甲乙还作甲，乙庚丙作初
丙辛从戊起，丁壬庚子居
戊癸何方求，壬子时真途




```

