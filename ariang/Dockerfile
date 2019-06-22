ARG BUILD_DATE=now
ARG VCS_REF=local
ARG BUILD_VERSION=dev

FROM __DOCKER_ARCH__/alpine:latest as builder

ARG ariang_version

COPY qemu-__QEMU_ARCH__-static /usr/bin/

RUN set -ex; \
   apk add --no-cache \
      nodejs \
      npm \
      git; \
    npm install -g gulp; \
    git clone "https://github.com/mayswind/AriaNg.git"; \
    cd /AriaNg; \
    git checkout "${ariang_version}"; \
    npm install; \
    npm install natives@1.1.6; \
    gulp clean build

FROM __DOCKER_ARCH__/nginx:alpine as final

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.version=$BUILD_VERSION \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/dol-leodagan/docker-images.git" \
      org.label-schema.name="ariang" \
      org.label-schema.description="Modern web frontend making aria2 easier to use" \
      org.label-schema.usage="https://github.com/dol-leodagan/docker-images/blob/master/ariang/README.md" \
      org.label-schema.schema-version="1.0.0-rc1" \
      maintainer="Leodagan <leodagan@freyad.net>"

COPY --from=builder /AriaNg/dist /usr/share/nginx/html

