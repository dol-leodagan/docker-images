ARG BUILD_DATE=now
ARG VCS_REF=local
ARG BUILD_VERSION=dev

FROM __DOCKER_ARCH__/alpine:3.9 as builder

ARG pptp_version
ARG make_jobs=4

COPY qemu-__QEMU_ARCH__-static /usr/bin/

RUN set -ex; \
    case "__DOCKER_ARCH__" in \
        arm32v6) export QEMU_CPU="arm1176" ;; \
        arm32v7) export QEMU_CPU="cortex-a7" ;; \
        arm64v8) export QEMU_CPU="cortex-a53" ;; \
    esac ; \
    uname -a ; \
    apk add --no-cache \
      perl \
      musl-dev \
      gcc \
      make \
      git ; \
    git clone --branch "${pptp_version}" --depth 1 https://git.code.sf.net/p/pptpclient/git pptp ; \
    cd /pptp ; \
    CFLAGS="-O3 -pipe -fomit-frame-pointer" CXXFLAGS="-O3 -pipe -fomit-frame-pointer" \
    make IP="/sbin/ip" -j"${make_jobs}" ; \
    make install ;

FROM scratch as filer

COPY --from=builder /usr/sbin/pptp* /usr/sbin/
COPY --from=builder /etc/ppp/options.pptp /etc/ppp/
COPY entrypoint.sh /entrypoint.sh

FROM __DOCKER_ARCH__/alpine:3.9 as final

ARG BUILD_DATE
ARG VCS_REF
ARG BUILD_VERSION

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.version=${BUILD_VERSION} \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.name="pptp" \
      org.label-schema.description="Containerized Client for PPTP VPN" \
      org.label-schema.usage="https://github.com/dol-leodagan/docker-images/blob/master/pptp/README.md" \
      org.label-schema.schema-version="1.0.0-rc1" \
      maintainer="Leodagan <leodagan@freyad.net>"

COPY qemu-__QEMU_ARCH__-static /usr/bin/
COPY --from=filer / /

WORKDIR /

RUN set -ex; \
    case "__DOCKER_ARCH__" in \
        arm32v6) export QEMU_CPU="arm1176" ;; \
        arm32v7) export QEMU_CPU="cortex-a7" ;; \
        arm64v8) export QEMU_CPU="cortex-a53" ;; \
    esac ; \
    uname -a ; \
    apk add --no-cache \
      ppp-daemon \
      iproute2 ; \
    rm -f /usr/bin/qemu-* ;

WORKDIR /

ENTRYPOINT ["/entrypoint.sh"]
