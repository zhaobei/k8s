# k8s中的用户

### 一、Kubernetes中的用户

K8S中有两种用户(User)

- 服务账号(ServiceAccount)
- 普通用户(User)

ServiceAccount是由K8S管理的，而User通常是在外部管理

### 二、普通用户

尽管K8S认知用户靠的只是用户的名字，但是只需要一个名字就能请求K8S的API显然是不合理的，所以依然需要验证此用户的身份

在K8S中，有以下几种验证方式：

- X509客户端证书
   客户端证书验证通过为API Server指定--client-ca-file=xxx选项启用，API Server通过此ca文件来验证API请求携带的客户端证书的有效性，一旦验证成功，API Server就会将客户端证书Subject里的CN属性作为此次请求的用户名
- 静态token文件
   通过指定--token-auth-file=SOMEFILE选项来启用bearer token验证方式，引用的文件是一个包含了 token,用户名,用户ID 的csv文件 请求时，带上Authorization: Bearer 31ada4fd-adec-460c-809a-9e56ceb75269头信息即可通过bearer token验证
- 静态密码文件
   通过指定--basic-auth-file=SOMEFILE选项启用密码验证，类似的，引用的文件时一个包含 密码,用户名,用户ID 的csv文件 请求时需要将Authorization头设置为Basic BASE64ENCODED(USER:PASSWORD)



![img](https://img-blog.csdnimg.cn/20191107133738534.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2NibWxqcw==,size_16,color_FFFFFF,t_70)

kubectl使用的就是`X509客户端证书`来标识用户的，我们来验证一下





