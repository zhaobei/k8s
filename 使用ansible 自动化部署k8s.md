# 使用ansible 自动化部署k8s

1、开启一个 VM 作为模板机器，确保该机器有可用的 YUM 源

配置ansible 主机组



配置免密登陆

```go
ssh-keygen
```



```go
ssh-copy-id  root@host登陆一下
```

配置yum源

```
cat` `<<EOF > ``/etc/yum``.repos.d``/kubernetes``.repo
[kubernetes]
name=Kubernetes
baseurl=https:``//mirrors``.aliyun.com``/kubernetes/yum/repos/kubernetes-el7-x86_64/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https:``//mirrors``.aliyun.com``/kubernetes/yum/doc/yum-key``.gpg https:``//mirrors``.aliyun.com``/kubernetes/yum/doc/rpm-package-key``.gpg
EOF
```

安装docker系列

```
yum install -y yum-utils device-mapper-persistent-data lvm2
```

```
添加国内 docker yum source
yum-config-manager --add-repo http:``//mirrors``.aliyun.com``/docker-ce/linux/centos/docker-ce``.repo
```

安装pip



yum -y install epel-release

yum install -y net-tools 为了使ifconfig生效

yum -y install python-pip

yum install -y ansible 

安装ifconfig\

yum install -y net-tools

(如果有问题请清除本地缓存 执行：yum clean all)



初始化机器之前请 注意 yum源的配置