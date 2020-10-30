#!/bin/bash

set -u
set -x

set -o allexport
source ./env.sh
set +o allexport

# 删除 pod,deployment,svc
kubectl delete all --all -n ${MANAGER_NS}
kubectl delete all --all -n ${JUPYTER_NS}
kubectl delete all --all -n ${BATCH_NS}

# 删除所有 secret
kubectl delete secret ${HARBOR_SECRET} -n ${BATCH_NS}
kubectl delete secret ${UHUB_SECRET}   -n ${MANAGER_NS}
kubectl delete secret ${UHUB_SECRET}   -n ${JUPYTER_NS}
kubectl delete secret ${UHUB_SECRET}   -n ${BATCH_NS}

# 删除 RBAC
kubectl delete sa jupyter-biz -n ${MANAGER_NS}
kubectl delete rolebinding jupyter-biz-as-master -n ${JUPYTER_NS}
kubectl delete rolebinding default-as-master -n ${BATCH_NS}

# 删除配置文件
kubectl delete cm kube-config -n ${MANAGER_NS}
kubectl delete cm jupyter-biz-env offline-server-env -n ${MANAGER_NS}

