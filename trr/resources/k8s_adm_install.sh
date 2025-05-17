#edit hosts
while read -u 10 p; do
  echo $p
  desiredIP=$(echo "$p" | cut -d ' ' -f1)
  echo $desiredIP
  echo $(grep $desiredIP /etc/hosts)
  [[ -z $(grep $desiredIP /etc/hosts) ]] && echo "" >> /etc/hosts && echo $p >> /etc/hosts
done 10</tmp/resources/vm_list.txt


# upgrade system
yum check-update && yum upgrade -y


# configure modules
cat <<EOF | tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF


# add modules
modprobe overlay && modprobe br_netfilter


# configure sysctl
cat <<EOF | tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF


sysctl --system


# configure firewall
firewall-cmd --permanent --zone=public --set-target=ACCEPT
firewall-cmd --permanent --zone=public --add-port=0-65535/tcp
firewall-cmd --permanent --zone=public --add-port=0-65535/udp
firewall-cmd --reload


# install repository
yum install -y yum-utils
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install -y sshpass


# install containerd
yum install -y containerd
mkdir -p /etc/containerd
containerd config default | tee /etc/containerd/config.toml
systemctl enable containerd.service
sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml
systemctl restart containerd


# install kubeadm
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

cat <<EOF | tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.30/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.30/rpm/repodata/repomd.xml.key
exclude=kubelet kubeadm kubectl cri-tools kubernetes-cni
EOF

yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
systemctl enable --now kubelet
echo 'export KUBECONFIG=/etc/kubernetes/admin.conf' >> /root/.bash_profile