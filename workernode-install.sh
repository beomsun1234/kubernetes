sudo su

cd /root

# install docker

sudo apt-get update -y
 
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# docker GPG key
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg


echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null


sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io 


sudo docker version

sleep 1 # 1초 일시 정지

sudo systemctl enable docker
sudo systemctl start docker

# -----------------------------------------------------------------

# install k8s ---------------------------------------


swapoff -a && sed -i '/swap/s/^/#/' /etc/fstab


cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sudo sysctl --system




sudo apt-get update -y
sudo apt-get install -y apt-transport-https ca-certificates curl


echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -



sudo apt-get update -y
sudo apt-get install -y kubelet=1.25.4-00 kubeadm=1.25.4-00 kubectl=1.25.4-00
sudo apt-mark hold kubelet kubeadm kubectl


sudo systemctl daemon-reload
sudo systemctl restart kubelet

sudo rm /etc/containerd/config.toml
sudo systemctl restart containerd
echo '1' > /proc/sys/net/ipv4/ip_forward

sleep 1

sudo kubeadm join [master_ip]:6443 --token [kubeadm token] --discovery-token-ca-cert-hash sha256:[token hash]

