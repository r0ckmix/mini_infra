#!/bin/bash
source ./clu_env.txt

cd ~

curl -fsSL -o get_helm.sh $HELM_URL
chmod 700 get_helm.sh
./get_helm.sh

kubeadm init --pod-network-cidr $POD_NETWORK
export KUBECONFIG=/etc/kubernetes/admin.conf

kubectl create -f $CALICO_URL/operator-crds.yaml
kubectl create -f $CALICO_URL/tigera-operator.yaml
curl $CALICO_URL/custom-resources.yaml -O
sed -i "s|cidr: 192.168.0.0/16|cidr: $POD_NETWORK|g" ./custom-resources.yaml
kubectl create -f ./custom-resources.yaml

sleep 2
kubectl wait pod --all --for=condition=Ready --timeout=300s -n calico-system
sleep 2
kubectl wait pod --all --for=condition=Ready --timeout=300s -n calico-apiserver
sleep 2
kubectl wait pod --all --for=condition=Ready --timeout=300s -n tigera-operator
sleep 2