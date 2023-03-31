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

개발자 park에게 role-test라는 namespace에 모든 pod를 확인할 수 있도록 권한 부여




