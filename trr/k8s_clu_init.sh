#!/bin/bash
cd ~
kubeadm init --pod-network-cidr $POD_NETWORK
export KUBECONFIG=/etc/kubernetes/admin.conf
kubectl create -f $CALICO_URL/tigera-operator.yaml
curl $CALICO_URL/custom-resources.yaml -O
sed -i "s/cidr: 192.168.0.0\/16/cidr: $POD_NETWORK/g" ./custom-resources.yaml
kubectl create -f ./custom-resources.yaml

until [ $(kubectl get pods -n calico-system --no-headers | grep '\/0' | wc -l) -eq 0 ]
do
    sleep 2
    ((c++)) && ((c==90)) && exit 1
done