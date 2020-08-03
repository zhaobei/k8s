# 自动制作kubeconfig

默认情况下，把所有的标识开发者的`ServiceAccount`全创建在`default namespace`，然后根据该`ServiceAccount`的`token`为开发者生成`kubeconfig`文件。

ps : 需要文件

make-kubeconfig-master

网址：https://git.ucloudadmin.com/Steve/make-kubeconfig

例如，要为steve.wang创建kubeconfig：

```
make config sa=steve-wang ns=default
```

该脚本将会在`kube`目录中生成`kubeconfig`文件。

为服务帐户绑定ClusterRole

默认的，我们在重组内部创建一个叫`ns-full-access`的`ClusterRole`，其拥有所有权限。我们会使用`Rolebinding`将其与代表开发者的`ServiceAcount`绑定，以便开发者拥有指定`namespace`的所有权限。

```
make binding sa=steve-wang ns=test-baiduai-manager
```

