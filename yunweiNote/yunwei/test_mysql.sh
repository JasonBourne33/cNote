#!/bin/bash

echo "=====method 1"
if [ `netstat -tunlp|grep mysql | wc -l` = "1" ]
  then
    echo "MySQL is running."
else
  echo "MySQL is stopped"
  systemctl start mariadb
fi


echo "======method 2"
if [ `ss -tunlp|grep mysql | wc -l` = "1" ];
  then
    echo "MySQL is running."
else
  echo "MySQL is stopped"
  systemctl start mariadb
fi


echo "======method 3"
if [ `lsof -i tcp:3306 | wc -l` -gt "0" ];
  then
    echo "MySQL is running."
else
  echo "MySQL is stopped"
  systemctl start mariadb
fi


echo "======method 4  php script"
php /root/py/mysql_test.php
if [ "$?" -eq 0 ];
  then
    echo "MySQL is running."
else
  echo "MySQL is stopped"
  systemctl start mariadb
fi


echo "======method 5  python script"
python3 /root/py/test_python_mysql.py
if [ "$?" -eq 0 ];
  then
    echo "MySQL is running."
else
  echo "MySQL is stopped"
  systemctl start mariadb
fi


























