ARG BUILD_DATE=now
ARG VCS_REF=local
ARG BUILD_VERSION=dev

FROM amd64/alpine:3.9 as builder

ARG pptpd_version
ARG make_jobs=4

#COPY qemu-__QEMU_ARCH__-static /usr/bin/

RUN set -ex; \
    apk add --no-cache \
      ppp-dev \
      musl-dev \
      gcc \
      make \
      git ; \
    git clone https://git.code.sf.net/p/poptop/git pptpd ; \
    cd /pptpd ; \
    git checkout "${pptpd_version}" ; \
    sed -i -e '64i #ifndef MSG_TRYHARD\n        # define MSG_TRYHARD    MSG_DONTROUTE\n#endif\n' bcrelay.c ; \
    ./configure CFLAGS="-O3 -pipe -fomit-frame-pointer" CXXFLAGS="-O3 -pipe -fomit-frame-pointer" \
                --prefix=/usr \
                --sysconfdir=/etc \
                --enable-bcrelay ; \
    make -j"${make_jobs}" ; \
    make install ;

FROM amd64/alpine:3.9 as final

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.version=${BUILD_VERSION} \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.name="pptpd" \
      org.label-schema.description="Containerized PPTP VPN Server" \
      org.label-schema.usage="https://github.com/dol-leodagan/docker-images/blob/master/pptpd/README.md" \
      org.label-schema.schema-version="1.0.0-rc1" \
      maintainer="Leodagan <leodagan@freyad.net>"

COPY --from=builder 

WORKDIR /

ENTRYPOINT ["pptpd"]
