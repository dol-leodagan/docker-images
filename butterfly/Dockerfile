ARG BUILD_DATE=now
ARG VCS_REF=local
ARG BUILD_VERSION=dev

FROM __DOCKER_ARCH__/python:3-alpine3.9 as builder

ARG butterfly_version

COPY qemu-__QEMU_ARCH__-static /usr/bin/

WORKDIR /

RUN set -ex; \
    apk add --no-cache \
        gcc \
        musl-dev \
        libffi-dev \
        openssl-dev \
        ca-certificates \
        git ; \
    pip install --upgrade setuptools; \
    git clone https://github.com/paradoxxxzero/butterfly.git ; \
    cd /butterfly ; \
    git checkout "${butterfly_version}" ; \
    python setup.py build ; \
    python setup.py install -O2 ;

FROM scratch as filer

COPY --from=builder /usr/local/lib/python3.7/site-packages/asn1crypto-0.24.0-py3.7.egg/ /usr/local/lib/python3.7/site-packages/asn1crypto-0.24.0-py3.7.egg/
COPY --from=builder /usr/local/lib/python3.7/site-packages/cryptography-2.7-py3.7-linux-x86_64.egg/ /usr/local/lib/python3.7/site-packages/cryptography-2.7-py3.7-linux-x86_64.egg/
COPY --from=builder /usr/local/lib/python3.7/site-packages/pycparser-2.19-py3.7.egg/ /usr/local/lib/python3.7/site-packages/pycparser-2.19-py3.7.egg/
COPY --from=builder /usr/local/lib/python3.7/site-packages/butterfly-3.2.5-py3.7.egg/ /usr/local/lib/python3.7/site-packages/butterfly-3.2.5-py3.7.egg/
COPY --from=builder /usr/local/lib/python3.7/site-packages/six-1.12.0-py3.7.egg/ /usr/local/lib/python3.7/site-packages/six-1.12.0-py3.7.egg/
COPY --from=builder /usr/local/lib/python3.7/site-packages/cffi-1.12.3-py3.7-linux-x86_64.egg/ /usr/local/lib/python3.7/site-packages/cffi-1.12.3-py3.7-linux-x86_64.egg/
COPY --from=builder /usr/local/lib/python3.7/site-packages/pyOpenSSL-19.0.0-py3.7.egg/ /usr/local/lib/python3.7/site-packages/pyOpenSSL-19.0.0-py3.7.egg/
COPY --from=builder /usr/local/lib/python3.7/site-packages/tornado-6.0.3-py3.7-linux-x86_64.egg/ /usr/local/lib/python3.7/site-packages/tornado-6.0.3-py3.7-linux-x86_64.egg/
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

