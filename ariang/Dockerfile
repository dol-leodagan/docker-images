ARG BUILD_DATE=now
ARG VCS_REF=local
ARG BUILD_VERSION=dev

FROM alpine:latest as builder

ARG ariang_version

RUN set -ex; \
   apk add --no-cache \
      nodejs \
      npm \
      git; \
    npm install -g gulp; \
    git clone --branch "${ariang_version}" --depth 1 "https://github.com/dol-leodagan/AriaNg.git"; \
    cd /AriaNg; \
    npm install; \
    npm install natives@1.1.6; \
    gulp clean build


FROM __DOCKER_ARCH__/nginx:alpine as middle

COPY qemu-__QEMU_ARCH__-static /usr/bin/

RUN set -ex; \
    mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.template; \
    sed -i -e '/location \//i \ \ \ \ location = / {\
        set $ariang_jsonrpc_string "__ARIANG_JSONRPC_STRING__";\
        if ($is_args = "") {\
            set $ariang_jsonrpc "$ariang_jsonrpc_string";\
        }\
        if ($ariang_jsonrpc != "") {\
            return 302 $scheme://$http_host/?configured#!$ariang_jsonrpc;\
        }\
        root \/usr\/share\/nginx\/html;\
        index index.html index.htm;\
    }' /etc/nginx/conf.d/default.conf.template


FROM scratch as filer

COPY --from=builder /AriaNg/dist /usr/share/nginx/html
COPY --from=middle /etc/nginx/conf.d/default.conf.template /etc/nginx/conf.d/default.conf.template


FROM __DOCKER_ARCH__/nginx:alpine as final

ARG BUILD_DATE
ARG VCS_REF
ARG BUILD_VERSION

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.version=$BUILD_VERSION \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/dol-leodagan/docker-images.git" \
      org.label-schema.name="ariang" \
      org.label-schema.description="Modern web frontend making aria2 easier to use" \
      org.label-schema.usage="https://github.com/dol-leodagan/docker-images/blob/master/ariang/README.md" \
      org.label-schema.schema-version="1.0.0-rc1" \
      maintainer="Leodagan <leodagan@freyad.net>"

COPY --from=filer / /

CMD [ "sh", "-c", "sed -e 's#__ARIANG_JSONRPC_STRING__#'\"${ARIANG_JSONRPC_STRING}\"'#' /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf && exec nginx -g 'daemon off;'" ]

