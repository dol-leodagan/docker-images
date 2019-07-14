ARG BUILD_DATE=now
ARG VCS_REF=local
ARG BUILD_VERSION=dev

FROM amd64/golang:1.12-alpine as builder

ARG filebrowser_version
ARG make_jobs=4

WORKDIR /

RUN set -ex; \
    apk add --no-cache \
      nodejs \
      npm \
      ca-certificates \
      git ; \
    export CGO_ENABLED=0 ; \
    export GO111MODULE=on ; \
    git clone --branch "${filebrowser_version}" --depth 1 https://github.com/filebrowser/filebrowser.git ; \
    cd /filebrowser ; \
    git submodule update --init --recursive ; \
    echo "### Downloading Dependencies" ; \
    go mod download ; \
    echo "### Install Go Rice" ; \
    go install github.com/GeertJohan/go.rice/rice ; \
    echo "### Building Frontend" ; \
    cd frontend ; \
    npm install ; \
    npm run build ; \
    rm -rf node_modules; \
    echo "### Embedding Frontend with Rice" ; \
    cd ../http ; \
    rm -rf rice-box.go ; \
    rice embed-go ; \
    echo "### Building Filebrowser" ; \
    cd .. ; \
    case "__DOCKER_ARCH__" in \
        arm32v6) \
            export GOARCH="arm"; \
            export GOARM="6"; \
        ;; \
        arm32v7) \
            export GOARCH="arm"; \
            export GOARM="7"; \
        ;; \
        arm64v8) \
            export GOARCH="arm64"; \
        ;; \
    esac ; \
    case "${filebrowser_version}" in \
        master) \
            DISPLAY_VERSION="$(git rev-parse --short HEAD)" \
            ;; \
        *) \
            DISPLAY_VERSION="${filebrowser_version}" \
            ;; \
    esac ; \
    go build -o filebrowser -ldflags \
        "-s -w -X github.com/filebrowser/filebrowser/v2/version.CommitSHA=$(git rev-parse --short HEAD) \
            -X github.com/filebrowser/filebrowser/v2/version.Version=leodagan/filebrowser-${DISPLAY_VERSION}" \
        main.go


FROM scratch as filer

COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=builder /filebrowser/filebrowser /filebrowser
COPY --from=builder /filebrowser/.docker.json /.filebrowser.json

FROM scratch as static

ARG BUILD_DATE
ARG VCS_REF
ARG BUILD_VERSION

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.version=$BUILD_VERSION \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.name="filebrowser" \
      org.label-schema.description="Web File Browser which can be used as a middleware or standalone app" \
      org.label-schema.usage="https://github.com/dol-leodagan/docker-images/blob/master/filebrowser/README.md" \
      org.label-schema.schema-version="1.0.0-rc1" \
      maintainer="Leodagan <leodagan@freyad.net>"

COPY --from=filer / /

WORKDIR /

VOLUME /srv
EXPOSE 80

ENTRYPOINT [ "/filebrowser" ]

FROM __DOCKER_ARCH__/alpine:3.9 as embedded-alpine

ARG BUILD_DATE
ARG VCS_REF
ARG BUILD_VERSION

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.version=$BUILD_VERSION \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.name="filebrowser-alpine" \
      org.label-schema.description="Web File Browser which can be used as a middleware or standalone app" \
      org.label-schema.usage="https://github.com/dol-leodagan/docker-images/blob/master/filebrowser/README.md" \
      org.label-schema.schema-version="1.0.0-rc1" \
      maintainer="Leodagan <leodagan@freyad.net>"

COPY --from=filer / /

WORKDIR /

VOLUME /srv
EXPOSE 80

ENTRYPOINT ["/filebrowser"]

FROM __DOCKER_ARCH__/busybox:musl as embedded-busybox

ARG BUILD_DATE
ARG VCS_REF
ARG BUILD_VERSION

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.version=$BUILD_VERSION \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.name="filebrowser-busybox" \
      org.label-schema.description="Web File Browser which can be used as a middleware or standalone app" \
      org.label-schema.usage="https://github.com/dol-leodagan/docker-images/blob/master/filebrowser/README.md" \
      org.label-schema.schema-version="1.0.0-rc1" \
      maintainer="Leodagan <leodagan@freyad.net>"

COPY --from=filer / /

WORKDIR /

VOLUME /srv
EXPOSE 80

ENTRYPOINT ["/filebrowser"]

