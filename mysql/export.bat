@echo off
rem 设置mysql用户名密码
set mysql_user=root
:: 设置密码
set mysql_pwd=123456
:: 数据库密码
set mysql_database=demo
:: 数据表前缀
set mysql_table_list=demo_%%
:: 导出文件名
set export_name=export.sql
:: del old file
del %export_name%
del temp.data
mysql -u%mysql_user% -p%mysql_pwd% -e"select table_name from information_schema.tables where table_schema='%mysql_database%' and table_name like '%mysql_table_list%';" > temp.data

for /f %%i in (temp.data) do mysqldump -u%mysql_user% -p%mysql_pwd% -d %mysql_database% %%i >>%export_name%
del temp.data