##  终端连接MySQL

1. 打开终端，为Path路径附加MySQL的bin目录

```sql
PATH="$PATH":/usr/local/mysql/bin
```

2. 通过以下命令登陆MySQL（密码就是前面自动生成的临时密码）

   ```python
   mysql -u root -p
   ```

   

退出mysql服务：

```
quit
```

最后退出sh-3.2#超级权限 代码

```
exit
```



在终端输入代码

sudo su

输入完后获取超级权限 终端显示 sh-3.2#

输入本机密码（Apple ID密码）

接着通过绝对路径登陆 代码

/usr/local/mysql/bin/mysql -u root -p

再输入mysql密码（我的密码设置为root）

登陆成功

退出代码

quit

退出成功 bye

最后退出sh-3.2#超级权限 代码

exit