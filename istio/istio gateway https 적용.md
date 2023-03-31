# istio ingress gateway https 적용

[istio-doc](https://istio.io/latest/docs/tasks/traffic-management/ingress/secure-ingress/)

## 1. 인증서 생성 

폴더를 만든다.

    mkdir beom_istio_certs
    
1. 인증서에 서명할 Root CA와 private key 생성
    
    openssl req -x509 -sha256 -nodes -days 3650 -newkey rsa:2048 -subj '/O=beom Inc./CN=beombeom.com' -keyout beom_istio_certs/beom-istio-rootCA.key -out beom_istio_certs/beom-istio-rootCA.crt
    

2. 인증서 및 개인키생성

  openssl req -out beom_istio_certs/beom-istio.csr -newkey rsa:2048 -nodes -keyout beom_istio_certs/beom-istio.key -subj "/CN=beombeom.com/O=beom organization"
  
  
  openssl x509 -req -sha256 -days 3650 -CA beom_istio_certs/beom-istio-rootCA.crt -CAkey beom_istio_certs/beom-istio-rootCA.key -set_serial 0 -in beom_istio_certs/beom-istio.csr -out beom_istio_certs/beom-istio.crt
    

3. TLS secret 생성

    cd beom_istio_certs
  
    kubectl create -n istio-system secret tls beom-credential-v1 --key=beom-istio.key --cert=beom-istio.crt


4. istio ingress gateway 구성


    apiVersion: networking.istio.io/v1alpha3
    kind: Gateway
    metadata:
      name: bookinfo-gateway
    spec:
      selector:
        istio: ingressgateway # use istio default controller
      servers:
      - port:
          number: 443
          name: https
          protocol: HTTPS
        tls:
          mode: SIMPLE
          credentialName: beom-credential-v1 # must be the same as secret
        hosts:
        - "*"
    ---
    
## 결과

![k9](https://user-images.githubusercontent.com/68090443/229118075-52ddcd14-61fe-4b4b-82b0-4f916dea7b13.PNG)


![k10](https://user-images.githubusercontent.com/68090443/229118343-042f162f-3376-4674-a236-d748c990013e.PNG)


![k8](https://user-images.githubusercontent.com/68090443/229117326-ad662603-659c-4806-b926-c4dd88876d40.PNG)
