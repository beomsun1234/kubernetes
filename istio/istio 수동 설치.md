# istio 수동 설치

[istio 수동설치 문서](https://istio.io/latest/docs/setup/install/operator/)](https://istio.io/latest/docs/setup/install/operator/)

## 1. 아래 명렁어를 통해 operator 설치
    
    istioctl operator init
    
## 2. istio custom resources 설정파일 실행

    kubectl create -f istio-op.yaml



### istio-op.yaml


    apiVersion: install.istio.io/v1alpha1
    kind: IstioOperator
    metadata:
      namespace: istio-system
      name: example-istiocontrolplane
    spec:
      profile: default
      components:
        ingressGateways:
        - enabled: true
          k8s:
            service:
              ports:
              - name: status-port
                port: 15021
                targetPort: 15021
              - name: http2
                port: 80
                targetPort: 8080
                nodePort: 32080
              - name: https
                port: 443
                targetPort: 8443
                nodePort: 32443
              - name: tls
                port: 15443
                targetPort: 15443
          name: istio-ingressgateway
      values:
        gateways:
          istio-ingressgateway:
            type: NodePort
