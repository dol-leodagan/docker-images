pptp
----
Containerized Client for PPTP VPN

| Tag | amd64 | arm32v6 | arm32v7 | arm64v8 |
| ------------ | ------------ | ------------ | ------------ | ------------ |
| latest, 1.10.0 | [![](https://images.microbadger.com/badges/image/leodagan/pptp:latest.svg)](https://microbadger.com/images/leodagan/pptp:latest "Get your own image badge on microbadger.com") | [![](https://images.microbadger.com/badges/image/leodagan/pptp:latest-arm32v6.svg)](https://microbadger.com/images/leodagan/pptp:latest-arm32v6 "Get your own image badge on microbadger.com") | [![](https://images.microbadger.com/badges/image/leodagan/pptp:latest-arm32v7.svg)](https://microbadger.com/images/leodagan/pptp:latest-arm32v7 "Get your own image badge on microbadger.com") | [![](https://images.microbadger.com/badges/image/leodagan/pptp:latest-arm64v8.svg)](https://microbadger.com/images/leodagan/pptp:latest:latest-arm64v8 "Get your own image badge on microbadger.com") |
| edge | [![](https://images.microbadger.com/badges/image/leodagan/pptp:edge.svg)](https://microbadger.com/images/leodagan/pptp:edge "Get your own image badge on microbadger.com") | [![](https://images.microbadger.com/badges/image/leodagan/pptp:edge-arm32v6.svg)](https://microbadger.com/images/leodagan/pptp:edge:edge-arm32v6 "Get your own image badge on microbadger.com") | [![](https://images.microbadger.com/badges/image/leodagan/pptp:edge-arm32v7.svg)](https://microbadger.com/images/leodagan/pptp:edge-arm32v7 "Get your own image badge on microbadger.com") | [![](https://images.microbadger.com/badges/image/leodagan/pptp:edge-arm64v8.svg)](https://microbadger.com/images/leodagan/pptp:edge-arm64v8 "Get your own image badge on microbadger.com") |

Prerequisites
----
| Kernel Config | Module |
| ------------ | ------------ |
| CONFIG_PPP | ppp_generic, slhc |
| CONFIG_PPP_MPPE | ppp_mppe |
| CONFIG_PPP_ASYNC | ppp_async |
| CONFIG_NF_NAT_PPTP | nf_nat_pptp |
| CONFIG_NF_NAT_PROTO_GRE | nf_nat_proto_gre |
| CONFIG_NF_CONNTRACK_PPTP | nf_conntrack_pptp |
| CONFIG_NF_CT_PROTO_GRE | nf_conntrack_proto_gre |

Netfilter Options

```
echo 'net.netfilter.nf_conntrack_helper = 1' >> /etc/sysctl.conf
echo 1 > /proc/sys/net/netfilter/nf_conntrack_helper
```

Run
----
```
docker run --rm -e SERVER=domain.tld -e USERNAME=user -e PASSWORD=secret --cap-add NET_ADMIN --device=/dev/ppp --dns 8.8.8.8 --dns 8.8.4.4 --name pptpclient -d leodagan/pptp
```

Test
----
```
docker run --rm --network container:pptpclient busybox wget -O- ifconfig.ovh
```
```
Connecting to ifconfig.ovh (213.186.33.173:80)
writing to stdout
-                    100% |********************************|    16  0:00:00 ETA
written to stdout
111.111.111.111
```

Docker-Compose
----
```yaml
version: '2'
services:

  pptp:
    container_name: pptpclient
    image: leodagan/pptp
    restart: unless-stopped
    environment:
      SERVER: domain.tld
      USERNAME: user
      PASSWORD: secret
    dns:
      - 8.8.8.8
      - 8.8.4.4
    devices:
      - /dev/ppp
    cap_add:
      - NET_ADMIN

  test:
    image: busybox
    command: wget -O- ifconfig.ovh
    network: service:pptp
```

