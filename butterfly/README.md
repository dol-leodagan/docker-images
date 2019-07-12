butterfly
----
Butterfly is a xterm compatible terminal that runs in your browser.

| Tag | amd64 | arm32v6 | arm32v7 | arm64v8 |
| ------------ | ------------ | ------------ | ------------ | ------------ |
| latest, 3.2.5 | [![](https://images.microbadger.com/badges/image/leodagan/butterfly:latest.svg)](https://microbadger.com/images/leodagan/butterfly:latest "Get your own image badge on microbadger.com") | [![](https://images.microbadger.com/badges/image/leodagan/butterfly:latest-arm32v6.svg)](https://microbadger.com/images/leodagan/butterfly:latest-arm32v6 "Get your own image badge on microbadger.com") | [![](https://images.microbadger.com/badges/image/leodagan/butterfly:latest-arm32v7.svg)](https://microbadger.com/images/leodagan/butterfly:latest-arm32v7 "Get your own image badge on microbadger.com") | [![](https://images.microbadger.com/badges/image/leodagan/butterfly:latest-arm64v8.svg)](https://microbadger.com/images/leodagan/butterfly:latest-arm64v8 "Get your own image badge on microbadger.com") |
| edge | [![](https://images.microbadger.com/badges/image/leodagan/butterfly:edge.svg)](https://microbadger.com/images/leodagan/butterfly:edge "Get your own image badge on microbadger.com") | [![](https://images.microbadger.com/badges/image/leodagan/butterfly:edge-arm32v6.svg)](https://microbadger.com/images/leodagan/butterfly:edge-arm32v6 "Get your own image badge on microbadger.com") | [![](https://images.microbadger.com/badges/image/leodagan/butterfly:edge-arm32v7.svg)](https://microbadger.com/images/leodagan/butterfly:edge-arm32v7 "Get your own image badge on microbadger.com") | [![](https://images.microbadger.com/badges/image/leodagan/butterfly:edge-arm64v8.svg)](https://microbadger.com/images/leodagan/butterfly:edge-arm64v8 "Get your own image badge on microbadger.com") |

Run
----
By default the webservice is available through HTTP on port 80 without any authentication.
```
docker run --rm -d leodagan/butterfly
```
Install additional packages available through the terminal.
```
docker run --rm -d --entrypoint sh leodagan/butterfly -c 'apk add openssh-client && exec butterfly.server.py --host=0.0.0.0 --port=80 --unsecure --i-hereby-declare-i-dont-want-any-security-whatsoever'
```
You should **STRONGLY** consider adding a security layer (Reverse-proxy with SSL termination and authentication) or enabling *butterfly* secure options before exposing to public.

References
----
https://github.com/paradoxxxzero/butterfly

