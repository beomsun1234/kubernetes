# istio에 websocket 배포

## service yaml


    apiVersion: v1
    kind: Service
    metadata:
      name: stock
      labels:
        app: stock
        service: stock
    spec:
      ports:
      - name: tcp
        port: 8082
      selector:
        app: stock
    
    ---
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: stock
      labels:
        app: stock
    spec:
      replicas: 1
      selector:
        matchLabels:
          app: stock
      template:
        metadata:
          labels:
            app: stock
        spec:
          containers:
          - name: stock
            image: [websocket img]
            ports:
            - containerPort: 8082




## Gateway, VirtualService


    apiVersion: networking.istio.io/v1alpha3
    kind: Gateway
    metadata:
      name: open-gateway
    spec:
      # The selector matches the ingress gateway pod labels.
      # If you installed Istio using Helm following the standard documentation, this would be "istio=ingress"
      selector:
        istio: ingressgateway # use istio default controller
      servers:
      - port:
          number: 443
          name: https
          protocol: HTTPS
        tls:
          mode: SIMPLE
          credentialName: beom-credential-v1
        hosts:
        - "*"
    ---
    apiVersion: networking.istio.io/v1alpha3
    kind: VirtualService
    metadata:
      name: open
    spec:
      hosts:
        - "*"
      gateways:
        - open-gateway
      http:
        - name: stock
          match:
            - uri:
                prefix: "/stock"
          route:
            - destination:
                host: stock
                port:
                  number: 8082
        - name: open
          route:
            - destination:
                host: vuejs
                port:
                  number: 80


## 결과

![스크린샷 2023-09-23 오후 7 11 01](https://github.com/beomsun1234/kubernetes/assets/68090443/e906786b-421f-44df-914d-05942a0a05be)
