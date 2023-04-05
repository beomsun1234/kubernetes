# Kubernetes RBAC Authorization

[k8s-doc](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)

RBCA(Role-based access control)는 컴퓨터, 네트워크 자원을 user의 role 기반으로 제어하는 방법이다.

Kubernetes RBAC Authorization은 'rbac.authorization.k8s.io' api 그룹을 사용하여 권한부여 결정을 내리며 Kubernetes API를 통해 동적으로 정책을 구성할 수 있도록 해준다.

## API objects
RBCA API는 4종류의 Kubernetes object를 선언한다. Role, ClusterRole, RoleBinding and ClusterRoleBinding.

### Role

Role은 특정 namespace 안에서의 권한을 부여한다..

### ClusterRole

속해있지 않은 namespace에도 권한을 부여한다..

### RoleBinding, ClusterRoleBinding

정의된 role에 대한 권한을 사용자에게 부여한다.


RoleBinding -> 특정 namespace, ClusterRoleBinding -> 클러스터전체


ClusterRoleBinding은 속해있지 않는 네임스페이스에서도 권한이 유효

## Role 예제

dev-park1이라는 user role-test라는 namespace에 모든 pod를 확인할 수 있도록 권한 부여

### role-test 라는 namespace를 만들자


    kubectl create namespace role-test
    
    
### role-test namespace에 dev-park1이라는 service account 생성하자


    kubectl create sa -n role-test dev-park1



![sa1](https://user-images.githubusercontent.com/68090443/229472214-63c2b5d5-acb2-47d1-bbb4-dcc76754f0e3.PNG)



### Role 구성

    role-dev-park.yaml
    
    apiVersion: rbac.authorization.k8s.io/v1
    kind: Role
    metadata:
      namespace: role-test
      name: pod-reader
    rules:
    - apiGroups: [""] # "" indicates the core API group
      resources: ["pods"]
      verbs: ["get", "watch", "list"]



![role2](https://user-images.githubusercontent.com/68090443/229471772-7c0778c1-b62c-486a-8875-6d76db7972f0.PNG)





### RoleBinding 구성
    
    rolebind-dev-park.yaml

    apiVersion: rbac.authorization.k8s.io/v1
    # This role binding allows "jane" to read pods in the "default" namespace.
    # You need to already have a Role named "pod-reader" in that namespace.
    kind: RoleBinding
    metadata:
      name: read-pods
      namespace: role-test
    subjects:
    # You can specify more than one "subject"
    - kind: ServiceAccount
      name: dev-park1
      namespace: role-test
    roleRef:
      # "roleRef" specifies the binding to a Role / ClusterRole
      kind: Role #this must be Role or ClusterRole
      name: pod-reader # this must match the name of the Role or ClusterRole you wish to bind to
      apiGroup: rbac.authorization.k8s.io
  
  
  
![role1](https://user-images.githubusercontent.com/68090443/229471817-ac8e5d0e-72a5-48ba-9cc7-94a1f0ad1e33.PNG)
 
### Service Account에 대한 secret 생성


    dev-park1-secret.yaml
    
    
    apiVersion: v1
    kind: Secret
    metadata:
      name: dev-park1-secret
      namespace: role-test
      annotations:
        kubernetes.io/service-account.name: dev-park1
    type: kubernetes.io/service-account-token



![sa2](https://user-images.githubusercontent.com/68090443/229472136-c9bf3503-c3ae-4379-95ca-31ee456bdb31.PNG)

### 생성한 secret token으로 pod 요청


    kubectl describe secrets -n role-test dev-park1-secret

#### dev-park1으로 role-test namespace pod 조회 시

    curl https://[ip]:6443/api/v1/namespaces/role-test/pods
    

![result](https://user-images.githubusercontent.com/68090443/229475081-4f9db1eb-6afd-4b03-a292-1f5382dc0c21.PNG)



#### dev-pakr1으로 default namespace pod 조회 시
    
    
    curl https://[ip]:6443/api/v1/namespaces/default/pods
    
    
![result2](https://user-images.githubusercontent.com/68090443/229475306-2aa559f4-7cb7-477a-8705-6a36bddafaba.PNG)


## ClusterRoleBinding 
