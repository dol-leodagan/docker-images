ARG BUILD_DATE=now
ARG VCS_REF=local
ARG BUILD_VERSION=dev

FROM __DOCKER_ARCH__/python:3-alpine3.9 as builder

ARG butterfly_version

COPY qemu-__QEMU_ARCH__-static /usr/bin/

WORKDIR /

RUN set -ex; \
    case "__DOCKER_ARCH__" in \
        arm32v6) export QEMU_CPU="arm1176" ;; \
        arm32v7) export QEMU_CPU="cortex-a7" ;; \
        arm64v8) export QEMU_CPU="cortex-a53" ;; \
    esac ; \
    uname -a ; \
    apk add --no-cache \
        gcc \
        musl-dev \
        libffi-dev \
        openssl-dev \
        ca-certificates \
        git ; \
    pip install --upgrade setuptools; \
    git clone --branch "${butterfly_version}" --depth 1 https://github.com/paradoxxxzero/butterfly.git ; \
    cd /butterfly ; \
    python setup.py build ; \
    python setup.py install -O2 ; \
    find "/usr/local/lib/python3.7/site-packages" ! -name "*.egg" -mindepth 1 -maxdepth 1 -exec rm -rf '{}' \;

FROM scratch as filer

COPY --from=builder /usr/local/lib/python3.7/site-packages/ /usr/local/lib/python3.7/site-packages/

COPY --from=builder /usr/local/bin/b* /usr/local/bin/

FROM __DOCKER_ARCH__/python:3-alpine3.9 as final

ARG BUILD_DATE
ARG VCS_REF
ARG BUILD_VERSION

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.version=$BUILD_VERSION \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.name="butterfly" \
      org.label-schema.description="A web terminal based on websocket and tornado" \
      org.label-schema.usage="https://github.com/dol-leodagan/docker-images/blob/master/butterfly/README.md" \
      org.label-schema.schema-version="1.0.0-rc1" \
      maintainer="Leodagan <leodagan@freyad.net>"

COPY --from=filer / /

WORKDIR /

EXPOSE 80

ENTRYPOINT ["butterfly.server.py"]

CMD [ "--unsecure", "--host=0.0.0.0", "--port=80", "--i-hereby-declare-i-dont-want-any-security-whatsoever" ]

