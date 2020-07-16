# 测试环境搭建canal组件文档

1、将canal组件的tar包传到目标主机上（此处为master 节点）

scp <path>/canal-v3.12.0.tar root@<host>:/root/

2、在目标主机中load 刚刚传入的包

docker load -i canal-v3.12.0.tar 

3、将canal的yaml 文件传入目标主机 

scp <path>/canal.yaml root@<host>:/root

4、执行`kubectl create -f canal.yaml`以创建canal

5、执行 kubectl get po -A 查看组件创建情况，为running为成功

![image-20200713125828573](/Users/zhaobei/Library/Application Support/typora-user-images/image-20200713125828573.png)

