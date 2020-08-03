# kubernetes将外部服务映射为内部服务

在实际应用中，一般不会把mysql这种重IO、有状态的应用直接放入k8s中，而是使用专用的服务器来独立部署。而像web这种无状态应用依然会运行在k8s当中，这时web服务器要连接k8s管理之外的数据库，有两种方式：一是直接连接数据库所在物理服务器IP，另一种方式就是借助k8s的Endpoints直接将外部服务器映射为k8s内部的一个服务。



下面这个例子就是展示Endpoints将外部服务映射为k8s内部服务的例子。
将外部服务器的192.168.188.222的3306端口映射到内部服务

```
cat << EOF > lykops-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: lykops
spec:
  ports:
  - port: 3306
    targetPort: 30006
    protocol: TCP
EOF

cat << EOF > lykops-endpoints.yaml
apiVersion: v1
kind: Endpoints
metadata:
  name: lykops
subsets:
  - addresses:
    - ip: 192.168.188.222
    ports:
    - port: 3306
      protocol: TCP
EOF

kubectl create -f test-endpoints.yaml
kubectl create -f test-service.yaml
```

Endpoints的subsets中指定了需要连接的外部服务器的IP和端口。