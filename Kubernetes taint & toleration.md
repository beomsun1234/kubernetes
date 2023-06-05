# Taint와 Toleration

[doc](https://kubernetes.io/ko/docs/concepts/scheduling-eviction/taint-and-toleration/)


Taint(얼룩)는 Node에 정의할 수 있고, Toleration(용인)은 Pod에 정의할 수 있다. Taint가 설정된 node에는 pod가 배포되지 않는다. Taint 처리가 되어 있는 Node에는 Taint에 맞는 Toleration을 가지고 있는 Pod 만 배포될 수 있다.

## Taint 설정 및 제거


  format
  kubectl taint nodes <node-name> <key>=<value>:<effect>
  
  -설정-
  kubectl taint nodes node1 key1=value1:NoSchedule
  
  -제거-
  kubectl taint nodes node1 key1=value1:NoSchedule-

  
effect는 NoSchedule, PreferNoSchedule,NoExecute 3가지로 정의할 수 있다. 
  
- NoSchedule
  
  - Tainit Node에 Pod의 스케줄링을 허용하지 않음
  - 기존 실행 중인 Pod는 어쩔수 없고, 앞으로 실행될 Pod에 대해서만 스케쥴링 제한  
  
- PreferNoSchedule
  
  - Tainit Node에 Pod 스케줄링을 선호하지 않음
  - 기존 실행 중인 Pod는 허용하고, 앞으로 생성될 Pod도 스케쥴링되는 것을 선호하진 않지만, 해당 Node 밖에 스케쥴링 될 곳이 없다면 허용해줌

- NoExecute
  
  - Tainit Node에 Pod의 실행을 허용하지 않음
  - 앞으로 생성 될 Pod에 대한 스케쥴링을 제한함은 물론, 기존에 해당 Node에 배치된 Pod 모두 방출  
  
