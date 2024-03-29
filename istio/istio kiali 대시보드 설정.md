# istio kiali 대시보드 설치(nodeport방식)

istio가 설치된 폴더에 samples/addons 경로에 있는 모든 yaml 파일을 실행시켜준다.


    kubectl create -f istio폴더/samples/addons .


kiali 서비스를 nodeport로 설정해주자.

 kiali.yaml  

    # Source: kiali-server/templates/service.yaml
    apiVersion: v1
    kind: Service
    metadata:
      name: kiali
      namespace: istio-system
      labels:
        helm.sh/chart: kiali-server-1.63.1
        app: kiali
        app.kubernetes.io/name: kiali
        app.kubernetes.io/instance: kiali
        version: "v1.63.1"
        app.kubernetes.io/version: "v1.63.1"
        app.kubernetes.io/managed-by: Helm
        app.kubernetes.io/part-of: "kiali"
      annotations:
    spec:
      type: NodePort
      ports:
      - name: http
        appProtocol: http
        protocol: TCP
        port: 20001
        nodePort: 30001
      - name: http-metrics
        appProtocol: http
        protocol: TCP
        port: 9090
      selector:
        app.kubernetes.io/name: kiali
        app.kubernetes.io/instance: kiali


## reverse proxy 설정

proxy 서버 nginx에 ssl 설정 후 proxy 서버 /kiali 경로로 들어올 경우 kiali service로 전달

아래는 설정 부분이다.


    /etc/nginx/sites-available/default

    location /kiali {
                  proxy_pass http://[gcp-private-ip]:[kiali-port];

    }




![kiali](https://user-images.githubusercontent.com/68090443/227899239-4d124c3a-896d-45fb-a4b5-104c561ac7dc.PNG)

# istio kiali 대시보드 설치(gateway)

bookinfo를 예제로 한다.


kubectl create -f istio폴더/samples/addons .


bookinfo-gw.yaml



        apiVersion: networking.istio.io/v1alpha3
        kind: Gateway
        metadata:
          name: bookinfo-gateway
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
              credentialName: beom-cert-v1
            hosts:
            - "*"
        ---
        apiVersion: networking.istio.io/v1alpha3
        kind: VirtualService
        metadata:
          name: bookinfo
        spec:
          hosts:
          - "*"
          gateways:
          - bookinfo-gateway
          http:
          - match:
            - uri:
                exact: /productpage
            - uri:
                prefix: /static
            - uri:
                exact: /login
            - uri:
                exact: /logout
            - uri:
                prefix: /api/v1/products
            route:
            - destination:
                host: productpage
                port:
                  number: 9080
          - match:
            - uri:
                prefix: /kiali
            route:
            - destination:
                host: kiali.istio-system.svc.cluster.local
                port:
                  number: 20001


