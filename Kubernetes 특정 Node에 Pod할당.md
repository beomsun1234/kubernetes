# Kubernetes 특정 Node에 Pod할당

Kubernetes는 scheduler를 통해 pod를 할당합니다. 

특정 노드에서만 특정 파드를 할당 하고 싶은 경우 방법을 알아보겠습니다.

##  nodeSelector

### node label 추가

    kubectl label nodes <your-node-name> [key]=[value]
  
ex)
  
    kubectl label node k8s-worker-03 worker=service
  
### node label 제거
  
    kubectl label nodes <your-node-name> [key]-

ex)
  
    kubectl label node k8s-worker-03 worker-
  

### 선택한 노드에 스케줄되도록 파드 생성하기

nginx.yaml

    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: nginx-deployment
      labels:
        app: nginx
    spec:
      replicas: 2
      selector:
        matchLabels:
          app: nginx
      template:
        metadata:
          labels:
            app: nginx
        spec:
          containers:
          - name: nginx
            image: nginx:1.14.2
            ports:
            - containerPort: 80
          nodeSelector:
            worker: service
            
            
nodeSelector 부분에 pod를 스케줄링할 node의 label을 입력해줍니다. [key]: [value]


## Affinity

Taint가 Pod가 배포되지 못하도록 하는 정책이라면, affinity는 Pod를 특정 Node에 배포되도록 하는 정책이다. affinity는 Node를 기준으로 하는 Node affinity와, 다른 Pod가 배포된 위치(node) 를 기준으로 하는 Pod affinity 두 가지가 있다. 

## node affinity

Pod가 특정 node로 배포되도록 하는 기능이다

nodeSelector에 비해 다양한 조건을 명시할 수 있다.


크게 아래 4가지 조건이 있다.

    - requiredDuringSchedulingIgnoredDuringExecution 
    - preferredDuringSchedulingIgnoredDuringExecution 
    - requiredDuringSchedulingRequiredDuringExecution 
    - preferredDuringSchedulingRequiredDuringExecution


서두의 required는 반드시 포함되어야하고, preferred는 우선시하되 필수는 아닌지를 결정하는 조건이다. Scheduling 뒤에 나오는 Ignored는 운영 중 node의 label이 변경되면 무시하는 것 이고 , Required 즉각 처리하여 재기동을 수행할 것 인지를 결정한다. 



### 

nginx.yaml

    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: nginx-deployment
      labels:
        app: nginx
    spec:
      replicas: 2
      selector:
        matchLabels:
          app: nginx
      template:
        metadata:
          labels:
            app: nginx
        spec:
          containers:
          - name: nginx
            image: nginx:1.14.2
            ports:
            - containerPort: 80
          affinity:
            nodeAffinity:
              requiredDuringSchedulingIgnoredDuringExecution:
                nodeSelectorTerms:
                - matchExpressions:
                  - key: worker
                    operator: In
                    values:
                    - service         
                    
## 내용


    affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
            - matchExpressions:
                - key: worker
                    operator: In
                    values:
                    - service

requiredDuringSchedulingIgnoredDuringExecution의 경우 아래 조건들이 일치하는 node에 적용하겠다는 의미이다. node label에 key "worker"이고 값이 service인 조건에 만족해야한다.  operator: In의 경우 두개 이상의 values가 명시되어 있을 때 values 중 하나의 값을 가질 경우를 의미합니다.

## reference
https://waspro.tistory.com/582
