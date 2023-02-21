



```sh
簡單的辦法（不用手寫）
在vmware裏ip addr 看分配的ip地址
用shell登錄分配的ip地址，打開Xftp， 
進入 /etc/sysconfig/network-scripts ，編輯 ifcfg-ens33
粘貼覆蓋以下代碼
TYPE=Ethernet
PROXY_METHOD=none
BROWSER_ONLY=no
BOOTPROTO=static
DEFROUTE=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=yes
IPV6_AUTOCONF=yes
IPV6_DEFROUTE=yes
IPV6_FAILURE_FATAL=no
IPV6_ADDR_GEN_MODE=stable-privacy
NAME=ens33
UUID=1da8d761-427b-460e-9456-7c0ccab2abe4
DEVICE=ens33
ONBOOT=yes

IPADDR=193.169.0.3
#IPADDR=193.169.0.4
#IPADDR=193.169.0.5
NETMASK=255.255.255.0
GATEWAY=193.169.0.2
DNS1=8.8.8.8
DNS2=8.8.4.4

输入 sudo service network restart 重启网络
在vm里 编辑- 虚拟网络编辑器- 选中当前的子网地址（vmnet8，nat模式那個）- 子网ip改成193.169.0.0- 确定
用xftp连入 193.169.0.3 的地址端口 22
root
123456
```





```sh


Xshell和Xftp连接VMware中的centos 7 （启动网卡，静态ip配置）
源 https://blog.csdn.net/qq_39559641/article/details/104484560
用root用户登录到centos
输入 cat /etc/sysconfig/network-scripts/ifcfg-ens33 看到onboot=no
输入 vi  /etc/sysconfig/network-scripts/ifcfg-ens33  按i进入编辑，把no改成 ONBOOT=yes，
把bootproto=dhcp 改成bootproto=static
最后加上
IPADDR=193.169.0.3
#IPADDR=193.169.0.4
#IPADDR=193.169.0.5
NETMASK=255.255.255.0
GATEWAY=193.169.0.2
DNS1=8.8.8.8
DNS2=8.8.4.4
输入 :wq保存退出
输入 sudo service network restart 重启网络
输入 ip addr 查看ip地址 193.169 开头的
在vm里 编辑- 虚拟网络编辑器- 选中当前的子网地址- 子网ip改成193.169.0.0- 确定
用xftp连入 193.169.0.3 的地址端口 22
root
123456
```

