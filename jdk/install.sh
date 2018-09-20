#/bin/bash
RPM_PATH="soft/jdk-8u181-linux-x64.rpm"
echo 'install jdk into linux '
# 1. 判断用户
user=$(env | grep USER |cut -d "=" -f 2)
if [ "$user" = "root" ]; then 
    echo "开始启动redis"
else
	echo "请使用root用户运行这个脚本！"
    exit 1
fi
chmod 752 $RPM_PATH
rpm -ivh $RPM_PATH
if [ $? ]; then
  echo "安装jdk完成第一步~~~"
else 
  echo "安装失败，请检查错误信息"
  exit 1
fi
JAVA_HOME="/usr/java/jdk1.8.0_181-amd64"
echo "export JAVA_HOME=$JAVA_HOME">>/etc/profile
echo 'export PATH=$PATH:$JAVA_HOME/bin'>>/etc/profile
echo 'export CLASSPATH=.:$JAVA_HOME/jre/lib/dt.jar:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar'>>/etc/profile
source /etc/profile
if [ $? ]; then
    echo "安装jdk完成！"
else
    echo "安装失败！"
fi
echo $JAVA_HOME
echo $CLASSPATH
echo $PATH
