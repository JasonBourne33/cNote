

sed	替换
grep 过滤
awk 格式化输出，像exel

# grep	

[bili](https://www.bilibili.com/video/BV1rA4y1S7Hk?p=10&vd_source=ca1d80d51233e3cf364a2104dcf1b743)	[runoob](https://www.runoob.com/linux/linux-comm-grep.html)	

```sh



grep "root" /etc/passwd		#有关root的行
grep "^root" /etc/passwd	# 找出root用户(开头)的行
grep -E "^(root|yu)" /etc/passwd	#以root或yu开头的行
grep -E "^(root|nobody)\>" /etc/passwd	#找出root用户和nobody用户的行
grep -n "^bin" /etc/passwd	#找出带有bin的行并显示行号
grep -v "^root" /etc/passwd		#过滤掉root开头的行
grep -c "^root" /etc/passwd		#打印出现的次数
grep -m 2 "^yu" /etc/passwd		#只显示yu的前两条信息
grep "root" /etc/passwd /data/pwd.txt 	#匹配多文件
grep "/bin/bash$" /etc/passwd		#在/etc/passwd 中以binbash结尾的行
grep "/bin/bash$" /etc/passwd -v -n		#不以binbash结尾的行
grep -E "\<[0-9]{2,3}\>" /etc/passwd	#找出 /etc/passwd 中的两位数和三位数 的行
vi lovers.txt
I like my lover.
 I love my lover.
He likes his lovers.
#she loves her cat
i want ride my bike
cat lovers.txt
grep "^[[:space:]].*" lovers.txt 	#找出lovers.txt文件中的以空格开头，后面是非空内容的行
grep -E "^[[:space:]]+[^[:space:]]" lovers.txt 	#找出文件中的以空格开头，最后是非空内容的行
grep -i "^i" lovers.txt			#以i开头的
grep -E "^(i|I)" lovers.txt			#以i开头的
grep -E "^[iI]" lovers.txt		#以i开头的
grep -E "(root|yu|nobody)\>" /etc/passwd	#找到root|yu|nobody用户的，yu1和yu2都不要

vim /etc/init.d/functions
grep -E "[a-zA-Z]+\(\)" /etc/init.d/functions	#找出文件中所有的函数名 方法，比如 test()

grep -E "^([^:]+\>)" /etc/passwd	#找出 : 前的出用户名
grep -E "^([^:]+\>).*\1$" /etc/passwd	#找出用户名和解析器名相同的
```





# sed

[bili](https://www.bilibili.com/video/BV1rA4y1S7Hk?p=11&vd_source=ca1d80d51233e3cf364a2104dcf1b743)	

```sh
cp /etc/passwd /root/pwd2.txt
cat /etc/pwd2.txt
grep 'root' pwd2.txt 
sed 's/root/chaoge/' pwd2.txt 
```



































