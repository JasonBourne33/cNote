

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
grep 'root' pwd2.txt	 #找出包含root的
sed 's/root/chaoge/' pwd2.txt 	#s/// 是替换
sed 's/root/chaoge/gp' pwd2.txt -n #把所有root都换成chaoge输出（不会改源文件）
sed -n '1,10s/^bin/C/p' pwd2.txt	#把1到10行的bin改为C，打印出来（-n取消默认输出）
#把1到10行的bin改为C，并把m开头的行改为M
sed -n -e '1,10s/^bin/C/p' -e 's/^m/M/p' pwd2.txt
sed '5,$d' pwd2.txt		#删除4行后面所有的，（输出前4行）
sed '1,5d' pwd2.txt		#删除1到5行,输出后面的
sed '/^root/,/^ftp/d' pwd2.txt	#删除从root开头到ftp的行
sed 's/^[[:space:]]/#/g'  lovers.txt  #空白字符的开头的行，添加注释符
sed 's/^[[:space:]]/#/g' -i lovers.txt  #空白字符的开头的行，添加注释符(-i修改源文件)
#空白字符的开头的行，添加注释符,空行加#
sed -e 's/^[[:space:]]/#/g' -e 's/^$/#/g' lovers.txt 
sed -e '/^#/d' -e '/^$/d' lovers.txt	 #删除文件的空白和注释行
sed -r 's/(^.)/@\1/' lovers.txt		#给文件每行前加@符号
sed -r '1,3s/(^.)/@\1/' lovers.txt	#给文件前三行的每行前加@符号
ifconfig ens33|sed '2p' 
ifconfig ens33|sed '2p' -n	#只显示第二行
ifconfig ens33|sed '2p' -n | sed 's/^.*inet[[:space:]]//'  #去掉inet前面和空格
ifconfig ens33|sed '2p' -n | sed 's/^.*inet//' | sed 's/netmask.*//'  #去掉netmask后面
#只输出版本号的7
cat /etc/centos-release
sed -r 's/^.*release//p' /etc/centos-release -n		#去掉release之前的内容
sed -r 's/^.*release[[:space:]]*//p' /etc/centos-release -n  #去掉前面空格
# \1 表示输出（）里的内容    ([^.]).* 表示输出小数点以外的内容
sed -r 's / ^.*release[[:space:]] ([^.]).* */ \1 /p' /etc/centos-release -n

```





# awk

```sh
cat /etc/passwd
#-F指定分隔符  $1指定第一列  NF是最后一列(number of fills)  $(NF-1)是倒水第二列
awk -F ":" '{print $1 ,$(NF-1)}' /etc/passwd  
#找出普通用户（uid>=1000的）
awk -F ":" '$3>=1000{print $1 ,$(NF-1)}' /etc/passwd
awk -F ":" '$3>500{print $1 ,$(NF-1)}' /etc/passwd  #没有用户就用这个
vi /tmp/chaoge.txt
爱的魔力转圈圈1 爱的魔力转圈圈2 爱的魔力转圈圈3
爱的魔力转圈圈4 爱的魔力转圈圈5 爱的魔力转圈圈6
爱的魔力转圈圈7 爱的魔力转圈圈8 爱的魔力转圈圈9
爱的魔力转圈圈10 爱的魔力转圈圈11 爱的魔力转圈圈12
爱的魔力转圈圈13 爱的魔力转圈圈14 爱的魔力转圈圈15
爱的魔力转圈圈16 爱的魔力转圈圈17 爱的魔力转圈圈18
爱的魔力转圈圈19 爱的魔力转圈圈20
awk 'NR<6{print "#" $0}' /tmp/chaoge.txt  #打印前5行  NR是索引号（number of recourse）
vi tel.txt 			(page87)
Mike Harrington:[510] 548-1278:250:100:175
Christian Dobbins:[408] 538-2358:155:90:201
Susan Dalsass:[206] 654-6279:250:60:50
Archie McNichol:[206] 548-1348:250:100:175
Jody Savage:[206] 548-1278:15:188:150
Guy Quigley:[916] 343-6410:250:100:175
Dan Savage:[406] 298-7744:450:300:275
Nancy McNeil:[206] 548-1278:250:80:75
John Goldenrod:[916] 348-4278:250:100:175
Chet Main:[510] 548-5258:50:95:135
Tom Savage:[408] 926-3456:250:168:200
Elizabeth Stachelin:[916] 440-1763:175:75:300
awk -F ":" '{print $2}' tel.txt  #输出第二列
awk -F ":" '{print $1,$2,$3}' tel.txt	#输出3列
awk -F "[ :]" '{print $4}' tel.txt 	 #输出电话号码（空格和：为分隔符）
awk -F "[ :]" '/^Tom/{print $1,$4}' tel.txt  #显示tom的电话
awk -F "[ :]" '/^Nancy/{print $1,$2,$3,$4}' tel.txt  #显示Nancy的全名，区号，电话
awk -F "[ :]" '$2~/^D/' tel.txt  #姓以D开头的  ~是匹配正则//里面的
awk -F "[ :]" '$3~/\[916\]/' tel.txt  #电话区号是916的
#显示mike的捐款信息，前面加上$
awk -F "[ :]" '/^Mike/{print "$"$(NF-2),"$"$(NF-1),"$"$(NF)}' tel.txt
awk -F "[ :]" '{print $2","$1}' tel.txt  #显示所有人的 姓,名
#显示所有人的 姓,名 !/^$/是匹配非空  -v OFS=","修改内置变量逗号
awk -F "[ :]" -v OFS="," '!/^$/{print $2,$1}' tel.txt  
awk '!/^$/' tel.txt  #删除文件空白行








```































 
