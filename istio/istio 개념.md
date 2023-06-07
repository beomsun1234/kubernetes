# istio 
Istio는 서비스 메쉬의 구현체로써 서비스메쉬는 소프트웨어와 클러스터(쿠버네티스 등)사이의 추가적인 레이어를 통해 네트워크 통신을 추상화한다.

## Istio 구성요소

### Data Plane

Envoy Proxy 세트로 구성되어 있다. Envoy는 사이드카 방식으로 각각의 마이크로서비스에 붙어서(배포) 서비스로 들어오고 나가는 모든 트래픽을 통제하게 된다. 
Envoy를 통해서 서비스를 호출할 때 호출하는 서비스의 IP주소는 파일럿(Pilot)에 저장된 엔드포인트 정보를 활용하게 된다. 

### Control Plane

Data Plane에 배포된 envoy를 컨트롤 하는 부분이다. 

('istiod')[https://istio.io/latest/docs/ops/deployment/architecture/#istiod] 라는 모듈로 구성되어 있으며  

istiod는 서비스 디스커버리(Service Discovery), 설정 관리(Configuration Management), 인증 관리(Certificate Management) 등을 수행한다.


1.5 이전 버전 부터는 4가지 모듈로 구성되어 있었는데 이후 버전 부터 'istiod' 하나로 통합되었다.

    - 파일럿 (Pilot)
    파일럿은 envoy에 대한 설정 관리를 하는 역할을 한다. 
    먼저 앞에서 언급했듯이 서비스들의 엔드포인트(EndPoint)들의 주소를 얻을 수 있는 서비스 디스커버리 기능을 제공한다. 
    Istio에 유용한 기능중의 하나가 트래픽의 경로를 컨트롤 하는 기능인데, 서비스에서 서비스로 호출하는 경로를 컨트롤 할 수 있다. 이외도 서비스의 안정성을 제공하기 위해서 서비스간에 호출이 발생할때 재시도(retry), 장애 전파를 막기 위한 써킷 브레이커 (Circuit breaker), Timeout 등의 기능을 제공한다. 

    - 믹서(Mixer)
    액세스 컨트롤, 정책 통제 그리고 각종 모니터링 지표의 수집이다. 

    - 시타델(Citadel)
    보안에 관련된 기능을 담당하는 모듈이다. 서비스를 사용하기 위한 사용자 인증 (Authentication)과 인가 (Authorization)을 담당한다. 또한 Istio는 통신을 TLS(SSL)을 이용하여 암호화할 수 있는데, TLS 암호화나 또는 사용자 인증에 필요한 인증서(Certification)을 관리하는 역할을 한다. 

    - 갤리(Galley)
    Istio의 구성 및 설정 검증. 배포 관리 수행
    
    
    
# Service Mesh

MicroService Architecture를 적용한 시스템의 내부 통신이 Mesh 네트워크의 형태를 띄는 것에 빗대어 Service Mesh로 명명되었습니다.

Service Mesh 는 서비스 간 통신을 추상화하여 안전하고, 빠르고, 신뢰할 수 있게 만드는 전용 네트워크 인프라 계층입니다.
추상화를 통해 복잡한 내부 네트워크를 제어하고, 추적하고, 내부 네트워크 관련 로직을 추가함으로써 안정성, 신뢰성, 탄력성, 표준화, 가시성, 보안성 등을 확보합니다.
Service Mesh 의 구현체인 경량화 Proxy를 통해 다양한 Routing Rules, circuit breaker 등 공통기능을 설정할 수 있습니다.

## Service Mesh 구현

구현은 보통 서비스의 앞단에 경량화 프록시를 사이드카 패턴으로 배치하여 서비스 간 통신을 제어하는 방법으로 구현합니다. sidecar에 통신과 관련된 많은 기능들을 제공하여, 어플리케이션 코드의 변경없이 다양한 네트워크 구성(인증, 라우팅, 보안 등)을 적용할 수 있도록 한다. 

* 사이드카 패턴 :  Application 외 필요한 추가 기능을 별도의 Application으로 구현하고 이를 동일한 프로세스 또는 컨테이너 내부에 배치하는 것입니다.
