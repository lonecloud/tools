#/bin/bash
# 判断当前用户是否为root用户
cur_user=$(env | grep USER | cut -d "=" -f 2)
if [[ "${cur_user}" != "root" ]]; then
        #statements
        echo '请使用root用户使用该脚本'
        exit 1;
fi
# 需要创建的用户
user=$1
# 需要创建的密码
passwd=$2

base_sftp=$3

if [[ ! -n ${base_sftp} ]]; then
        echo "该变量为空，将设置为默认的目录为/home/sftp"
        base_sftp="/home/sftp"
        if [ ! -d ${base_sftp} ]; then
           echo "该文件夹不存在,正在创建文件夹${base_sftp}"
           mkdir -p ${base_sftp}
           chown root:sftp $base_sftp
        fi
fi
user_path=$base_sftp/$user
user_data_path=$base_sftp/$user/data
echo "用户的sftp基础目录为${user_path}"
# 1.添加用户
echo "创建用户 $1"
useradd -g sftp -s /bin/false -d $user_path $1
# 2. 设置密码
if [[ $? -eq 0 ]]; then
        echo '创建用户成功!'
        echo "2. 修改密码"
        echo $2 |passwd --stdin $1
        if [[ $? -eq 0 ]]; then
            echo "修改密码成功！"
            echo "3. 设置相关目录的权限"
            chown root:sftp $user_path
            chmod 755 $user_path
            mkdir ${user_data_path}
            chown ${user}:sftp $user_data_path
            chmod 755 $user_data_path
            service sshd restart
        fi
else
   echo ”该用户名称${user}已存在，请选择其他的用户名!“
fi