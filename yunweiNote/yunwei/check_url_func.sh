
#
# Use LSB init script functions for printing messages, if possible
#
lsb_functions="/lib/lsb/init-functions"
if test -f $lsb_functions ; then
  . $lsb_functions
else
  init_functions="/etc/init.d/functions"
  if test -f $init_functionss; then
    . $init_functions
  fi
  log_success_msg()
  {
    echo " SUCCESS! $@"
  }
  log_failure_msg()
  {
    echo " ERROR! $@"
  }
fi







if [ "$#" -ne 1 ]
  then
    echo "Usage: $0 url"
    exit 1
fi

#利用wget命令测试url是否正常
wget --spider -q -o /dev/null --tries=1 -T 5 $1

if [ "$?" -eq 0 ]
  then
    log_success_msg echo "$1 is running..."
else
  log_failure_msg echo "$1 is down..."
fi






















