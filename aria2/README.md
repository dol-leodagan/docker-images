aria2
----
aria2 is a lightweight multi-protocol & multi-source, cross platform download utility operated in command-line.

| Tag | amd64 | arm32v6 | arm32v7 | arm64v8 |
| ------------ | ------------ | ------------ | ------------ | ------------ |
| latest, 1.34 | [![](https://images.microbadger.com/badges/image/leodagan/aria2:latest.svg)](https://microbadger.com/images/leodagan/aria2:latest "Get your own image badge on microbadger.com") | [![](https://images.microbadger.com/badges/image/leodagan/aria2:latest-arm32v6.svg)](https://microbadger.com/images/leodagan/aria2:latest-arm32v6 "Get your own image badge on microbadger.com") | [![](https://images.microbadger.com/badges/image/leodagan/aria2:latest-arm32v7.svg)](https://microbadger.com/images/leodagan/aria2:latest-arm32v7 "Get your own image badge on microbadger.com") | [![](https://images.microbadger.com/badges/image/leodagan/aria2:latest-arm64v8.svg)](https://microbadger.com/images/leodagan/aria2:latest-arm64v8 "Get your own image badge on microbadger.com") |
| busybox, 1.34-busybox | [![](https://images.microbadger.com/badges/image/leodagan/aria2:busybox.svg)](https://microbadger.com/images/leodagan/aria2:busybox "Get your own image badge on microbadger.com") | [![](https://images.microbadger.com/badges/image/leodagan/aria2:busybox-arm32v6.svg)](https://microbadger.com/images/leodagan/aria2:busybox-arm32v6 "Get your own image badge on microbadger.com") | [![](https://images.microbadger.com/badges/image/leodagan/aria2:busybox-arm32v7.svg)](https://microbadger.com/images/leodagan/aria2:busybox-arm32v7 "Get your own image badge on microbadger.com") | [![](https://images.microbadger.com/badges/image/leodagan/aria2:busybox-arm64v8.svg)](https://microbadger.com/images/leodagan/aria2:busybox-arm64v8 "Get your own image badge on microbadger.com") |
| edge | [![](https://images.microbadger.com/badges/image/leodagan/aria2:edge.svg)](https://microbadger.com/images/leodagan/aria2:edge "Get your own image badge on microbadger.com") | [![](https://images.microbadger.com/badges/image/leodagan/aria2:edge-arm32v6.svg)](https://microbadger.com/images/leodagan/aria2:edge-arm32v6 "Get your own image badge on microbadger.com") | [![](https://images.microbadger.com/badges/image/leodagan/aria2:edge-arm32v7.svg)](https://microbadger.com/images/leodagan/aria2:edge-arm32v7 "Get your own image badge on microbadger.com") | [![](https://images.microbadger.com/badges/image/leodagan/aria2:edge-arm64v8.svg)](https://microbadger.com/images/leodagan/aria2:edge-arm64v8 "Get your own image badge on microbadger.com") |
| edge-busybox | [![](https://images.microbadger.com/badges/image/leodagan/aria2:edge-busybox.svg)](https://microbadger.com/images/leodagan/aria2:edge-busybox "Get your own image badge on microbadger.com") | [![](https://images.microbadger.com/badges/image/leodagan/aria2:edge-busybox-arm32v6.svg)](https://microbadger.com/images/leodagan/aria2:edge-busybox-arm32v6 "Get your own image badge on microbadger.com") | [![](https://images.microbadger.com/badges/image/leodagan/aria2:edge-busybox-arm32v7.svg)](https://microbadger.com/images/leodagan/aria2:edge-busybox-arm32v7 "Get your own image badge on microbadger.com") | [![](https://images.microbadger.com/badges/image/leodagan/aria2:edge-busybox-arm64v8.svg)](https://microbadger.com/images/leodagan/aria2:edge-busybox-arm64v8 "Get your own image badge on microbadger.com") |

Run
----
Download a file
```
docker run --rm -v "$(pwd):/download" leodagan/aria2 "https://google.com"
```
As daemon
```
docker run --rm -v "$(pwd):/download" -d leodagan/aria2 --enable-rpc --rpc-listen-all --rpc-allow-origin-all
```
You should implement security above aria2 RPC endpoint or enable ```--rpc-secret``` and ```--rpc-secure``` options before exposing to host.

