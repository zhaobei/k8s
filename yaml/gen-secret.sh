#!/bin/bash

set -e
set -u
set -x

# 从命令行参数中提取值
while getopts a:u:p:s:n: option
do 
case "${option}"
in
a) ADDR=${OPTARG};;
u) USER=${OPTARG};;
p) PASSWOED=${OPTARG};;
s) SECRET_NAME=${OPTARG};;
n) NAMESPACE=${OPTARG};;
esac
done

# 在 K8s 集群中创建 private registry secret
kubectl create secret docker-registry $SECRET_NAME \
  --docker-server=$ADDR \
  --docker-username=$USER \
  --docker-password=$PASSWOED \
  -n $NAMESPACE

