



```sh
从duanGua 方法进去，占病，占财等
占病：子孙为用神，父母为忌神 
1 子孙地支和月建月破日支 是否相同，相同就输出
2 子孙地支和月建月破日支 的五行生克关系
3 判断持世的是 子孙 还是 父母，有没有都输出
```









## 架构

```sh
BaGua 类
1 bazi 八字，岁阴岁破，禄马，
2 liuYao 干支，爻五行，关系（兄弟，官鬼），
	本宫，本宫五行
    第几变卦找到本宫，世 应位置
    
    
占卜的类型
占病
```



























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

[bili](https://www.bilibili.com/video/BV18T4y1J7gU/?spm_id_from=333.880.my_history.page.click&vd_source=ca1d80d51233e3cf364a2104dcf1b743)	[jjonline/calendar.js](https://github.com/jjonline/calendar.js/blob/master/calendar.js)	

```sh
1）纪年法： (公元年-3)/60=取商，取余数
（2020-3）/60=33余37 （庚子）

2）月算法：
Festival里只算出 二十六
Chronology 是 153/10 和 153/12
先找月算法并理解

尝试 用Chronology的年和月，日算法自己写 成功

五虎盾：
https://www.bilibili.com/video/BV1hQ4y1y78A
甲己之年丙作首，乙庚之年戊为头
丙辛之年寻庚上，丁壬壬寅顺水流
若问戊癸何处起，甲寅之上好追求

年天干 甲己 开头，正月时 丙寅
年天干 乙庚 开头，正月时 戊寅
年天干 丙辛 开头，正月时 庚寅
年天干 丁壬 开头，正月时 壬寅
年天干 戊癸 开头，正月时 甲寅

3）日算法：
2000~2099 日干支系数=(年尾两位数+7) *5+15+ (年尾两位数+19) /4
1900~1999 日干支系数=(年尾两位数+3) *5+55+ (年尾两位数-1) /4


example 2020年6月16日		农历 庚子 年 , 壬午 月 , 庚寅 日
日干支系数=(20+7) *5+15+ (20+19) /4=159  159/60=2 余39
（39+31+29+31+30+31+16）/60=207/60=3 余数27 	27对应 六十甲子表是 (庚寅日)


4）时算法：五鼠盾
甲己还作甲，乙庚丙作初
丙辛从戊起，丁壬庚子居
戊癸何方求，壬子时真途
					六十甲子表
日干甲己，子时是 甲子		1
日干乙庚，子时是 丙子		13
日干丙辛，子时是 戊子		25
日干丁壬，子时是 庚子		37
日干戊癸，子时是 壬子		49


例子  7：30 辰时，甲辰
庚子 辛丑 壬寅 癸卯 甲辰
2009年8月10日		   早7:30
己丑年，壬申月，丁亥日，甲辰时

gethour 0	 12	  34	56	78	9,10 11,12 
	   子	丑	寅	卯	辰	巳	午	未	申	酉	戌	亥


```





# 位运算

[cnblogs](https://www.cnblogs.com/tinys-top/p/11648535.html)	[bili](https://www.bilibili.com/video/BV1DC4y1s7L9/?spm_id_from=333.337.search-card.all.click&vd_source=ca1d80d51233e3cf364a2104dcf1b743)	

```sh
位运算操作整数。但是是操作整数的位。
# & 按位 与，
两个位都是1，结果就是1，否则为0。
1.清零（将一个单元与0进行位与运算结果为零）
2.取一个数指定位（例如取num=1010 1101的低四位 则将num&0xF得到0000 1101）。
3.判断奇偶性：用if ((a & 1) == 0) 代替 if (a % 2 == 0)来判断a是不是偶数。

# | 按位 或，
两个或一个位是1，结果是1，否则为0。
使用场景：
下面这个方法是摘自HashMap类，这个算法来修改用户使用构造器传进来的size的，这个算法是使用移位和或结合来实现的，性能上比循环判断要好。
public static final int tableSizeFor(int cap) {
    int n = cap - 1;
    n |= n >>> 1;
    n |= n >>> 2;
    n |= n >>> 4;
    n |= n >>> 8;
    n |= n >>> 16;
    return (n < 0) ? 1 : (n >= MAXIMUM_CAPACITY) ? MAXIMUM_CAPACITY : n + 1;
}

# ^ 按位 异或，
两个位不同，结果是1，否则结果为0。
使用 ^ 位运算符（装逼必备）
a ^= b;
b ^= a;
a ^= b;

# ~ 按位 非，
操作一个数，对位取反，0变成1，1变成0。

# << 按位 左移，
被操作的数据<<被移位数，左移后右边会空，补0。
一般用来表示 乘以2 的操作，比如  66>>1=33  22>>1=11   23>>1=11

# >> 按位 右移 ， 
被操作的数>>被移位数，右移后左边补0，无符号最左边一位是0，有符号最左边一位是1。
一般用来表示 除以2 的操作，比如  66>>1=33  22>>1=11   23>>1=11
12>>> 
```





```sh
2022.10.28 
1 加入 本宫卦对象 benGongGua，方便后面 飞神和伏神
2 判断用神 刚好对应 月建Hashmap 里哪一个 

```





