


我小白，请问开发量化是用什么软件的呀

现在业内实盘期货用户最多的是文华然后是TB，再然后MC。但是文华的软件策略设计深度比较差。股票嘛，应该是聚宽，第二是MC。。。。

lSm33

[MC官网](https://www.multicharts.cn/)	

# heima RiceQuant

[bili](https://www.bilibili.com/video/BV1q4411P71K?p=6&vd_source=ca1d80d51233e3cf364a2104dcf1b743)		[rice quant](https://www.ricequant.com/quant/strategys)	[cheive  strategy](https://www.ricequant.com/quant/strategy/2106398)	[财务数据 bili](https://www.bilibili.com/video/BV1q4411P71K?p=7&vd_source=ca1d80d51233e3cf364a2104dcf1b743)	

```sh
新建策略，cheive，

    # 当前运行日期起，前5天收盘价的价格
    close=history_bars(context.s1,5,'1d','close')
    logger.info(close)
    # 当前运行日期起，前5天的开盘价和收盘价
    his_1=history_bars(context.s1,5,'1d',['open','close'])
    logger.info(his_1)
    #获取基本面信息
get_fundamentals


alpha 与市场无关的
beta 与市场完全相关，整个市场的平均收益率乘以一个beta系数 （投资组合的系统风险）
```

























































# theme1
