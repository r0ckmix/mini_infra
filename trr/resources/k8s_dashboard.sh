#!/bin/bash
source ./clu_env.txt
export KUBECONFIG=/etc/kubernetes/admin.conf

cd ~



# install metallb
helm repo add metallb https://metallb.github.io/metallb
helm install metallb metallb/metallb

sleep 5
kubectl wait pod --all --for=condition=Ready --timeout=300s



cat >/tmp/resources/metallb-ipaddresspool.yaml <<EOF
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: first-pool
  namespace: default
spec:
  addresses:
    - ${METALLB_POOL}
EOF

sleep 1


# install kubernetes dashboard
helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
helm upgrade --install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard --create-namespace --namespace kubernetes-dashboard

kubectl apply -f /tmp/resources/dashboard-user.yaml
kubectl apply -f /tmp/resources/dashboard-clusterrolebinding.yaml
kubectl apply -f /tmp/resources/dashboard-secret.yaml

sleep 3

TOKEN=$(kubectl get secret dashboard-secret -n kubernetes-dashboard -o jsonpath="{.data.token}" | base64 --decode)

cat >/tmp/resources/dashboard-proxy-cm.yaml <<EOF
apiVersion: v1
data:
  proxy.conf: |
    server {
      listen 80;
      location / {
        proxy_pass https://kubernetes-dashboard-kong-proxy.kubernetes-dashboard.svc.cluster.local:443;
        proxy_ssl_server_name on;
        proxy_set_header Authorization "Bearer ${TOKEN}";
      }
    }
kind: ConfigMap
metadata:
  name: dashboard-proxy-config
  namespace: kubernetes-dashboard
EOF

kubectl apply -f /tmp/resources/dashboard-proxy-cm.yaml
kubectl apply -f /tmp/resources/dashboard-proxy-deployment.yaml
kubectl apply -f /tmp/resources/dashboard-proxy-svc.yaml

kubectl wait pod --all --for=condition=Ready --timeout=300s -n kubernetes-dashboard

kubectl apply -f /tmp/resources/metallb-ipaddresspool.yaml
kubectl apply -f /tmp/resources/metallb-l2advertisement.yaml