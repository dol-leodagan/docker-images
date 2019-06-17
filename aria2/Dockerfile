ARG BUILD_DATE=now
ARG VCS_REF=local
ARG BUILD_VERSION=dev

FROM __DOCKER_ARCH__/alpine:latest as builder

ARG aria_version
ARG make_jobs=4

COPY qemu-__QEMU_ARCH__-static /usr/bin/

RUN apk add --no-cache \
      expat-dev \
      openssl-dev \
      cppunit-dev \
      c-ares-dev \
      libssh2-dev \
      zlib-dev \
      gettext-dev \
      file \
      gettext \
      ca-certificates \
      g++ \
      make \
      automake \
      autoconf \
      libtool \
      git && \
    git clone https://github.com/aria2/aria2 && \
    cd /aria2 && \
    git checkout "${aria_version}" && \
    autoreconf -i && \
    ./configure ARIA2_STATIC=yes CFLAGS="-O3 -pipe -fomit-frame-pointer" CXXFLAGS="-O3 -pipe -fomit-frame-pointer" \
                --enable-ssl \
                --enable-bittorrent \
                --enable-metalink \
                --enable-websocket \
                --enable-epoll \
                --enable-largefile \
                --disable-nls \
                --without-libxml2 \
                --with-ca-bundle='/etc/ssl/certs/ca-certificates.crt' && \
    make -j"${make_jobs}" && \
    make install

FROM scratch as static

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.version=$BUILD_VERSION \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/dol-leodagan/docker-images.git" \
      org.label-schema.name="aria2" \
      org.label-schema.description="Utility for downloading files and torrents" \
      org.label-schema.usage="https://github.com/dol-leodagan/docker-images/blob/master/aria2/README.md" \
      org.label-schema.schema-version="1.0.0-rc1" \
      maintainer="Leodagan <leodagan@freyad.net>"

COPY --from=builder /usr/local/bin/aria2c /usr/local/bin/aria2c
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt

EXPOSE 6800

WORKDIR /

ENTRYPOINT ["aria2c"]

FROM __DOCKER_ARCH__/busybox:musl as embedded

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.version=${BUILD_VERSION}-busybox \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.name="aria2-busybox" \
      org.label-schema.description="Utility for downloading files and torrents with embedded Busybox" \
      org.label-schema.usage="https://github.com/dol-leodagan/docker-images/blob/master/aria2/README.md" \
      org.label-schema.schema-version="1.0.0-rc1" \
      maintainer="Leodagan <leodagan@freyad.net>"

COPY --from=builder /usr/local/bin/aria2c /usr/local/bin/aria2c
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt

EXPOSE 6800

WORKDIR /

ENTRYPOINT ["aria2c"]

