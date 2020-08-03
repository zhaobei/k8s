# ansible-playbook 拉起K8s 集群

所有的部署配置变量集中收口在 `playbook.json` 中。具体 playbook 执行时需要的变量由 python 脚本通过模板生成到对应的 `vars` 目录中去。比如由 `main.yaml.template` 生成对用的 `main.yaml`。此外，python 脚本还会在当前目录生成 hosts 文件，供 ansible 使用。一级目录会有各个部署单元的 playbook，包括：

- nfs.yaml 部署主备 NFS 服务

- k8s.yaml 部署 K8s 服务

- add-node.yaml 添加集群节点

#### 一、调整配置文件

由于使用ansible 部署，所以会对ansible 做一些配置。

1、首先拉起的服务器生成密钥

```
 ssh-keygen   有提示直接回车即可
```

2、将master pub.key写入work 节点

```
ssh-copy-id  root@<work_host>
```



部署之前要根据实际情况修改 `playbook.json` ，**仅对关键参数做调整即可，多数使用默认**。

```
{
    "k8s_common": {
        "config": {
            "version": "1.16.3",
            "pod_cidr": "10.244.0.0/16",
            "svc_cidr": "172.20.0.0/16",
            "node_cidr": "192.168.254.0/24",   // 集群的网段
            "dns_domain": "cluster.local",
            "apiserver_domain": "kube-apiserver-lb.com",
            "apiserver_vip": "172.16.1.26",   //此处如果单master填写master_ip 如果多master 此处填写负载均衡的ip
            "apiserver_vport": "6443",
            "image_hub": "hub.sf.ucloud.cn/library"
        },
        "node_info": {
            // 主 master 节点
            "master_primary": [
                "172.16.1.26"
            ],
            // 其他 master 节点
            "master_secondary": [
                "172.16.1.27",
                "172.16.1.28"
            ],
            // worker 节点
            "node": [
                "172.16.1.29"
            ]
        }
    },
    "roles": {
        "env_init": {
            "source_dir": "/deployment/env_init",
            // 要添加的 host 配置
            "add_hosts": [{
                "ip": "192.168.1.9",
                "domain": "ai-hub.3incloud.com"
            }],
            "install_packages": [
                
            ],
            "master_uni_config":{
                "uni_iface": "eth2"
            }
        }, 
        "master_nginx_init": {
            "source_dir": "/deployment/master_nginx_init"
        }, 
        "master_init": {
            "source_dir": "/deployment/master_init",
            "k8s_images_tar": "/home/k8s-v1.16.3-hub.sf.ucloud.cn-labeled.tar"
        }, 
        "master_add": {
            "source_dir": "/deployment/master_add"
        }, 
        "node_add": {
            "source_dir": "/deployment/node_add"
        }, 
        "plugin_install": {
            "source_dir": "/deployment/plugin_install",
            "canal_images_tar": "/home/canal-v3.12.0.tar",
            "canal_config": {
                "canal_iface": "eth0",
                "backend_type": "vxlan",
                "cni_image": "calico/cni:v3.12.0",
                "flexvol_driver_image": "calico/pod2daemon-flexvol:v3.12.0",
                "calico_node_image": "calico/node:v3.12.0",
                "flannel_image": "quay.io/coreos/flannel:v0.11.0"
            }
        },
        "env_pos": {
            "source_dir": "/deployment/env_pos"
        },
        "nfs_server_init": {
            "source_dir": "/deployment/nfs_server_init",
            "nfs_client_provisioner_image_tar": "/home/nfs-client-provisioner-v1.tar",
            "infos": [
                {
                    "common": {
                        "name": "nfs-test",
                        "storage": "200Gi",
                        "accessmodes": "ReadWriteMany",
                        // 在 K8s 中为 NFS service 分配的 service IP（自己在规定的网段里拍一个即可）
                        "cluster_ip": "172.20.1.10",
                        "action": "init",
                        "disk_dev": "/dev/vdb",
                        "volume_dir": "/data/k8s"
                    },
                    // NFS 主节点
                    "master":{
                        "ip":"172.16.1.16"
                    },
                    // NFS 从节点
                    "backup":{
                        "ip":"172.16.1.17"
                    }
                }
            ]
        }
    }
}

```

#### 部署 K8s 集群

备注：在写好参数后可现验证下json文件是否符合规范，验证网址：https://jsonlint.com/

```
# 生成相关配置文件
python playbook.py --role k8s

# 开始部署
ansible-playbook k8s.yaml
```

