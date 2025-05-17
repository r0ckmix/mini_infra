#!/bin/bash
source ./clu_env.txt

cd ~

curl -fsSL -o get_helm.sh $HELM_URL
chmod 700 get_helm.sh
./get_helm.sh

kubeadm init --pod-network-cidr $POD_NETWORK
export KUBECONFIG=/etc/kubernetes/admin.conf
kubectl create -f $CALICO_URL/tigera-operator.yaml
curl $CALICO_URL/custom-resources.yaml -O
sed -i "s|cidr: 192.168.0.0/16|cidr: $POD_NETWORK|g" ./custom-resources.yaml
kubectl create -f ./custom-resources.yaml

sleep 2

until [ $(kubectl get pods -n calico-system --no-headers | grep Running -v | wc -l) -ne 0 ]
do
    kubectl get pods -n calico-system

    ((c++))
    (( c > 150 )) && exit 1
    sleep 2
done