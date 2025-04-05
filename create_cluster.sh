# set current dir




# run terraforf

#cd ./trr
#terraform apply -var-file=secret.tfvars
#
#helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
#helm upgrade --install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard --create-namespace --namespace kubernetes-dashboard

K8S_USER=$(grep 'vm_user = ' ./trr/secret.tfvars | cut -f2 -d'=' | tr -d '"')
K8S_PASS=$(grep 'vm_password = ' ./trr/secret.tfvars | cut -f2 -d'=' | tr -d '"')

#echo $K8S_USER
#echo $K8S_PASS

for server in $(grep 'ip = ' ./trr/variables.tf | cut -f2 -d'=' | tr -d '"' | tr -d '\n'); do
  echo $server
#  ssh $USER@$server "bash -s" < $SCRIPT
#  sshpass -p $K8S_PASS ssh -o StrictHostKeyChecking=accept-new $K8S_USER@$WRK_IP $J_COMM
  sshpass -p $K8S_PASS ssh -o StrictHostKeyChecking=accept-new $K8S_USER@$server hostname
done