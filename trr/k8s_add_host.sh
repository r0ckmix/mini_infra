#!/bin/bash
J_COMM=$(kubeadm token create --print-join-command)
sshpass -p $K8S_PASS ssh -o StrictHostKeyChecking=accept-new $K8S_USER@$WRK_IP $J_COMM