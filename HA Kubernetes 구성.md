# HA Kubernetes 

![스크린샷 2023-06-10 오후 6 57 35](https://github.com/beomsun1234/kubernetes/assets/68090443/a33a6150-da22-4848-a5ef-f8c6cd3fd257)

![스크린샷 2023-06-10 오후 7 07 37](https://github.com/beomsun1234/kubernetes/assets/68090443/72855df8-31cc-419f-8b96-8b53794a2216)

##  LB 구성
HA Proxy 사용하여 lb 구성
![스크린샷 2023-06-10 오후 7 10 09](https://github.com/beomsun1234/kubernetes/assets/68090443/01fd6dd4-c429-467f-b15f-121c91736ce2)


    ........
    
    frontend kubernetes-master-lb
            bind 0.0.0.0:6443
            option tcplog
            mode tcp
            default_backend kubernetes-master-nodes

    backend kubernetes-master-nodes
            mode tcp
            balance roundrobin
            option tcp-check
            option tcplog
            server master1 [master1-ip]:6443 check
            server master2 [master2-ip].11:6443 check
            server master3 [master2-ip]:6443 check
    listen stats # "stats"라는 이름으로 listen 지정
        bind :9000 # 접속 포트 지정
        stats enable
        stats realm Haproxy\ Statistics  # 브라우저 타이틀
        stats uri /  # stat 를 제공할 URI
    ............ 
    
## kubeadm init (master1 only)

    kubeadm init --control-plane-endpoint "[LB-IP]:[LB-PORT]" \
    --upload-certs \
    --pod-network-cidr "192.168.0.0/16"

## join

### master
init 시 위에 나온다.

      kubeadm join [LB-IP]:6443 --token [token] \
        --discovery-token-ca-cert-hash sha256:[cert] \
        --control-plane --certificate-key [key]
      
### worker

    kubeadm join [LB-IP]:6443 --token [token] \
            --discovery-token-ca-cert-hash sha256:[cert] \
