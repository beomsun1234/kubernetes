## docker 설치( v1.24 이상부터 도커 x, containerd, CRI-O과 같은 CRI 기반의 컨테이너 런타임들을 지원)

    sudo apt install docker.io

    sudo systemctl enable docker
    sudo systemctl start docker
    sudo systemctl status docker
    sudo systemctl start docker
    
## CRI 설치

### 1.Docker GPG 키를 추가
    
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    
### 2.Docker 저장소 추가 amd 
    
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

### 3.containerd.io 패키지 설치 및 시작

    sudo apt-get update
    sudo apt-get install -y containerd.io
    sudo systemctl start containerd

    #check arch
    sudo dpkg -l | grep containerd
### 4.kubeadm init error 발생시

    option 1
    # disabled_plugins = ["cri"] 줄을 주석 처리
    sudo vi /etc/containerd/config.toml
    
    option 2
    sudo rm /etc/containerd/config.toml
    
## kubeadm 설치

    https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/


## arm버전 설치

    https://velog.io/@tkfka/containerd-kubernetes-%EC%84%A4%EC%B9%98%ED%95%98%EA%B8%B0-feat.-Arm
