# run terraform
terraform -chdir=./trr apply -var-file=secret.tfvars -auto-approve

# get VM credentials
K8S_USER=$(grep 'vm_user = ' ./trr/secret.tfvars | cut -f2 -d'=' | tr -d '"')
K8S_PASS=$(grep 'vm_password = ' ./trr/secret.tfvars | cut -f2 -d'=' | tr -d '"')
sleep 30

# install kubeadm
for server in $(grep 'ip = ' ./trr/variables.tf | cut -f2 -d'=' | tr -d '"' | tr -d '\n'); do
  sshpass -p $K8S_PASS scp -r -o StrictHostKeyChecking=no ./trr/resources $K8S_USER@$server:/tmp
  sshpass -p $K8S_PASS ssh -o StrictHostKeyChecking=no $K8S_USER@$server 'chmod -R 777 /tmp/resources'
  sshpass -p $K8S_PASS ssh -o StrictHostKeyChecking=no $K8S_USER@$server 'bash -s < /tmp/resources/k8s_adm_install.sh'
done

# init cluster
FIRST_CP_NODE=$(grep -m 1 'k8scp' ./trr/resources/vm_list.txt | cut -f1 -d' ' | tr -d '\n')
echo $FIRST_CP_NODE
sshpass -p $K8S_PASS ssh -o StrictHostKeyChecking=no $K8S_USER@$FIRST_CP_NODE 'cd /tmp/resources/ && bash -s < ./k8s_clu_init.sh'

#todo add node to CP

# add node to cluster
JOIN_COMMAND=$(sshpass -p $K8S_PASS ssh -o StrictHostKeyChecking=no $K8S_USER@$FIRST_CP_NODE 'kubeadm token create --print-join-command')
for server in $(grep 'worker' ./trr/resources/vm_list.txt | cut -f1 -d' ' | tr -d '\n'); do
  echo $server
  echo $JOIN_COMMAND
  sshpass -p $K8S_PASS ssh -o StrictHostKeyChecking=no $K8S_USER@$server $JOIN_COMMAND
done

sleep 10

# install dashboard to cluster
#FIRST_CP_NODE=$(grep -m 1 'k8scp' ./trr/resources/vm_list.txt | cut -f1 -d' ' | tr -d '\n')
echo $FIRST_CP_NODE
sshpass -p $K8S_PASS ssh -o StrictHostKeyChecking=no $K8S_USER@$FIRST_CP_NODE 'cd /tmp/resources/ && bash -s < ./k8s_dashboard.sh'



#if [ $? -eq 0 ]; then

#else
#    echo FAIL
#    exit 1
#fi