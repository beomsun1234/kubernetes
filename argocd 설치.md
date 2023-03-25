# argocd 설치

[argocd doc](https://argo-cd.readthedocs.io/en/stable/getting_started/)

## reverse proxy 적용

proxy 서버 nginx에 ssl 설정 후 proxy 서버 / 경로로 들어올 경우 argocd service로 전달

아래는 설정 부분이다.

    /etc/nginx/sites-available/default

    location / {
                  # First attempt to serve request as file, then
                  # as directory, then fall back to displaying a 404.
                  proxy_pass https://[ip]:[port];

    }
    
    
 
![argocd4](https://user-images.githubusercontent.com/68090443/227714797-73890957-c395-4c34-a50c-ec5e9992b292.PNG)
