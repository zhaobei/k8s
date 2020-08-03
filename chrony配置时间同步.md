# chrony配置时间同步

1、安装chrony

```
yum install chrony -y 
```

2、修改master地址（选一台主机作为时间同步master节点）

```
 vi /etc/chrony.conf
```

这里指定了时间上有服务器的地址留一个就行，如果master1作为主节点 ，那么他的上游服务器就是本身，这里修改master的配置文件。

```
server 127.127.1.0 iburst
```

3、更改一下访问限制

```
allow 192.168.38.0/24
```

4、配置node 节点以master时间为同步基准（在node节点操作）

```
vim /etc/chrony.conf
```

修改：

```
server <master_host> iburst
```

5、启动

```
systemctl start chronyd && systemctl enable chronyd
```

6、验证是否同步成功

```
chronyc sources
```

若同步异常可重启服务

```
systemctl restart chronyd
```

