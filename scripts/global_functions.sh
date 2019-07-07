#!/usr/bin/env sh

docker_arch_to_qemu_arch()
{
    case "${1}" in
        arm32v6|arm32v7) echo "arm";;
        arm64v8) echo "aarch64";;
        amd64|*) echo "amd64";;
    esac
}

docker_tag_to_docker_arch()
{
    case "${1}" in
        *-arm32v6) echo "arm32v6";;
        *-arm32v7) echo "arm32v7";;
        *-arm64v8) echo "arm64v8";;
        *-amd64|*) echo "amd64";;
    esac
}

prepare_dockerfile_qemu()
{
    DOCKERF="${1}"
    ARCH="${2:-amd64}"
    QARCH="$(docker_arch_to_qemu_arch "${2}")"

    if [ "${ARCH}" = "amd64" ]; then
        sed \
            -e "s/__DOCKER_ARCH__/amd64/g" \
            -e "/__QEMU_ARCH__/d" \
            "${DOCKERF}" > "${DOCKERF}.${ARCH}"
    else
        QEMU_USER_STATIC_DOWNLOAD_URL="https://github.com/multiarch/qemu-user-static/releases/download"
        QEMU_USER_STATIC_LATEST_TAG=$(curl -sL https://api.github.com/repos/multiarch/qemu-user-static/tags \
            | grep 'name.*v[0-9]' \
            | head -n 1 \
            | cut -d '"' -f 4)

        curl -sL "${QEMU_USER_STATIC_DOWNLOAD_URL}/${QEMU_USER_STATIC_LATEST_TAG}/x86_64_qemu-${QARCH}-static.tar.gz" \
            | tar xzv

        sed \
            -e "s/__DOCKER_ARCH__/${ARCH}/g" \
            -e "s/__QEMU_ARCH__/${QARCH}/g" \
            "${DOCKERF}" > "${DOCKERF}.${ARCH}"

        docker run --rm --privileged multiarch/qemu-user-static:register --reset
    fi
}

build_docker_image()
{
    docker build \
        --build-arg BUILD_DATE="$(date -u +"%Y-%m-%dT%H:%M:%SZ")" \
        --build-arg VCS_REF="$(git rev-parse --short HEAD)" \
        "$@" \
        .
}

qemu_test()
{
    ARCH="$(docker_tag_to_docker_arch "${DOCKER_TAG}")"
    if [ "${ARCH}" = "amd64" ]; then
        docker run --rm "$@"
    else
        QARCH="$(docker_arch_to_qemu_arch "${ARCH}")"
        docker run --rm -v "$(pwd)/qemu-${QARCH}-static:/usr/bin/qemu-${QARCH}-static" "$@"
    fi
}

push_docker_image_with_ref()
{
    ARCH="$(docker_tag_to_docker_arch "${2}")"

    docker push "${1}:${2}"

    case "${2}" in
        latest) docker push "${1}:${3}";;
        latest-*) docker push "${1}:${3}-${ARCH}";;
    esac
}
